Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaK1WD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 17:03:27 -0500
Date: Fri, 28 Nov 2014 23:03:25 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v5 2/4] cfg80211: allow usermode to query wiphy
	specific regdom
Message-ID: <20141128220325.GY25677@wotan.suse.de> (sfid-20141128_230331_545923_94305336)
References: <1417074298-12254-1-git-send-email-arik@wizery.com> <1417074298-12254-2-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417074298-12254-2-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 27, 2014 at 09:44:56AM +0200, Arik Nemtsov wrote:
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
> v5: don't return all regdomains if a specific wiphy is requested
> 
>  include/uapi/linux/nl80211.h |  16 +++++-
>  net/wireless/nl80211.c       | 127 +++++++++++++++++++++++++++++++++----------
>  net/wireless/reg.c           |   2 +-
>  net/wireless/reg.h           |   1 +
>  4 files changed, 115 insertions(+), 31 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index d775245..1f2f7d6 100644
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
>   * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
>   *	after being queried by the kernel. CRDA replies by sending a regulatory
>   *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
> @@ -1688,6 +1690,14 @@ enum nl80211_commands {
>   *
>   * @NL80211_ATTR_MAC_MASK: MAC address mask
>   *
> + * @NL80211_ATTR_WIPHY_PRIV_REG: flag attribute indicating the regulatory
> + *	information was obtained from the device's wiphy. This can happen
> + *	when the driver uses the regulatory_hint() API for setting the device's
> + *	regulatory domain.

Can you clarify here that even if a driver used regulatory_hint() its device
will still have some settings further restricted by consenus with other
regulatory data gathered by cfg80211, the main cfg80211 regulatory domain
is reflective of what the wiphy is really allowed, the wiphy->regd in this
case would be reflective of the regulatory domain that the device originally
wanted.

Other than that I think we need a flag to let nl80211 pass all regdomains,
to address Johannes' concerns.

  Luis
