Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1899 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3C1VTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 17:19:15 -0400
Message-ID: <5154B347.9080904@broadcom.com> (sfid-20130328_221920_187662_CA02680B)
Date: Thu, 28 Mar 2013 22:16:55 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Dan Williams" <dcbw@redhat.com>,
	"Adrian Chadd" <adrian@freebsd.org>,
	"Felix Fietkau" <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	"Ben Greear" <greearb@candelatech.com>
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication
 from user-space
References: <1364472669-5629-1-git-send-email-arend@broadcom.com>
 <1364487476.10397.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364487476.10397.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2013 05:17 PM, Johannes Berg wrote:
> On Thu, 2013-03-28 at 13:11 +0100, Arend van Spriel wrote:
>> Some protocols need a more reliable connection to complete
>> successful in reasonable time. This patch adds a user-space
>> API to indicate the wireless driver that a critical protocol
>> is about to commence and when it is done, using nl80211 primitives
>> NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.
>>
>> The driver can support this by implementing the cfg80211 callbacks
>> .crit_proto_start() and .crit_proto_stop(). Examples of protocols
>> that can benefit from this are DHCP, EAPOL, APIPA. Exactly how the
>> link can/should be made more reliable is up to the driver. Things
>> to consider are avoid scanning, no multi-channel operations, and
>> alter coexistence schemes.
> 
> Looks better than the BT coex thing :-)
> 

These are only words, but thanks ;-)

>> + * @NL80211_CMD_CRIT_PROTOCOL_START: Indicates user-space will start running
>> + *	a critical protocol that needs more reliability in the connection to
>> + *	complete.
> 
> I think this needs a little bit more documentation, addressing
> specifically:
> 
>  * What is the protocol ID? You haven't defined that at all, I don't
> like that
>    you're effectively introducing a private driver API there, and
> userspace tools
>    can't really know what to put into it. What's the value in that
> anyway, is it
>    to allow nesting multiple protocols? That seems a bit excessive for
> the
>    kernel, if needed it could be managed by the supplicant?
>    If it doesn't go away, then it should probably be an enum and be
> checked ...
>    but then you might need to have drivers advertise which ones they
> support? I
>    fail to see the point right now.

I was already hesitant to put the protocol (ETH_P_*) in here. I do not
have a clear use-case for it so let us drop it.

>  * I think there should probably be some sort of timeout. Would that
> timeout be
>    configurable by userspace, or should this be determined in the
> driver? It
>    seems userspace has a better idea of what kind of timeout would be
> needed.
>    Either way, does userspace need an indication that it ended?
>    Also, if there's a timeout, is a per-device maximum advertisement
> needed?
> 
>> +	NL80211_ATTR_CRIT_PROT_ID,
>> +	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
> 
> Oh, you do have a duration, but I don't see it used in the cfg80211 API?
> 
>> +++ b/net/wireless/core.c
>> @@ -745,6 +745,8 @@ static void wdev_cleanup_work(struct work_struct *work)
>>  	wdev = container_of(work, struct wireless_dev, cleanup_work);
>>  	rdev = wiphy_to_dev(wdev->wiphy);
>>  
>> +	schedule_delayed_work(&wdev->crit_proto_work, 0);
> 
> That's icky -- will cause all kinds of locking problems if this
> schedules out because it'll be hard to ensure it really finished. You
> should probably cancel and do it inline here?
> 
>> +void wdev_cancel_crit_proto(struct work_struct *work)
>> +{
>> +	struct delayed_work *dwork;
>> +	struct cfg80211_registered_device *rdev;
>> +	struct wireless_dev *wdev;
>> +
>> +	dwork = container_of(work, struct delayed_work, work);
>> +	wdev = container_of(dwork, struct wireless_dev, crit_proto_work);
>> +	rdev = wiphy_to_dev(wdev->wiphy);
>> +
>> +	rdev_crit_proto_stop(rdev, wdev, wdev->crit_proto);
>> +	wdev->crit_proto = 0;
> 
> Why even store the protocol value in the wdev? Or was that intended to
> be used to verify that you're not canceling something that doesn't
> exist?
> 
>> +#define NL80211_MIN_CRIT_PROT_DURATION		2500 /* msec */
> 
> That seems pretty long? Why have such a long *minimum* duration? At 2.5
> seconds, it's way long, and then disabling most of the
> protections/powersave/whatever no longer makes sense for this period of
> time since really mostly what this does will be reducing the wifi
> latency.
> 

Ok, so what minimum do you (or someone else can chime in here) think a
DHCP exchange takes as that was considered a likely protocol that can
benefit from this API.

>> @@ -1417,6 +1419,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
>>  		}
>>  		CMD(start_p2p_device, START_P2P_DEVICE);
>>  		CMD(set_mcast_rate, SET_MCAST_RATE);
>> +		CMD(crit_proto_start, CRIT_PROTOCOL_START);
>> +		CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
> 
> Ah, a tricky problem -- unrelated to your patch. You probably saw the
> wiphy size limit problem. If we keep adding commands here, we'll
> eventually break older userspace completely, so I think we shouldn't. A
> new way will probably be required, either adding new commands only
> conditionally on split wiphy dump, or inventing a new way. I suppose
> making it conditional is acceptable for all new commands since new tools
> in userspace will be required anyway to make them work.
> 

Indeed noticed some emails on this. I simply added these lines without
looking what this code fragment does.

>> +	cancel_delayed_work(&wdev->crit_proto_work);
> 
> That should probably be _sync. Is it even valid to start one while an
> old one is present? What's the expected behaviour? Right now you
> override, but is that really desired?

Good point. Maybe keep track that crit_proto is started and reject a
subsequent call (-EBUSY). Ideally, the start and stop should be done by
the same user-space process/application. Is that possible?

> Actually ... I think you should just get rid of the work, or at least
> make it optional. If we were going to implement this, for example, we'd
> definitely push the timing all the way into the firmware, and thus
> wouldn't want to have this cancel work. Isn't that similar for you?
> 
>> +	/* skip delayed work if no timeout provided */
> 
> I suspect a timeout should be required?
> 
>> +	schedule_delayed_work(&wdev->crit_proto_work,
>> +			      msecs_to_jiffies(duration));
> 
> Ah, ok, I guess I misunderstood it. You do use it, but don't pass it to
> the driver since you let cfg80211 handle the timing...
> 

Indeed. I wanted to be sure that the duration provided by user-space is
applicable independent from a driver implementation. Do you think it
makes sense to have this dealt with by cfg80211?

>> +	wdev->crit_proto = proto;
>> +
>> +done:
>> +	return rdev_crit_proto_start(rdev, wdev, proto);
> 
> If this fails, you get confusion, the work will run anyway.
> 

Good point.

>> +	if (info->attrs[NL80211_ATTR_CRIT_PROT_ID])
>> +		proto = nla_get_u16(info->attrs[NL80211_ATTR_CRIT_PROT_ID]);
>> +
>> +	return rdev_crit_proto_stop(rdev, wdev, proto);
> 
> You stored it before, so why not use that here as well? Or would
> 	start(proto=1)
> 	stop(proto=2)
> 
> be valid?

Let's make life a bit easier by getting rid of the proto as we do not
currently see a use-case for the protocol.

Thanks,
Arend

