Return-Path: <SRS0=Edxh=DP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCA9C433E7
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 21:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BCAC22241
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602194345;
	bh=R9f9hIsAqruRmlzMHSQOyKh4EzOF5BOtu/7A43VKfig=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=al6Wv6auHskbQimEU421I2l/QJqIWOmNgjpcWr4uR35R4eI66RaaTSKvnzkMhRjO3
	 3G/odR2MxLetofE08bnZNLhJWEmrWMfprg8bYZbMQe9tV39YUNNeofAPzihEENgqXP
	 37JyHKzmxk/mtOqESAGRTW1JxmnlH/AUPN/0VgWU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgJHV7A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Oct 2020 17:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJHV7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Oct 2020 17:59:00 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B325B22241;
        Thu,  8 Oct 2020 21:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602194339;
        bh=R9f9hIsAqruRmlzMHSQOyKh4EzOF5BOtu/7A43VKfig=;
        h=Date:From:To:Cc:Subject:From;
        b=0us3m4MalVN2FlI9J0jRQ2NX/BWhtd1DU278R44GCOBNahHxliUWUHa1v+WVovGv0
         MRJd1TpXGhZeaqADZ9io1jWrGx0mXLBTr7gojGgyQ2bClYEPGn8CKT61qbn6a+vtDf
         MPdbRkKkiKLNCHVXJ26/pTPuq5IXS2Cy8IFBlgTs=
Date:   Thu, 8 Oct 2020 17:04:22 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ray_cs: Use fallthrough pseudo-keyword
Message-ID: <20201008220422.GA6926@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to enable -Wimplicit-fallthrough for Clang[1], replace the
existing /* fall through */ comments with the new pseudo-keyword
macro fallthrough[2].

[1] https://git.kernel.org/linus/e2079e93f562c7f7a030eb7642017ee5eabaaa10
[2] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ray_cs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index bf3fbd14eda3..590bd974d94f 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -877,10 +877,10 @@ static int ray_hw_xmit(unsigned char *data, int len, struct net_device *dev,
 	switch (ccsindex = get_free_tx_ccs(local)) {
 	case ECCSBUSY:
 		pr_debug("ray_hw_xmit tx_ccs table busy\n");
-		/* fall through */
+		fallthrough;
 	case ECCSFULL:
 		pr_debug("ray_hw_xmit No free tx ccs\n");
-		/* fall through */
+		fallthrough;
 	case ECARDGONE:
 		netif_stop_queue(dev);
 		return XMIT_NO_CCS;
@@ -1272,7 +1272,7 @@ static int ray_set_mode(struct net_device *dev, struct iw_request_info *info,
 	switch (wrqu->mode) {
 	case IW_MODE_ADHOC:
 		card_mode = 0;
-		/* Fall through */
+		fallthrough;
 	case IW_MODE_INFRA:
 		local->sparm.b5.a_network_type = card_mode;
 		break;
-- 
2.27.0

