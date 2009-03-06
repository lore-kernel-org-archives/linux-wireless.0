Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:38020 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZCFI5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 03:57:43 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: fix compile error in debug.c
Date: Fri,  6 Mar 2009 09:57:39 +0100
Message-Id: <1236329859-17911-3-git-send-email-juhosg@openwrt.org> (sfid-20090306_095748_502704_A33739A3)
In-Reply-To: <1236329859-17911-1-git-send-email-juhosg@openwrt.org>
References: <1236329859-17911-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath9k/debug.c: In function 'read_file_wiphy':
drivers/net/wireless/ath9k/debug.c:377: error: implicit declaration of
function 'put_unaligned_le32'
drivers/net/wireless/ath9k/debug.c:378: error: implicit declaration of
function 'put_unaligned_le16'

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath9k/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 8d91422..bce6476 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -14,6 +14,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/unaligned.h>
+
 #include "ath9k.h"
 
 static unsigned int ath9k_debug = DBG_DEFAULT;
-- 
1.5.3.2

