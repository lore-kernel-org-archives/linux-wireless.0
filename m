Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A53C43381
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 18:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED712064A
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 18:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vx1yCoTb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfCESek (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:34:40 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43512 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfCESek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 13:34:40 -0500
Received: by mail-wr1-f42.google.com with SMTP id d17so10598603wre.10
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2019 10:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:mime-version:content-language
         :content-transfer-encoding;
        bh=FZfotppR9I+Lvt75jczjSBpde9gaaZe/M6FU6B0SsZ4=;
        b=Vx1yCoTbn84I6pEYokJRCED7JkiTlCejrLMCfB/oAmWvAT96wsMGnXuxGcNnzh9uGx
         2SiY6HLTR6b4QOHXgI2DQt2Iyh+aT82IDJFedktfnNFHX1xEn/5jxONELceYIvAjc3i1
         qYZU1DGZRuKHX7iKwQQKTYSrB0xifT6PYa44sN9bZ+k7ZXj5xN5oI2GiSaIo4GUPmsQG
         F3rM7TH4cAzFY5+wytIXLPsLu5BG3qZyPxNmEtz+93e34gYDTWyXsrF66nI1PEclVEkg
         scYZeJ++pgoI86/e0WnYNfzKK27ckJqM6FiT9ljQGOL/YHBzMy7cBcWtyZQyLqGELjh+
         e76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:mime-version
         :content-language:content-transfer-encoding;
        bh=FZfotppR9I+Lvt75jczjSBpde9gaaZe/M6FU6B0SsZ4=;
        b=GAyER2RahEs76b4A7zO/Sisc8ey9uB3JFV+KFgKJivTh6kys7IlRPHPSpqbfL7evm0
         OjVYDz9XuqoP602nvcqrMm7yLp2tKXhL/bMQWjsGja2BMCtF8esPxddwSRak/O869Kfj
         MemlMQLsD375DW1hZoMr6fV+XqWyk8fH8jRX1Uder/XO6UeQTgd5ebuRYHOFR6vZj+qd
         inQElcfoOQCfCZ+7YwNybWHkZ5R5WZmxbVQnslEDLJKPmZ6YK+q6zN1Bl+eK+CZ3kCQo
         JRIj4vrWe68xd+3FYlEwPGwiXjpXQdkjOCKoO01/6T6p9dhAaCSdElq/kc97In1DHs7/
         4Dhw==
X-Gm-Message-State: APjAAAVBG56oa0l2gWv/V2qmKwkhPkaSplV9XSotMk99wSgL2VSTOhVk
        BVhJF29dushTyz/6Sv9xt7hku2Q=
X-Google-Smtp-Source: APXvYqwfXlMzFb+qgKVbi70uYxgSSrrtLPUz3auYsHuAeEXZqcPIr99HF5DSf26X3UEFII2eHfLnXw==
X-Received: by 2002:adf:c593:: with SMTP id m19mr200151wrg.124.1551810878058;
        Tue, 05 Mar 2019 10:34:38 -0800 (PST)
Received: from localhost (118.red-88-12-24.staticip.rima-tde.net. [88.12.24.118])
        by smtp.gmail.com with ESMTPSA id j5sm10034201wrw.59.2019.03.05.10.34.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 10:34:37 -0800 (PST)
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: mediatek: duplicate usb devices
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com>
Date:   Tue, 5 Mar 2019 19:33:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,


There a three duplicate devices at:

mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Aukey USB-AC1200 */

mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },

mt76/mt76x0/usb.c:      { USB_DEVICE(0x7392, 0xb711) }, /* Edimax / Elecom  */
mt76/mt76x2/usb.c:      { USB_DEVICE(0x7392, 0xb711) }, /* Edimax EW 7722 UAC */


Thanks.
