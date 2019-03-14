Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1DFC10F0B
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46D272085A
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S3iZ22XI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S3iZ22XI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfCNN2o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:28:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33506 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfCNN2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:28:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E4BC66087D; Thu, 14 Mar 2019 13:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552570122;
        bh=slD10bHyzWi4cHRxwTbM2JSNUAz8MwhqILBOtysGqB4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S3iZ22XIT+DuHkibXaW4Ly/wjZbBMBXODGA+mKNY37SpVdZTlW/8vfPNv5sSts4ET
         NLHgUtuCs24HvzXAychIruUZICE+kXOkhBUcQSiQrObkZFzqYaN1fppZmtcXg+5g6J
         +SDxZ6wg3Z6IZuSPhLVZoZCExvgOdrQsEoHCbrks=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DAC96601CF;
        Thu, 14 Mar 2019 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552570122;
        bh=slD10bHyzWi4cHRxwTbM2JSNUAz8MwhqILBOtysGqB4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S3iZ22XIT+DuHkibXaW4Ly/wjZbBMBXODGA+mKNY37SpVdZTlW/8vfPNv5sSts4ET
         NLHgUtuCs24HvzXAychIruUZICE+kXOkhBUcQSiQrObkZFzqYaN1fppZmtcXg+5g6J
         +SDxZ6wg3Z6IZuSPhLVZoZCExvgOdrQsEoHCbrks=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DAC96601CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
        <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com>
        <87o96f1cya.fsf@codeaurora.org>
        <CAKR_QVL+4f4Y8Edj_tVeDefa0YMJM6N5mrBnXUF6MnxEJ98=gQ@mail.gmail.com>
Date:   Thu, 14 Mar 2019 15:28:38 +0200
In-Reply-To: <CAKR_QVL+4f4Y8Edj_tVeDefa0YMJM6N5mrBnXUF6MnxEJ98=gQ@mail.gmail.com>
        (Tom Psyborg's message of "Wed, 13 Mar 2019 13:57:08 +0100")
Message-ID: <87zhpxzit5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tom Psyborg <pozega.tomislav@gmail.com> writes:

> locales problems during some system upgrades. can you fix it without
> resending?

There's actually a bigger problem, I cannot find your patches from
patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/

Maybe patchwork dropped them because of the charset problem? Anyway, you
have to resend so that I see the patches in patchwork.

-- 
Kalle Valo
