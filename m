Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35600 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbJIOxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 10:53:51 -0400
Received: by lbwr8 with SMTP id r8so82993221lbw.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2015 07:53:48 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: Fix memory leak in error path
Date: Fri,  9 Oct 2015 16:52:42 +0200
Message-Id: <1444402362-12796-1-git-send-email-ola1olsson@gmail.com> (sfid-20151009_165354_451440_F39EFC29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The leak is present if malloc fails after requesting
a scan with ies or meshid as input.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scan.c b/scan.c
index 8197679..d3c7d98 100644
--- a/scan.c
+++ b/scan.c
@@ -446,8 +446,11 @@ static int handle_scan(struct nl80211_state *state,
 
 	if (ies || meshid) {
 		tmpies = (unsigned char *) malloc(ies_len + meshid_len);
-		if (!tmpies)
+		if (!tmpies) {
+			free(ies);
+			free(meshid);
 			goto nla_put_failure;
+		}
 		if (ies) {
 			memcpy(tmpies, ies, ies_len);
 			free(ies);
-- 
1.7.9.5

