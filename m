Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0LNHQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 02:16:22 -0500
Subject: Re: [PATCH 03/14] iwlagn: check ready in iwlagn_bss_info_changed()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>
In-Reply-To: <1292285372-11373-4-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1292285372-11373-4-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 08:16:19 +0100
Message-ID: <1292310979.3569.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-13 at 16:09 -0800, Wey-Yi Guy wrote:

> -	if (WARN_ON(!ctx->vif)) {
> +	if (unlikely(!iwl_is_ready(priv))) {
> +                IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
> +                mutex_unlock(&priv->mutex);
> +		return;

There appears to be some whitespace damage here.

johannes

