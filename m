Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A4DC67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 03:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C99E20672
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 03:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544498833;
	bh=NimB7XQtKMmr+lDRELD0kHxy8Na7xypmYSSGLBqUgNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dBiyluZZBJIZvO4sBfBOMno1lz2rABcAD95zqwvfWNbYSw5+IDvA7SKOECGFD3L2L
	 E/NVN2aw7WhYeCLEUCFU1HZp6FDxJmYEVbB1vQhapDEUdG3rMEeFD5hsWxgkDVoWBP
	 q1eyzENb+uHIE/DL7pk5OXl0Vq68rB+EhtOggom8=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C99E20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbeLKD1M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 22:27:12 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37075 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbeLKD1L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 22:27:11 -0500
Received: by mail-ot1-f66.google.com with SMTP id 40so12687675oth.4;
        Mon, 10 Dec 2018 19:27:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wFSTEXsyMN+M+m75a/jcZRHvPPVV3VWmlNLY7oOS0gQ=;
        b=R5WxILZmnqJfYkJgwVE4aXntnP2kDf4YoQuG4ZrviWAHfIQbj9Phq8tN7Fw9apkkal
         rRYwEtZ4w8+2Iv5nSYrH8JAiP82KO8QyJ80qBC2U1Yrgj3pB1l1aleBRBvC6EHIdbPG+
         JgGnpPj/Si93Z/QQ7hzkL9/GPpI9pQl3bgFkNBa7IzOaleQuAUmNyhn2DJB0mKnuJGgI
         nHpLroEu7fFCOWt3nzWT4CHqfKDeRNukhWlxISEmNqij18ks25id3bnbWfgZoWKcEqyq
         mMfubSq89wQ4BX20fHm/AzSc4nYtjkSvKlviBheOD8sWpg+o8aNdsEOroqq44cRJsxzK
         N4pw==
X-Gm-Message-State: AA+aEWaW63wR13mBSHFfdboHzHqStHWevAzeLmgh8AvJTuPiAvAc3gSe
        xbnNqrajcWdJCm2squxBDCJqc1M=
X-Google-Smtp-Source: AFSGD/VF7PlolazMPspOeE9x1Ou8isDQdhUEMB/4xOj3IoT3wm/Ni5qpx7H5pSH4OMIinRtXPAUkew==
X-Received: by 2002:a9d:3ba5:: with SMTP id k34mr10660866otc.364.1544498829236;
        Mon, 10 Dec 2018 19:27:09 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t21sm5952212otq.67.2018.12.10.19.27.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 19:27:08 -0800 (PST)
Date:   Mon, 10 Dec 2018 21:27:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: Re: [PATCH v3 2/3] dt-bindings: net: ath10k: add new dt entry to
 identify external FEM
Message-ID: <20181211032708.GA14508@bogus>
References: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
 <1544466691-11821-3-git-send-email-bperumal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544466691-11821-3-git-send-email-bperumal@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 11 Dec 2018 00:01:30 +0530, Bhagavathi Perumal S wrote:
> This adds new dt entry ext-fem-name, it is used by ath10k driver
> to select correct timing parameters and configure it in target wifi hardware.
> The Front End Module(FEM) normally includes tx power amplifier(PA) and
> rx low noise amplifier(LNA). The default timing parameters like tx end to
> PA off timing values were fine tuned for internal FEM used in reference
> design. And these timing values can not be same if ODM modifies hardware
> design with different external FEM. This DT entry helps to choose correct
> timing values in driver if different external FEM hardware used.
> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
