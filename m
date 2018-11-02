Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E766C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 13:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 546F42081B
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 13:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 546F42081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeKBWhB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 18:37:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37065 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbeKBWhA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 18:37:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id z3-v6so2007956wru.4
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 06:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Stwq+tXqAPSqCEQzTiPimT1uI6NWm3LaSD7uBpjYPZk=;
        b=H01vi82xytXNzJ4KrrRB5XPW35zlq72hKaMmgnJ7mgILiwJB0OVezpF2w/TsSXvWQK
         +6AH4RikfYAdMShO5o5JAJL6zZzJaKfa2zsXQz8/za5Ktj0TGCV0kNL4nFGanHDO1+JR
         8j6MWeANtcfBtRWuIoKiEuKOzE/iXV2P92G18clroCGZwuXA8wqTkYsMSKhf66WNWzwr
         74aIAeuuByWO88aMH34QU4ArdP5qj7eX10LRjDBpVKVHu2E2SeSZAfmpRlKAd46BVPli
         GKEl7b7NYaj5c7qhq72dG1cGnDT2n4X7XABOWgjUqAQZoDhpur+5W3WLNcOk+Q5lJUAy
         9PMA==
X-Gm-Message-State: AGRZ1gLTKHxZTi1zssTwaC4yZFvfpNiaVnbd3d6pdil6k84Eb+xrQxtc
        Wg4mcWHecWFTL3A45YRtklzN23NgDro=
X-Google-Smtp-Source: AJdET5clW3iNL/+G+gYE41QTd+rWyJ7CtMs1mXFKXyubSJW7btrdJ5DGsWKS/+5F7eUoylP0elw53g==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11-v6mr8733430wrt.72.1541165389553;
        Fri, 02 Nov 2018 06:29:49 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id t143-v6sm22335755wmt.2.2018.11.02.06.29.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Nov 2018 06:29:49 -0700 (PDT)
Date:   Fri, 2 Nov 2018 14:29:46 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Cheng-Hao.Luo@mediatek.com, Ryder.Lee@mediatek.com
Subject: Re: [PATCH 2/3] mt76x0: phy: introduce tssi calibration support
Message-ID: <20181102132945.GB27823@localhost.localdomain>
References: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
 <d5d9abef3141a2809f5bf6319fcb407970b7eb19.1540848411.git.lorenzo.bianconi@redhat.com>
 <20181102130917.GB5247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181102130917.GB5247@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> (cc Mediatek.com engineers)
> 
> On Mon, Oct 29, 2018 at 10:31:24PM +0100, Lorenzo Bianconi wrote:
> > Run mt76x0 tssi calibration process if enabled in eeprom data.
> > Perform calibration procedure every 4s
> 
> I just checked the Mediatek vendor drivers for both MT7610E (at
> github https://github.com/i80s/mtk-sources ) and GPL relesed MT7610U driver
> are compiled without MT76x0_TSSI_CAL_COMPENSATION define.
> So seems TSSI compensation is not used or tested in vendor driver.

During the tests I carried out, TSSI calibration is disabled on my mt7610e
device (it runs temperature calibration) but it is enabled on my mt7610u
dongle and it seems to work properly.
Anyway more light on this topic from mtk folks is definitely very useful.

Regards,
Lorenzo

> 
> Perhaps Cheng-Hao Luo and Ryder Lee at Mediatek could clarify if this
> code is needed and is correct.
> 
> Thanks
> Stanislaw
> 
> 
