Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53925 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbbA3M6S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:58:18 -0500
Message-ID: <1422622694.1919.17.camel@sipsolutions.net> (sfid-20150130_135821_332536_6F2E65C6)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Fri, 30 Jan 2015 13:58:14 +0100
In-Reply-To: <1422621086-28970-3-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133341_121083_F7682B5B)
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150130_133341_121083_F7682B5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/drivers/net/wireless/ath/ath10k/core.h

> @@ -277,6 +282,7 @@ struct ath10k_vif {
>  	dma_addr_t beacon_paddr;
>  
>  	struct ath10k *ar;
> +	struct ath10k_chanctx *arctx;

you also have vif->chanctx_conf pointer, which you could use

ultimately it's a software architecture decision - personally I wouldn't
want to duplicate all that data and the lists etc. in the driver when
mac80211 has them, but that's just my opinion. :)

johannes


