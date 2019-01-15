Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA6CC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 15:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9DD020645
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 15:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbfAOPrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 10:47:52 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37651 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbfAOPrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 10:47:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so3692959wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 07:47:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Oy0jIOM/zSRWk0R1W5rhmxXrt4c2XYJSzve44Pv9PPU=;
        b=HIvtFQWm3g8i4yZ1WWDiiJZZfc1yG4YJkExJ3xol3fZ7t9y3rM/Wh4vL8Gii1uqLgZ
         1JEoIUa01r/2juBthsl9i1hAibaeg6Y7hqhm44MbTjUEozlsChD1Yl/cEmNe2p6L4Ugb
         /XzoxmuYff6Zf3vU8C9nmGZk6wnP8FN5KFM+ewAn5DescACOn4jpg4oxf+YULxXwyi8q
         nSKYllmkslgxYU593o7IL3GkRtfaIDVBazmkUQYWqQ0lzNGtEtWrzShdhqWU10iW7d0C
         SFxCuLyagPlVQE2ZZG7a4fCj6rNQuqZ88mxTe7pyMd/49oJc5iWqEHDN2gNFY2uqzq9c
         Dwqw==
X-Gm-Message-State: AJcUukc1L6s2qZ3Bmni/S5FyY5Hbqh8KOBNY4N5eEWOYy6LG4sDa+ZOv
        KKrMl9we0RE0G/GoazsF+FBz63AiwiU=
X-Google-Smtp-Source: ALg8bN4P/NnULV7CpJgHLHOXB2tegpM7t2ywZZTIoT6RlHEjoo2PxcwNVpgacyRdaqKiEUbR8onIDg==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr3958846wmi.10.1547567270059;
        Tue, 15 Jan 2019 07:47:50 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a132sm41049337wmh.5.2019.01.15.07.47.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 07:47:49 -0800 (PST)
Date:   Tue, 15 Jan 2019 16:47:47 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190115154746.GA30564@localhost.localdomain>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115153546.GA8387@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Jan 15, 2019 at 01:33:41PM +0100, Lorenzo Bianconi wrote:
> > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > {tx,rx} datapath if the usb controller has sg data length constraints.
> > Moreover add disable_usb_sg module parameter in order to explicitly
> > disable scatter-gather. Some users have reported sg issues on AMD IOMMU

Hi Stanislaw,

> 
> Not sure what is the problem , but this patch set look like a workaround
> not fix. If this an issue with IOMMU and sg, seems there is something wrong
> in sg page mappings eigher on mt76 dirver or IOMMU driver.

The main point here I guess is we do not need sg if fragment number is one (e.g
usb2.0). Moreover this can fix IOMMU reported issues.

@Rosen: could you please try this series enabling IOMMU?

> 
> If things need to be fixed in mt76 I whould check if page mappings for
> sg are correct. Or remove sg usage from mt76_usb completly, mt76 MMIO
> version do not use sg for framgments, so most likely USB don't need it
> as well.

usb scatter-gather is used to properly support non-linear skbs (A-MSDU,
with usb3.0) since the hw (unlike pci counterpart) does not support it,
so we need it.

Regards,
Lorenzo

> 
> Thanks
> Stanislaw 
