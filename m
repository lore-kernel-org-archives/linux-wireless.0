Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52936C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 15:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1250020644
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 15:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EdxDzoF7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EdxDzoF7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1250020644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeJMXPt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 19:15:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbeJMXPt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 19:15:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6600B6031A; Sat, 13 Oct 2018 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539445092;
        bh=GhhpxpgifEVhx77n8XxvE0v+iaFY+qm60cBNrV3RrDA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EdxDzoF7waJn3orsYZeD+gjTtPDX24KLveD5/J8wSxohEiAPb0ffEi6ASA59ysbBb
         YDe1nGT4pOdleySJL9thoCqy/1PksWYmN1dEcoXKWPaZV3bLrcy/yq94YOuZo3Pat4
         baSAWc6k9vj9gndJjRjRAFgtNfS6qWLv0LRrkmNw=
Received: from x230.qca.qualcomm.com (85-76-48-32-nat.elisa-mobile.fi [85.76.48.32])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30A246079B;
        Sat, 13 Oct 2018 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539445092;
        bh=GhhpxpgifEVhx77n8XxvE0v+iaFY+qm60cBNrV3RrDA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EdxDzoF7waJn3orsYZeD+gjTtPDX24KLveD5/J8wSxohEiAPb0ffEi6ASA59ysbBb
         YDe1nGT4pOdleySJL9thoCqy/1PksWYmN1dEcoXKWPaZV3bLrcy/yq94YOuZo3Pat4
         baSAWc6k9vj9gndJjRjRAFgtNfS6qWLv0LRrkmNw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30A246079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-10-13
References: <b1a9e887-ecba-8e72-4b1c-169a19809c49@nbd.name>
Date:   Sat, 13 Oct 2018 18:38:08 +0300
In-Reply-To: <b1a9e887-ecba-8e72-4b1c-169a19809c49@nbd.name> (Felix Fietkau's
        message of "Sat, 13 Oct 2018 16:40:55 +0200")
Message-ID: <87tvlpvov3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Hi Kalle,
>
> Here's another batch of mt76 code cleanup / deduplication / fixes
>
> - Felix
>
> The following changes since commit c894696188d5c2af1e636e458190e80c53fb893d:
>
>   rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version (2018-10-13 15:00:37 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-13
>
> for you to fetch changes up to f27a058199ee6da50d724302d42fff94a00851c7:
>
>   mt76x0: phy: do not run calibration during channel switch (2018-10-13 16:35:16 +0200)
>
> ----------------------------------------------------------------
> mt76 patches for 4.20
>
> * mt76x0 fixes
> * mt76x0e improvements (should be usable now)
> * usb support improvements
> * more mt76x0/mt76x2 unification work
> * minor fix for aggregation + powersave clients
>
> ----------------------------------------------------------------

Your s-o-b is missing from some of the patches, I can't pull this.

-- 
Kalle Valo
