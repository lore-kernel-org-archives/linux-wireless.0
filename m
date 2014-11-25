Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaKYTis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 14:38:48 -0500
Date: Tue, 25 Nov 2014 20:38:46 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 1/3] cfg80211: leave invalid channels on regdomain
	change
Message-ID: <20141125193846.GJ25677@wotan.suse.de> (sfid-20141125_203857_901828_2B9FAADC)
References: <1416754941-4439-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416754941-4439-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 23, 2014 at 05:02:19PM +0200, Arik Nemtsov wrote:
> When the regulatory settings change, some channels might become invalid.
> Disconnect interfaces acting on these channels, after giving userspace
> code a grace period to leave them.
> 
> This mode is currently opt-in, and not all interface operating modes are
> supported for regulatory-enforcement checks. A wiphy that wishes to use
> the new enforcement code must specify an appropriate regulatory flag,
> and all its supported interface modes must be supported by the chekcing
> code.

This is all looking beter now, since I had a few requests for the last patch
I'll ask for some other things here without asking  to negage the flag purpose
as I originally wanted.

> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> ---
>  include/net/regulatory.h |   6 +++
>  net/wireless/core.c      |  13 ++++++
>  net/wireless/reg.c       | 106 ++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 124 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
> index dad7ab2..701177c 100644
> --- a/include/net/regulatory.h
> +++ b/include/net/regulatory.h
> @@ -136,6 +136,11 @@ struct regulatory_request {
>   *      otherwise initiating radiation is not allowed. This will enable the
>   *      relaxations enabled under the CFG80211_REG_RELAX_NO_IR configuration
>   *      option
> + * @REGULATORY_ENFORCE_CHANNELS: the regulatory core will make sure all
> + *	interfaces on this wiphy reside on allowed channels. Upon a regdomain
> + *	change, the interfaces are given a grace period to disconnect or move
> + *	to an allowed channels. Interfaces on forbidden channels are forcibly
> + *	disconnected.

Please rename to REGULATORY_IGNORE_STALE_KICKOFF, also please add
some information about the amount current of grace period used,
and types of interfaces supported. Since this is a regulatory flag
this information will help folks decide whether to enable or not.
Also encourage its use, and mention that once all supported devices
get support for this will be enabled by default. In the meantime
I'd prefer if this feature was enabled by default if the supported
interface types of a dveice match the white list of supported
interfaces.

  Luis
