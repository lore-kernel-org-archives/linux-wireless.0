Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:53834 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBZJ6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:58:52 -0500
Message-ID: <1393408729.13669.1.camel@dubbel> (sfid-20140226_105856_775176_DAE2E6B1)
Subject: Re: [PATCH v5 3/4] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Wed, 26 Feb 2014 11:58:49 +0200
In-Reply-To: <1393331984-21692-4-git-send-email-luca@coelho.fi>
References: <1393331984-21692-1-git-send-email-luca@coelho.fi>
	 <1393331984-21692-4-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 14:39 +0200, Luciano Coelho wrote:
> +		if (sdata_iter == sdata ||
> +		    rcu_access_pointer(sdata->vif.chanctx_conf) == NULL ||
> +		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
> +			continue;

There is a typo here, we should check sdata_iter->vif.chanctx_conf
instead of sdata...

v6 coming soon.

--
Luca.

