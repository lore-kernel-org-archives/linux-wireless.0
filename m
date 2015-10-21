Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35760 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbbJUMCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:02:52 -0400
Received: by pasz6 with SMTP id z6so53419271pas.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 05:02:52 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: Fix segfault when no args are given to offchannel
Date: Wed, 21 Oct 2015 14:02:24 +0200
Message-Id: <1445428944-21589-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_140255_942480_2159A928)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The offchannel command assumes that frequency and duration
are given as arguments, otherwise iw segfaults - fix that
by printing help text instead.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 offch.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/offch.c b/offch.c
index 49b101a..04bf4c6 100644
--- a/offch.c
+++ b/offch.c
@@ -15,6 +15,10 @@ static int offchannel(struct nl80211_state *state,
 {
 	char *end;
 
+	if (argc < 2) {
+		return 1;
+	}
+
 	/* freq */
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
 		    strtoul(argv[0], &end, 10));
-- 
1.7.9.5

