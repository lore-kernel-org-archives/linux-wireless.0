Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2669CC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E187B20865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E187B20865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbeJLXwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:52:14 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44124 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbeJLXwO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 19:52:14 -0400
Received: by mail-ot1-f66.google.com with SMTP id p23so12879962otf.11;
        Fri, 12 Oct 2018 09:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DYcg0gJAsO4+uP7LcG9o3pdp0DWo/GRBtDztDI90D48=;
        b=lqAVMoWotFYqkKf4SEgkFhk3/zNs14vO4NTe2R1P72Q41pHZZwbhbdD6PFyp5sah4p
         Gxi+4NoS8/cTOSGEaBSEYhU0hHg08F3QeYmxkn5DIiKbijEZN+MZN+IMuUtAqsvEvb95
         smvaKDEJ8gI6iq85bkSxL3q07H8hinxs2iameNJkGLvp2RwNycethEACT3bUCzFC/qtx
         tVYVgNhzuLsVPmUPVfxwYLqCcH3EIY78A7yw7PQQahS2/FHetewIzUi1ftW7SwpOtoQw
         QV3wA9zWNCP4u2rFl2ILfp8mM8hleiyqfr1ddw4TlNIxCZIj4be+ZGKjPRmbdKQtmgGC
         Lgmg==
X-Gm-Message-State: ABuFfoiy+NWGKNDxuY9YyaYJQnb4GXkvDOUHVu5sDOvEu3v0QHDnLH+J
        SyPFVLZnhc722T3WVAZH3A==
X-Google-Smtp-Source: ACcGV62zZ6DawpktDvw181UlLVyf9veQNWUrIrpgcwPgZRadQL4U5xLcYcJ37HqjWJugVOYixkiWBg==
X-Received: by 2002:a9d:6387:: with SMTP id w7mr3990260otk.250.1539361139386;
        Fri, 12 Oct 2018 09:18:59 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 37sm466352ots.39.2018.10.12.09.18.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 09:18:58 -0700 (PDT)
Date:   Fri, 12 Oct 2018 11:18:57 -0500
From:   Rob Herring <robh@kernel.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        robh+dt@kernel.org, andy.gross@linaro.org,
        linux-soc@vger.kernel.org, Govind Singh <govinds@codeaurora.org>
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for
 WCN3990 wifi node
Message-ID: <20181012161857.GA27708@bogus>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 10 Oct 2018 17:22:54 +0530, Govind Singh wrote:
> Add missing optional properties in WCN3990 wifi node.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          | 28 ++++++++++++++++------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
