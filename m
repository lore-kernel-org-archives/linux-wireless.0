Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30786 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbbF3Dt5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 23:49:57 -0400
From: David Lin <dlin@marvell.com>
To: Joe Perches <joe@perches.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v4] Add new mac80211 driver mwlwifi.
Date: Tue, 30 Jun 2015 03:49:51 +0000
Message-ID: <ad49eacb50784efaa37cae2a67401276@SC-EXCH02.marvell.com> (sfid-20150630_055013_601770_B8886754)
References: <cf8d3fa226704acea770a987100f4d4e@SC-EXCH02.marvell.com>
 <1435634193.9587.64.camel@perches.com>
In-Reply-To: <1435634193.9587.64.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Joe Perches wrote:
> 
> On Tue, 2015-06-30 at 01:49 +0000, David Lin wrote:
> > The Linux driver for WRT1900AC. The work was initially developed as
> > part of openwrt effort and maintained on https://github.com/kaloz/mwlwifi.
> 
> trivia:
> 
> Please add terminating newlines to logging messages.
> This prevents interleaving output from multiple threads.
> 
> > diff --git a/drivers/net/wireless/mwlwifi/fwcmd.c
> > b/drivers/net/wireless/mwlwifi/fwcmd.c
> []
> > +static bool mwl_fwcmd_chk_adapter(struct mwl_priv *priv) {
> []
> > +	if (regval == 0xffffffff) {
> > +		wiphy_err(priv->hw->wiphy, "adapter is not existed");
> 
> 		wiphy_err(priv->hw->wiphy, "adapter is not existed\n");
> 
> > +static int mwl_fwcmd_wait_complete(struct mwl_priv *priv, unsigned
> > +short cmd) {
> []
> > +	if (curr_iteration == 0) {
> > +		wiphy_err(priv->hw->wiphy, "cmd 0x%04x=%s timed out",
> 
> 		wiphy_err(priv->hw->wiphy, "cmd 0x%04x=%s timed out\n",
> 
> etc...
> 
Should be modified in next patch.
