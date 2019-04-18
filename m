Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06744C282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 01:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6CC214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 01:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNZI0fl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387442AbfDRB5m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 21:57:42 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:54456 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730037AbfDRB5l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 21:57:41 -0400
Received: by mail-it1-f173.google.com with SMTP id a190so936538ite.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cNXAJg9TuqkJ4/H9v0AhTKXkUQby3LdnCACh1GS7Q3o=;
        b=VNZI0fl8pyv9XGmrhQV5g7yKynNm81vpNgjhEgrOL7kgNhuzNctVs10Lax+gXWU52L
         fhNVMHqu8LUlM2voFYNcopRdLde1uhUtk84Lu5mR2+lrmbEqwxxaCURMGygirAtJd+eM
         baZbH8OZ2jM0y12AJ5oec/2oIM7XXnFULq/ygNJ2wkPwnQW8t9zQLmBiElbjqYlh4Ip0
         hrTPFgQda7T84cVOX05AcTvx2hVsfCWoGFUtTzdZSj8D3dWmhNVNSlumFUsDyrZbHyDO
         g91L53W3Z3xMfSFE+VCholsbIH6wJoeFJkk3ELoCxdUKTIj6p9SkbQ9Xc34mdblNzblq
         blSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cNXAJg9TuqkJ4/H9v0AhTKXkUQby3LdnCACh1GS7Q3o=;
        b=nFdApzy5o9VLAermMeVoth8PVKO9DAeiwnFd6d7bxuVg4u4Y1QTkgzk/DLrVNMuvSk
         OzfYSGR3hpPkZeCWHjGT0v0pkBAZTvqAfTOcaaXsCRVJLN+qyZ/X0xgsdGHgis4UYkVI
         M3Rt2sgSMM+1FdH83+blz7nE2ygc2cCWTEZCsr6nmo/TIe6PknNjqgdGQ4QJ7N6BjnP2
         HnKjJ1JTa4SqhSzcMJNIpJF0XpHywaX8dsJ07huI5EhRD1zkOfPoKFozZD22YDAoAZ2X
         EACz1gTGMKYJEs8GgLvHlTAWbDEKIwHu4CZpmAvDZ8U0EwosFkLVf2XpsCY+HI311cmz
         ruZw==
X-Gm-Message-State: APjAAAVz0LKxDC60m9xNeYkjS+eY9Q7hXZ1hiL0jXsC41DML1nDnqZX1
        bMtsqo4EC3hB6SLHT5EUJX6R5vEa8UbV+DMnRSqsBVgP
X-Google-Smtp-Source: APXvYqyLobAw66ckw3GlLslYSHd2Ii8OQ6XYY/31pYJ4L8q0BkQXx1xV0FHkuSyBiNUG9AbFpYD4R4ZUrBPw5hsVavU=
X-Received: by 2002:a24:70d5:: with SMTP id f204mr1386591itc.32.1555552660930;
 Wed, 17 Apr 2019 18:57:40 -0700 (PDT)
MIME-Version: 1.0
From:   Kevan Salva <kenico15@gmail.com>
Date:   Wed, 17 Apr 2019 20:57:30 -0500
Message-ID: <CAAM6Ncf0=1wBbnomxH=o8r9-edhSk2zr_xzhJeA1uWdzRZ84Eg@mail.gmail.com>
Subject: Kali Linux 4.19.13 VM, Ralink RT3072 - Not Finding Wireless Networks
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello All,

I am running Kali Linux (4.19.13) in a VM. I have a USB network
adapter - a Ralink RT3072, passed through to the VM. However, it is
not finding any wireless networks. This issue occurs on both VMware
and on Virtualbox, but not on a live install of the same OS. This is
the output I get from dmesg: pastebin.com/HaXUDNug . What may be the
issue here?

With much appreciation,

Kevan
