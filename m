Return-Path: <SRS0=qoP/=CT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64CAC433E2
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 16:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4C52087C
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 16:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CiZHkvSL";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="dddedF+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbgIJQBu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Sep 2020 12:01:50 -0400
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:45292
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731490AbgIJQAJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Sep 2020 12:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599753578;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=no4xzk5dl0DZKu3yUy/aceo++Mol/reXQMZo5+6oVlQ=;
        b=CiZHkvSL4bMmh+qQ11uG7MbYW4uMlL0lTFdYbN/dXguilmjr27AdVOj8vr0+KbCy
        dM80HgUJ4YfPCfovCH8T7qTDVhJK7LUWVrfLtin1rTvNnlU5kZ1mLizc1i1ICqgH5Yn
        XFmvZx2AIJi7a9eUEHKvOlTnj0qzAIOPs88+KF00=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599753578;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=no4xzk5dl0DZKu3yUy/aceo++Mol/reXQMZo5+6oVlQ=;
        b=dddedF+dAsRi1kD+OZUzAlpFu/REI8s/VEA8IBNbeOh40MLL2Qz9sS+CsAc/HSXG
        y44uNSosJJxfnitXyjSeFO2BBpFnyReFOaXfZcspKls0utPkc+NzSsRWM8aI8+7dmNo
        G+hgOzoIyXYFPS/h6iEq6+4Y2CpziZVVYy9Zd4So=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 932C9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 3/3] ath11k: add ipq6018 support
References: <1599551717-3801-1-git-send-email-akolli@codeaurora.org>
        <010101746cb68afd-6bca691b-12eb-40bd-bf2d-f22769b756ed-000000@us-west-2.amazonses.com>
Date:   Thu, 10 Sep 2020 15:59:38 +0000
In-Reply-To: <010101746cb68afd-6bca691b-12eb-40bd-bf2d-f22769b756ed-000000@us-west-2.amazonses.com>
        (Anilkumar Kolli's message of "Tue, 8 Sep 2020 07:55:36 +0000")
Message-ID: <0101017478be67b1-30e23aef-2da8-4355-b4d9-142972261c3e-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2020.09.10-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Anilkumar Kolli <akolli@codeaurora.org> writes:

> IPQ6018 has one 5G and one 2G radio with 2x2,
> shares ipq8074 configurations.
>
> Tested on: IPQ6018 hw1.0 AHB WLAN.HK.2.2-02134-QCAHKSWPL_SILICONZ-1
> Tested on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-00009-QCAHKSWPL_SILICONZ-1
>
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>

[...]

> --- a/drivers/net/wireless/ath/ath11k/core.h
> +++ b/drivers/net/wireless/ath/ath11k/core.h
> @@ -90,6 +90,7 @@ struct ath11k_skb_rxcb {
>  
>  enum ath11k_hw_rev {
>  	ATH11K_HW_IPQ8074,
> +	ATH11K_HW_IPQ6018,
>  	ATH11K_HW_QCA6390_HW20,
>  };

In the pending branch I changed this to:

enum ath11k_hw_rev {
	ATH11K_HW_IPQ8074,
	ATH11K_HW_QCA6390_HW20,
	ATH11K_HW_IPQ6018_HW10,
};

Also ATH11K_HW_IPQ8074 should be renamed to ATH11K_HW_IPQ8074_HW20, but
in a separate patch later.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
