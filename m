Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6089DC65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 228322147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S4f4uIJK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S4f4uIJK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 228322147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbeJFSca (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 14:32:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbeJFSca (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 14:32:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E114160C4E; Sat,  6 Oct 2018 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538825376;
        bh=2kvAmHpwPsjY9ebAHWPr22OoZDPdrAvA4LNuNVl0vtI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S4f4uIJKJZD5CMG2zjCD1jxE9IxyIi7Kdnpzgoc4eHdKCmXhk0CsGy8hgoWFCx1Ep
         toxAeeRF0Ic6mQytLMRBpfaXatOTIqLKNxVORbHnzub7wBzW4poHKBCyVKcXeDO/vy
         vm2OmSD8yYFX7xCSwXVnwxhe0lH5LnM1F2rj1I18=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B228E60275;
        Sat,  6 Oct 2018 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538825376;
        bh=2kvAmHpwPsjY9ebAHWPr22OoZDPdrAvA4LNuNVl0vtI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S4f4uIJKJZD5CMG2zjCD1jxE9IxyIi7Kdnpzgoc4eHdKCmXhk0CsGy8hgoWFCx1Ep
         toxAeeRF0Ic6mQytLMRBpfaXatOTIqLKNxVORbHnzub7wBzW4poHKBCyVKcXeDO/vy
         vm2OmSD8yYFX7xCSwXVnwxhe0lH5LnM1F2rj1I18=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B228E60275
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-10-05 v2
References: <783b92c4-0fba-35d8-9fdb-2c3462aa9f7f@nbd.name>
        <87sh1jh0fo.fsf@kamboji.qca.qualcomm.com>
        <20524062-9770-24d6-b1d8-9dfbe30e6b1f@nbd.name>
Date:   Sat, 06 Oct 2018 14:29:33 +0300
In-Reply-To: <20524062-9770-24d6-b1d8-9dfbe30e6b1f@nbd.name> (Felix Fietkau's
        message of "Sat, 6 Oct 2018 12:03:50 +0200")
Message-ID: <87k1mvgvoi.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> here's the fixed version of the previous pull request. I've dropped
> the broken patch from the previous round.
>
> - Felix
>
> The following changes since commit e1c02eb16a9c742178874a7d1a08d300981715fb:
>
>   qtnfmac: implement dump_station support for STA mode (2018-10-05 14:01:44 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-05
>
> for you to fetch changes up to 9b43960b899c71c758209a58c7e8d7d6e481e272:
>
>   mt76: move irq handler in mt76x02-lib moudle (2018-10-05 20:05:46 +0200)
>
> ----------------------------------------------------------------
> mt76 patches for 4.20
>
> * unify code between mt76x0, mt76x2
> * mt76x0 fixes
> * another fix for rx buffer allocation regression on usb
> * move mt76x2 source files to mt76x2 folder
> * more work on mt76x0e support
>
> ----------------------------------------------------------------

This compiled without problems, thanks for the quick update. Pulled.

-- 
Kalle Valo
