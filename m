Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E62C6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 11:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BB1221104
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 11:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SfjBXXao";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SfjBXXao"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BB1221104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbeLNL47 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 06:56:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbeLNL47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 06:56:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D538760722; Fri, 14 Dec 2018 11:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544788618;
        bh=FtzKxwdouyo0Gwfd3dh1I3RTPXhwPOJWxfFe1DyIORM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SfjBXXaoLMt4fAhvuXXQpe1zJXkxyzzfs5BYa6ZTx8It697OBolOCFfKz1MdX/WT6
         GW2SJVrqHM2Lq/wFIE0bE0pMxHjDEp6GpER5z1Rsfjyw2+I8mkMKGoimqBiQFiAY5y
         ohv5+NZKtqBdGMsSHgx105SgPs1GUzyUQtz5K/VU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1FC13600E2;
        Fri, 14 Dec 2018 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544788618;
        bh=FtzKxwdouyo0Gwfd3dh1I3RTPXhwPOJWxfFe1DyIORM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SfjBXXaoLMt4fAhvuXXQpe1zJXkxyzzfs5BYa6ZTx8It697OBolOCFfKz1MdX/WT6
         GW2SJVrqHM2Lq/wFIE0bE0pMxHjDEp6GpER5z1Rsfjyw2+I8mkMKGoimqBiQFiAY5y
         ohv5+NZKtqBdGMsSHgx105SgPs1GUzyUQtz5K/VU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1FC13600E2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: skip sending quiet mode cmd for WCN3990
References: <1544782666-24837-1-git-send-email-kvalo@codeaurora.org>
Date:   Fri, 14 Dec 2018 13:56:54 +0200
In-Reply-To: <1544782666-24837-1-git-send-email-kvalo@codeaurora.org> (Kalle
        Valo's message of "Fri, 14 Dec 2018 12:17:46 +0200")
Message-ID: <87ftv0xqwp.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> From: Rakesh Pillai <pillair@codeaurora.org>
>
> HL2.0 firmware does not support setting quiet mode.  If the host driver sends
> the quiet mode setting command to the HL2.0 firmware, it crashes with the below
> signature.
>
> fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0
>
> The quiet mode command support is exposed by the firmware via thermal throttle
> wmi service. Enable ath10k thermal support if thermal throttle wmi service bit
> is set.  10.x firmware versions support this feature by default, but
> unfortunately do not advertise the support via service flags, hence have to
> manually set the service flag in ath10k_core_compat_services().
>
> Compile tested only.

I'm planning to queue this for 4.20 as wcn3990 support won't work
otherwise. But I wasn't able to test this so can someone help, please?

-- 
Kalle Valo
