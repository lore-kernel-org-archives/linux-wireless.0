Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262BDC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 09:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B9A21852
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 09:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmcBm6B4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfCNJIF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 05:08:05 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:40365 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfCNJIF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 05:08:05 -0400
Received: by mail-qt1-f170.google.com with SMTP id f11so5166199qti.7
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 02:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KFsGdJiREbumxh5N/+Ggm7SW1ZO2LTQnk8QvVEwiL78=;
        b=XmcBm6B4asAfqCERbYPcEp4tvAp8YQQvy6uzDtDisC2ENasOtSAkFvQqUP0wePd0Ra
         LxLOlshnLRDisNszwhEIBMzaPLXZGafVzSgZyJF4V4bAeC6ykj+meB+gKC/oR961rQ9o
         8u/zuhiwb/FgqmOrBYcsl+p31WO7FLHkvKNgYu6wtS6e1WBjnWGNPkadKXeWXGy5EsOT
         GXzCACo0PlDUOdjJ90XTNld1bmL4nrTp589K2ALipRQbTqkkw1cN8OnWw6UE4JxqOUYi
         Z/8XTr4PiK1VsIqCqg1f8zH3X22kcgWAyE01fDGcjzCKuU/xEJLDLH4u1REkH5+LVEr7
         qcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KFsGdJiREbumxh5N/+Ggm7SW1ZO2LTQnk8QvVEwiL78=;
        b=b2NZMNCyni4NF57AxZlHtNoYaCpb+EMgStzl/Lyj3Uv8pnNsAJYtHI34j0YlpXrKv4
         Pl08/5lgZ2G/pro9kvlM8+NEEdn2MiAm5n4F+QXC9NknxuTIEjDrIrXSb5Lp6s16IOcU
         /PX9qunBnbRvMv+Q/MAHcATsR+0izVo0mp/TSl0aR7SUDy9clP6SIX9JJIRrN5mNRIWy
         +fp2Z7yilaOHlV7qdHesVnZUZ1b0Hzgyr4j3CtXKof7FOyIrUfB63cOeZgk09VqsRHOg
         LBdgXaUCDGDR6sZV/hT5jbWFGzpkX74JW/nzZtrau65q0RsGC1F5w2cjJiuLieZyEEoK
         +Akg==
X-Gm-Message-State: APjAAAVi7pqnEulMDzZ39gR2420XfiQyTgxIhlm2tR1Jfci6tkR9pSNB
        fSDelVnUJwirdpTRtfDAKYL8WIN6cu/EK+wZd1f3CG/r
X-Google-Smtp-Source: APXvYqxklf7qDsS3JLc3Edb3OIpD861q8q8bHqPLtoXyPnrbIeCjIuMja9uqdbG3BW5etcAoy+jDYUL70LqSawqb050=
X-Received: by 2002:ac8:7302:: with SMTP id x2mr12031483qto.293.1552554484248;
 Thu, 14 Mar 2019 02:08:04 -0700 (PDT)
MIME-Version: 1.0
From:   Robert Marko <robimarko@gmail.com>
Date:   Thu, 14 Mar 2019 10:07:53 +0100
Message-ID: <CAOX2RU5igDk_nkj74i-1_hoC4JbSSK3w1_-DyH+3EzyeMHnMcw@mail.gmail.com>
Subject: wil6210 firmware version
To:     linux-wireless@vger.kernel.org, merez@codeaurora.org,
        wil6210@qti.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
I am working on OpenWrt support for device using wil6210 card.
I am using firmware and board file provided in linux-firmware for its
development but it appears tha most of newer features that driver
enables are firmware dependant and version 5.2 in linux-firmware is
too old to expose those.

Is there any chance of QCA pushing updated version to linux-firmware?

Thanks
Robert Marko
