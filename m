Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359E3C48BD5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 10:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0971A215EA
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 10:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r/XR7/xP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfFYK3i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 06:29:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731567AbfFYK3h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 06:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=03ojHgXKpRrzEADBxRtQ8YC8RIb84J9PztiNz1KmLWs=; b=r/XR7/xP6nyXRTnUY3y2v+YEK
        65bqRI45tLGykqbtovBBlOEpa/POnCsGZXJ9VKlizAcjRVNVxhXn9Clu423Ly+x/1uSblIAP6baao
        2dr6hPTSGnD7Rj75C8kTEJuUAZh2TvAzxTxe636gI5fza1jbBCK1QgWZ6xLlcOB+2cbruei5dJO96
        ushlCvQNRvUkIeffIaYJz6HG3AlHB10GCW9U7WbV+S0TLMDX6HZP9slfAYRtYyEWFErI6ZHUN7Cf/
        mrzyO9Uenwf/gDyMHOb9Ywz1SVjx0bt2N1pJbNBtusXJYzDF153QoDHfKmACDYb3D6+5dBjiD8Yz1
        GKadHXIaA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfihj-0005S9-O8; Tue, 25 Jun 2019 10:29:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: b43 / b43 legacy dma mask cleanups
Date:   Tue, 25 Jun 2019 12:29:28 +0200
Message-Id: <20190625102932.32257-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

below are a few cleanups for the DMA mask handling.  I came up with these
untested patches after looking through the code to debug the 32-bit pmac
30-bit dma issue involving b43legacy.
