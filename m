Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48698 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaBRW7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 17:59:44 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so17362168pbb.23
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 14:59:43 -0800 (PST)
Date: Tue, 18 Feb 2014 14:59:39 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v3 2/6] cfg80211: Add Kconfig option for cellular BS hints
Message-ID: <20140218225936.GB14296@garbanzo.do-not-panic.com> (sfid-20140218_235950_773492_326EA834)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-3-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390818118-27261-3-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 27, 2014 at 12:21:54PM +0200, Ilan Peer wrote:
> Move the regulatory cellular base station hints support under
> a specific configuration option and make the option depend
> on CFG80211_CERTIFICATION_ONUS.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> ---
>  net/wireless/Kconfig |    7 +++++++
>  net/wireless/reg.c   |    2 +-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 16d08b3..81c05e4 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -95,6 +95,13 @@ config CFG80211_CERTIFICATION_ONUS
>  	  you are a wireless researcher and are working in a controlled
>  	  and approved environment by your local regulatory agency.
>  
> +config CFG80211_REG_CELLULAR_HINTS
> +	bool "cfg80211 regulatory support for cellular base station hints"
> +	depends on CFG80211_CERTIFICATION_ONUS
> +	---help---
> +	  This option adds support for drivers that can receive regulatory
> +	  hints from cellular base stations

Please use:

This option enables support for parsing regulatory
hints from cellular base stations. If enabled and at
least one driver claims support for parsing cellular
base station hints the regulatory core will allow and
parse these regulatory hints. The regulatory core will
only apply these regulatory hints on drivers that support
this feature. You should only enable this feature if you
have tested and validated this feature on your systems.

  Luis
