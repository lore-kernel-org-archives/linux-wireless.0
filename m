Return-Path: <SRS0=eW0r=7W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD036C433E0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD83E20760
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591664019;
	bh=YP48rbtDsCt7cPYauRcjGLjAc3a4MGalUtGGAlwwvpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0IO5G3lI2HuFi/7ALkAvlgqADVvS96nSWkpzwHHTcGWLEFj2il+yZIW/DS0uPc0+R
	 taqRGGwtzDMHuHfp7Ac/eLFvTF8nIdj6eb367rd65dWZC1D/d2BX3tEBxsTriCblUl
	 tAozsgBmif8yH/XmqRFKgslWdrQtnM4nnhlYVw4M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbgFIAxi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbgFHXJn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195F320897;
        Mon,  8 Jun 2020 23:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657782;
        bh=YP48rbtDsCt7cPYauRcjGLjAc3a4MGalUtGGAlwwvpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caYNJ/377KU+JoNx1q38H67pp0OaoZ88mXx/hTWbnNStLGmcj56v79XpR77FMDNm4
         r7eaZGqJQ8WZwBDumGKdEcEKYrbCAUopsgjBcgbhgvKIhGwjYnHiNVvZaw5OqFwY2n
         I3/EQxkq0JQq6e/UVAlvU0aTu62HL2xXYe5+bLBM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 164/274] libertas_tf: avoid a null dereference in pointer priv
Date:   Mon,  8 Jun 2020 19:04:17 -0400
Message-Id: <20200608230607.3361041-164-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 049ceac308b0d57c4f06b9fb957cdf95d315cf0b ]

Currently there is a check if priv is null when calling lbtf_remove_card
but not in a previous call to if_usb_reset_dev that can also dereference
priv.  Fix this by also only calling lbtf_remove_card if priv is null.

It is noteable that there don't seem to be any bugs reported that the
null pointer dereference has ever occurred, so I'm not sure if the null
check is required, but since we're doing a null check anyway it should
be done for both function calls.

Addresses-Coverity: ("Dereference before null check")
Fixes: baa0280f08c7 ("libertas_tf: don't defer firmware loading until start()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200501173900.296658-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index 25ac9db35dbf..bedc09215088 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -247,10 +247,10 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 
-	if_usb_reset_device(priv);
-
-	if (priv)
+	if (priv) {
+		if_usb_reset_device(priv);
 		lbtf_remove_card(priv);
+	}
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
-- 
2.25.1

