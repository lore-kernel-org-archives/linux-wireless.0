Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:54367 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925Ab1B0Kr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 05:47:29 -0500
Date: Sun, 27 Feb 2011 12:47:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH 2/5] mac80211: Let user space receive and send mesh
 auth/deauth frames
Message-ID: <20110227104723.GA8482@jm.kir.nu>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
 <1298683960-20835-3-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298683960-20835-3-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 05:32:37PM -0800, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>
> @@ -529,7 +529,9 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
>  	[NL80211_IFTYPE_MESH_POINT] = {
> +		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
> +			BIT(IEEE80211_STYPE_AUTH >> 4) |
> +			BIT(IEEE80211_STYPE_DEAUTH >> 4),

This seems to be pointing towards processing the full Authentication
frame in user space. However, some other patches in this series seemed
to be extending the NL80211_CMD_AUTHENTICATE mechanism to allow SAE to
be implemented on top of it. Which direction is being taken here? Or are
both mechanisms going to be used depending on iftype?

For non-mesh cases, I would probably prefer NL80211_CMD_AUTHENTICATE
extension for the station vif to continue with the style we started for
FT. The AP vif is already handling the full Authentication frame in user
space, so that is fine to for SAE, too.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
