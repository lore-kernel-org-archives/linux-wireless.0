Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:57937 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751759AbbEYIOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 04:14:37 -0400
Message-ID: <1432541670.2846.48.camel@perches.com> (sfid-20150525_101441_467827_24EC2945)
Subject: Re: [PATCH] Reordering for better readability and consistency [EDT]
From: Joe Perches <joe@perches.com>
To: rahul.jain@samsung.com
Cc: "johannes.berg@intel.com" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 25 May 2015 01:14:30 -0700
In-Reply-To: <255092351.26861432539449201.JavaMail.weblogic@epmlwas02a>
References: <255092351.26861432539449201.JavaMail.weblogic@epmlwas02a>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-25 at 07:37 +0000, Rahul Jain wrote:
> diff --git a/net/wireless/util.c b/net/wireless/util.c
[]
> @@ -1340,10 +1340,7 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
>  	case 128 ... 130:
>  		*band = IEEE80211_BAND_5GHZ;
>  		return true;
> -	case 81:
> -	case 82:
> -	case 83:
> -	case 84:
> +	case 81 ... 84:
>  		*band = IEEE80211_BAND_2GHZ;
>  		return true;
>  	case 180:

While I don't find this particularly more readable,
I would probably find it more readable in numeric
ascending order and the case moved above BAND_5GHZ.

Also, this function seems to be used only once in
net/mac80211/spectmgmt.c  Maybe it should be static
in that file and not EXPORT_SYMBOL.



