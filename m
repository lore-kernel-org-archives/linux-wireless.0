Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AED0C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E805222C0
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YbXM/p3v";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YbXM/p3v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbfBLS7p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:59:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfBLS7p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:59:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 714B460227; Tue, 12 Feb 2019 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997984;
        bh=DIAoN7wfg86xaD9z1+i7Ro8Uz/atNuH1GLWGHufgAsM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YbXM/p3v9NO9a5TqwoIc/TzheKqlWbgik5zu8HJGO1N0FkNISDPPeogLe8Y2RHQOK
         0VxEg2zk55KdcTV5v+5RY6f3+8lOY2XVzCfpNMzvWJ0sOIwGAcOr0pBhN7CEyMVFY/
         zHpw3D1LeGGjs5AlTD4AJtw8nnqILQucq/36R5S4=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19B85601C4;
        Tue, 12 Feb 2019 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997984;
        bh=DIAoN7wfg86xaD9z1+i7Ro8Uz/atNuH1GLWGHufgAsM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YbXM/p3v9NO9a5TqwoIc/TzheKqlWbgik5zu8HJGO1N0FkNISDPPeogLe8Y2RHQOK
         0VxEg2zk55KdcTV5v+5RY6f3+8lOY2XVzCfpNMzvWJ0sOIwGAcOr0pBhN7CEyMVFY/
         zHpw3D1LeGGjs5AlTD4AJtw8nnqILQucq/36R5S4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19B85601C4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        stefan.wahren@i2se.com
Subject: Re: [PATCH wireless-drivers 0/3] fix multiple issues in mt76u error path
References: <cover.1549832428.git.lorenzo.bianconi@redhat.com>
Date:   Tue, 12 Feb 2019 20:59:40 +0200
In-Reply-To: <cover.1549832428.git.lorenzo.bianconi@redhat.com> (Lorenzo
        Bianconi's message of "Sun, 10 Feb 2019 22:49:12 +0100")
Message-ID: <87va1orfxf.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Fix following issues in mt76u initialization error path:
> - NULL pointer dereference in mt76u_mcu_deinit
> - possible memory leak in mt76u_buf_free
> - use-after-free warning since mt76u_queues_deinit is run twice
>
> This series has been tested running mt76x0u driver on rpi3+
> (dwc_otg controller does not support SG I/O)
>
> Lorenzo Bianconi (3):
>   mt76: usb: fix possible NULL pointer dereference in mt76u_mcu_deinit
>   mt76: usb: fix possible memory leak in mt76u_buf_free
>   mt76: usb: do not run mt76u_queues_deinit twice

As we are in -rc6 now, better to push these via -next. So I assume Felix
will take these.

-- 
Kalle Valo
