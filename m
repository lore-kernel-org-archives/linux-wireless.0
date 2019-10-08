Return-Path: <SRS0=jiki=YB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDF2ECE58C
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 15:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F120D206BB
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Oct 2019 15:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tcez90tD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lMOdN6k2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfJHPt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Oct 2019 11:49:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfJHPt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Oct 2019 11:49:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9864F61110; Tue,  8 Oct 2019 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570549796;
        bh=h3VL4ZBPrnT897PQsUIyI6anbgxW0GUUyodhS8+7YPI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Tcez90tDP4y04s5zhd9xb/f7RNp45PgAY2zrZZadV5t8uHqw6bdvj8hC1ubpNsmbn
         75WCtv6mgh/+OFsV8WtSn09J2NHPh37SP5C9au694oMzqXLfQpVxfVIPiqpDfbP+tz
         YlHhU8UOLBJamY5k7aw61Fs6MgVkPekSXROK0wHk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D18D602DC;
        Tue,  8 Oct 2019 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570549796;
        bh=h3VL4ZBPrnT897PQsUIyI6anbgxW0GUUyodhS8+7YPI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lMOdN6k2Odv3QIiy+N47mS6ScNn1pjGxCRVK4qsM4t/vSnhr5ksNIJINqIkM0hZLv
         P2deuwTuv1fbdY0RCItnttszJPXeHhwr8zxLwDoB+NAqQWi2dPowepGt1TJQQOyNsp
         kelq4DekPrCjG4cKx2iVRTk2nV5djMDfNwQdIWuk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D18D602DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rt2x00: remove input-polldev.h header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191002215052.GA116229@dtor-ws>
References: <20191002215052.GA116229@dtor-ws>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191008154956.9864F61110@smtp.codeaurora.org>
Date:   Tue,  8 Oct 2019 15:49:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> The driver does not use input subsystem so we do not need this header,
> and it is being removed, so stop pulling it in.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Patch applied to wireless-drivers.git, thanks.

98d22b01f9f6 rt2x00: remove input-polldev.h header

-- 
https://patchwork.kernel.org/patch/11171877/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

