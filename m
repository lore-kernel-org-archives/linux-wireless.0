Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C24C31E4B
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 20:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A68217F9
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 20:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfDHaoIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfFNU1C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 16:27:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41742 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFNU1B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 16:27:01 -0400
Received: by mail-ot1-f66.google.com with SMTP id 107so3831665otj.8
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2019 13:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BzAuP59c+mnRQdrNGFF3JHkBjDs4c9FanIK2oGpuCJ0=;
        b=YfDHaoIkhr6JKK7JMLaAHwgPwJXV+g1soRU/fj8dqWt4lVcpk+SrliJ/s4rGbxdfs/
         oBmfa+208OH13QGmQVrgNJPUF2pqdeOxFPAHVIYwZVMOb6hSrx8/k2afVabh1NKomGGZ
         vpovnPzT3A3wuBjfiN252S38aGBat0pNG9wpBrvTWZuYesikd2xZkzlIApB3wM3FVjiO
         g4wvSAcLgPEdLEFG6LMwutzx6msGS/UXi244Dj8NBn3WVVOQGBKjh8/O0lYxF9KlTKil
         qfQMvjy2ppJ90+UouG/2mF6d/RBFPUBTzrbpiqetq9VTiH6OZ1SmdOxZyn8Lf5tNVYc2
         n8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=BzAuP59c+mnRQdrNGFF3JHkBjDs4c9FanIK2oGpuCJ0=;
        b=HZ5zLiXfweb6yCCH7VUd3zUbcoN/NiR/SBvTCcYQfkwFFbEvaXcB0fw+xhCNIUNDou
         e09RDDXuWB46r7AKwDwDnUDTy05ICK9LSA8Y1lWNgellQ7ZJG60lO76A9/Y9UN0teFaP
         5HMab6AVcDCBbX4PMnr/hxxMjQ3sRpURcmU7iUDfmNyCFqBQoTd/pWDE3ZvlbE1RVCdK
         f9LDdssyZDPbp7903R+xYZXOlHEbSA+MHShNHVNoeZoDKKlcwUv8E+gNgCCCx/0BZEJ4
         mhugLi0I2fS3e0mz5S4DBebMJAuZu20YwfDAhYZM6yYBswfZgSMhFfmiVs4X7OBENtfU
         YTZw==
X-Gm-Message-State: APjAAAWU8UD5rLjxu3fFe9KfoIt059x1CYkPp/lbUvyFhdKxXBWbin8Q
        ZE2hqszG5D7yWgOnTGDTr1H0owDm2779Ti36TDI=
X-Google-Smtp-Source: APXvYqxN/jmymRQMwaDFmV+sVnktjEkSpfHpw5nDKAe1V7KfbAaGoS9cLcGkgyVXH8tVcY2eIgO88BCUaGd4LGcBVGc=
X-Received: by 2002:a05:6830:12d6:: with SMTP id a22mr19599298otq.236.1560544021291;
 Fri, 14 Jun 2019 13:27:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:2015:0:0:0:0 with HTTP; Fri, 14 Jun 2019 13:27:00
 -0700 (PDT)
In-Reply-To: <309ba2702f6b553a3dd08262efe34c4cecc4e445.camel@sipsolutions.net>
References: <1557307533-5795-1-git-send-email-mpubbise@codeaurora.org>
 <fd3addc01fc3f5362dba5771ee82659cf01c195b.camel@sipsolutions.net>
 <c8484254-f4f7-9955-e3f8-8a423cc6c325@codeaurora.org> <CAKR_QV+dVx+LK1HyCo6CQZQ7ZX_u6ON0hEH5adNiJTB+XaP3WA@mail.gmail.com>
 <dc9039be42df8d241b14d4f673f3c472dc113991.camel@sipsolutions.net>
 <CAKR_QV+5oY-5z4UB+HKV_57r5NneDme+TBg_c26h4C7Sy8R+UQ@mail.gmail.com> <309ba2702f6b553a3dd08262efe34c4cecc4e445.camel@sipsolutions.net>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 14 Jun 2019 22:27:00 +0200
Message-ID: <CAKR_QVLyxBdqJAN6CsVG3ts41NOED56MvWdgvgVKPm-GRJXo-g@mail.gmail.com>
Subject: Re: [PATCH v3] {nl,mac}80211: allow 4addr AP operation on crypto
 controlled devices
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 14/06/2019, Johannes Berg <johannes@sipsolutions.net> wrote:

> I'm also not convinced how this patch would affect *staying*
> connected... it should affect connecting to start with?
>
> johannes
>
>

If you don't want to read posts but only topic title, in short, no
data pass thorugh with v2/v3 of this patch. Only v1 works.
