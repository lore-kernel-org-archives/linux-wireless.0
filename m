Return-Path: <SRS0=sWjF=YP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD93CA9EAF
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Oct 2019 02:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD4F2086D
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Oct 2019 02:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pUDg4SPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbfJVCvu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Oct 2019 22:51:50 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:40533 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730156AbfJVCvu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Oct 2019 22:51:50 -0400
Received: by mail-io1-f42.google.com with SMTP id p6so10342601iod.7
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2019 19:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=vwHJvn5LlsBsZWMTHEdYg10EePvWqYZi2Mc809hAbx8=;
        b=pUDg4SPAa9Qc8IKn+TsP+71KtKf3jtywyQtoUTXwA2BnwYVUmO20EiBtXsasv3Z0ze
         8c2tp3PYjZZ35oBQh/RzOlt6GMcoz0Uk5IVM+JFz6M9OrF2JzZsbO24j18UsKz0TcjNp
         BCY/hrNoG/MAhyVFGXOjZ7l9PRudxTLxQ6SrMv+G39ta0V+3vODzZbWFQjM7ZxkufwbZ
         aMlmGi23pEPRUYGpkDa2IUf81EJ7+g+yqwBWnv2N4XayHSnSBKfILI+Yyg+xAhlJENKq
         v3FNas/uljUY4KnskA6G2AwpiNmW+7oPC8XoygEZNBUYy6wYumNMsqEplPF4S+aBbUno
         YHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vwHJvn5LlsBsZWMTHEdYg10EePvWqYZi2Mc809hAbx8=;
        b=cJk7WHy5XKXnfqMHsknchurLZc9toTFa0g1a10dGUbkkPLK1cG//zpIi3WIHjFYlmD
         swQe0RxK50tLVH2O+RyxiQv2aSOUvqD0G+3rAcO2g+xRlQey4I4e6Zd5KNxdIGbiix/I
         szcp467AmZF+b1Nf4XJrMHoBE0kE3ZhsN5OyqScParJSdyjkRkktJMSF+G6LdTi9G+R3
         qGwrK3YZ5UMnDyJ3SrTiolmaW6xjdGPufGbASy2DhDLYmIiTFGGpUF1yB4UyqvITAo73
         4wegf2TU5baTDidCEPx7HZOoPdVa5K11sKjhYbN9ExZhh9EbhIj50FRjirZfsbP0TkDA
         2NrA==
X-Gm-Message-State: APjAAAVPqEWGOie9Y/9YXJntSjMy6NWQkhzsB+J6Ko4R5MQ20IuWAKjH
        /SatJ+RRoX6eGjcOzbvFkhzED+ffU06KXhjOu1ORnw58
X-Google-Smtp-Source: APXvYqzZtr9RPiXPPo6lVT9W9YnI0cYdvSmklBcT60Wvyv2TvjTF5Aj83gnltiWOcVWs5e4UVVej0ovHuYx+GtxuZ/Y=
X-Received: by 2002:a02:70c8:: with SMTP id f191mr1496682jac.117.1571712708795;
 Mon, 21 Oct 2019 19:51:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac0:9c85:0:0:0:0:0 with HTTP; Mon, 21 Oct 2019 19:51:48
 -0700 (PDT)
From:   JH <jupiter.hce@gmail.com>
Date:   Tue, 22 Oct 2019 13:51:48 +1100
Message-ID: <CAA=hcWS_5keJiNJwqpiOh+N49LoNE-pHjkwYSKSN1q=G12z3pw@mail.gmail.com>
Subject: mwifiex Invalid Sched_scan parameters
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I am running kernel 4.19.75 LTS on imx6, the WiFi connection is not
stable, sometime it works, sometime it didn't, it could work with some
home WiFi modem, but not with some other WiFi modem. there is a
following error message, do I need to worry about?

[  519.870877] ieee80211 phy0: mwifiex_cfg80211_sched_scan_start :
Invalid Sched_scan parameters

There was no that error message when I ran the kernel 5.1 at the same
device, the WiFi connection was much reliable than kernel 4.19, any
explanation?

The reason we moved from kernel 5.1 back to 4.19 is we want to  use
kernel LTS release, which might not be a good idea.

Appreciate your comments.

Thank you.

Kind regards,

- jupiter
