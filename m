Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CFBECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 22:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74282075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 22:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOsqLHSm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74282075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbeJYHX5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 03:23:57 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:40915 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbeJYHX4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 03:23:56 -0400
Received: by mail-ot1-f41.google.com with SMTP id m15so5320325otl.7
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 15:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=HnDBiZcWdBGQjUUdcKe1pkBSDHtegaLyIUr55keEgoI=;
        b=OOsqLHSmzdglJi+N66EXub7JZ80BFeGnPwdpAPgnj3txBVAluPZKLfA/YoGRow60CK
         CqlzzsN+DJdWENW70HrMk+XLtl84oCrtk8gy5V5S3Yp99tKBVpcpciE9VODY+mtqOu6s
         Sezx/5xlwYqBo7HmFfii1xQTE0SznmSd9xU7J6+ZM7ovKHE7VUPq2xhorM9u8hTkObEw
         xklQ5TUrkjbtNZy7KpfAIji26A7gxhGVnXBNfWH0SPiqrxTXf1MYKXr6luQDQC6YF5uy
         qk1rSUHAvTb+OXpn4bN4moAZBOh3xa9bmTi2QYpiZSD7C15dmBcDqekF/HYBUh0XtxPP
         HHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=HnDBiZcWdBGQjUUdcKe1pkBSDHtegaLyIUr55keEgoI=;
        b=ntKHbpLPmKs1rNF3UJERoLl6bDg7uSM5noDciJL9Rq4Y7M2JUFF4DJ6YrGfLxS7oo/
         CjCSbbQDdEwDdhAYplWjyQzoKdHjypQaNbeQ1bndYPtwcnf2f3+mPiEpRrK+rcXQwLuw
         pD5d6ozycwEMUWUdN0+GGstqcWJ5t0dwBDdcvXYAZwLNacNq08d5DLbMOuF7Dvo9Su/8
         BFY23hxTC7W3OAJKkBB8zVZvLw0ik2wembw55XLRim7FhCYiK6PEzu8W4bUbBnx4jXpq
         fXMONizy9NXVu2ICpa+ESRuUlBuPZ4YVpA2IYvj3QGDob0uU178kxYk/bCLaO9+Olt25
         HNIA==
X-Gm-Message-State: AGRZ1gKsNIln02yjs7/AhjQfgS1U4cfuDrxshxzUVRIMziQqjpXG4Omi
        fbtWdDcVcKTgu8SG2elrudTXazKaovPMixqqyLM41A==
X-Google-Smtp-Source: AJdET5e3sTJ8Xsa/k4nwXuDeSduloUz0kSUZelRfiBT1+yogd4wo/p/5L9b5MhRwCj8BfZy6qGb5VEmQsrV4LqlvTjg=
X-Received: by 2002:a9d:4d0a:: with SMTP id n10mr2693848otf.95.1540421637711;
 Wed, 24 Oct 2018 15:53:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 24 Oct 2018 15:53:57
 -0700 (PDT)
In-Reply-To: <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com> <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 25 Oct 2018 00:53:57 +0200
Message-ID: <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com>
Subject: Re: ath9k driver may be broken on ARM64 ?
To:     Ellie Revves <ellierevves@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

Try selecting config option ATH9K_SUPPORT_PCOEM (Support chips used in
PC OEM cards) and rebuild your image.

I'm not familiar with your architecture but it seems you're not
getting debug output. It should print a lot of info right after the:
ath: phy0: WB335 2-ANT card detected
