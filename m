Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35789 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab3C1Qay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 12:30:54 -0400
Message-ID: <51547024.7060800@candelatech.com> (sfid-20130328_173058_866439_A581EAA7)
Date: Thu, 28 Mar 2013 09:30:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	Dan Williams <dcbw@redhat.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication from
 user-space
References: <1364472669-5629-1-git-send-email-arend@broadcom.com> <1364487476.10397.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364487476.10397.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2013 09:17 AM, Johannes Berg wrote:
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
>> + * @NL80211_CMD_CRIT_PROTOCOL_START: Indicates user-space will start running
>> + *	a critical protocol that needs more reliability in the connection to
>> + *	complete.
>
> I think this needs a little bit more documentation, addressing
> specifically:
>
>   * What is the protocol ID? You haven't defined that at all, I don't

Maybe just ignore the protocol entirely.  Let applications set their
skb->priority or ToS so that their packets are handled with priority
as desired.

I'm guessing the NIC should have the same behaviour regardless of
the protocol (ie, stop scanning, no off-channel work, etc), so
why would it care about protocol.

And, I do like the timeout (with maximum value hard-coded in the
kernel so that a crashed or buggy app can't disable scanning/off-channel
for longer than a few seconds).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

