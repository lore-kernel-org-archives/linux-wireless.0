Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BFCC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 05:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46BD82086C
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 05:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BbUHT/lG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mGqzupeD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfBUFKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:10:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfBUFKz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 00:10:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4ED9B608CE; Thu, 21 Feb 2019 05:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550725854;
        bh=lRgFiHQkPJBlwkYYN98XyfiJuaSuVOLvuadqQ3tv3rA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BbUHT/lGMyAvH0QvVn8pEc3XYabhAqhrpX+TXZ0EI5dcRiifkAh2AINZFy24A4XJl
         7LMcXHcTutHXufjovKFZEu1DGh09gF5QT0/w96VCVe1WL7w+aNB2F6yMQPyq/aVdo/
         u5Zv6UYzfrkNMDo9NdYiZdkyRbejX3XfwvflBBk0=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C11EC60397;
        Thu, 21 Feb 2019 05:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550725853;
        bh=lRgFiHQkPJBlwkYYN98XyfiJuaSuVOLvuadqQ3tv3rA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mGqzupeDsALUVJTo1rkaofHrtXpkGTbGb56j4yBnubUByQ296kuGfU6jP4JAvTmNA
         PnEHo0rOtcaezXxOP3ta3XvLXtk6fvBg60t3pCC69M264jDFeGozO6VVl9GXMe9DJ0
         eOdIk1UqvVyyfdUukPCoGsSwCdq0kV36P369sRW8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C11EC60397
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     lorenzo@kernel.org
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] mt76: usb: fix warning in mt76u_buf_free
References: <cover.1550706341.git.lorenzo@kernel.org>
        <bfd5659680fb3ef89554a48ff950d74dd88240dd.1550706341.git.lorenzo@kernel.org>
Date:   Thu, 21 Feb 2019 07:10:49 +0200
In-Reply-To: <bfd5659680fb3ef89554a48ff950d74dd88240dd.1550706341.git.lorenzo@kernel.org>
        (lorenzo@kernel.org's message of "Thu, 21 Feb 2019 00:57:19 +0100")
Message-ID: <87bm3520bq.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

lorenzo@kernel.org writes:

> From: Lorenzo Bianconi <lorenzo@kernel.org>
>
> Fix following static checker warning in mt76u_buf_free:
>   drivers/net/wireless/mediatek/mt76/usb.c:372 mt76u_buf_free()
>   warn: address of 'urb->sg[i]' is non-NULL
>
> There is no need to check sg page pointer since urb->num_sgs
> has been already validated in mt76u_fill_rx_sg
>
> Fixes: cb83585e1121 ("mt76: usb: fix possible memory leak in mt76u_buf_free")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

The merge window is really close, should I take this directly to
wireless-drivers-next?

BTW, Lorenzo please add your name to SMTP From line to make threading
cleaner:

From:   lorenzo@kernel.org

-- 
Kalle Valo
