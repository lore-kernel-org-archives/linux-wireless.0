Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:1088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZIAPhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:37:14 -0400
Received: by fg-out-1718.google.com with SMTP id 22so809577fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:37:16 -0700 (PDT)
Message-ID: <4A9D3FA8.9020800@lwfinger.net>
Date: Tue, 01 Sep 2009 10:37:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/7] wireless: update cfg80211 kconfig entry
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com> <1251818566-9264-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> cfg80211 is now *the* wireless configuration API. Lets also
> give a little explanation as to what it is and refer people to
> the wireless wiki for more information.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/Kconfig |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index aea7e68..9fd570b 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -1,6 +1,15 @@
>  config CFG80211
> -	tristate "Improved wireless configuration API"
> +	tristate "cfg80211 - wireless configuration API"
>  	depends on RFKILL || !RFKILL
> +	---help---
> +	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
> +	  Enable this if you have a wireless device.
> +
> +	  For more information refer to documentation on the wireless wiki:
> +
> +	  http://wireless.kernel.org/en/developers/Documentation/cfg80211
> +
> +	  When built as a module cfg80211 will be built as cfg80211

First of all, I think this modest change is much better than the
previous set of patches, and that the additional info you provide for
mac80211 and friends will be useful for those who don't live with
802.11 wifi all day long.

That said, I find the above statement to be a little clumsy. Perhaps
it should be "When built as a module, it will be called cfg80211". The
same comment also applies to patch 6 for mac80211.

Larry

