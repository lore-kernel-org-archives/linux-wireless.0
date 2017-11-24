Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35254 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753758AbdKXVRS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 16:17:18 -0500
Received: by mail-qk0-f194.google.com with SMTP id p19so25927082qke.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Nov 2017 13:17:17 -0800 (PST)
Subject: Re: [PATCH] cfg80211: select CRYPTO_SHA256 if needed
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20171124083525.28735-1-johannes@sipsolutions.net>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9f8c14d6-d70d-693c-9ada-44d092f8d757@gmail.com> (sfid-20171124_221723_200342_283CF524)
Date: Fri, 24 Nov 2017 13:17:14 -0800
MIME-Version: 1.0
In-Reply-To: <20171124083525.28735-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2017 12:35 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When regulatory database certificates are built-in, they're
> currently using the SHA256 digest algorithm, so add that to
> the build in that case.
> 
> Also add a note that for custom certificates, one may need
> to add the right algorithms.
> 
> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for the quick fix!

> ---
>  net/wireless/Kconfig | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index da91bb547db3..1abcc4fc4df1 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -20,6 +20,10 @@ config CFG80211
>  	tristate "cfg80211 - wireless configuration API"
>  	depends on RFKILL || !RFKILL
>  	select FW_LOADER
> +	# may need to update this when certificates are changed and are
> +	# using a different algorithm, though right now they shouldn't
> +	# (this is here rather than below to allow it to be a module)
> +	select CRYPTO_SHA256 if CFG80211_USE_KERNEL_REGDB_KEYS
>  	---help---
>  	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
>  	  Enable this if you have a wireless device.
> @@ -113,6 +117,9 @@ config CFG80211_EXTRA_REGDB_KEYDIR
>  	  certificates like in the kernel sources (net/wireless/certs/)
>  	  that shall be accepted for a signed regulatory database.
>  
> +	  Note that you need to also select the correct CRYPTO_<hash> modules
> +	  for your certificates, and if cfg80211 is built-in they also must be.
> +
>  config CFG80211_REG_CELLULAR_HINTS
>  	bool "cfg80211 regulatory support for cellular base station hints"
>  	depends on CFG80211_CERTIFICATION_ONUS
> 

-- 
Florian
