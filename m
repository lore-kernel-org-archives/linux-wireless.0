Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03325C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 13:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA30F2087F
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 13:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfA1NoV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 08:44:21 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37098 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfA1NoU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 08:44:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id g67so13946292wmd.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 05:44:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E6HCdEUZNXKA7SBjUFiESwkTv2HYCI2eh3jxRaYw2EE=;
        b=Pnaxt7p1nq1K3ZOmnsQI7repVfR+jKrS0sVfGVGoM486fqMDIbieEwf6U427rstKEp
         8vqSDBVH5Sp/vFAqdSepuPZEdhwGqJyahOjDbAnNL5MIWXdzKAwvyW/yWvC2D4SAFc3V
         sBqC+o7aA1lfkzbE66UOQPSfGuw1mx1A8mKfShpgl4UFTfPAA5j3qu5g23iCk+ZXtlw2
         wSqBNyGyjK+CoJ8j+jfsa9aBc6iD/TK7w7zuTjgc0QDSVZl6i1ys3YL8PHP1PzdQVAR0
         O8VBAlamIDZYpktfl3LOXyd5n2R0AwaO/a+TEX7n82KmdOPP+NpKornQXhbNAcmEy004
         z9Yg==
X-Gm-Message-State: AJcUukcZK32nxet7EyZ2cprRG7vGdrQ/dO+Ax6FycgYEWNlrAqSVvw/s
        mTlmBbSNnXOSuu90IAcyamsWXg==
X-Google-Smtp-Source: ALg8bN4LFFrgSFDDPgJpJax11PcKcSOYAH5f/UPM7p0meMQTwF5KxIPkRIBoUVehGaqb9/kdH+/ZaQ==
X-Received: by 2002:a1c:dc02:: with SMTP id t2mr16777820wmg.78.1548683058707;
        Mon, 28 Jan 2019 05:44:18 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 3sm87815552wmw.46.2019.01.28.05.44.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Jan 2019 05:44:18 -0800 (PST)
Date:   Mon, 28 Jan 2019 14:44:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 6/7] mt76: beaconing fixes for USB
Message-ID: <20190128134414.GC9257@localhost.localdomain>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <1548678108-9526-7-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548678108-9526-7-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

[...]

> +
> +void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
> +				   struct ieee80211_vif *vif, bool val)
> +{
> +	u8 vif_idx = ((struct mt76x02_vif *)vif->drv_priv)->idx;
> +	struct sk_buff *skb = NULL;
> +
> +	if (mt76_is_mmio(dev))
> +		tasklet_disable(&dev->pre_tbtt_tasklet);
> +	else
> +		skb = ieee80211_beacon_get(mt76_hw(dev), vif);

I guess we can avoid to allocate the skb here if we are disabling 'beaconing'

> +
> +	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
> +
> +	if (mt76_is_mmio(dev))
> +		tasklet_enable(&dev->pre_tbtt_tasklet);
> +}
