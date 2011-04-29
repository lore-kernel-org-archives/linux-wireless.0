Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49318 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760563Ab1D2TPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:15:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Bing Zhao <bzhao@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwifiex: fix copy-n-paste 'thinko' for tsf_val
Date: Fri, 29 Apr 2011 15:07:47 -0400
Message-Id: <1304104067-29124-1-git-send-email-linville@tuxdriver.com> (sfid-20110429_211552_076377_0525C264)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/mwifiex/join.o
drivers/net/wireless/mwifiex/join.c: In function ‘mwifiex_cmd_802_11_associate’:
drivers/net/wireless/mwifiex/join.c:119:8: warning: ‘tsf_val’ may be used uninitialized in this function
drivers/net/wireless/mwifiex/join.c:103:12: note: ‘tsf_val’ was declared here

Looks like a copy-n-paste error, identical lines are a few lines below
the ones removed, with an actual memcpy to tsf_val in between...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/join.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 23d2d0b..042eb77 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -116,9 +116,6 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 	memcpy(*buffer, &tsf_tlv, sizeof(tsf_tlv.header));
 	*buffer += sizeof(tsf_tlv.header);
 
-	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
-	*buffer += sizeof(tsf_val);
-
 	memcpy(&tsf_val, bss_desc->time_stamp, sizeof(tsf_val));
 
 	dev_dbg(priv->adapter->dev, "info: %s: TSF offset calc: %016llx - "
-- 
1.7.4.4

