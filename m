Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1BRLFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:05:34 -0500
Subject: Re: [PATCH 2/2] mac80211: Clear PS related flag on disabling power
 save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1298018905-6984-1-git-send-email-vnatarajan@atheros.com>
References: <1298018905-6984-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:05:22 +0100
Message-ID: <1298027122.3772.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 14:18 +0530, Vivek Natarajan wrote:
> Clear IEEE80211_STA_NULLFUNC_ACKED flag on disabling power
> save. Without this fix, there is a chance of setting CONF_PS
> before sending nullfunc frame.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>


>  		ieee80211_queue_work(&local->hw,
>  				     &local->dynamic_ps_disable_work);
> +		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;

Shouldn't those be the other way around, just to make reading easier?

johannes

