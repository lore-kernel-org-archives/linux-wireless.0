Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42142 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab3FJPiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 11:38:21 -0400
Message-ID: <51B5F2EA.4040506@openwrt.org> (sfid-20130610_173827_277247_91EDDC95)
Date: Mon, 10 Jun 2013 17:38:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 0/5] add master channel switch announcement support
References: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de> <51B2195C.1010303@openwrt.org> <20130610151154.GA1640@pandem0nium>
In-Reply-To: <20130610151154.GA1640@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-10 5:11 PM, Simon Wunderlich wrote:
> Hey Felix,
> 
> On Fri, Jun 07, 2013 at 07:33:16PM +0200, Felix Fietkau wrote:
>> On 2013-06-07 7:05 PM, Simon Wunderlich wrote:
>> > This is the follow up from the RFC posted a month ago. This patchset adds generic
>> > channel switch support for AP. This is required for DFS operation
>> > (e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
>> > be required for IBSS-DFS later.
>> > 
>> > The rough design is:
>> >  * userspace asks kernel to switch a channel using the new NL80211_CMD_CHANNEL_SWITCH
>> >    command. It supplies IE information for the time while staying on the old channel and
>> >    announcing the switch, and IE information for after the switch to the new channel. 
>> >  * IE information contains the beacon and optionally probe responses, which should
>> >    include (E)CSA IEs for the CSA case. Furthermore an offset is provided (for beacon
>> >    and probe response) to point to the counter field within the channel switch IEs.
>> >  * The driver gets the new beacons passed and must set them, and decrement the
>> >    counter field. When it reaches 0, the channel is changed and userspace notified.
>> > 
>> > Discussion points:
>> >  * Assembling all these IE information is a little bit tedious but doable (I've
>> >    patched hostapd).
>> >  * Other future users like IBSS/MESH will not get the beacon/probe response IEs, as they
>> >    generate these beacons themselves. Therefore they need the COUNT attribute, which
>> >    is kind of duplicate right now.
>> >  * Userspace must generate/handle all IEs, which lifts the previous limitations of
>> >    the RFC (e.g. no change of band allowed, no operation mode change allowed).
>> >  * it currently works for me [TM] on my ath9k based machine
>> I think this is a bit racy. Just because the driver gets a beacon from
>> mac80211 doesn't mean that the beacon will be sent *immediately*. I'd
>> recommend calling back from the driver into mac80211 on beacon tx
>> completion. Also, it might make sense to skip CAB queue transmissions in
>> this case.
> 
> mhm, you're right, changing channel might race with sending the beacon as it's
> set right now. I'd change it to:
> 
>  * update the counter within get_beacon() (as done now)
>  * perform the channel switch after beacon transmission is completed (not sure how to get this
>    event practically yet ... :] )
> 
> What do you think?
> 
> This must probably handle stuck/lost beacons too - is there any completion function
> called for stuck beacons?
Right now there are no mac80211 callbacks for either completed or missed
beacon tx. Inside ath9k, on AR93xx+, beacons get normal tx completion
events. For older chipsets the status descriptor must be checked
explicitly - see the implementation of drv_tx_last_beacon.
To get the timing right for checking tx completion of the beacon, you
can let the normal pre-AR93xx tx completion function check the beacon
queue if CSA was indicated via a flag or something.

As for stuck beacon, you can hook into the beacon tasklet function.
If the driver knows that a CSA is imminent, it can send the notification
on a stuck beacon event even before it hits the hw reset (which it only
does after several consecutive stuck beacon events).

- Felix
