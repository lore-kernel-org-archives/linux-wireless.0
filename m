Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1JLBCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:55 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:55 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 12 Oct 2011 03:02:52 +0200
Subject: [RFC 07/07] mac80211: Do not call release_buffered_frames if not
 available.
To: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27ru2maya27un@edmitar> (sfid-20111012_030258_417331_5CE804F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Date: Wed, 5 Oct 2011 13:20:04 +0200

A new .release_buffered_frames callback was introduced recently.
Check for the callback presence was missing in the mac80211 code,
and PM state could get broken in some cases.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
  net/mac80211/sta_info.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 58b1c2b..ff30fe3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1262,7 +1262,9 @@ ieee80211_sta_ps_deliver_response(struct sta_info  
*sta,
  		tids = ieee80211_tids_for_ac(ac);

  		if (!found) {
-			driver_release_tids = sta->driver_buffered_tids & tids;
+			if (local->ops->release_buffered_frames)
+				driver_release_tids =
+					sta->driver_buffered_tids & tids;
  			if (driver_release_tids) {
  				found = true;
  			} else {
-- 
1.7.1
