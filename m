Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:44075 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2AJIGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 03:06:38 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RkWj5-0004Az-O2
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 09:06:35 +0100
Received: from localhost ([::1]:42531 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkWj5-0008R5-K7
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 09:06:35 +0100
Received: from [195.4.92.21] (port=40998 helo=11.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkWgv-0007it-CJ
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 09:04:21 +0100
Received: from p4fde00e1.dip0.t-ipconnect.de ([79.222.0.225]:46044 helo=mail.maya.org)
	by 11.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RkWgu-0002Ad-Rx
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 09:04:21 +0100
Message-Id: <201201100803.q0A83nsQ003757@mail.maya.org> (sfid-20120110_090647_080665_C4B59C67)
Date: Tue, 10 Jan 2012 09:03:49 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
In-Reply-To: <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mon, 9 Jan 2012 14:45:06 +0100
schrieb Helmut Schaa <helmut.schaa@googlemail.com>:

> On Mon, Jan 9, 2012 at 2:29 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
> > Helmut Schaa schrieb:
> >> On Thu, Jan 5, 2012 at 9:44 AM, Andreas Hartmann
> >> <andihartmann@freenet.de> wrote:
> >>> Helmut Schaa schrieb:
> >>>> Hi,
> >>>>
> >>>> Am Mittwoch, 4. Januar 2012, 09:38:02 schrieb Andreas Hartmann:
> >>>>> Helmut Schaa schrieb:
> >>>>>>> Removing this patch
> >>>>>>>
> >>>>>>> mac80211: retry sending failed BAR frames later instead of tearing down
> >>>>>>> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
> >>>>>>> it working again.
> >>>>>>>
> >>>>>>> Device is: RaLink RT2800 802.11n PCI
> >>>>>>
> >>>>>> What's the client device connected to the rt2x00 AP?
> >>>>>
> >>>>> It's a rt3572 usb chip (Linksys WUSB600N v2), driven with the rt3572sta
> >>>>> module.
> >>>>>
> >>>>>> Mind to send a
> >>>>>> 802.11 capture wen this stall happens?
> >>>>
> >>>> Andreas provided me with a capture now. The interesting part is that
> >>>> the rt2x00 AP sends bursts of BARs with the same sequence number when
> >>>> the stall happens. I only had a quick look at the code in question but
> >>>> couldn't see anything wrong at a first glance.
> >>>
> >>>
> >>> Some additional information:
> >>>
> >>> - The AP initiates BARs for 6 different, successive sequence numbers.
> >>> - The first 5 sequence numbers are finished after sending of about 8 (!)
> >>> BAR's.
> >>> Important: each BAR is responded *instantly* by the STA.
> >>> - The BAR for the next sequence number is sent "endless" though the STA
> >>> responses to each BAR instantly again.
> >>>
> >>>
> >>> Another thing: it is striking, that the performance from STA -> AP is at
> >>> max 8,5 MBit/s, whereas the performance from AP -> STA can be 15 MBit/s
> >>> (all measured with netperf).
> >>>
> >>>
> >>> Could it be, that somewhere in the stack of the AP the response packet
> >>> from STA -> AP get's lost or ignored or blocked?
> >>
> >> The BlockAck is solely handled in hardware. But I need to check, maybe
> >> the BAR tx status is reported as unacknowledged when the BA contains
> >> a BA bitmap of only zeros ...
> >>
> >> Don't know when I can find time to do this but if you like to test something
> >> you could try to add some printks in the rt2x00 tx status path to see if any
> >> BAR frames are reported as acknowledged (and if these have a bitmap != 0).
> >
> > I tried the following with reverted patch "mac80211: retry sending
> > failed BAR frames later instead of tearing down" to see what's done to
> > not break down the data stream:
> >
> > -> enabling CONFIG_MAC80211_HT_DEBUG
> > -> some additional output
> >
> >
> > Start of netperf:
> >
> > [18836.107487] Open BA session requested for 00:25:9c:aa:bb:cc tid 0
> > [18836.116149] IEEE80211_AMPDU_TX_START
> > [18836.116156] activated addBA response timer on tid 0
> > [18836.116209] Rx A-MPDU request on tid 0 result 0
> > [18836.118846] switched off addBA timer for tid 0
> > [18836.118851] Aggregation is on for tid 0
> >
> > (that's the same as with the patch, which I reverted)
> >
> >
> > Later on, I can see some sequences like this:
> >
> > [18868.875495] ieee80211_ba_session_work() called
> > ___ieee80211_stop_tx_ba_session
> > [18868.875503] Tx BA session stop requested for 00:25:9c:aa:bb:cc tid 0
> > [18868.884143] IEEE80211_AMPDU_TX_STOP
> > [18868.884155] Stopping Tx BA session for 00:25:9c:aa:bb:cc tid 0
> > [18868.963066] Open BA session requested for 00:25:9c:aa:bb:cc tid 0
> > [18868.972047] IEEE80211_AMPDU_TX_START
> > [18868.972054] activated addBA response timer on tid 0
> > [18868.979154] switched off addBA timer for tid 0
> > [18868.979156] Aggregation is on for tid 0
> >
> >
> > With the reverted patch applied again, I can't see any entries in the
> > moment of the stall. It just stalls silently.
> > How is the situation I can see with the reverted patch handled now?
> > Could it be, that it isn't handled at all?
> 
> Felix patch intended to not restart the BA session in this case as it
> introduces some unnecessary processing if it would be possible to
> just flush the reordering buffer of the peer by resending the BAR
> later. However, there is no message printed in this case ...

Thank you for your really fast reply! 
Unfortunately, freenet mailing was broken yesterday. Hope it's fine again today.

Meanwhile, I took a look at the tx_path with Felix patch applied. I'm
getting this output:


-> netperf start  

[38139.839028] Open BA session requested for 00:25:9c:de:4e:30 tid 0
[38139.848151] IEEE80211_AMPDU_TX_START
[38139.848157] activated addBA response timer on tid 0
[38139.849723] switched off addBA timer for tid 0
[38139.849728] Aggregation is on for tid 0

-> stall  

[38161.686305] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 1
[38161.698957] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 2

[38161.698963] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.699116] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.710238] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 3
[38161.710240] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.710394] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.724512] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 4
[38161.724519] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.724659] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.735416] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 5
[38161.735423] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.735486] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.747815] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 6
[38161.747822] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.747888] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.755268] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 7
[38161.755271] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.758823] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.772898] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 8
[38161.772901] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
[38161.773049] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
[38161.789222] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 9
...

