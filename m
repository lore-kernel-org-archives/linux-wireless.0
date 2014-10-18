Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57956 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaJRH5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 03:57:17 -0400
Received: by mail-wi0-f171.google.com with SMTP id em10so3603369wid.16
        for <linux-wireless@vger.kernel.org>; Sat, 18 Oct 2014 00:57:16 -0700 (PDT)
Date: Sat, 18 Oct 2014 09:57:06 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RESEND PATCH v2 4/4] mac80211: minstrel_ht: add basic support
 for VHT rates <= 3SS@80MHz
Message-ID: <20141018075651.GA31338@gobelin> (sfid-20141018_095730_799495_46908BE9)
References: <1413570896-27740-5-git-send-email-karl.beldan@gmail.com>
 <1413575459-29612-1-git-send-email-karl.beldan@gmail.com>
 <1413575459-29612-5-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In v3 the moduleparam minstrel_vht_only should go under
CONFIG_MAC80211_RC_MINSTREL_VHT.

On Fri, Oct 17, 2014 at 09:50:59PM +0200, Karl Beldan wrote:
> @@ -91,6 +124,10 @@
>  		}					\
>  	}
>  
> +static bool minstrel_vht_only = true;
> +module_param(minstrel_vht_only, bool, 0644);
> +MODULE_PARM_DESC(minstrel_vht_only, "Use only VHT rates when VHT is supported by sta.");
> +
Here,

> @@ -1012,6 +1155,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>  			continue;
>  		}
>  
> +		if (minstrel_vht_only && !(gflags & IEEE80211_TX_RC_VHT_MCS))
> +			continue;
> +
and there.

 
Karl
