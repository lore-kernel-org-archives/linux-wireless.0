Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34030 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYA0Rzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:55:46 -0500
Message-ID: <479CC590.7090406@trash.net> (sfid-20080127_175628_167505_CF7A8C29)
Date: Sun, 27 Jan 2008 18:55:28 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
CC: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com, yi.zhu@intel.com
Subject: Re: [RFC PATCH 06/10] mac80211: A-MPDU Tx adding qdisc support
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com> <11999857503421-git-send-email-ron.rindjunsky@intel.com>
In-Reply-To: <11999857503421-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ron Rindjunsky wrote:
> This patch allows qdisc support in A-MPDU Tx. This is not a complete
> solution, but a general direction to handle QoS <-> TID switches
>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> ---

> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -19,10 +19,13 @@
>  #include "wme.h"
>  
>  /* maximum number of hardware queues we support. */
> -#define TC_80211_MAX_QUEUES 8
> +#define TC_80211_MAX_QUEUES 16

Is there a reason to add new features to this instead of using
the generic multiqueue support, moving classification to a
classifier and killing wme?

