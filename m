Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED1BC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB4FF20684
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H/Tq+J4m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DCEU5nDi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfDYQ6y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:58:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDYQ6y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:58:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 42A8160388; Thu, 25 Apr 2019 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211533;
        bh=dy1g4A/ZXYy6lDJvUyNKeffze1xxIx1tsY4j9Y+qmPE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=H/Tq+J4mHKxojEewTcnB6Dt5U220gETRiNJfSDFb51CcnBShh0nmP1LzOREPXUqN/
         AfNMoT35Fluv6BB+HIM7eaBz7xxQ2mtmdyXDE9aNSXlTclAdQ3ZVYDKQOuyoLJfvAN
         MZbuc/a/YyG9hqZReIZl5dOsfW533TpKbsSAIa0M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C02FA60388;
        Thu, 25 Apr 2019 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211532;
        bh=dy1g4A/ZXYy6lDJvUyNKeffze1xxIx1tsY4j9Y+qmPE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=DCEU5nDiuuB3u/0ZpzupuqvghSCdrGych39Kv95266DWzjiGyF5Nx8sX2C1j797t7
         VpJF4+gyefiGxek0DY4uUBHlpwTEz7uz2GOT2H6Qshi8t6BoDnKVyMxkrbuzVjwfbR
         EvS0F9ZfKg3IQ0uDMbrp6LXXZMrSGo+GkRMxqfbw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C02FA60388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rt2x00: add RT3883 support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1556092164-23823-1-git-send-email-sgruszka@redhat.com>
References: <1556092164-23823-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165853.42A8160388@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:58:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> From: Gabor Juhos <juhosg@openwrt.org>
> 
> Patch add support for RT3883 chip. Code was taken direclty
> from openwrt project and merge into one patch.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

d0e61a0f7cca rt2x00: add RT3883 support

-- 
https://patchwork.kernel.org/patch/10914303/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

