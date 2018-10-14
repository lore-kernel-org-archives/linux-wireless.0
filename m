Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92C5C7112A
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AEAE2077C
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AEAE2077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbeJOCAs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 22:00:48 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:35847 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbeJOCAr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 22:00:47 -0400
Received: by mail-io1-f47.google.com with SMTP id p4-v6so12691566iom.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 11:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zMFrgJvnxR4siKK/PwRWs+lpO1WnG/IE4fLTqulXSH4=;
        b=sAX/UhoZsQrxqeXzAqLhjHcrWiOdT3S1zTqOOUappiW3Cr/w/cy0Q/fTuES7Sc3X07
         3pXzUdCgxwmHLZjUIVoPZ5u0URFSu2VFiWNrWosL/EuxCMOYGjwNh+CvqXDy/4YLFTEG
         S9tz76vSEbskX+AP3uHIQWvD1X7FYEycrGG1vivEPBpw2+KI6UWXnplhgE8j2s5iGxK7
         maNd0kWeDj7puR3k770bihtlsOA5qJ4KMegdlH86p2yHhqHsQLZc3O7YLrBBaUmJ1jYf
         az4dbo3TExAYmvqoXCkTtkot2PHw8h1zzr5dXmIvJCfsEEXCKqEuSAxcR0wuo0YIZKW8
         F1hQ==
X-Gm-Message-State: ABuFfoiIWOFhPkEGcQ37NrYaipa91+INA1fxzt18puLCjoGkGRXMRZvw
        yqH5/yFl1YyLcGGshXm/GBUIqY1PXHrGioqITR4yLg==
X-Google-Smtp-Source: ACcGV62x6mT/OeT1WwSlnv27iqB0lCzfXxd0RR7KHluk6HTaceS+QgqKpE8KnHPiazrpfREv1EW74xqMikN5LXRMWq4=
X-Received: by 2002:a5e:9419:: with SMTP id q25-v6mr8597487ioj.228.1539541134899;
 Sun, 14 Oct 2018 11:18:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539534731.git.lorenzo.bianconi@redhat.com>
In-Reply-To: <cover.1539534731.git.lorenzo.bianconi@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 14 Oct 2018 20:18:43 +0200
Message-ID: <CAJ0CqmWA3RcyFjyeGSYu1Swuuh1F_oCb_XL_ZYLXkn2ODB-WnQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] update firmware used on mt76x2u driver
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Align mt76x2 pcie/usb firmware.
> Update vga logic on mt76x2u driver
>
> Lorenzo Bianconi (2):
>   mt76x2: align mt76x2 and mt76x2u firmware
>   mt76x2u: align channel gain logic to mt76x2 one
>
>  .../net/wireless/mediatek/mt76/mt76x2/dfs.h   |   1 -
>  .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   4 +-
>  .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |  21 ----
>  .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  90 --------------
>  .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 111 ++++++++++++++++++
>  .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   4 +-
>  .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |   4 +-
>  .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  41 +------
>  8 files changed, 118 insertions(+), 158 deletions(-)
>
> --
> 2.19.0
>

Felix,

please drop this series, I am sending a v2 removing mt76x2u_mcu_set_dynamic_vga
since it is no longer used

Regards,
Lorenzo
