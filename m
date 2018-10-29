Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1E1C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A6D20657
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VYC8H+0m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VYC8H+0m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2A6D20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbeJ2XTX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 19:19:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbeJ2XTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 19:19:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 656AD6029D; Mon, 29 Oct 2018 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540823429;
        bh=dHbkkhy76+grwK8z7xrxP5T5sJZWutvp9VcszBlNv3Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VYC8H+0mSBGhdPSZJJJwRakg0/0zLabW03dvNM9Tq96l01fySy03H8iqUHHYRGU1z
         rqmW0/9FVtbSpf2ci1tEXWt7EjKnlfeirpRwNVN7cebNOaQVhsdO+Blm3ptdUkRe1y
         BQQLvrXa7UKwv6qT8l1xGAJrt23ySbcwdZiOhNok=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 75A05600ED;
        Mon, 29 Oct 2018 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540823429;
        bh=dHbkkhy76+grwK8z7xrxP5T5sJZWutvp9VcszBlNv3Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VYC8H+0mSBGhdPSZJJJwRakg0/0zLabW03dvNM9Tq96l01fySy03H8iqUHHYRGU1z
         rqmW0/9FVtbSpf2ci1tEXWt7EjKnlfeirpRwNVN7cebNOaQVhsdO+Blm3ptdUkRe1y
         BQQLvrXa7UKwv6qT8l1xGAJrt23ySbcwdZiOhNok=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 75A05600ED
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: use band parameter for LC calibration
References: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
Date:   Mon, 29 Oct 2018 16:30:26 +0200
In-Reply-To: <1540484313-9354-1-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Thu, 25 Oct 2018 18:18:33 +0200")
Message-ID: <87va5kbzb1.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> We use always 1 as band parameter for MCU_CAL_LC, this break 2GHz,
> we should use 0 for this band instead.
>
> Patch fixes problems happened sometimes when try to associate with 2GHz
> AP and manifest by errors like below:
>
> [14680.920823] wlan0: authenticate with 18:31:bf:c0:51:b0
> [14681.109506] wlan0: send auth to 18:31:bf:c0:51:b0 (try 1/3)
> [14681.310454] wlan0: send auth to 18:31:bf:c0:51:b0 (try 2/3)
> [14681.518469] wlan0: send auth to 18:31:bf:c0:51:b0 (try 3/3)
> [14681.726499] wlan0: authentication with 18:31:bf:c0:51:b0 timed out
>
> Fixes: 9aec146d0f6b ("mt76x0: pci: introduce mt76x0_phy_calirate routine")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> This is for 4.20.

This describes the symptoms better than the other 4.20 patch, thanks for
that. And at least to me looks ok for 4.20.

-- 
Kalle Valo
