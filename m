Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:51629 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750892AbdGGMBh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 08:01:37 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcmfmac: fix possible buffer overflow in brcmf_cfg80211_mgmt_tx()
Date: Fri,  7 Jul 2017 13:01:33 +0100
Message-Id: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170707_140140_467929_3104918C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lower level nl80211 code in cfg80211 ensures that "len" is between
25 and NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) from
"len" so thats's max of 2280.  However, the action_frame->data[] buffer is
only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
overflow.

	memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
	       le16_to_cpu(action_frame->len));

Reported-by: "freenerguo(郭大兴)" <freenerguo@tencent.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

Here is the patch as Linus send it to us and security@kernel.org. I
removed the lower bound check as that is already done in cfg80211.
Now I signed off on the patch although formally I suppose Linus should
sign it off. Putting it out there so people can respond as deemed
necessary.

Now fingers crossed whether patchwork will properly deal with the UTF-8
characters :-p

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index cd1d673..d182a00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4851,6 +4851,11 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
 					GFP_KERNEL);
 	} else if (ieee80211_is_action(mgmt->frame_control)) {
+		if (len > BRCMF_FIL_ACTION_FRAME_SIZE + DOT11_MGMT_HDR_LEN) {
+			brcmf_err("invalid action frame length\n");
+			err = -EINVAL;
+			goto exit;
+		}
 		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
 		if (af_params == NULL) {
 			brcmf_err("unable to allocate frame\n");
-- 
1.9.1
