Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04618C4338F
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Aug 2021 08:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B9A60EE8
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Aug 2021 08:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbhHFIr3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:47:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:41947 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231497AbhHFIr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Aug 2021 04:47:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628239633; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ana7UmuqR+Bk0VGuXemplEABFtFk/iLk/wuJCyedqS0=;
 b=Fiv9584hmXvKpmnxC8hur+y/VWHcAR4tE4X2ZTN2uc6xYeuwlFno+uTIor5ahJBOlAL+ZYc7
 N2IrShCrLmOFnBQZr8izc2mJKwpOan9d1r7ARcsMagCjoEb+EI7Cvy8V+OWmUsq8UYCbDcJt
 TiHmWaqJbdpzQjx2dvJojpUEprk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 610cf711ad1af63949ce7b32 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 08:47:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A1C1C43460; Fri,  6 Aug 2021 08:47:12 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A9CAC433F1;
        Fri,  6 Aug 2021 08:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A9CAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 27/54] dt-bindings: net: wireless: Convert ESP ESP8089
 binding
 to a schema
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210721140424.725744-28-maxime@cerno.tech>
References: <20210721140424.725744-28-maxime@cerno.tech>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210806084712.5A1C1C43460@smtp.codeaurora.org>
Date:   Fri,  6 Aug 2021 08:47:12 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maxime Ripard <maxime@cerno.tech> wrote:

> The ESP8089 Wireless Chip is supported by Linux (through an out-of-tree
> driver) thanks to its device tree binding.
> 
> Now that we have the DT validation in place, let's convert the device
> tree bindings for that driver over to a YAML schema.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: de Goede <hdegoede@redhat.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Reviewed-by: Rob Herring <robh@kernel.org>

We support out-of-tree drivers in DT?  Via which tree is this supposed to go? I
guess not via wireless-drivers-next as this is an out-of-tree driver.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210721140424.725744-28-maxime@cerno.tech/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

