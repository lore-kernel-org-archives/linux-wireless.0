Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A4AC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 158D52190B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nVWGcJLq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aQbXcs6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbfBLSpp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:45:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbfBLSpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:45:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 43A6660208; Tue, 12 Feb 2019 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997144;
        bh=cBs2qsOgt2Pp1+10w7CYlKr2ObY5/XgaF//tr52//7Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nVWGcJLqj80eOVmMOgTGR59Si0j25OcLm5q42dFkXOP5Pt3UdaY4hiTinbsQZ5Mjr
         /CwiSV9Ns95sFguySUxCKD2F7hKSgCWucbrhQLotBMbiTtjE1OZMem3l4Rvm9D/og+
         dHTXAGpGSkVt3NXY4roof76Fssoll5Dl0R93Kmnw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0610E6030D;
        Tue, 12 Feb 2019 18:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997143;
        bh=cBs2qsOgt2Pp1+10w7CYlKr2ObY5/XgaF//tr52//7Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aQbXcs6BNKBVgaJL2u9cWLYCayNtx5a2TooT+vEI2DDALqDGfA3SYvhuJ940n2xZH
         rTzNlmMh9GDE7BWSn1E9w4oy+jKDty2gbXbcvoRL10OVWEKYrBekxJ7crQ8Vei75SW
         8cNfOJ9dX0il+xDr9Z6RdL8j7J/fiwKU6izhBASw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0610E6030D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 2/4] ath9k: Switch to mac80211 TXQ scheduling and
 airtime APIs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122142019.21417-3-toke@redhat.com>
References: <20190122142019.21417-3-toke@redhat.com>
To:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212184544.43A6660208@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 18:45:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen wrote:

> This moves the ath9k driver to use the mac80211 TXQ scheduling and
> airtime accounting APIs, removing the corresponding state tracking
> inside the driver.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> [rmanohar@codeaurora.org: fixed checkpatch error and warnings]
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

89cea7493a34 ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
bb2edb733586 ath10k: migrate to mac80211 txq scheduling
d1ce37b7831a ath10k: report estimated frame transmit airtime to improve fairness

-- 
https://patchwork.kernel.org/patch/10775549/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

