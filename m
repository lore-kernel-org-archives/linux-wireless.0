Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987EDC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 16:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6804A20684
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551112392;
	bh=Eugwhe41lppKrKHFAJQA1tnSoyllr3oB1VbEaPcDfTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fGzKXwL+4QpM2BsTsMS/nismVBNHICXdjI2TD8nloJQSlXxithaiSE5iBFWlzbnlR
	 2eW6CHuDWOKYnzPZE3BygWk561RgRul1QzflstDKssrpfAoUfBVXilMGjz2lvGhahG
	 8NLTEmUQkSq9g70VeoO+mmveETZkgb8k9fpoh2m8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfBYQdL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 11:33:11 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37546 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbfBYQdL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 11:33:11 -0500
Received: by mail-oi1-f196.google.com with SMTP id w66so7755173oia.4;
        Mon, 25 Feb 2019 08:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xWvZjRfD5IvPzo1yPIbbhOrlkHggNsSHTPd8UWW3Jck=;
        b=d13Q9/8//peQLI1nKPtmpcUvLUVKh3IxpyqQDL/yUMr5+YU0dyZrdFsXJV/BWcI5PK
         jgsaxPH2pLj8P19dPAUZqzVtS3xK+pY3Zup1Q3WJzTeF7VTuzPBzmoV8Yhl+Ibtpq8Uk
         7olj0xPw+y8dLQR4EiFxmnBlZt1xshWj66IG+OECibi0v282exsXRRTBP564LmN8vsw9
         fdZQDiZHrEvkLbDk3Wyi7nBP82TwbvmC2LcB7Q1XKcXukOvBc7HBxv8bEReHRo062rR9
         XOPa01JdYRXIYl6rQ5jJ47980mjQ6j1gCtMH8CgG+6bHEXQx9aFP6mazEQtCz4yj4mbF
         OmGg==
X-Gm-Message-State: AHQUAuaE3zmvDxJEAXF9CaAjowu1apvzi2J25FhB/fuJEOmsCf3j/Rp+
        3fiY5s6gZ7s8WhnQnJacng==
X-Google-Smtp-Source: AHgI3IZE/xReXM7yr2SERZjueWk9UDenIQl7I7QmQ/eF2CzgM9vGtZ0/hkV4nOWPUras71ITuWN2oQ==
X-Received: by 2002:aca:b503:: with SMTP id e3mr11316456oif.87.1551112390160;
        Mon, 25 Feb 2019 08:33:10 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l6sm4124173otf.63.2019.02.25.08.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 08:33:09 -0800 (PST)
Date:   Mon, 25 Feb 2019 10:33:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: net: mt76: update binding for mt7603
 driver
Message-ID: <20190225163308.GA6363@bogus>
References: <20190130140756.91317-1-nbd@nbd.name>
 <20190130140756.91317-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130140756.91317-2-nbd@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 30 Jan 2019 15:07:55 +0100, Felix Fietkau wrote:
> In addition to MT7603E PCI devices, the driver supports the WLAN core on
> MT7628/MT7688, which needs to be defined in DT.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../bindings/net/wireless/mediatek,mt76.txt   | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
