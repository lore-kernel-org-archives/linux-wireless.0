Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp29.msg.oleane.net ([62.161.4.29]:55181 "EHLO
	smtp29.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422897AbbFEOIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 10:08:14 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
References: <01eb01d09f64$fd522730$f7f67590$@acksys.fr>	<CA+BoTQnehkYETptdaw4VsqKmhAampJ9_Zm_bNfH6PwGX7SqRww@mail.gmail.com>	<01f701d09f71$47ae9910$d70bcb30$@acksys.fr>	<CA+BoTQkQyTbgctPOTSvLH76+YKkjvYySJSYtGszJ3TT35-uXQQ@mail.gmail.com>	<01fb01d09f7c$d6bdfa00$8439ee00$@acksys.fr>	<CA+BoTQkBPkNPCX2YJSvSBbcGe_4RT3Ua_54MVmSMwUyWef-gzA@mail.gmail.com> <CA+BoTQmkV9Pg9pMiVarhj_peSPFCBZykMJDx_sZ0HbQ-4NUmdA@mail.gmail.com>
In-Reply-To: <CA+BoTQmkV9Pg9pMiVarhj_peSPFCBZykMJDx_sZ0HbQ-4NUmdA@mail.gmail.com>
Subject: RE: ATH10K and VLAN : Frame with VLAN tag are not sent
Date: Fri, 5 Jun 2015 16:07:09 +0200
Message-ID: <020501d09f98$e9853150$bc8f93f0$@acksys.fr> (sfid-20150605_160920_896411_67489C78)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >>> >
> >>> > I did an interesting test. With ostinato software I generate an
> >>> > ICMP
> >>> frame without vlan tag. I changed the ethertype in the frame.
> >>> > I tried with the ethertype 0x800 (IP), 0x801, 0x8892 (PROFINET),
> >>> > 0x8100
> >>> (dot1q), 0x0600. All frames are sent except when the ethertype is
> >>> set to 0x8100. It seems the firmware do not accept the ethertype
> 0x8100.
> >>>
> >>> Interesting. This may suggest firmware actually doesn't handle dot1q
> >>> VLAN tagging properly in NWifi Tx encap mode. Can you try changing
> >>> it to 802.3 encap and re-test, please?
> >>>
> >>> --- a/drivers/net/wireless/ath/ath10k/mac.c
> >>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> >>> @@ -3172,7 +3172,7 @@ ath10k_tx_h_get_txmode(struct ath10k *ar,
> >>> struct ieee80211_vif *vif,
> >>>         if (ieee80211_is_data_present(fc) && sta && sta->tdls)
> >>>                 return ATH10K_HW_TXRX_ETHERNET;
> >>>
> >>> -       return ATH10K_HW_TXRX_NATIVE_WIFI;
> >>> +       return ATH10K_HW_TXRX_ETHERNET;
> >>>  }
> >>>
> >>> Note: Your backports may not have the necessary code.. In which case
> >>> it'll be difficult to do this the easy way. If that's the case I
> >>> suggest you get latest backports or generate them yourself from the
> >>> latest kvalo/ath master.
> >> I will try to change my backport. But it is not easy, because I need
> to use a cross-compiler. From openwrt website I can download a backport
> 2015-05-08. I will try to integrate it.
> >>
> >> Do you know how I can generate a tar file for openwrt from kale git
> hub?
> >
> > That's non-trivial as far as I understand. You could try generating a
> > quilt patch in openwrt to update ath10k. Either some sort of manual
> > cherry-picking of the txmode patch for ath10k or create a partial diff
> > (e.g. only drivers/net/wireless/ath/ath10k) between openwrt backports
> > and kvalo/ath generated backports.
> 
> I've managed to reproduce your problem in my setup.
> 
> With NWifi Txed frames with dot1Q VLAN tagging aren't even sent OTA and
> are reported as not acked by firmware.
> 
> When I changed the Tx encap mode to 802.3 (ethernet) I can see frames OTA
> but they are corrupted 3addr frames with invalid SA/DA addresses.
> I'm guessing this is because firmware expects explicit
> WMI_PEER_ADD_WDS_ENTRY_CMDID to be issued when trying too use 802.3 Tx
> encap with 4addr frames.
> 

Thanks for these informations, but where I need to set the flag WMI_PEER_ADD_WDS_ENTRY_CMDID?
The backport 2015-05-08 should support your modification. I'm trying du compile it.

> 
> Michał

