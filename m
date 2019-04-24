Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1318EC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 09:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1DA32148D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 09:52:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GqThel/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfDXJwi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 05:52:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48310 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfDXJwh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 05:52:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3O9nUP3031264;
        Wed, 24 Apr 2019 09:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=9xUAQynxxcopPBpkyEnnXya3Rm/3GMgYNaN5Wfhwjy0=;
 b=GqThel/ZcjVtCCnNvnmEKKru9v/DL+7TZmc6FUNvrdyDyC48wh+39aCC30844d8jMqd/
 K9mkeW/mfrBNplPd9pcqUkQiYI767P8kiJMfpcEwketYa5ueUT7KG06wHIXcDam+snjw
 67RbYqw2JtFYUpvJsc8W1tPF/a7IEEWpr3j2vSv5bmXbZ2yQBztwR1NQu+2dwlkCcxfJ
 0eBe+Csq0NdjgjVeyndGOJvA/FcpeGLkHo1JwdqPVCewvWvie53OAqTjtXuCSRmAepql
 Uzn8CfLo6Psy0wb/a9OXTdTO0HozJmf4XGY4/fUNVh4RlklgtG0zT0fe6VixNIL8aN5l /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2ryrxd1fnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 09:52:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3O9qRhO161590;
        Wed, 24 Apr 2019 09:52:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s0f0w084q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 09:52:30 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3O9qTeW002902;
        Wed, 24 Apr 2019 09:52:29 GMT
Received: from mwanda (/105.55.12.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Apr 2019 02:52:28 -0700
Date:   Wed, 24 Apr 2019 12:52:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, kernel-janitors@vger.kernel.org
Subject: [PATCH] brcm80211: potential NULL dereference in
 brcmf_cfg80211_vndr_cmds_dcmd_handler()
Message-ID: <20190424095218.GB16450@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904240083
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904240083
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If "ret_len" is negative then it could lead to a NULL dereference.

The "ret_len" value comes from nl80211_vendor_cmd(), if it's negative
then we don't allocate the "dcmd_buf" buffer.  Then we pass "ret_len" to
brcmf_fil_cmd_data_set() where it is cast to a very high u32 value.
Most of the functions in that call tree check whether the buffer we pass
is NULL but there are at least a couple places which don't such as
brcmf_dbg_hex_dump() and brcmf_msgbuf_query_dcmd().  We memcpy() to and
from the buffer so it would result in a NULL dereference.

The fix is to change the types so that "ret_len" can't be negative.  (If
we memcpy() zero bytes to NULL, that's a no-op and doesn't cause an
issue).

Fixes: 1bacb0487d0e ("brcmfmac: replace cfg80211 testmode with vendor command")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
index 8eff2753abad..d493021f6031 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
@@ -35,9 +35,10 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	struct brcmf_if *ifp;
 	const struct brcmf_vndr_dcmd_hdr *cmdhdr = data;
 	struct sk_buff *reply;
-	int ret, payload, ret_len;
+	unsigned int payload, ret_len;
 	void *dcmd_buf = NULL, *wr_pointer;
 	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
+	int ret;
 
 	if (len < sizeof(*cmdhdr)) {
 		brcmf_err("vendor command too short: %d\n", len);
@@ -65,7 +66,7 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 			brcmf_err("oversize return buffer %d\n", ret_len);
 			ret_len = BRCMF_DCMD_MAXLEN;
 		}
-		payload = max(ret_len, len) + 1;
+		payload = max_t(unsigned int, ret_len, len) + 1;
 		dcmd_buf = vzalloc(payload);
 		if (NULL == dcmd_buf)
 			return -ENOMEM;
-- 
2.18.0

