Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33714 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbbGMFms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 01:42:48 -0400
Received: by widic2 with SMTP id ic2so2480330wid.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2015 22:42:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=o5b7rZUW9Wr4K0P2d3XreCO2hcf5t8+0eArwAVfWSUKQ@mail.gmail.com>
References: <CALhHN=o5b7rZUW9Wr4K0P2d3XreCO2hcf5t8+0eArwAVfWSUKQ@mail.gmail.com>
Date: Mon, 13 Jul 2015 07:42:46 +0200
Message-ID: <CALhHN=ruLW=hfnAO5A9p6Ggu+KtrcwKSTBomnOTAym7b5jpBOg@mail.gmail.com> (sfid-20150713_074255_278366_5B7ACA2D)
Subject: Re: ath9k: multicast don't work when: two STA (sta + p2p_client) + hwcrypt
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Felix Fietkau <nbd@openwrt.org>,
	Sujith Manoharan <sujith@msujith.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 June 2015 at 10:06, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> STA iface:
> ath: phy0: Set HW Key 0 (pairwise) vif: 2c:d0:5a:d3:f1:e9 sta:
> f4:b7:e2:38:83:f3 - idx: 4
> ath: phy0: Set HW Key 0 (group) vif: 2c:d0:5a:d3:f1:e9 sta:
> (null) - idx: 1
>
> P2P_CLIENT iface:
> ath: phy0: Set HW Key 0 (pairwise) vif: 2e:d0:5a:d3:f1:e9 sta:
> 0c:8b:fd:1e:58:9f - idx: 68
> ath: phy0: Set HW Key 0 (group) vif: 2e:d0:5a:d3:f1:e9 sta:
> (null) - idx: 1
>
> Seems we overwrite multicast hw key - both idx = 1
>
> 1) First patch I made:
>
> diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
> index 1816b4e..b15873b 100644
> --- a/drivers/net/wireless/ath/key.c
> +++ b/drivers/net/wireless/ath/key.c
> @@ -507,6 +507,15 @@ int ath_key_config(struct ath_common *common,
>
>         if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
>                 switch (vif->type) {
> +               case NL80211_IFTYPE_STATION:
> +                       idx = key->keyidx;
> +                       if (vif->bss_conf.bssid) {
> +                               ether_addr_copy(gmac, bssid);
> +                               gmac[0] |= 0x01;
> +                               mac = gmac;
> +                               idx =
> ath_reserve_key_cache_slot(common, key->cipher);
> +                       }
> +                       break;
>                 case NL80211_IFTYPE_AP:
>                         memcpy(gmac, vif->addr, ETH_ALEN);
>                         gmac[0] |= 0x01;
>
> Multicast works fine for STA/P2P_CLIENT but multicast rekeying don't
> work correctly, while we have 2 multicast keys installed for the same
> bssid (eg. idx 6, 68) after rekey. Seem hw choose always key with
> lowest idx - hw decrypt mcast packects correctly every second rekey
> :-)
>
> BTW, this needs attention to be sure hw decrypt frames correctly - I
> am checking RX_FLAG_DECRYPTED flag, while often HW send crypted
> packets and mac80211 decrypt them correctly (every second rekey for
> example). So, some mixture of hwcrypt and swcrypt is seen :)
>
> 2) works perfectly when ath9k loaded with nohwcrypt=1
>
> Any ideas how to solve this correctly (is it possible with hwcrypt at all)?
>
> BR
> Janusz

Adding ath9k-devel@lists.ath9k.org
