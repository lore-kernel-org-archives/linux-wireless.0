Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BACC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 18:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2D4B2087F
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 18:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p7TrjR/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfAGSYp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 13:24:45 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54855 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfAGSYp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 13:24:45 -0500
Received: by mail-wm1-f67.google.com with SMTP id a62so1777833wmh.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 10:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjZ7aRpp8k+xCNk4auAxvkNxZqhKqWGExXQBeEZeu2Y=;
        b=p7TrjR/SZQQV3ll1k0enquLKQMAQxXtb+2Q160AL24QqIf2IQqG86ncdsCqBrO7qBH
         6ewxXip1v9OrwdthO1Jy+K2nXnbyzTEHKRESIEOYZ9d5P+oiR2M2eLZ+5xqGNAgAX1zC
         FkcNjTQqdDm+IUMYlaectu8EfkgEGuJjtEuxBB66cawGAnibCupv/jqHJY47PNJrSZSp
         Nu3yMtxT9e708axq7SFhIaEO2pjHiqiw26XomapRH4qZO8Hgqd8mTnwLyfo5tWmbIjxI
         vroqukhvsN8voNGIWacyauDuf3XDNnpMq4r3vDITvCYTMcF1R2ssvG6viVCJ3F0UTgC4
         C9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjZ7aRpp8k+xCNk4auAxvkNxZqhKqWGExXQBeEZeu2Y=;
        b=OcxLlRZjNHw1nDkmumPqUNAdDSIy3lHERCCuNbYoSzyHigxQY/qJa1lrieIA1kkc4x
         YdKU0kd85tnk6g8Kii6AX6fxFOB1enNZlzDooS2qP1ppb9LEoHinDcXntoNjyq5/Ce3j
         +V1YXTbbAyJRfuDUb9WCKkECRDLXC98o/c1uLwWHba+0QQOBQ13QC3b+eHvKt7Fs+Iof
         BBofyotmbNBgCpOFglvch5DbH+SE/DiPt8oAK5Zt9zRAmPqEfFIa5XMm6CrAqv32MxbQ
         5Uj1Jk2Cl0ZOae/RCRzF/jFgDo4NyVYRJSPGBymHpxMOQA+eRr3Mxv6Cd1krHnSXlDw1
         hPyQ==
X-Gm-Message-State: AJcUukcxN3ZuP+ORrVMjuSgvrZ6c96tiAPd96XlDG1gwXWC5ykEUmIgx
        E3iVEmTGSvlh/VxCrXZY6eE=
X-Google-Smtp-Source: ALg8bN7QQxSK65dBtJj8IVg95prIE1EFjJQ4Pu6OWeBUPwRIz+7mQeCehVjdcmn2MA+IZchRiZ9CBg==
X-Received: by 2002:a1c:578e:: with SMTP id l136mr9260268wmb.124.1546885482463;
        Mon, 07 Jan 2019 10:24:42 -0800 (PST)
Received: from debian64.daheim (p4FD09848.dip0.t-ipconnect.de. [79.208.152.72])
        by smtp.gmail.com with ESMTPSA id z7sm52407189wrw.22.2019.01.07.10.24.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 10:24:41 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92-RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1ggZZp-0006ET-76; Mon, 07 Jan 2019 19:24:41 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     James Prestwood <james.prestwood@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Issue with Ath9k/PCI passthrough
Date:   Mon, 07 Jan 2019 19:24:41 +0100
Message-ID: <3155667.IrPEAHJHAv@debian64>
In-Reply-To: <6cc1ddae1bab8f71daa07c2c7082354507496f5f.camel@linux.intel.com>
References: <6cc1ddae1bab8f71daa07c2c7082354507496f5f.camel@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday, January 7, 2019 6:55:48 PM CET James Prestwood wrote:
> Hi,
> 
> I am passing through PCI wireless adapters into a qemu VM and I am
> seeing my host machine lock up/freeze when starting qemu if I try and
> pass through an Atheros AR5B22 PCI card. After reboot I don't see
> anything suspicious in /var/log/kern.log, although I don't really know
> what to look for either (or maybe there is another log to look at?). I
> have successfully done PCI passthrough with both an Intel 7260 and
> 3160. Its whenever I add the Atheros card into the mix (or by itself) I
> get this lockup when starting the VM.
> 
> I have enabled the Ath9k drivers when building the kernel (same as with
> Intel cards). This page I read online (https://wiki.debian.org/ath9k)
> said the Ath9k cards don't require firmware like the Intel cards do, so
> I have not added any firmware binaries for this card into the kernel
> build. I also tried turning on the Ath9k debugging but saw no
> additional prints in kern.log.
> 
> With PCI passthrough there is some configuration required, like
> substituting the drivers for the vfio-pci driver on the host machine,
> so it could be completely unrelated to the Ath9k driver. Still, I was
> hoping that someone more knowledgeable than me may know whats going on,
> or at least where to look. The fact that the Intel cards work fine was
> what made me think it could be a driver problem.
> 
> I am more or less following this guide (except with wifi adapters
> rather than GPU):
> https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF
> 

You could be a victim of:

|/*
| * Some Atheros AR9xxx and QCA988x chips do not behave after a bus reset.
| * The device will throw a Link Down error on AER-capable systems and
| * regardless of AER, config space of the device is never accessible again
| * and typically causes the system to hang or reset when access is attempted.
| * http://www.spinics.net/lists/linux-pci/msg34797.html
| */
|DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
|DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032, quirk_no_bus_reset);
|DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
|DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/pci/quirks.c#n3400>

I know that the AR93xx and AR94xx cards have problems with PCIe Passthrough:
<https://patchwork.kernel.org/patch/9141239/> and
<https://www.spinics.net/lists/linux-pci/msg34797.html> so maybe you can get
it to work, once you add a entry to the fixup list.

Regards,
Christian


