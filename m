Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BE6C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696F220651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WcPVrWDD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Iij5jZxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfBZNHI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:07:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfBZNHG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:07:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8F29460F3B; Tue, 26 Feb 2019 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186425;
        bh=Ngz/aUZjvXVCJOMIptdhUEeGw58v4R+NcawkbywvUeI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WcPVrWDDNYBb+by81815xVtxy5DtdMGIrasq8wqbN2MlkEW6LBF/dlUKULOFPT7BZ
         P+dX/B/UmrahVOVOcsGuEozdktvcLpCYgfBuGYkqyK7+p+vxwDBFAxQYmGj9SqfEtb
         LkjsI1vFxq5vP9ESDRIzC0jsSKnc43PpmxEZlmiw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D0ED60E5D;
        Tue, 26 Feb 2019 13:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186425;
        bh=Ngz/aUZjvXVCJOMIptdhUEeGw58v4R+NcawkbywvUeI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Iij5jZxZAaKjQyHu+6sNi7Ee9JOcM1F3MY3RppCm1PZTEzEuoh4qdR2TJyao+Er5p
         ox2QFWDxjAG9Vt3EVeTCWlAT+0V559mVuTHSDrHqpsscN1Zs0y0dUMVRXoCVXC6/kN
         Li6Z0ghIxxKYrarMTRSYZVaPhvVRHbuXoFnFiI7s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0D0ED60E5D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: update the max num of peers supported for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550570468-25869-1-git-send-email-aambure@codeaurora.org>
References: <1550570468-25869-1-git-send-email-aambure@codeaurora.org>
To:     Abhishek Ambure <aambure@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130705.8F29460F3B@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:07:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Abhishek Ambure <aambure@codeaurora.org> wrote:

> WCN3990 firmware versions WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1 & onwards
> supports maximum 33 peers including self peer. To support maximum peers,
> send updated peer param to firmware during initialization.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

15493239eacf ath10k: update the max num of peers supported for WCN3990

-- 
https://patchwork.kernel.org/patch/10819597/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

