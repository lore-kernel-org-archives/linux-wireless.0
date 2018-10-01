Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B75C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39D39208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="je3phLul";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OxxAogy0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39D39208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbeJAUbI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:31:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbeJAUbI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:31:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6F37760B7F; Mon,  1 Oct 2018 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538401993;
        bh=wZp41YmfhqSIFC64XD5v4Qy5HGxqLgqLBMH7hSHbJM0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=je3phLulI+yRR9hpefCezaRdZpWq/5E9de20dt+ZXRnFRC6/lotHOvz18hbnxHTX4
         nzKomJwLNI/T2X7f1WG0AVfxvYjFeEG0yo/73Z+WSNNTWEfbnDIoUd9lgYF/H0wriO
         P3Y1pUTTsAy0UcRJKWSD7o0Mkdy8TjSH8JFopifo=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09DB160128;
        Mon,  1 Oct 2018 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538401993;
        bh=wZp41YmfhqSIFC64XD5v4Qy5HGxqLgqLBMH7hSHbJM0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OxxAogy00MS4m8T9s0mAKwsdEGyE3NWNDEJfrWuGAnQ7HM3GyLR0AYRoOVeBzvc2W
         nx+EcnlVPFKoWi43uIsWHZXt3H67ZXKdcE9/lgh6UQM6cafQlL0D8mFT6Z4vGnzl5I
         qcKTgKJvE+VRmliWHPjCN7z9nHV6qz+kHtd1jCmU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 09DB160128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Fix tx status flag setting for management
 frames
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1536240447-14841-1-git-send-email-pillair@codeaurora.org>
References: <1536240447-14841-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001135313.6F37760B7F@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 13:53:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The tx_status for management frames is being filled
> incorrectly in the flags of skb_cb. This incorrect
> flag setting causes the upper layers to consider that
> the particular frame was not transmitted properly,
> leading to improper behavior.
> 
> Set the IEEE80211_TX_STAT_ACK flag in the info flags
> of skb_cb, to indicate the successful transmission of
> the management frame.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Fixes: dc405152bb64d4ae01c9ac669de25b2d1fb6fc2d
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

058a7eab9d9e ath10k: fix tx status flag setting for management frames

-- 
https://patchwork.kernel.org/patch/10590621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

