Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:36381 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab2AIPhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 10:37:34 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RkHHw-0005YF-Mt
	for linux-wireless@vger.kernel.org; Mon, 09 Jan 2012 16:37:32 +0100
Received: from localhost ([::1]:58917 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkHHw-0004MO-KC
	for linux-wireless@vger.kernel.org; Mon, 09 Jan 2012 16:37:32 +0100
Received: from [195.4.92.18] (port=33587 helo=8.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkHFX-000437-Qg
	for linux-wireless@vger.kernel.org; Mon, 09 Jan 2012 16:35:03 +0100
Received: from p4fde0028.dip0.t-ipconnect.de ([79.222.0.40]:59111 helo=mail.maya.org)
	by 8.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RkFI2-0001oM-Om
	for linux-wireless@vger.kernel.org; Mon, 09 Jan 2012 14:29:34 +0100
Message-ID: <4F0AEBAB.9020104@01019freenet.de> (sfid-20120109_163739_119043_06E938BA)
Date: Mon, 09 Jan 2012 14:29:15 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de> <1408490.qSFZVkU7fA@helmutmobil.site> <4F0562DF.3000200@dualc.maya.org> <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
In-Reply-To: <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> On Thu, Jan 5, 2012 at 9:44 AM, Andreas Hartmann
> <andihartmann@freenet.de> wrote:
>> Helmut Schaa schrieb:
>>> Hi,
>>>
>>> Am Mittwoch, 4. Januar 2012, 09:38:02 schrieb Andreas Hartmann:
>>>> Helmut Schaa schrieb:
>>>>>> Removing this patch
>>>>>>
>>>>>> mac80211: retry sending failed BAR frames later instead of tearing down
>>>>>> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
>>>>>> it working again.
>>>>>>
>>>>>> Device is: RaLink RT2800 802.11n PCI
>>>>>
>>>>> What's the client device connected to the rt2x00 AP?
>>>>
>>>> It's a rt3572 usb chip (Linksys WUSB600N v2), driven with the rt3572sta
>>>> module.
>>>>
>>>>> Mind to send a
>>>>> 802.11 capture wen this stall happens?
>>>
>>> Andreas provided me with a capture now. The interesting part is that
>>> the rt2x00 AP sends bursts of BARs with the same sequence number when
>>> the stall happens. I only had a quick look at the code in question but
>>> couldn't see anything wrong at a first glance.
>>
>>
>> Some additional information:
>>
>> - The AP initiates BARs for 6 different, successive sequence numbers.
>> - The first 5 sequence numbers are finished after sending of about 8 (!)
>> BAR's.
>> Important: each BAR is responded *instantly* by the STA.
>> - The BAR for the next sequence number is sent "endless" though the STA
>> responses to each BAR instantly again.
>>
>>
>> Another thing: it is striking, that the performance from STA -> AP is at
>> max 8,5 MBit/s, whereas the performance from AP -> STA can be 15 MBit/s
>> (all measured with netperf).
>>
>>
>> Could it be, that somewhere in the stack of the AP the response packet
>> from STA -> AP get's lost or ignored or blocked?
> 
> The BlockAck is solely handled in hardware. But I need to check, maybe
> the BAR tx status is reported as unacknowledged when the BA contains
> a BA bitmap of only zeros ...
> 
> Don't know when I can find time to do this but if you like to test something
> you could try to add some printks in the rt2x00 tx status path to see if any
> BAR frames are reported as acknowledged (and if these have a bitmap != 0).

I tried the following with reverted patch "mac80211: retry sending
failed BAR frames later instead of tearing down" to see what's done to
not break down the data stream:

-> enabling CONFIG_MAC80211_HT_DEBUG
-> some additional output


Start of netperf:

[18836.107487] Open BA session requested for 00:25:9c:aa:bb:cc tid 0
[18836.116149] IEEE80211_AMPDU_TX_START
[18836.116156] activated addBA response timer on tid 0
[18836.116209] Rx A-MPDU request on tid 0 result 0
[18836.118846] switched off addBA timer for tid 0
[18836.118851] Aggregation is on for tid 0

(that's the same as with the patch, which I reverted)


Later on, I can see some sequences like this:

[18868.875495] ieee80211_ba_session_work() called
___ieee80211_stop_tx_ba_session
[18868.875503] Tx BA session stop requested for 00:25:9c:aa:bb:cc tid 0
[18868.884143] IEEE80211_AMPDU_TX_STOP
[18868.884155] Stopping Tx BA session for 00:25:9c:aa:bb:cc tid 0
[18868.963066] Open BA session requested for 00:25:9c:aa:bb:cc tid 0
[18868.972047] IEEE80211_AMPDU_TX_START
[18868.972054] activated addBA response timer on tid 0
[18868.979154] switched off addBA timer for tid 0
[18868.979156] Aggregation is on for tid 0


With the reverted patch applied again, I can't see any entries in the
moment of the stall. It just stalls silently.
How is the situation I can see with the reverted patch handled now?
Could it be, that it isn't handled at all?


Here you can see the triggering of the teardown of the BA session
(hopefully), if the patch is reverted:

"ieee80211_ba_session_work() called ___ieee80211_stop_tx_ba_session"
triggers the dropping of BA session. The code at this point is
(net/mac80211/ht.c):


--------------------------------------------------------------------------
void ieee80211_ba_session_work(struct work_struct *work) {
...
for (tid = 0; tid < STA_TID_NUM; tid++) {

    ...

    tid_tx = rcu_dereference_protected_tid_tx(sta, tid);

    if (tid_tx && test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
                                     &tid_tx->state)) {

        printk("ieee80211_ba_session_work called
               ___ieee80211_stop_tx_ba_session\n"); // debug

        ___ieee80211_stop_tx_ba_session(sta,tid,
					WLAN_BACK_INITIATOR,
                                        true);
	}
    }
...
}
----------------------------------------------------------------------------

Does this help you to get the reason for the problem? I could do some
more tests - but I'm not sure where to get the bitmap you desire to see :-).


Kind regards,
Andreas
