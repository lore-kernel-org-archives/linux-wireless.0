Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AB0C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19BF220700
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553715380;
	bh=9QsSymN6+QdwHLCzp5kxZJSSzBmmhUceuZCJb7tALNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wrQ00lupIzykVl+nZ1ysSDnlpBYmGo4ccaNqfRKSD0w0O7YFW7P6FvUibeGqRtCyq
	 BKwHtzO8SZOlLXmvQw/Efs+e+P1RCk+G0ZWQuv7sV83Y11Ct3yFfPU1TLYM9cK3sNC
	 nZwRZf6zaUmgoMr4tRebSiBYqgsZZZ1lLfcPSOu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbfC0TgT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:36:19 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36719 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfC0TgT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 15:36:19 -0400
Received: by mail-oi1-f195.google.com with SMTP id t206so13838747oib.3;
        Wed, 27 Mar 2019 12:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HNzd5korLgatZnZdViJ9+Mc/RbfMyglM4c7e2LXOJpg=;
        b=BuodQnBn68tFFVV+s94OOC/VFk5m01vKuie8+Bi9yp91qWZ9DnGL03GWkNTzL/7yDd
         t42DNy0i/fWEKTP76P57YMPMgnzPGd2Q557bNTdOdIEferbFzGS7UPt+O3yWNiNGy3J5
         /Lfap9fpo2OvdsaDr3TzlCP80aRaR5TzXCnatBzcll5qki+ff6IJrAC9qPsRzcwk88+6
         XI4f2z2xPkzD9p//L56XHpPU/HsIiJmu5TXUqzPNa5Sb2GiZeEJzospGpxEeI29ZwJ7d
         hMlV7bKl6m4XLF0Kd/BrOE1zzzp/OO5IGjh/tYoaUVvEyiPy+nx0NU94RXfMWNdCM1Ul
         krkw==
X-Gm-Message-State: APjAAAWOXB6PtQSp0u1Ubdn2jeZbaxkP3p+2YO3OjQpKLuMjlRRS8T0T
        UUM04/QPkdPem+PbgpK1c/tH96s=
X-Google-Smtp-Source: APXvYqzdUXhEXf7G8flBbfl+s/pHJs40h2LdsCRhrAOH8FB3nM7N3I+tl7HmnEROiKaDp6KzTZHEBg==
X-Received: by 2002:aca:f594:: with SMTP id t142mr21396219oih.100.1553715378523;
        Wed, 27 Mar 2019 12:36:18 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 30sm6614924otq.62.2019.03.27.12.36.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Mar 2019 12:36:17 -0700 (PDT)
Date:   Wed, 27 Mar 2019 14:36:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: bindings: add dt entry for XO calibration support
Message-ID: <20190327193617.GA18283@bogus>
References: <20190302050635.17694-1-govinds@codeaurora.org>
 <20190302050635.17694-2-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190302050635.17694-2-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 02, 2019 at 10:36:34AM +0530, Govind Singh wrote:
> Add dt binding to get xo calibration data support for wifi rf clock.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index ae661e65354e..ab8042866e83 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -81,6 +81,7 @@ Optional properties:
>  	Definition: Name of external front end module used. Some valid FEM names
>  		    for example: "microsemi-lx5586", "sky85703-11"
>  		    and "sky85803" etc.
> +- xo-cal-data: xo cal offset to be configured in xo trim register.

Should have a vendor prefix.

Rob
