Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:57498 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2AJOoj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 09:44:39 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RkcwH-00068H-L4
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 15:44:37 +0100
Received: from localhost ([::1]:37046 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkcwH-0004Yd-HH
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 15:44:37 +0100
Received: from [195.4.92.26] (port=36919 helo=16.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkctW-0003cM-Tm
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 15:41:46 +0100
Received: from p4fde00e1.dip0.t-ipconnect.de ([79.222.0.225]:44988 helo=mail.maya.org)
	by 16.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RkctW-0005hW-4p
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 15:41:46 +0100
Message-Id: <201201101441.q0AEfaZ8005133@mail.maya.org> (sfid-20120110_154443_762479_52E1840B)
Date: Tue, 10 Jan 2012 15:41:36 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
In-Reply-To: <CAGXE3d9R7BOfTOc=SW6NT89=CxBugXBEnj+nffKw4M-VwtPcpA@mail.gmail.com>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201101156.q0ABuS87004643@mail.maya.org>
	<CAGXE3d9usjQB+9jkBPgtvL6fT8L84ZzDQQ3UqHyMdb+PRfhrKA@mail.gmail.com>
	<201201101301.q0AD1qSK004871@mail.maya.org>
	<CAGXE3d9R7BOfTOc=SW6NT89=CxBugXBEnj+nffKw4M-VwtPcpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Tue, 10 Jan 2012 14:43:21 +0100
schrieb Helmut Schaa <helmut.schaa@googlemail.com>:

> Hi,
> 
> On Tue, Jan 10, 2012 at 2:01 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
> > Helmut Schaa schrieb:
> > [...]
> >> So this looks good to me although the broken tx status for BAR frames
> >> is for sure a rt2800pci problem (or even a hw issue).
> >
> > Sorry - What do you mean with "hw issue"? Is my hw broken?
> 
> Hehe, no :)
> 
> > Or is it a specific "behavior" of exactly this device:
> 
> I think most rt2800pci will behave the same and just interpret a
> BlockAck as response to a BAR in a different manner as a BlockAck
> in response to a Data frame.
> 
> When we send the BAR we tell the hw that the frame needs to be
> acknowledged and according to the spec the hw will only count
> a normal ACK as successful transmission, the peer will however
> answer with a BlockAck as long as a BA session is active.
> 
> It might be possible to advise the hw to allow the BAR to be acked
> by a BlockAck by specifying AMDPU=1 in the TXWI. Not sure
> if that breaks anything else.
> 
> However, a BAR seems to be "ack-able" by both an ACK and a
> BlockAck according to 802.11-2007. If the recipient answers with
> an ACK the BA session might already be terminated and we would
> stop the BA session as soon as 3 BARs failed with the previous
> patch. This should be fine I guess.
> 
> So you might just give the following a try (also fully untested and
> maybe with some of your debugging output enabled).
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c
> b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index e4641da..5d0a3d3 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -393,6 +393,9 @@ static void
> rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>  		txdesc->u.ht.txop = TXOP_SIFS;
>  	else
>  		txdesc->u.ht.txop = TXOP_HTTXOP;
> +
> +	if (ieee80211_is_back_req(hdr->frame_control))
> +		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
>  }
> 
>  static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,

Unfortunately, I don't think it fixes anything (an equal looking
sequence could be seen just 10s before - ok other ssn numbers :-)):

[38517.363964] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 19
[38517.363977] __set_bit ENTRY_TXD_HT_AMPDU
[38517.363989] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 20
[38517.363995] __set_bit ENTRY_TXD_HT_AMPDU
[38517.364005] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 21
[38517.364011] __set_bit ENTRY_TXD_HT_AMPDU
[38517.364020] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 22
[38517.364026] __set_bit ENTRY_TXD_HT_AMPDU
[38517.364034] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 23
[38517.364042] __set_bit ENTRY_TXD_HT_AMPDU
[38517.375021] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 24
[38517.375028] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27248>
[38517.389129] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 25
[38517.389132] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27264>
[38517.397279] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 26
[38517.397283] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27280>
[38517.407062] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 27
[38517.407069] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27296>
[38517.417684] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 28
[38517.417691] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27312>
[38517.417742] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 2 tid: 0 failed_bar_ssn: 27312
[38517.417751] __set_bit ENTRY_TXD_HT_AMPDU
[38517.417763] ieee80211_check_pending_bar -> ieee80211_send_bar() retry cnt: 1 tid: 0 failed_bar_ssn: 27312
[38517.417768] __set_bit ENTRY_TXD_HT_AMPDU
[38517.417775] ieee80211_check_pending_bar -> ieee80211_stop_tx_ba_session() retry cnt: 0 tid: 0 failed_bar_ssn: 27312
[38517.417840] Tx BA session stop requested for 00:25:9c:11:22:33 tid 0
[38517.426147] Stopping Tx BA session for 00:25:9c:11:22:33 tid 0
[38517.432511] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 29
[38517.432518] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27312>
[38517.439356] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 30
[38517.439362] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <27312>
[38517.491026] Open BA session requested for 00:25:9c:11:22:33 tid 0
[38517.499048] activated addBA response timer on tid 0
[38517.507633] switched off addBA timer for tid 0
[38517.507637] Aggregation is on for tid 0


Some additional information might be interesting: 
I'm getting these tx errors nearly always (I haven't seen them in the
other direction until now) while sending data from STA -> AP (not from
AP -> STA). The throughput from STA -> AP is mostly about 8 MBit/s
whereas the other direction reaches up to 15 MBit/s.



Kind regards,
Andreas
