Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34112 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1LSVZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:33 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 10/15] initvals: fix type of the second argument of 'main'
Date: Mon, 19 Dec 2011 22:24:55 +0100
Message-Id: <1324329900-3923-11-git-send-email-juhosg@openwrt.org> (sfid-20111219_222543_095229_7750C2EC)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the followinf warning
(with CFLAGS=-Wmain):

initvals.c:673: warning: second argument of ‘main’ should be ‘char **’

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index 1908986..32a38f6 100644
--- a/initvals.c
+++ b/initvals.c
@@ -669,7 +669,7 @@ print_initvals_family(char *family, bool check)
 	}
 }
 
-int main(int argc, void *argv[])
+int main(int argc, char *argv[])
 {
 
 	if (argc > 1) {
-- 
1.7.2.1

