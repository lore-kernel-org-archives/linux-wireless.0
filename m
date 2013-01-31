Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50716 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab3AaPXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:23:46 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so1392723bkw.3
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2013 07:23:44 -0800 (PST)
Message-ID: <510A8C7E.9070602@cozybit.com> (sfid-20130131_162358_968515_EC3A54B4)
Date: Thu, 31 Jan 2013 16:23:42 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 2/3] mac80211: mesh power save doze scheduling
References: <1358936360-7795-1-git-send-email-marco@cozybit.com>  <1358936360-7795-3-git-send-email-marco@cozybit.com>  (sfid-20130123_111932_695381_467B8C3D) <1359640314.8415.31.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359640314.8415.31.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2013 02:51 PM, Johannes Berg wrote:
> On Wed, 2013-01-23 at 11:19 +0100, Marco Porsch wrote:
>
>> Expose a callback ieee80211_mps_init for drivers to register
>> mesh powersave ops:
>> - hw_doze - put the radio to sleep now
>> - hw_wakeup - wake the radio up for frame RX
>> These ops may be extended in the future to allow drivers/HW to
>> implement mesh PS themselves. (The current design goal was to
>> concentrate mesh PS routines in mac80211 to keep driver
>> modifications minimal.
>>
>> Track the beacon timing information of peers we are in PS mode
>> towards. Set a per-STA hrtimer which will trigger a wakeup right
>> before the peer's next TBTT.
>> Also use the same hrtimer to go to sleep mode after not
>> receiving a beacon in a defined time margin. In this case
>> calculate the next TBTT and increase the margin.
>>
>> For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
>> a timer which triggers a hw_doze call on expiry.
>
> Hmm. I'm not completely happy with this hrtimer stuff in mac80211.
> There's a lot of (USB) hardware that could never implement such a thing,
> but could, conceivably, implement this differently?

The use of hrtimers for MPS is debatable currently. The approach of 
calculating the peer's TSF should be accurate to the usec. Good timing 
here directly affects the energy savings. On the other handside the 
margin of 5ms used shows that something is not working as expected yet. 
If this cannot be fixed, I may as well use regular timers here. How 
strongly do you oppose hrtimers? :)

>> @@ -1146,6 +1148,11 @@ struct ieee80211_local {
>>
>>   	int user_power_level; /* in dBm, for all interfaces */
>>
>> +	/* mesh power save */
>> +	bool mps_enabled;
>> +	bool mps_hw_doze;
>
> Generally, this also seems wrong, you're making the assumption that mesh
> will be the only interface. That might actually be true for many use
> cases, but is it really an assumption we should still put into the stack
> today, with multi-channel etc? I'm not convinced of that.

When trying to enable MPS in mps_hw_conf_check, I check if there are any 
non-mesh interfaces. If yes, it is not enabled.
So these status variables are just used to sync multi-mesh-vif MPS on a 
single device.

Multiple mesh interfaces are ok. An AP vif is a no-go for any PS mode. 
Mesh + client is theoretically fine, but handled completely differently 
- also a no for now.

> So I think you should (at least attempt to) make an implementation that
> is less tied to the exact timing implementation. Maybe program the
> wakeup TBTT in advance.  Maybe with a small library the driver can
> connect to this that uses hrtimers to implement it? That could then also
> assume that callbacks need not sleep, thus allowing to reduce
> TBTT_MARGIN.
 >
> In theory I think with ath9k you could even use hardware timers &
> interrupts to wake the hardware, thus probably being able to reduce
> TBTT_MARGIN significantly.

Earlier, I had successfully implemented wakeups using ath9k HW before we 
at cozybit decided to concentrate all code in mac80211. Concerning ath9k 
it worked fine but required more callbacks to mac80211 and will 
eventually add redundant code that has to be maintained to multiple drivers.

--Marco
