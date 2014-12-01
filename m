Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbaLAQIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 11:08:31 -0500
Date: Mon, 1 Dec 2014 17:08:29 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v6 1/4] cfg80211: allow usermode to query wiphy
	specific regdom
Message-ID: <20141201160829.GE25677@wotan.suse.de> (sfid-20141201_170840_248055_5F2C0620)
References: <1417448927-9337-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417448927-9337-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2014 at 05:48:44PM +0200, Arik Nemtsov wrote:
> If a wiphy-idx is specified, the kernel will return the wiphy specific
> regdomain, if such exists. Otherwise return the global regdom.
> 
> When no wiphy-idx is specified, return the global regdomain as well as
> all wiphy-specific regulatory domains in the system, via a new nested
> list of attributes.
> 
> Add a new attribute for each wiphy-specific regdomain, for usermode to
> identify it as such.
> 
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> ---
>  include/uapi/linux/nl80211.h |  11 ++-
>  net/wireless/nl80211.c       | 178 +++++++++++++++++++++++++++++++++++--------
>  net/wireless/reg.c           |   2 +-
>  net/wireless/reg.h           |   1 +
>  4 files changed, 157 insertions(+), 35 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index b37bd5a..2b03274 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -252,7 +252,9 @@
>   *	%NL80211_ATTR_IFINDEX.
>   *
>   * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
> - * 	regulatory domain.
> + *	regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
> + *	has a private regulatory domain, it will be returned. Otherwise, the
> + *	global regdomain will be returned.

Its important we clarify here the meaning of what a private regdomain is and
the differenct types there are.  Since this is patch 1 and no self managed is
yet added you can just describe that a driver that uses regulatory_hint() may
have a regulatory domain hint first instantiated and used for it, this is the
regdomain that is sent. Even if a regdomain was originally used the wiphy
channel information will still be mended depending on further hints from the
regulatory core to help with compliance.

> @@ -1688,6 +1690,11 @@ enum nl80211_commands {
>   *
>   * @NL80211_ATTR_MAC_MASK: MAC address mask
>   *
> + * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating this device
> + *	is self-managing its regulatory information and any regulatory domain
> + *	obtained from it is coming from the device's wiphy and not the global
> + *	cfg80211 regdomain.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2045,6 +2052,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_MAC_MASK,
>  
> +	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
> +

This is unused in this patch... it is actually used on patch #3 so it
seems this belongs there.

  Luis
