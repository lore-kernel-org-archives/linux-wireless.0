Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237CEC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 13:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE832081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 13:20:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDE832081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbeKBW1V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 18:27:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37115 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbeKBW1V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 18:27:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id z3-v6so1977712wru.4
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 06:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y69HDwLuG23cnrbSaCENh1aSw+bPSFNa68Gy2VsZgqw=;
        b=R4POOJ/jXCH9vp9euqwl6v/SnZUK7FrTXk0QGdpClUpz0vAY2B9H5ucNZHxhm13qOJ
         kUw+zpWDneFO/dpmdrsX7zzVqR1Q67mSlQhU6/DqcXzDEel6e/8HfV5ezPEUkhTp1REr
         HOWl9c4JNbCmkwtK7spgS1D3WHtPNmMHycZ+DAPECc+01f6g8L8tmsJzSkYWpIf0VkHd
         pEYhVKnP6bFLpSRfm/f0YYFwDL6O9R++8kxrUHVAgSvb0rs/7OZPjWl2Rt5oeVKwxapo
         t6DRXw1jZDYzByRmSt8uctTxa3MyXS38dHEd3RYezxy/skBQGOaf2ds5gDLsse5amVak
         9ATw==
X-Gm-Message-State: AGRZ1gIgEHkXCud1FuFAHQLdwYEyQR/+D0ZgyB8t6eObmxI5GFxzCFWl
        XqhzEbnjh0GaOb9XyZC3PPoTCcwWD70=
X-Google-Smtp-Source: AJdET5c9fPUnJQs2PSGIMLZ/gcYjy/2xf7/2IXZwSIuVFcPNeDzK/myBGt8PVEW0jvIJSn/fnoD33A==
X-Received: by 2002:a5d:42cf:: with SMTP id t15-v6mr3292724wrr.225.1541164810882;
        Fri, 02 Nov 2018 06:20:10 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id 193-v6sm13491693wmp.48.2018.11.02.06.20.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Nov 2018 06:20:10 -0700 (PDT)
Date:   Fri, 2 Nov 2018 14:20:07 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH] mt76: fix building without CONFIG_LEDS_CLASS
Message-ID: <20181102132006.GA27823@localhost.localdomain>
References: <cover.1541150589.git.lorenzo.bianconi@redhat.com>
 <5d0d7286445acef822a806dc89fcbf9eb2672ade.1541150589.git.lorenzo.bianconi@redhat.com>
 <87r2g3btnd.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r2g3btnd.fsf@purkki.adurom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When CONFIG_LEDS_CLASS is disabled, or it is a loadable module while
> > mt76 is built-in, we run into a link error:
> >
> > drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_register_device':
> > mac80211.c:(.text+0xb78): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `devm_of_led_classdev_register'
> >
> > We don't really need a hard dependency here as the driver can presumably
> > work just fine without LEDs, so this follows the iwlwifi example and
> > adds a separate Kconfig option for the LED support, this will be available
> > whenever it will link, and otherwise the respective code gets left out from
> > the driver object.
> >
> > Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> 
> Should this go to 4.20? A linker error is pretty bad, even though I
> think this is few months old issue already.

 I guess so. The patch is based on top of Felix's repository so it apply with a
 'fuzz' on net-next/wireless-drivers-next but the patch is ok. Do I need to
 resend or it is ok?

 Regards,
 Lorenzo

> 
> And are conflicts with -next version of mt76 likely?
> 
> -- 
> Kalle Valo
