Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70706C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3162920850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l6xL+Koj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FRaQB/Dx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3162920850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbeLCMuD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:50:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbeLCMuD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:50:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E20E60B62; Mon,  3 Dec 2018 12:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543841348;
        bh=9jY/kiaNNMyuigDJmz1eK4j/O9SP9k5USUl2K97IftM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l6xL+KojIsTinvJIk1XSKFWGn24xMtUsiayAGBJYErfNR4yTZpJAjHPK31SECRb6A
         xvCVbsxz5bSjsiBuPUMHyF68lJbCl8KblFrJqbM83+T0m4F07nNSfzr6Xe2+QVhOMC
         ry+ihdQfyykr7TZG2Nxv25Kk2ukVM86ugGQvmMMo=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1BC396021A;
        Mon,  3 Dec 2018 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543841347;
        bh=9jY/kiaNNMyuigDJmz1eK4j/O9SP9k5USUl2K97IftM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FRaQB/Dxl20YvbKVBFdF6t9IbsvG1okIIh8Hlr6mtLQQcBPOV95qJlLpf9VgTodvX
         qaVZ5FW9ZN2203ZjVpyLkbL7EwLf+KkE3JRtbZXemdIem57N5v7hUu7YNnN7ynJUrh
         ZhhbZI55AOe+BN45IlH0Eqazd9ypzBglbQ2qHGMM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1BC396021A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     merez@codeaurora.org, davem@davemloft.net, kubakici@wp.pl,
        pizza@shaftnet.org, matthias.bgg@gmail.com,
        lorenzo.bianconi@redhat.com, nbd@nbd.name, sgruszka@redhat.com,
        joe@perches.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wireless: convert to DEFINE_SHOW_ATTRIBUTE
References: <20181202093047.11174-1-tiny.windzz@gmail.com>
Date:   Mon, 03 Dec 2018 14:49:01 +0200
In-Reply-To: <20181202093047.11174-1-tiny.windzz@gmail.com> (Yangtao Li's
        message of "Sun, 2 Dec 2018 04:30:47 -0500")
Message-ID: <87d0qig4hu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> writes:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c    | 240 +++---------------
>  .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  20 +-
>  .../wireless/mediatek/mt76/mt76x2/debugfs.c   |  38 +--
>  .../net/wireless/mediatek/mt7601u/debugfs.c   |  40 +--
>  drivers/net/wireless/st/cw1200/debug.c        |  32 +--
>  5 files changed, 64 insertions(+), 306 deletions(-)

This is rather large cleanup so please split these per driver (wil6210,
mt76 and cw1200).

-- 
Kalle Valo
