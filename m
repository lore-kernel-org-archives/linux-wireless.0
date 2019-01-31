Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DA7C282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D19A218EA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548940561;
	bh=12Ixcgdd5ByPPgRPrckh93UFXuKJB2u8/hJZjGNZ550=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=LjEqDxapAd4HIsZZNpBvFNPv8RUg6NQvJcd01cOUU2DDhgwEpT4x/F/rSjRmF0c4s
	 G+m85hIU1+mVcB9EICSldeNAtT1krgBJx7nNDg8JpsQf0/KTCdqWTwprJt3Z8Z8XY4
	 wp1SH2sI71TzwCe0LmorECda4azdbTW8S0Rk2VFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbfAaNP7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfAaNP7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 08:15:59 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417BD218D3;
        Thu, 31 Jan 2019 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548940558;
        bh=12Ixcgdd5ByPPgRPrckh93UFXuKJB2u8/hJZjGNZ550=;
        h=Date:From:To:Cc:Subject:From;
        b=M5CgFxQsnyBb1Av2vuPXA5fWs+bv94X0RVyRC9ogd0qc1sXDfoMJlSpM5ROBHUDqG
         dXiBtHM1PTq9gmQAQb/K88bU1wCI/LtfxI8+Lb2BkXs69f8w54+6Cywd6MO6FfPtAP
         GZ7DDc3p6qWzEgSNmqMM1ek6RPKqwb/bhXZ1USI4=
Date:   Thu, 31 Jan 2019 14:15:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] ath10k: do not return invalid pointers as a *dentry
Message-ID: <20190131131556.GB19807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When calling debugfs functions, they can now return error values if
something went wrong.  If that happens, return a NULL as a *dentry to
the relay core instead of passing it an illegal pointer.

The relay core should be able to handle an illegal pointer, but add this
check to be safe.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/spectral.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 653b6d013207..4a7fa3e4e99f 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -494,6 +494,9 @@ static struct dentry *create_buf_file_handler(const char *filename,
 
 	buf_file = debugfs_create_file(filename, mode, parent, buf,
 				       &relay_file_operations);
+	if (IS_ERR(buf_file))
+		return NULL;
+
 	*is_global = 1;
 	return buf_file;
 }
-- 
2.20.1

