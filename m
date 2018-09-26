Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A763EC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A102083A
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="poEZZ07Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51A102083A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeIZPQo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 11:16:44 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42894 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbeIZPQn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 11:16:43 -0400
Received: by mail-ed1-f66.google.com with SMTP id b20-v6so1191946edr.9
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2018 02:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ucyj6XD9kqWbs3VrOP1duuT1acYbiNBsgAnGpGQosOU=;
        b=poEZZ07Q3I63m/d8ythbXuz77oYwvgWhD67OSn/iMKF1zAAY3j2LwUty1k6qGVIS3Y
         bXvOjpbgOpUiEg3aKxqXJwSeqhyc4N/sqAFRoDtBnnpMHH0/UDkUatvekMFxnxg+ueVJ
         ls4C/W/+nYzJdx85NEPWJcnsLJBScucJZrP1tPg6RovaXcT8q1TTFnid4afTmQ4KzJ/R
         qKH9hsuHtKT7RzFMMC19yOdroCnBL9+RCbpz0W8/D9pdkg7e7tuicJOerRt0j8YujieF
         kKobi3pUc1/m9/spjRYTB/1xlXk3Tt9boI4Tu0G/sP+kgcufYMAbHayo/EMHEMni50Wm
         YctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ucyj6XD9kqWbs3VrOP1duuT1acYbiNBsgAnGpGQosOU=;
        b=ZySRk8XbkaMx/N/t4hyaBpTFvM6qNXB4tEboVWG8tIhkqPO4VChxjrSuGqwQ2czHjP
         M6BV2FmlmDlgVtN8AzDx4xg6lgOztI3/u5plOvLH6VpqtoeHVzllI27fsP0CL0SkjAX+
         HRI9ZIneNlXQm3OlLqOW24ZelkJfUDtabNOi0mgDzaDHn0bQX41mATI7M+UhvoqEGQlU
         4clG1M6vv7ZJj0F7ijY059qYGV7d11Icsi94Nv26rS105Q1yDT+GhJvd5NeNLebs0vYS
         d676jGSDR8qmuj4TUbWtMuLe9Jetms59ybiJPjEzBeSE7sGWWdqiEPq3n5Y9/eojUiSS
         6tDw==
X-Gm-Message-State: ABuFfoiK4Jpmhb7n8K2y8ipj3ZfWzsumyrKZ4UkrM8nF9kOMClmaP4Yr
        2URGOoUAMak0cJV78LMgOro=
X-Google-Smtp-Source: ACcGV60/21jnhnqOiBmFWis1La/vXoiMAHy+OqS7J7pgx4biYzhOJGt4nP4d3HmNVxfol+6NXAukzg==
X-Received: by 2002:a50:8f66:: with SMTP id 93-v6mr8191635edy.248.1537952686200;
        Wed, 26 Sep 2018 02:04:46 -0700 (PDT)
Received: from manjaro ([37.237.208.230])
        by smtp.gmail.com with ESMTPSA id p21-v6sm772014eds.32.2018.09.26.02.04.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 02:04:45 -0700 (PDT)
Date:   Wed, 26 Sep 2018 12:04:28 +0300
From:   Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH v3] brcmsmac: AP mode: update beacon when TIM changes
Message-ID: <20180926120428.00e75231@manjaro>
In-Reply-To: <20180923095425.10292-1-alimjalnasrawy@gmail.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
        <20180923095425.10292-1-alimjalnasrawy@gmail.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I suggest here some improvements to this patch but I don't have strong
opinion about them so any feedback is appreciated:

-split it into two: one for storing the current vif into brcms_c_info
and also setting it to NULL on remove_interface to avoid dangling
pointers; and an other one for actually updating the beacon; I believe
them to be separate changes.

On Sun, 23 Sep 2018 12:54:25 +0300
Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com> wrote: 
> +static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
> +				 struct ieee80211_sta *sta, bool set)
> +{
> +	struct brcms_info *wl = hw->priv;
> +	struct sk_buff *beacon;
> +	u16 tim_offset = 0;
> +
> +	beacon = ieee80211_beacon_get_tim(hw, wl->wlc->vif,
> +					  &tim_offset, NULL);
> +	if (beacon){
> +		spin_lock_bh(&wl->lock);
> +		brcms_c_set_new_beacon(wl->wlc, beacon, tim_offset,
> +
> wl->wlc->vif->bss_conf.dtim_period);
> +		spin_unlock_bh(&wl->lock);
> +	}
> +
> +	return 0;
> +}
> +

-on brcms_ops_beacon_set_tim, include ieee80211_beacon_get_tim call in
the lock context and also check for vif to be null before passing it as
argument.

