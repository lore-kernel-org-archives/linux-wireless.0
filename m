Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0JDNPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:15:55 -0400
Subject: Re: [PATCH v2 3/3] mac80211: move to the home channel for
 disassociation when roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1285965233-11097-4-git-send-email-lrodriguez@atheros.com>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:15:52 +0200
Message-ID: <1286198152.3620.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 16:33 -0400, Luis R. Rodriguez wrote:

> @@ -2203,6 +2204,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>  			return -EALREADY;
>  		}
>  
> +		/*
> +		 * right before this was authentication, that was on
> +		 * the same the wk->chan so we need to ensure we temporarily
> +		 * go back to the operating channel to send the disassocation.
> +		 */
> +		local->tmp_channel = NULL;
> +		ieee80211_hw_config(local, 0);
> +

Yikes, no, you can't do this. You don't know what has been merged with
the authentication work item, etc.

johannes

