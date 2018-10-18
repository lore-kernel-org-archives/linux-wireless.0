Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3306C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A138F2145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A138F2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbeJRQ3o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:29:44 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59906 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727396AbeJRQ3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:29:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gD3gh-0002jy-Rz; Thu, 18 Oct 2018 10:29:47 +0200
Message-ID: <a28348956ba3fbfded80bc78ba1c0335df7edb75.camel@sipsolutions.net>
Subject: Re: [RFC 2/2] ath10k: Add QCA vendor command/attr support to
 filterneighbor BSS frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date:   Thu, 18 Oct 2018 10:29:32 +0200
In-Reply-To: <20181005060031.BA1EB60BF4@smtp.codeaurora.org>
References: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
         <20181005060031.BA1EB60BF4@smtp.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-05 at 06:00 +0000, Kalle Valo wrote:
> 
> So I'm not sure what to do with this. A bpf type of filtering system in
> mac80211 would be nice

Yes, I think we really need to start implementing that sooner rather
than later. I had something, must see if I can find time for it.

> but then again we cannot benefit from HW offloading.

Yes, that's a concern. But how big of a concern is it really?

This patch only talks about "allow an AP" etc. and so while important,
power isn't the _utmost_ concern like on mobile. Given an efficient
filtering solution in software, would that be sufficient?

johannes

