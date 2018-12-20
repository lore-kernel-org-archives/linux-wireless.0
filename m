Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AF5C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3DC321720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W5m1bO++";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pNfEZbW8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbeLTRKv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:10:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730526AbeLTRKu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:10:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 27DC0602CB; Thu, 20 Dec 2018 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325850;
        bh=4KHXoovCIWdGhbdb3dczZ/8+4Tc+qf9BFQhfXKgn/uA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W5m1bO++5chIHJrteDrXAKUJDRk9d37Qil0XxBHPvBgrftZfkqVHPhKSGyfAyT4wo
         kd5cKH9uL1es1w47EhLrDX4ZxUTcnAT+71HqkA4ztJKvkXQvqC94TZF/DuhXizPgCH
         jjw7oylfdcUNx/XW8KfISfYiDlgVEXeymOR6FVmg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD0516014B;
        Thu, 20 Dec 2018 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325849;
        bh=4KHXoovCIWdGhbdb3dczZ/8+4Tc+qf9BFQhfXKgn/uA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=pNfEZbW8p5OL9Wt1VXxorHyf11zGiEKAfMd9ZK7kRqOn8+sItsCNR9oLo07dcBe4e
         SJxmSR3DkLr1BGIyOEBKUjbQVGm5kGXUekKldV1Gz1pv/a5xhgJfCtHjnVLdtHxZvZ
         qQ7JOrJaMoE+bdmmohp3sH8tEI7qrwnXs8lfdPds=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AD0516014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ath10k: fix node name and device
 type in qcom ath10k example
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1544544804-4039-2-git-send-email-bperumal@codeaurora.org>
References: <1544544804-4039-2-git-send-email-bperumal@codeaurora.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220171050.27DC0602CB@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:10:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bhagavathi Perumal S <bperumal@codeaurora.org> wrote:

> In qcom,ath10k documentation, ath10k is used as node name in the example of
> pci based device. Normally, node name should be class of device and not the
> model name, so fix it to node name "wifi". And remove the property device_type
> pci since only pci bridges should have this property.
> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

e5404969a335 dt-bindings: net: ath10k: fix node name and device type in qcom ath10k example
f3f587995c5a dt-bindings: net: ath10k: add new dt entry to identify external FEM
84758d4d43e9 ath10k: add support to configure BB timing over wmi

-- 
https://patchwork.kernel.org/patch/10724123/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

