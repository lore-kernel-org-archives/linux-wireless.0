Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2133C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 669CC21479
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RHSYD0EA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RHSYD0EA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 669CC21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbeJJOaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 10:30:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58364 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJOaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 10:30:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AB16E60C4D; Wed, 10 Oct 2018 07:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539155383;
        bh=VCT9uqRVXFx3c8XcIAAHcvCX1aNZHvUPAkvVFQBUHM8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RHSYD0EA+eOmjqU2UnW9r/rIcNODSh7qJFzdvRD6ArkZbwaDBKMefLf4idqF65vx3
         Sg/dh/J4aZhsZ/oYPLc8DTTqmTOOXucXmAvHUXXMthEuZpCBVlTgtR/royA8ExtgM7
         Z58HhTHbQ5R+nTjOSoYenZRRKngrEMR0y/uHjPAc=
Received: from x230.qca.qualcomm.com (188-67-121-187.bb.dnainternet.fi [188.67.121.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E27D6086B;
        Wed, 10 Oct 2018 07:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539155383;
        bh=VCT9uqRVXFx3c8XcIAAHcvCX1aNZHvUPAkvVFQBUHM8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RHSYD0EA+eOmjqU2UnW9r/rIcNODSh7qJFzdvRD6ArkZbwaDBKMefLf4idqF65vx3
         Sg/dh/J4aZhsZ/oYPLc8DTTqmTOOXucXmAvHUXXMthEuZpCBVlTgtR/royA8ExtgM7
         Z58HhTHbQ5R+nTjOSoYenZRRKngrEMR0y/uHjPAc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E27D6086B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based machines
References: <20181009124755.25402-1-hdegoede@redhat.com>
        <20181009124755.25402-5-hdegoede@redhat.com>
Date:   Wed, 10 Oct 2018 10:09:38 +0300
In-Reply-To: <20181009124755.25402-5-hdegoede@redhat.com> (Hans de Goede's
        message of "Tue, 9 Oct 2018 14:47:54 +0200")
Message-ID: <87murmxop9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

> For x86 based machines, set the board_type used for nvram file selection
> based on the DMI sys-vendor and product-name strings.
>
> Since on some models these strings are too generic, this commit also adds
> a quirk table overriding the strings for models listed in that table.
>
> The board_type setting is used to load the board-specific nvram file with
> a board-specific name so that we can ship files for each supported board
> in linux-firmware.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

[...]

> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: ISC

I don't see the ISC file in LICENSES directory[1] and I don't feel
comfortable taking SPDX tags which which don't have a license file.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/LICENSES

-- 
Kalle Valo
