Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C986CC04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C5E32084C
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pMSgeT6K";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Hqrf2ERL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C5E32084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbeLEHdm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 02:33:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbeLEHdm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 02:33:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 217C7607B5; Wed,  5 Dec 2018 07:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543995221;
        bh=RukOF3KYe2UJ3iLmwUE7ziSl6VspL9eX8+tw/QHJflo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pMSgeT6KH8kpoQly2mxvoynCl7q7huUWy8nwnl3yyhAMJwG1Ge2yemnmb577KtppW
         LBYrETUOInAktn14I+9bDJIxKRFiv21k6rH5V3FEw1bcVKG2Q1wfTRuRiaCmJgu0Va
         4O8/l768bRS1h/LKu2rBUEMHutLNq1F92mwfXhlc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F194E601B4;
        Wed,  5 Dec 2018 07:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543995220;
        bh=RukOF3KYe2UJ3iLmwUE7ziSl6VspL9eX8+tw/QHJflo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Hqrf2ERLOjTR5TeQY8to3GrRiOH0Nyu7HVOMFk0zMC8GUOvt0czLNFDX1pTQ4LP9h
         +4uaZYOdd/xrAcYQ6QE+B58ODDVgQVoqNM8gC/pcULxqnAp8ML4aL2u3OI1kmuWzZS
         71HsSxp+mYD/V3oKL2FWve5FCo8HjbnuG4/LOXMw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F194E601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-11-30
References: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name>
Date:   Wed, 05 Dec 2018 09:33:36 +0200
In-Reply-To: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name> (Felix Fietkau's
        message of "Fri, 30 Nov 2018 12:34:25 +0100")
Message-ID: <87sgzc4ecv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> here's my first pull request for 4.21
>
> - Felix
>
> The following changes since commit b72c51a58e6d63ef673ac96b8ab5bc98799c5f7b:
>
>   brcmfmac: Fix out of bounds memory access during fw load (2018-11-29 17:33:10 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-11-30
>
> for you to fetch changes up to e28487ea84a9c081c6d8d7da319427f7fcc32ff5:
>
>   mt76: replace sta_add/remove ops with common sta_state function (2018-11-30 12:30:37 +0100)
>
> ----------------------------------------------------------------
> first batch of mt76 patches for 4.21
>
> * use the same firmware for mt76x2e and mt76x2u
> * mt76x2 fixes
> * mt76x0 fixes
> * mt76x0e survey support
> * more unification between mt76x2 and mt76x0
> * mt76x0e AP mode support
> * mt76x0e DFS support
> * rework and fix tx status handling for mt76x0 and mt76x2
>
> ----------------------------------------------------------------

I fast forwarded w-d-next to net-next and now there's a conflict. I did
a test merge in the pending branch, please double check:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=e69caab09bf98d0d8b559d06887364cc0090097c

This was the conflict:

diff --cc drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 3f001bd6806c,b54a32397486..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@@ -264,21 -173,6 +173,24 @@@ static int mt76x2_get_antenna(struct ie
  	return 0;
  }
  
++<<<<<<< HEAD
 +static int
 +mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 +{
 +	struct mt76x02_dev *dev = hw->priv;
 +
 +	if (val != ~0 && val > 0xffff)
 +		return -EINVAL;
 +
 +	mutex_lock(&dev->mt76.mutex);
 +	mt76x2_mac_set_tx_protection(dev, val);
 +	mutex_unlock(&dev->mt76.mutex);
 +
 +	return 0;
 +}
 +
++=======
++>>>>>>> 1b0adb0ab8649a1ed44f9840724878cffaaa6896
  const struct ieee80211_ops mt76x2_ops = {
  	.tx = mt76x02_tx,
  	.start = mt76x2_start,

I solved it by removing mt76x2_set_rts_threshold(). After there was also
a compilation error which I fixed like this:

diff --cc drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 3f001bd6806c,b54a32397486..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 3a70e5bf7d42..38bd466cff16 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -462,9 +462,9 @@ int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 	if (val != ~0 && val > 0xffff)
 		return -EINVAL;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	mt76x02_mac_set_tx_protection(dev, val);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }

-- 
Kalle Valo
