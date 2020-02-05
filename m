Return-Path: <SRS0=U5kn=3Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3873C352A2
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 17:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1670217BA
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580924955;
	bh=qu97ho64I01Jqu+8j6o3YO79NwmsJxrKOpqYsQsoB8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OlosiPF6YATdwtRwDqVB9s+LCsYiLW6FZlkbKYRRM9Pv4fBrMUZEtgJrNUCbp5Ewv
	 mF39Q3WUa37K58wf7I9D1GMIwqJNMLAoQ6SHOysGMpXb/2t41OeXSWiarUpOZpwLvk
	 V2YrrhK3MejQHJN752/LenILjkPyiffh7u/OT7/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgBERtP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Feb 2020 12:49:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36816 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgBERtO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Feb 2020 12:49:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so3905744wma.1;
        Wed, 05 Feb 2020 09:49:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p7yEieln0jae2eT2M/0er6+kV9NoBt/oQX2qMjPZJ/Q=;
        b=Vkg6rWGzIbo2Rb2+JwVkfGipK8LcEPHzzweKLy1UXhfWkt8taI12ZVYMyTHw+Sx+az
         kcscyMSDyzCHgo4BUNWLRs86WOl6RgWT34GUkdXYQGODl/n3wAaUub8205qukgpfLsZ1
         xe2wRUc+sQeZxWzHwuoWzmy5aOLhKBwVaBZc0XEFzxJ955Xd9BR+T1N/PnK3nCojidQB
         7WamhChOj+p15UVuKr3l7i2HpFr4EPCNfajws4S12LjtXVZYUlXDZECdFPItenZcJEZ7
         rYSqfJVCKMCK15gCn+dfah65C1xoq/ZMssX4T4LK4qAivMVTycBUHt1BMKsXaVZPoziH
         RgPQ==
X-Gm-Message-State: APjAAAW7L6wkzm46TYRgKxfgZZvJA1AEaIa4GMAFUEGffr7mKHvLE9gO
        G2VWjf1j6RHg9eoEweColw==
X-Google-Smtp-Source: APXvYqxrkccvNl9da8AtZiLVomEnf+cjr97jeYk9zDCvBB4OzibTwGtQk0HvdayBC/CQAVvY6ffffQ==
X-Received: by 2002:a05:600c:20c6:: with SMTP id y6mr6912417wmm.95.1580924952525;
        Wed, 05 Feb 2020 09:49:12 -0800 (PST)
Received: from rob-hp-laptop ([212.187.182.166])
        by smtp.gmail.com with ESMTPSA id s1sm695548wro.66.2020.02.05.09.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 09:49:11 -0800 (PST)
Received: (nullmailer pid 29276 invoked by uid 1000);
        Wed, 05 Feb 2020 17:49:10 -0000
Date:   Wed, 5 Feb 2020 17:49:10 +0000
From:   Rob Herring <robh@kernel.org>
To:     Tamizh Chelvam <tamizhr@codeaurora.org>
Cc:     ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Tamizh Chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCHv2 1/2] dt-bindings: ath10k: Add new dt entries to
 identify coex support
Message-ID: <20200205174910.GA29218@bogus>
References: <1580152736-18654-1-git-send-email-tamizhr@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580152736-18654-1-git-send-email-tamizhr@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 28 Jan 2020 00:48:55 +0530, Tamizh Chelvam wrote:
> This adds new dt entries qcom,coexist-support and qcom,coexist-gpio-pin
> which will be used by ath10k driver to identify coex support
> of a hardware and notify wifi firmware the gpio pin number.
> This pin number information is needed for the hardware QCA4019.
> 
> Signed-off-by: Tamizh Chelvam <tamizhr@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
