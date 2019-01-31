Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7EBC282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F4B218D3
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548940591;
	bh=kvlDNuVH0cTobc5CRLGlm6Fc/5depbdiij71SYRp5xs=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=pm2TUJYAMGbG6d/R3p/N7xsyA8fpc78P35FPpOQp413jrU/M7OvQf6WIj+E8/7+mg
	 AnTafOZtgUDxvtZpw1NiKoQc0ZtfrrjoTpletSn0Yq98zKASbLNFu77RbRw+8CetKh
	 CzQy1OhvFFnyJmz/eGso24Vwfuh4hauPi/tgLtXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733181AbfAaNQ2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbfAaNQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 08:16:28 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86AD4218D3;
        Thu, 31 Jan 2019 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548940588;
        bh=kvlDNuVH0cTobc5CRLGlm6Fc/5depbdiij71SYRp5xs=;
        h=Date:From:To:Cc:Subject:From;
        b=JUeYgmTBDj3tBplb/c41ycqst9hj3JON+Pj8vAYBjxzHLw1ztW7GJ8i0pT6fYyq1q
         cw1vOKx6AsHXSNRwJMNUMcCE3CDKWhjSWs1GTZY7XXXzcMehJ/dBxeI516tFhrx5ue
         wL0GX+EVDcDmENa8rt3hFlwOmhLjVDZqmDDpRCbU=
Date:   Thu, 31 Jan 2019 14:16:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH] ath9k: do not return invalid pointers as a *dentry
Message-ID: <20190131131625.GC19807@kroah.com>
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
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 6aa3ec024ffa..21191955a7c1 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -1039,6 +1039,9 @@ static struct dentry *create_buf_file_handler(const char *filename,
 
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

