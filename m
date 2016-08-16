Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcHPMLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 08:11:21 -0400
From: Colin King <colin.king@canonical.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: fix missing break on IEEE80211_STYPE_ACTION case
Date: Tue, 16 Aug 2016 13:10:13 +0100
Message-Id: <1471349413-21893-1-git-send-email-colin.king@canonical.com> (sfid-20160816_141143_653719_0DEB0D06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The IEEE80211_STYPE_ACTION case is missing a break in the switch
statement, causing it to fall through to the default case that
reports a debug message about an unknown frame subtype. Fix this
by adding in the missing break statement.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 6681be0..18fbb96 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -386,6 +386,7 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 				    "unknown public action frame category %d\n",
 				    category);
 		}
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, INFO,
 		    "unknown mgmt frame subtype %#x\n", stype);
-- 
2.8.1
