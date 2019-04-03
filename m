Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9570C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F11920882
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GfM/yoeY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfDCT5Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 15:57:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44068 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfDCT5Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 15:57:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id i2so8836184pgj.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 12:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=an4G9DlkQJnw9LYLtuTe/g4HOjWNsEnVvOcfLgUxuUQ=;
        b=GfM/yoeY4p2YDeg79PF4O6xdTtxFlg4qpqtgb596j8/LHWre24t3cI31hYo5gzpqmY
         j0wQp6TfQQ8wKaGtEnOQCvC0xVBudtrqTd0XPK+bE+lKg37cfuBtsA5/TUdHJZWGSm5r
         dfNVr/nNAfbVZG5EsufDVbHEUHwGPuMrEq7uQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=an4G9DlkQJnw9LYLtuTe/g4HOjWNsEnVvOcfLgUxuUQ=;
        b=X4Ki2LBxfBKl51U+WLQkghqjMz0P1t2xJSlgJoCktUFgWBtsrWT3285YT5dOAyzuCg
         ns58oGGVgBIzzAkeO81PxP9JmiTCUBcGXtRuSI6Qj41OZ+YHsdxbQ5xkQk6HwdurfVfy
         odX82CX1vf7RtIKDRQrnZg0YRLdLhhWpZ5dTanWfsWB+2XetufVDKjSa9TxWg9C2Vjyl
         j/DHLNWIxoiarzqpUEHbQRjfiVOtWAoULucS7hyBq/p715PWOZd1qlih0c+v5H9P4Ju7
         ao0+mL3+xGhLkoknL/+c3SmkqxCik4P4zLD+6QhUU8iz9MV6kMC80xKHT5BBjLI7QeOZ
         XnFQ==
X-Gm-Message-State: APjAAAVA0fzW/xzx08ZdyXJ46xa6sSP6ydnXcXVLE4rpIcd3k4f8iiZH
        2UC7AF0xNMkNVfrZFrOz2pgsBA==
X-Google-Smtp-Source: APXvYqzt0kIoakdW5oUFFaB8Q1wWX8ChImi79ucnutdpgtLOmg96I3A9U0E2hvv3PwkeEAOI1/A5SA==
X-Received: by 2002:a63:2a09:: with SMTP id q9mr1544367pgq.397.1554321444082;
        Wed, 03 Apr 2019 12:57:24 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id j19sm17885347pfh.41.2019.04.03.12.57.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Apr 2019 12:57:22 -0700 (PDT)
Date:   Wed, 3 Apr 2019 12:57:20 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        ath10k@lists.infradead.org, Todd Brandt <todd.e.brandt@intel.com>,
        linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Claire Chang <tientzu@google.com>
Subject: Re: [PATCH] ath10k: Drop WARN_ON()s that always trigger during
 system resume
Message-ID: <20190403195718.GA74723@google.com>
References: <2884043.Jv1Mn93hE8@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2884043.Jv1Mn93hE8@aspire.rjw.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Sriram, Pradeep, Claire

On Sun, Mar 03, 2019 at 06:24:33PM +0100, Rafael J. Wysocki wrote:

Ooh, exactly 1 month ago!

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> ath10k_mac_vif_chan() always returns an error for the given vif
> during system-wide resume which reliably triggers two WARN_ON()s
> in ath10k_bss_info_changed() and they are not particularly
> useful in that code path, so drop them.
> 

Particularly, when WOWLAN isn't enabled, we get called during resume via
ieee80211_reconfig(), where we're not associated and don't have any
channel contexts. AFAICT, we shouldn't need to communicate anything in
particular to the firmware here, and so failing the 'if' is definitely
not worth WARN-ing about.

I'd love to see this get applied with:

Fixes: cd93b83ad927 ("ath10k: support for multicast rate control")
Fixes: f279294e9ee2 ("ath10k: add support for configuring management packet rate")

and sent to stable. This has been bugging people since 4.19. Spurious
WARN_ON()s can trigger reports to various crash trackers, and on some
systems appear as user-visible warnings ("System problem detected").

> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/ath/ath10k/mac.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/net/wireless/ath/ath10k/mac.c
> ===================================================================
> --- linux-pm.orig/drivers/net/wireless/ath/ath10k/mac.c
> +++ linux-pm/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5705,7 +5705,7 @@ static void ath10k_bss_info_changed(stru
>  	}
>  
>  	if (changed & BSS_CHANGED_MCAST_RATE &&
> -	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
> +	    !ath10k_mac_vif_chan(arvif->vif, &def)) {
>  		band = def.chan->band;
>  		rateidx = vif->bss_conf.mcast_rate[band] - 1;
>  
> @@ -5743,7 +5743,7 @@ static void ath10k_bss_info_changed(stru
>  	}
>  
>  	if (changed & BSS_CHANGED_BASIC_RATES) {
> -		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
> +		if (ath10k_mac_vif_chan(vif, &def)) {
>  			mutex_unlock(&ar->conf_mutex);
>  			return;
>  		}
> 
