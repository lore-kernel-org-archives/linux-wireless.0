Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBA1C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1ADF2087F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RT8LQv5M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HPrQVL2f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfAHQrr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:47:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbfAHQrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:47:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C53EC609C3; Tue,  8 Jan 2019 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546966066;
        bh=xPLPICHJjcYTSuDHaMnI7hYtEDaQuYyW1Ye7JT0LB6o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RT8LQv5MFM83TgxImfQuOXhHzFKoCWrDQW9OT1CgnFUV2cvTyZQf92blKF+hbzArF
         ptYmtlqkEfB/HslMme4gvT3ftXAbkiTiIwSCvEwDsifBz3dSPtfMdkWJ3wHPmC3E2y
         xCrtp4VlGdoYX685MDijO8JHJXVBANyI1knDOrAE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C2AA609C3;
        Tue,  8 Jan 2019 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546966064;
        bh=xPLPICHJjcYTSuDHaMnI7hYtEDaQuYyW1Ye7JT0LB6o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HPrQVL2fbiD4tA5ZSzBjrvBgx8j9rqndLiRmTjl2thl8gu4n9jWwAWmw2ulpcQblV
         7DyLXA5abmnpxMFasJ9O/Zf+4WtbHbdOC74G1bHX5efixtsoqE4Df11f6jmHNRN0bP
         cVj9bC5t5V8k+fYBiFLo9ERKvLgwsTG9WeANU4To=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C2AA609C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: ath: return error code upstream
References: <20181226064328.75897-1-kjlu@umn.edu>
Date:   Tue, 08 Jan 2019 18:47:39 +0200
In-Reply-To: <20181226064328.75897-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Wed, 26 Dec 2018 00:43:28 -0600")
Message-ID: <87r2dnqeok.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

> ath6kl_wmi_cmd_send could fail, so let's return its error code upstream.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/net/wireless/ath/ath6kl/wmi.c | 4 +---

The correct prefix is "ath6kl: " but I can fix that.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
