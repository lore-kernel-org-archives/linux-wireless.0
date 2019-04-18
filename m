Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EBBC282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 02:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A150E2183E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 02:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OA7YuQSk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbfDRCIR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 22:08:17 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:35168 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfDRCIR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 22:08:17 -0400
Received: by mail-oi1-f172.google.com with SMTP id j132so410936oib.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 19:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dcBZPcbZzsULcJ3r7iTrH6Th28iyI61W7jCtobkudYg=;
        b=OA7YuQSkFYzGD/mkJ7uTuHXxmRNR3ZmXd+TjGpAjtz/aksG+YNix4qS65coyXJYIXu
         1yItrAQI1FyX9Jp0WfFBtYO151O88zomiFtTYCGGydWK8frBqN6DSPjwVZ3nLBDEP7I+
         KGPyCxIAOI4h60nMNGV48zmm9OIECajvuxDFdJLu+WpFCn+6CmXPBzftEln4AtiMYETL
         DqypLCl7w4GI/6Hrxz5SR08Jqu0hlhrv3p0akTslpUYDAxRj7syabH/+fhaaAKdtWSY4
         rEcEFOFlIa++Z65C7t5htqG4QKrH+ZPSn2US6nG/TsDPcwtqC4WKbrIL3Kj6NDHF7c/W
         +9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=dcBZPcbZzsULcJ3r7iTrH6Th28iyI61W7jCtobkudYg=;
        b=AGwTBKizaUeQXlfskNlb/tg0k4lE4etCpR9u4/vNQ5ZoFEH+dBgbxfRb7vbcfMN0ex
         d1ZcxJ9OvcHEq1aOpgHGg2cVAF5TbY7mgntwOCPT/ubsKqdRKMK7znc231nYm+5gUDjo
         JFA3IeOvEJvkcCK/HWKm8/opqizrsaHDlvphT9PLgjKzNulvQ2XvNh0ziFwCWpsgBhm9
         eU4ntfyxjeACrZNXANERkmYUoW1pHXNr6lljG2lr2L7CokTAghRixiF65/CW4/7ufk39
         Yan8AEn67n4l4xpx+6w/oonKzYxuo0hovczJG2ZTo15RbCW4R6KdgamNdssDwu7cv7Kp
         pA6w==
X-Gm-Message-State: APjAAAXzqytv+et1XRtT/rfEQKl+wx8JGI0vjeF73gv45xFU5kITfJGQ
        TSGLhkHwqqlSh8rmvjatZAXmuwhrrAnRVsXZbT8=
X-Google-Smtp-Source: APXvYqzUXkfBQvTvn3uAAv+mOjHNw6h6MBsCOMVFl1MGz6ophGXhv/2mRzoB4PNnAvx6dallwfIqZPL8YRzTu4r2+Rk=
X-Received: by 2002:aca:5757:: with SMTP id l84mr419598oib.155.1555553296681;
 Wed, 17 Apr 2019 19:08:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Wed, 17 Apr 2019 19:08:16
 -0700 (PDT)
In-Reply-To: <CAAM6Ncf0=1wBbnomxH=o8r9-edhSk2zr_xzhJeA1uWdzRZ84Eg@mail.gmail.com>
References: <CAAM6Ncf0=1wBbnomxH=o8r9-edhSk2zr_xzhJeA1uWdzRZ84Eg@mail.gmail.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 18 Apr 2019 04:08:16 +0200
Message-ID: <CAKR_QVJ7cRPKZ9eRwS-jmmgbqsbSQZ=B792H_6K2AwZECzs0=w@mail.gmail.com>
Subject: Re: Kali Linux 4.19.13 VM, Ralink RT3072 - Not Finding Wireless Networks
To:     Kevan Salva <kenico15@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 18/04/2019, Kevan Salva <kenico15@gmail.com> wrote:
> Hello All,
>
> I am running Kali Linux (4.19.13) in a VM. I have a USB network
> adapter - a Ralink RT3072, passed through to the VM. However, it is
> not finding any wireless networks. This issue occurs on both VMware
> and on Virtualbox, but not on a live install of the same OS. This is
> the output I get from dmesg: pastebin.com/HaXUDNug . What may be the
> issue here?
>
> With much appreciation,
>
> Kevan
>

do you get such issues if running older kali/linux version on the same system?
