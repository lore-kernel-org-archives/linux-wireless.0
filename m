Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66AEC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 15:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7901A20B1F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 15:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="TaoT5s2p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbfAaPfl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:35:41 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43026 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfAaPfl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 10:35:41 -0500
Received: by mail-pl1-f195.google.com with SMTP id gn14so1620331plb.10
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 07:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1iT1OoAJ9Wp8fXpeUssYAOnTHPQXWZkCq0P3ZrWjLj4=;
        b=TaoT5s2pyt9n9r/g82GlKM7gBEzU9iaNjZmOcNppEUVzMvpUBOnmuJ+c1tDi3M6tZ+
         SawauXsE33FnxLF8Apvz+Wl/cCsf6HwJz2myNUGK0LGbbwZ0r6u+xGGVqFEhF1PqdQB/
         BGQrc3Z7Y/7jX1ZIDUky0zs1UiiHpTZ9RiPME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1iT1OoAJ9Wp8fXpeUssYAOnTHPQXWZkCq0P3ZrWjLj4=;
        b=ldyWITgcOgrEIUyYGRI4kXKzGXdfUXKdNUB3+eR8Q2mHuTDdv0DPA2sD6XpeuHDWAQ
         JvmvfzGdaQX8Mwc/oquEOf3Cxu2qywOkkWmLm/gvMHoYcacx3P7CrW4ZPu3RMhO0RIpN
         Pp22SMHlbGI7TnSvKUZRrW1sAKv2MEs7WJA3+KVF6l0XJkNSkicdVQpmKPy83OzYmXW5
         vjC9Z0e7VM3Vq8kKfQ2EkgwQ+C3ePGlvMbdDSSUxA43rNLxBwh3TrfBivPs2TRDPjdTt
         aGo4YNQViYfK3Fi4KMQLE4B0/+ZTdH33rx3nWbRFosskrkOQvSL36LlDm6rmkAUfgyhW
         VrTw==
X-Gm-Message-State: AJcUukeY4dvk0xF/0dVbbIeZaDSP8MaZxeL98beXVj88NHLc/Xe1grLC
        hgeJKNU2baFkqWM4mX67qogb9A==
X-Google-Smtp-Source: ALg8bN4zGXtN+7c9WRIYvupagquxd7jN7qiVNeTCmksk35BivTrsNQr+koMYtf2nQMsfIx2ni0Mp2w==
X-Received: by 2002:a17:902:2887:: with SMTP id f7mr34479721plb.176.1548948940448;
        Thu, 31 Jan 2019 07:35:40 -0800 (PST)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b26sm14315350pfe.91.2019.01.31.07.35.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 07:35:39 -0800 (PST)
Date:   Thu, 31 Jan 2019 07:35:37 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Set DMA address mask to 35 bit for WCN3990
Message-ID: <20190131153537.GC2387@tuxbook-pro>
References: <1535992622-5074-1-git-send-email-pillair@codeaurora.org>
 <20190130185721.GT31919@minitux>
 <871s4tj5p9.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871s4tj5p9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu 31 Jan 05:51 PST 2019, Kalle Valo wrote:

> Bjorn Andersson <bjorn.andersson@linaro.org> writes:
> 
> > On Mon 03 Sep 09:37 PDT 2018, Rakesh Pillai wrote:
> >
> >> WCN3990 is a 37-bit target but can address memory range
> >> only upto 35 bits. The 36th bit is used to control the
> >> smmu/iommu translation and the 37th bit is used by the
> >> internal bus masters to access the wifi subsystem internal
> >> SRAM. With the DMA mask set to 37i-bit, the host driver
> >> can get 37-bit dma address, which leads to incorrect
> >> address access in the target.
> >> 
> >> Hence the host driver can used addresses upto 35-bit
> >> for WCN3990. Fix the dma mask for wcn3990 to 35-bit,
> >> instead of 37-bit.
> >> 
> >> Tested HW: WCN3990
> >> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> >> 
> >> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> >
> > This solves the problem I'm seeing on my SDM845, where I see a
> > translation fault on a 32-bit address from the IOMMU, which we
> > previously mapped the 36 bit version of (my dma-ranges is set to 36
> > bits).
> >
> > So:
> >
> > Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Thanks for the reminder. This got piled up in my deferred queue in
> patchwork and I hadn't looked at it yet. I'll queue this for -next.
> 

Thanks

> > However, some of the changes in this patch and the fact that I get a
> > translation error on the lower 32 bits of the mapped iova, makes me
> > suspect that while the hardware is capable of 37 bits, the driver only
> > dealt with the lower 32.  And if that's the case I would like to see
> > that mentioned in the commit message.
> 
> Rakesh mentioned that it's actually 35 bits. Should something changed in
> the commit log still? I can do that if needed.
> 

Right, so the patch and commit message matches. What I'm asking about is
that in my testing I saw, from the IOMMU translation errors, that the
addresses accessed by the hardware wasn't 35 bit, they where only 32
bits.

Given that the patch also makes changes to how it writes addresses to
the ring I was wondering if the patch actually takes the limit from 32
to 35, not 37 to 35.


Regardless, I'm fine with the end result, you have my T-b and I would be
happy to see this in v5.1.

Regards,
Bjorn
