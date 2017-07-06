Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17938 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdGFInE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 04:43:04 -0400
Date: Thu, 6 Jul 2017 11:41:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, security@kernel.org
Subject: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
Message-ID: <20170706084134.zlwazczcvkxaxv4b@mwanda> (sfid-20170706_104308_838943_A81CB5B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <76EE61108481FC4BBFFF404FA986AA6719B8EA26@EXMBX-TJ001.tencent.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lower level networking code ensures that "len" is between 25 and
NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) from
"len" so thats's max of 2280.  But the action_frame->data[] buffer is
only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
overflow.

	memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
	       le16_to_cpu(action_frame->len));

Reported-by: "freenerguo(郭大兴)" <freenerguo@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index dcde596c9eb9..bdae7b44a5ec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4934,6 +4934,11 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
 					GFP_KERNEL);
 	} else if (ieee80211_is_action(mgmt->frame_control)) {
+		if (len > sizeof(action_frame->data) + DOT11_MGMT_HDR_LEN) {
+			err = -EINVAL;
+			goto exit;
+		}
+
 		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
 		if (af_params == NULL) {
 			brcmf_err("unable to allocate frame\n");
