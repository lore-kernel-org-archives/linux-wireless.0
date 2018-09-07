Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38471 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeIGMf7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 08:35:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id w11-v6so13971924wrc.5
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 00:56:15 -0700 (PDT)
Date: Fri, 7 Sep 2018 09:56:12 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, arnd@arndb.de
Subject: Re: [PATCH] net: wireless: mediatek: fix mt76 LEDS build error
Message-ID: <20180907075612.GB2725@localhost.localdomain> (sfid-20180907_095628_041611_7978B8CD)
References: <563c7f90-1d9f-440c-4670-8fbebc9f76b0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <563c7f90-1d9f-440c-4670-8fbebc9f76b0@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> All of the mt76 driver options use its mac80211.o component,
> which uses led interfaces, so each of them should depend on
> LEDS_CLASS.
> 
> Fixes this build error:
> 
> drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_led_init':
> drivers/net/wireless/mediatek/mt76/mac80211.c:119: undefined reference to `devm_of_led_classdev_register'
> 
> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
> 

Hi Randy,

a fix for it has been already proposed by Arnd here:
https://marc.info/?l=linux-wireless&m=151628136830540&w=2
but it has not been applied yet

Regards,
Lorenzo