Looks as if sending of any package is reported as broken at some
point of time and this circle cannot be left anymore.


The additional debug output in rt2x00dev.c is:

void rt2x00lib_txdone(struct queue_entry *entry,
                      struct txdone_entry_desc *txdesc)
{
...

        if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
                if (success)
                        tx_info->flags |= IEEE80211_TX_STAT_ACK;
                else {
                        rt2x00dev->low_level_stats.dot11ACKFailureCount++;
                        printk("rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: %d\n",
				rt2x00dev->low_level_stats.dot11ACKFailureCount); // debug
                        }
        }
...
}


In status.c:

void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
{
...
                if (!acked && ieee80211_is_back_req(fc)) {
                        u16 control;

                        /*
                         * BAR failed, store the last SSN and retry sending
                         * the BAR when the next unicast transmission on the
                         * same TID succeeds.
                         */
                        bar = (struct ieee80211_bar *) skb->data;
                        control = le16_to_cpu(bar->control);
                        if (!(control & IEEE80211_BAR_CTRL_MULTI_TID)) {
                                u16 ssn = le16_to_cpu(bar->start_seq_num);

                                tid = (control &
                                       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
                                      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;

                                printk("status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <%d> control: <%d>\n",
					tid,control); // debug
                                ieee80211_set_bar_pending(sta, tid, ssn);
                        }
                }
...
}



static void ieee80211_check_pending_bar(struct sta_info *sta, u8 *addr, u8 tid)
{
        struct tid_ampdu_tx *tid_tx;

        tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
        if (!tid_tx || !tid_tx->bar_pending)
                return;

        printk("ieee80211_check_pending_bar -> ieee80211_send_bar() %s tid: %d failed_bar_ssn: %d\n",
	       tid_tx->bar_pending?"true":"false",tid, tid_tx->failed_bar_ssn); // debug

        tid_tx->bar_pending = false;
        ieee80211_send_bar(&sta->sdata->vif, addr, tid, tid_tx->failed_bar_ssn);
}



Kind regards,
Andreas


