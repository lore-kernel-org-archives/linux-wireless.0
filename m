Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1EaTcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:32:05 -0400
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1306869394-83047-2-git-send-email-nbd@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 21:31:58 +0200
Message-ID: <1306870318.29989.0.camel@jlt3.sipsolutions.net> (sfid-20110531_213210_240492_E1746206)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:

> +	rcu_read_lock();
> +
> +	sta = sta_info_get(sdata, sdata->u.wds.remote_addr);
> +
> +	if (!sta) {
> +		rcu_read_unlock();
> +		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
> +				     GFP_KERNEL);
> +		if (!sta)
> +			return;
> +
> +		new = true;
> +	}

...

> +	rcu_read_unlock();

definitely doesn't look right.

johannes

