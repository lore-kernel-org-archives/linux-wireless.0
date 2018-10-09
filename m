Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82A5C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 15:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77E242087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 15:58:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77E242087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbeJIXPp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:15:45 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:39053 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeJIXPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 19:15:45 -0400
Received: from wuerfel.lan ([109.193.40.16]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MA88C-1fzVLJ32HS-00Bf2S; Tue, 09 Oct 2018 17:57:59 +0200
Received: from wuerfel.lan ([109.193.40.16]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MA88C-1fzVLJ32HS-00Bf2S; Tue, 09 Oct 2018 17:57:59 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qtnfmac: avoid uninitialized variable access
Date:   Tue,  9 Oct 2018 17:57:35 +0200
Message-Id: <20181009155757.494212-1-arnd@arndb.de>
X-Mailer: git-send-email 2.18.0
X-Provags-ID: V03:K1:Xax1BOyVDSS/I6d+mxoxQgcdDQz5f+hcrKd/pDuDVWrpsoIp7bq
 ROicNzkQdIG+sypFTyswVlV4jds99I+dfS27N2vqq9iN+Extm5sNg1q+90HvaR8MT26dnJY
 EP9orhI5sseScpXK05Ecowgj4/5uOt2jpvBKc/NWpWSYIUm1GqiKp8EB/MCVktBJd81eIto
 zYVOmLQrFwj7ORhLAynIA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:QcTAjmk3cIQ=:2pdHry2WAzRiytm4ZY09Ob
 e2dZ5NcKYOGaP0bCq07jEJroWBSC5/8k3crJl6Z+4Vqw4zAhk/VeQ9+k25ey8HmhPBRDClon2
 UxEuEgNYV4NU+UVElmoy4oZ3NU3Gr4jnh46RHfu/YkuWVmFBw/GeFWhL9xc93xJvYxTJKtC18
 SbsrMFSp+083AWnlBDcpSYNmUUD5b7WYmIA0/kJFRAXoGkn5gYiqZZPF+uoIADek7GdK9ZK/x
 6cw3s8WwlvGbf9UsrcLoBrMn4yaE7bHzrhkU6zsD/fYAKluaoJxcGeZDY/ocpnhG59kbaqeNV
 xNTYDJPGDKfzt2vaZ72tJM7Zhb5saBFoJ6w6TMj9QPIIxP4F1OiUtq77tZGRmsHIAAYiNN/95
 q9wBp/nZ/uykld45UY53Fvzl0SwZDpHanFwBOzswSA2a2e+xUuqr5XqM0j8RDSu6uHXLiLxpm
 GEYihj2aEqMXQqb2/Mz8902mDzoqqScF9xImh9cEyVp9VS53/nn/zkp+SNSFbq3aiHKGpvupg
 kefD25F7gDcY3BbqUIJ8HboW20fuzY1H5/C/M/Bi8/Qw+pXytK2lkIC8XMuL3vmWR9+wXjqP9
 HpsQk8pUYJZWituCHA3oQd/jWmvZd8YFHZu4wdSBDL2abZlH+JgqhDIP3+cjJHWKL0u5WunOa
 CVHx4yajpzLJYrWH2sA6BUbdMBaE+vyrIBz9PZg451c2PPZR4mnJ5CqfNpW5hLk0T/Ec=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When qtnf_trans_send_cmd_with_resp() fails, we have not yet initialized
'resp', as pointed out by a valid gcc warning:

drivers/net/wireless/quantenna/qtnfmac/commands.c: In function 'qtnf_cmd_send_with_reply':
drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error: 'resp' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Since 'resp_skb' is also not set here, we can skip all further
processing and just print the warning and return the failure code.

Fixes: c6ed298ffe09 ("qtnfmac: cleanup and unify command error handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index bfdc1ad30c13..9b211459684a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -111,7 +111,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 
 	ret = qtnf_trans_send_cmd_with_resp(bus, cmd_skb, &resp_skb);
 	if (ret)
-		goto out;
+		goto out_noresp;
 
 	resp = (const struct qlink_resp *)resp_skb->data;
 	ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
@@ -132,6 +132,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	if (!ret && resp)
 		return qtnf_cmd_resp_result_decode(le16_to_cpu(resp->result));
 
+out_noresp:
 	pr_warn("VIF%u.%u: cmd 0x%.4X failed: %d\n",
 		mac_id, vif_id, le16_to_cpu(cmd->cmd_id), ret);
 
-- 
2.18.0

