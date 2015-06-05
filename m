Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp29.msg.oleane.net ([62.161.4.29]:40899 "EHLO
	smtp29.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbbFEKrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 06:47:17 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
References: <01eb01d09f64$fd522730$f7f67590$@acksys.fr>	<CA+BoTQnehkYETptdaw4VsqKmhAampJ9_Zm_bNfH6PwGX7SqRww@mail.gmail.com>	<01f701d09f71$47ae9910$d70bcb30$@acksys.fr> <CA+BoTQkQyTbgctPOTSvLH76+YKkjvYySJSYtGszJ3TT35-uXQQ@mail.gmail.com>
In-Reply-To: <CA+BoTQkQyTbgctPOTSvLH76+YKkjvYySJSYtGszJ3TT35-uXQQ@mail.gmail.com>
Subject: RE: ATH10K and VLAN : Frame with VLAN tag are not sent
Date: Fri, 5 Jun 2015 12:46:11 +0200
Message-ID: <01fb01d09f7c$d6bdfa00$8439ee00$@acksys.fr> (sfid-20150605_124721_057398_36BD862C)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] De la part de Michal Kazior
> Envoyé : vendredi 5 juin 2015 11:46
> À : voncken
> Cc : linux-wireless; ath10k@lists.infradead.org
> Objet : Re: ATH10K and VLAN : Frame with VLAN tag are not sent
> 
> [...]
> >> I see no reason why this should fail. The dot1q encapsulation
> >> shouldn't influence how firmware behaves.. but maybe I'm wrong.
> >>
> >> It's still unclear to me what your topology looks like. Perhaps
> >> you're having problem with environmental configuration itself? Did
> >> you try other Wi-Fi device (e.g. ath9k) instead of ath10k?
> > Yes I tested with ath9k wireless card, the same configuration works.
> >
> > I did an interesting test. With ostinato software I generate an ICMP
> frame without vlan tag. I changed the ethertype in the frame.
> > I tried with the ethertype 0x800 (IP), 0x801, 0x8892 (PROFINET), 0x8100
> (dot1q), 0x0600. All frames are sent except when the ethertype is set to
> 0x8100. It seems the firmware do not accept the ethertype 0x8100.
> 
> Interesting. This may suggest firmware actually doesn't handle dot1q VLAN
> tagging properly in NWifi Tx encap mode. Can you try changing it to 802.3
> encap and re-test, please?
> 
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3172,7 +3172,7 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct
> ieee80211_vif *vif,
>         if (ieee80211_is_data_present(fc) && sta && sta->tdls)
>                 return ATH10K_HW_TXRX_ETHERNET;
> 
> -       return ATH10K_HW_TXRX_NATIVE_WIFI;
> +       return ATH10K_HW_TXRX_ETHERNET;
>  }
> 
> Note: Your backports may not have the necessary code.. In which case
> it'll be difficult to do this the easy way. If that's the case I suggest
> you get latest backports or generate them yourself from the latest
> kvalo/ath master.
I will try to change my backport. But it is not easy, because I need to use a cross-compiler. From openwrt website I can download a backport 2015-05-08. I will try to integrate it.

Do you know how I can generate a tar file for openwrt from kale git hub?
Cedric

> 
> 
> Michał
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html

