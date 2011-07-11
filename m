Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab1GKRhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 13:37:03 -0400
Subject: Re: [PATCH 18/21] iwlagn: allow application own the uCode operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1310139989-27661-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182055_559575_E91406E2)
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1310139989-27661-19-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110708_182055_559575_E91406E2)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 19:37:10 +0200
Message-ID: <1310405830.23469.5.camel@jlt3.sipsolutions.net> (sfid-20110711_193707_380069_A84E163E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-07-08 at 08:46 -0700, Wey-Yi Guy wrote:

> +	struct iwl_priv *priv = hw->priv;
> +	u8 owner;
> +
> +	if (!tb[IWL_TM_ATTR_UCODE_OWNER]) {

This causes a compile warning because iwl_testmode_cmd() has
	struct nlattr *tb[IWL_TM_ATTR_MAX - 1];

and the -1 shouldn't be there.

johannes

