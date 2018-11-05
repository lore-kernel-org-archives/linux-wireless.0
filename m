Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2700C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6946F20854
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a8Jz69R6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a8Jz69R6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6946F20854
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbeKES2q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 13:28:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeKES2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 13:28:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6132360588; Mon,  5 Nov 2018 09:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541409003;
        bh=kuArTX5nZXk0IWoPytf75kp3EJmc0X8D7fJqkhULnLQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a8Jz69R6Nx1htvv8jrQwQrPnl70LDZnppx9oE9Ark0lGc2BrQP4FW6MoPo73ipco8
         VAaLamaWJr85qE8dAFADhHhOASk0tNFiSltXbHLKum7QouR0jGRviu0D4oLporwFyG
         Sn/vuSlZ4+snRC9j9lOjHPY1MpsZDHxbKrIu2s8M=
Received: from x230.qca.qualcomm.com (37-33-75-124.bb.dnainternet.fi [37.33.75.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 65BBE6053D;
        Mon,  5 Nov 2018 09:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541409003;
        bh=kuArTX5nZXk0IWoPytf75kp3EJmc0X8D7fJqkhULnLQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a8Jz69R6Nx1htvv8jrQwQrPnl70LDZnppx9oE9Ark0lGc2BrQP4FW6MoPo73ipco8
         VAaLamaWJr85qE8dAFADhHhOASk0tNFiSltXbHLKum7QouR0jGRviu0D4oLporwFyG
         Sn/vuSlZ4+snRC9j9lOjHPY1MpsZDHxbKrIu2s8M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 65BBE6053D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] b43: Drop internal cordic algorithm implementation
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
        <51f98dbd0efe48c315d8e7876074aeaa22fde580.1541238842.git-series.plaes@plaes.org>
Date:   Mon, 05 Nov 2018 11:09:59 +0200
In-Reply-To: <51f98dbd0efe48c315d8e7876074aeaa22fde580.1541238842.git-series.plaes@plaes.org>
        (Priit Laes's message of "Sat, 3 Nov 2018 11:59:44 +0200")
Message-ID: <87y3a7gaag.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> Signed-off-by: Priit Laes <plaes@plaes.org>

No empty commit logs, please.

And IMHO you could fold patch 5 into patch 4.

-- 
Kalle Valo
