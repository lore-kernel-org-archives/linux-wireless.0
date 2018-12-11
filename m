Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE0BC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 13:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076892082F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 13:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aJCjn4DC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GlKJTy1h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 076892082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbeLKNVm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 08:21:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbeLKNVm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 08:21:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2891060795; Tue, 11 Dec 2018 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544534501;
        bh=vvXiUAdc8w+A5sp4Ti7NCWDQO9DxLNU29uid736hbv0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aJCjn4DCiPmYegcf/m5ydJgzKF3wMhppYfCqRjm9LGRQnrdAYdxgxqooK3QpQUC0s
         9SSeDtijRzvVjXEq61MeRJdueaIhZKbbjZcChBoDY//QvZRD1C11YJjK3TFCHl2704
         QuPD2ral/aj75no0onsDpB1HVWy2xkRadt0DwpGg=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 665B16030F;
        Tue, 11 Dec 2018 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544534500;
        bh=vvXiUAdc8w+A5sp4Ti7NCWDQO9DxLNU29uid736hbv0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GlKJTy1hsU78n9ogR+vfsYx9F5OhVIfEN6QMW8xYZTPqUqWIESL+A4ij5zmtq0vPR
         FYMEG2QVTE9qpswT3j1oLtEqODugBKHP1yMrQBKU4Ov5xRuOJj4pxZY37l6B4OLpu+
         Wjrw+57y2H8DhI5EGeD3VE7wMMKQe57f1a8NBzfc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 665B16030F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: add entry in MAINTAINERS file
References: <cover.1544456498.git.lorenzo.bianconi@redhat.com>
        <47d46d5627fee5691f7faf682d385c2aa3a537d4.1544456498.git.lorenzo.bianconi@redhat.com>
Date:   Tue, 11 Dec 2018 15:21:38 +0200
In-Reply-To: <47d46d5627fee5691f7faf682d385c2aa3a537d4.1544456498.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Mon, 10 Dec 2018 16:46:28 +0100")
Message-ID: <87mupc8ahp.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Add entry for mt76 driver in MAINTAINERS file
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Thanks, I'll take this directly to wireless-drivers.

-- 
Kalle Valo
