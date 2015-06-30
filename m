Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:40043 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752787AbbF3DQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 23:16:37 -0400
Message-ID: <1435634193.9587.64.camel@perches.com> (sfid-20150630_051640_906395_9AC555A7)
Subject: Re: [PATCH v4] Add new mac80211 driver mwlwifi.
From: Joe Perches <joe@perches.com>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Mon, 29 Jun 2015 20:16:33 -0700
In-Reply-To: <cf8d3fa226704acea770a987100f4d4e@SC-EXCH02.marvell.com>
References: <cf8d3fa226704acea770a987100f4d4e@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-30 at 01:49 +0000, David Lin wrote:
> The Linux driver for WRT1900AC. The work was initially developed as part of
> openwrt effort and maintained on https://github.com/kaloz/mwlwifi.

trivia:

Please add terminating newlines to logging messages.
This prevents interleaving output from multiple threads.

> diff --git a/drivers/net/wireless/mwlwifi/fwcmd.c b/drivers/net/wireless/mwlwifi/fwcmd.c
[]
> +static bool mwl_fwcmd_chk_adapter(struct mwl_priv *priv)
> +{
[]
> +	if (regval == 0xffffffff) {
> +		wiphy_err(priv->hw->wiphy, "adapter is not existed");

		wiphy_err(priv->hw->wiphy, "adapter is not existed\n");

> +static int mwl_fwcmd_wait_complete(struct mwl_priv *priv, unsigned short cmd)
> +{
[]
> +	if (curr_iteration == 0) {
> +		wiphy_err(priv->hw->wiphy, "cmd 0x%04x=%s timed out",

		wiphy_err(priv->hw->wiphy, "cmd 0x%04x=%s timed out\n",

etc...


