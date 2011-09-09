Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm19-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.113]:34874
	"HELO nm19-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752190Ab1IIOH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 10:07:29 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Alexander Simon <an.alexsimon@googlemail.com>
Subject: Re: [PATCH v2 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT configuration
Date: Fri, 9 Sep 2011 16:07:24 +0200
Cc: linux-wireless@vger.kernel.org
References: <2053881.ENil2Dy3QM@alex-1> <5559682.keg4y6PyKd@alex-1>
In-Reply-To: <5559682.keg4y6PyKd@alex-1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109091607.24738.lindner_marek@yahoo.de> (sfid-20110909_160733_929830_7404BF80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 29, 2011 16:30:41 Alexander Simon wrote:
> +               if (channel) {
> +                       if (bss->pub.channel != channel)
> +                               continue;
> +                       if (check_ht) {
> +                               struct ieee80211_ht_info *ht_info;
> +                               ht_info = (struct ieee80211_ht_info *)
> +                                       ieee80211_bss_get_ie(&bss->pub,
> +                                                      WLAN_EID_HT_INFORMATION); 
> +                               if (!ht_info)
> +                                       continue;
> +                               if (ht_mode == NL80211_CHAN_HT40MINUS &&
> +                                             !(ht_info->ht_param &
> +                                             IEEE80211_HT_PARAM_CHA_SEC_BELOW))
> +                                       continue;
> +                               if (ht_mode == NL80211_CHAN_HT40PLUS &&
> +                                             !(ht_info->ht_param &
> +                                             IEEE80211_HT_PARAM_CHA_SEC_ABOVE))
> +                                       continue;
> +                       }
> +               }

What is the idea behind only checking the ht mode if a channel was specified ?
Is see no immediate need for this dependency - maybe I overlooked something ?

Cheers,
Marek

