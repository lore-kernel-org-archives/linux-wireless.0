Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE494C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90F9320882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fzaQPeXc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jkCfXbCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfA3LGa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:06:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3LGa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:06:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6A38C60CF4; Wed, 30 Jan 2019 11:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548846389;
        bh=I1ZdCr1Sfiuz9Qbuu3o6x29QQntnYDYsGTuCXXkenBY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fzaQPeXci0XSiDQ26iCJFH0cdP/zQFDdBTy6X072tSLTBSZ6oIUWYXgXCcKNuVBzN
         gkw+iKO6r16YsVjjmeQNuTY5+Ctsoj6A8HYdcbmkuvAXE1jd84Smpi26ornv2g/+TH
         0h/sToTGNKu3QvtzYXu4WORhMf5mr15ZcMLmXD2A=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACDAB60C7F;
        Wed, 30 Jan 2019 11:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548846370;
        bh=I1ZdCr1Sfiuz9Qbuu3o6x29QQntnYDYsGTuCXXkenBY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jkCfXbCQBLn4LNaxJ7g3R8x6KZBOBmBzOzVO60vYdnB6reqxccEHR9t+wiLBg+OLZ
         zbjl7UGOqYn3e0LPPhspiDDvwlwH38O/tMx5FU6CIe5rviceSNReHiz18Mkq+SadBK
         ta6SyeFwBPt1DGygzXhPigKrKHbDSgrsAlizJAz4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ACDAB60C7F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2019-01-22
References: <190a2c7e-d6ab-2984-2f25-e2ac34aede08@nbd.name>
Date:   Wed, 30 Jan 2019 13:06:07 +0200
In-Reply-To: <190a2c7e-d6ab-2984-2f25-e2ac34aede08@nbd.name> (Felix Fietkau's
        message of "Tue, 22 Jan 2019 16:45:55 +0100")
Message-ID: <87pnsejtgg.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> here's my first pull request for 5.1
>
> - Felix
>
> The following changes since commit 4ad0be160544ffbdafb7cec39bb8e6dd0a97317a:
>
>   brcmfmac: Use firmware_request_nowarn for the clm_blob (2019-01-10 13:41:03 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-01-22
>
> for you to fetch changes up to d225581df3147060bc99e931b11f7cf2dcb1b2ca:
>
>   mt76: avoid scheduling tx queues for powersave stations (2019-01-22 16:37:35 +0100)
>
> ----------------------------------------------------------------
> first batch of mt76 patches for 5.1
>
> * fixes for mt76x0/mt76x2
> * energy detect regulatory compliance fixes
> * tx status handling fixes
> * preparation for MT7603 support
> * channel switch announcement support
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
