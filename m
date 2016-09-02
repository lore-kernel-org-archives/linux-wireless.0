Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:36695 "EHLO
        srv-hp10.netsons.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753564AbcIBM6O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 08:58:14 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: devel@driverdev.osuosl.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] rtl8723au: remove declaration of unimplemented functions
Date: Fri,  2 Sep 2016 14:57:44 +0200
Message-Id: <1472821069-5437-1-git-send-email-luca@lucaceresoli.net> (sfid-20160902_145943_198376_2B3A10D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions have been declared without any implementation since
the first commit (364e30ebd2dbaccba430c603da03e68746eb932a) and there
has been no mention of them in following commits.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org

---

Changes v1 -> v2:
- improve the commit message.
---
 drivers/staging/rtl8723au/include/recv_osdep.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/recv_osdep.h b/drivers/staging/rtl8723au/include/recv_osdep.h
index c2d3f1b..c159dbc 100644
--- a/drivers/staging/rtl8723au/include/recv_osdep.h
+++ b/drivers/staging/rtl8723au/include/recv_osdep.h
@@ -26,9 +26,6 @@ int rtw_recv_indicatepkt23a(struct rtw_adapter *adapter, struct recv_frame *prec
 
 void rtw_handle_tkip_mic_err23a(struct rtw_adapter *padapter, u8 bgroup);
 
-int	rtw_init_recv_priv(struct recv_priv *precvpriv, struct rtw_adapter *padapter);
-void rtw_free_recv_priv (struct recv_priv *precvpriv);
-
 int rtw_os_recv_resource_init(struct recv_priv *precvpriv, struct rtw_adapter *padapter);
 
 void rtw_init_recv_timer23a(struct recv_reorder_ctrl *preorder_ctrl);
-- 
2.7.4
