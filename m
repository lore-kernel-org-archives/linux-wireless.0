Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3536FC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE1802087A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE1802087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbeIYOBI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 10:01:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40879 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbeIYOBI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 10:01:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8-v6so18598593wrh.7
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 00:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sSFt5ypKvUucGO+N8uq9Xozba9Y7st8CW3Maix9N++I=;
        b=RS2Ehejro6+stLLGZrV4a30Vw8ttRkTv2X+s4kgme5sPC0Bz5pir2NIxxcLbdb2sgF
         TLX8kwPM7CSc64Q2ZPKdF8O8EQunng9XNHg2wFNgtcu2BGju+eeemkQxVgkzalLEXCup
         Rv9LgSE11XKCxJhe/Au+33f7zNrvqMysXTASKbl0wB8V9O9Tdn+v1c8eS/I/fHf9MUdG
         o8y9heLMigpTI1NFy3UJy88KkXsSmBnOjOUAgCmJuJD4Xj07k49xOukjqawV4MBdUtae
         HEUEMsnXetOHtW7PAaDdM6dblh40fyIPPuiwM9tNRVYmq4JVM4nTlO26JqDT93ENfciX
         Fb3g==
X-Gm-Message-State: ABuFfojBtCZ3VEf/tIP37m2A/7Nj4EoSnzLWp8WjLfP5YsczwhxU/DGb
        AYhgSVDD0Sq+JGITvo0frFMeoQ==
X-Google-Smtp-Source: ACcGV61q5stN5IZflyp4V5yz3ek7A2NPujAmPO4QjxZgZlMVzNPaqvKaxhxhBDHVVzzCVfnEPR7nig==
X-Received: by 2002:a5d:54cb:: with SMTP id x11-v6mr1878438wrv.150.1537862088891;
        Tue, 25 Sep 2018 00:54:48 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t4-v6sm1871443wrb.45.2018.09.25.00.54.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 00:54:48 -0700 (PDT)
Date:   Tue, 25 Sep 2018 09:54:46 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Sid Hayn <sidhayn@gmail.com>
Subject: Re: [PATCH] mt76x0: add quirk to disable 2.4GHz band for Archer T1U
Message-ID: <20180925075445.GA3872@localhost.localdomain>
References: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>  
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> index 76d607f73758..b7a1069ecd0e 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> @@ -45,7 +45,8 @@
>  	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
>  	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
>  	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
> -	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
> +	{ USB_DEVICE(0x2357, 0x0105),
> +	  .driver_info = 1,	     }, /* TP-LINK Archer T1U */

Hi Stanislaw,

what about using 'ieee80211-freq-limit' OF property to limit available wireless
band? In this way we can take into account even the opposite case (no 5GHz).

Regards,
Lorenzo
