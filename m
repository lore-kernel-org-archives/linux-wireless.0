Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54816 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbbLKULL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 15:11:11 -0500
Date: Fri, 11 Dec 2015 21:02:05 +0100
From: Stefan Sperling <stsp@openbsd.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi A-MSDU tx
Message-ID: <20151211200205.GV25635@ted.stsp.name> (sfid-20151211_211114_683298_FE229442)
References: <20151203220522.GB11138@jessup.stsp.name>
 <CANUX_P2qxe+BqLPPWOs5uWiBY5nO4e8C1A7gkkYnvrTG270YFQ@mail.gmail.com>
 <CANUX_P0P5A6q1yQwrgagO5rVpE=6Zk0Fq2gNA-WVhkc7Ov2NdQ@mail.gmail.com>
 <CANUX_P19Aq_PKyUscg8jBkH=XJim1aut9kTmNUrVMeRt-upNyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P19Aq_PKyUscg8jBkH=XJim1aut9kTmNUrVMeRt-upNyw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

Thanks a bunch, this worked out quite well for me.
I got what I was aiming for out of this already but I still have some
additional questions if you don't mind.

Do you know of a good way to generate A-MSDUs?
One way I found is to run:
  top -d .01
on the AP and watching this top over SSH from my associated OpenBSD client.

It seems only locally generated packets will trigger A-MSDUs.
I suppose forwarded frames always fit the interface MTU and don't
trigger A-MSDUs. Is there a way to test this with forwarded traffic?

One issue I discovered is that OpenBSD (with my partly uncommitted 11n
patch set) cannot decrypt encrypted A-MSDUs sent by iwlwifi.
Frames carrying normal MSDUs have a CCMP header and are decrypted correctly.
But frames carrying A-MSDUs have a wep/tkip header (wireshark shows
"WEP parameters" instead of CCMP parameters") and decryption fails on
OpenBSD in ieee80211_ccmp_decrypt() because the ExtIV bit is not set.
It doesn't look like the source of this problem is at OpenBSD's end since
CCMP is required for HT. So in case the firmware doesn't produce CCMP for
A-MSDUs, this would be a problem in the firmware. Can you confirm this?
I also tried running iwlwifi in software crypto mode but the AP would
not send A-MSDUs at all in that case.

On the receiving OpenBSD side I'm currently limited to 4k A-MSDU and it
turns out the AP won't send more than 2 subframes per A-MSDU in this case.
To test with more than 2 subframes I applied the following crude patch which
makes the AP send more subframes but crashes the firmware after the frame
is sent. The driver recovers fine and traffic keeps flowing but that's
not pretty. Do you have a better idea? If not, no problem. I mainly did
this to confirm that OpenBSD won't crash handling A-MSDU with more than
2 subframes, which it won't.

Thanks again,
Stefan

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 7ece5c1..b3d562d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -448,7 +448,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	unsigned int mss = skb_shinfo(skb)->gso_size;
+	unsigned int mss = skb_shinfo(skb)->gso_size / 2;
 	struct sk_buff *tmp, *next;
 	char cb[sizeof(skb->cb)];
 	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;

On Fri, Dec 04, 2015 at 12:30:52PM +0200, Emmanuel Grumbach wrote:
> Adding the right mailing list this time.
> 
> On Fri, Dec 4, 2015 at 10:18 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> > On Fri, Dec 4, 2015 at 9:35 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> >> Hi,
> >>
> >> On Fri, Dec 4, 2015 at 12:05 AM, Stefan Sperling <stsp@openbsd.org> wrote:
> >>> Hi Emmanuel,
> >>>
> >>> As part of implementing 802.11n support in OpenBSD I'm looking for
> >>> an AP which sends A-MSDUs. Preferrably under software control rather
> >>> than firmware.
> >>>
> >>> I found your iwlwifi A-MSDU patches at
> >>> http://marc.info/?l=linux-wireless&m=144553311122495&w=2
> >>> and http://marc.info/?l=linux-wireless&m=144553311822496&w=2
> >>>
> >>> Would these patches make it possible to run an AP with an 5300 or 7260
> >>> card and send A-MSDUs? That would be great as I have the necessary hardware.
> >>
> >> 7260 will go. Not 5300.
> >> Note that this code simulates Tx TCP Csum offload. I did that to write
> >> the code while we still don't have the hardware that has this
> >> capability. But for testing purposes, it should do the work. The
> >> testing teams have reported that AP mode didn't work quite well with
> >> this and I haven't taken the time to look into yet, but if you see
> >> issues, please report them or even better: fix them :)
> >>
> >>>
> >>> Which Linux tree do these patches apply to? I've tried the following
> >>> but had no luck in getting these patches applied without rejects:
> >>>
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> >>>
> >>
> >> Right. These patches had a long internal review cycle. They are now
> >> merge in our internal tree.
> >> You can find them in our internal tree [1] (backport based). I will
> >> push them soon in iwlwifi-next.git.
> >
> > I forgot to mention that you need to change the define of
> > IWL_MVM_SW_TX_CSUM_OFFLOAD to 1.
> >
> >>
> >> [1] - https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/
> >> Please read https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release#how_to_install_the_driver.
> >>
> >>> Thanks,
> >>> Stefan
