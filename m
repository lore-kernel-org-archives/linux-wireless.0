Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C030FC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA1D2133D
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fyrgMu+S";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NiLBJja8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfB1IjH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:39:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfB1IjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:39:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DB24460F3D; Thu, 28 Feb 2019 08:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343145;
        bh=6oGjoUb6vPV6mXBqiIySFbbskd5JDkOO7r7AqQsM+8M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fyrgMu+SwdzKGBHTSrDkki2Oi8sEYc6Hn54DKIVdM5ybj/pHafKG8YBbvGgyEnc1i
         MxEI3RgHmLWnKz86V+FYW7IFRKLY+Xjsoo1Ew1eyDKoy6NivMTBCt1L9YvbjpMh0pR
         REn5TI07BZCIich9Db53cQdbyS3iDkyCLyBi9g+I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94E2B608CE;
        Thu, 28 Feb 2019 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343143;
        bh=6oGjoUb6vPV6mXBqiIySFbbskd5JDkOO7r7AqQsM+8M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NiLBJja8px4RzW7V2HuzTLV20UOZj8gds6SLwZIVU/qjzVjBa86j8C+SvZqS1b5ca
         DmlgM2aJ1fqDLG2TDivC06tbKvXO9y7XRiXXGLH7Xxmt5hQCN+XV+kU/M0YWlnKrZG
         DFIicHwIxoc9sA+YqY/be5xQs2zFGzT6T9EXAhDU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94E2B608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/5] mt76: fix a leaked reference by adding a missing
 of_node_put
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550819742-32155-3-git-send-email-wen.yang99@zte.com.cn>
References: <1550819742-32155-3-git-send-email-wen.yang99@zte.com.cn>
To:     Wen Yang <wen.yang99@zte.com.cn>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, anirudh@xilinx.com,
        John.Linn@xilinx.com, michal.simek@xilinx.com,
        wang.yi59@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228083905.DB24460F3D@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:39:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Yang <wen.yang99@zte.com.cn> wrote:

> The call to of_find_node_by_phandle returns a node pointer with refcount
> incremented thus it must be explicitly decremented after the last
> usage.
> 
> Detected by coccinelle with the following warnings:
> ./drivers/net/wireless/mediatek/mt76/eeprom.c:58:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
> ./drivers/net/wireless/mediatek/mt76/eeprom.c:61:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
> ./drivers/net/wireless/mediatek/mt76/eeprom.c:67:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
> ./drivers/net/wireless/mediatek/mt76/eeprom.c:70:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
> ./drivers/net/wireless/mediatek/mt76/eeprom.c:72:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
> 
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-mediatek@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

Patch applied to wireless-drivers-next.git, thanks.

34e022d8b780 mt76: fix a leaked reference by adding a missing of_node_put

-- 
https://patchwork.kernel.org/patch/10825315/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

