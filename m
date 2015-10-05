Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35272 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbbJEMSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 08:18:07 -0400
Received: by wicge5 with SMTP id ge5so117767798wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 05:18:06 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 5 Oct 2015 14:18:06 +0200
Message-ID: <CABAco3ChfKw6NuMLS7_gp2JOJ0adnrufmF_oQHqspJM97YU4Sg@mail.gmail.com> (sfid-20151005_141812_127764_3C10D314)
Subject: [PATCH] iw: use correct "MHz" instead of "MHZ"
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the last MHZ to MHz.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 ocb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ocb.c b/ocb.c
index fc48ecf..c60591c 100644
--- a/ocb.c
+++ b/ocb.c
@@ -18,9 +18,9 @@ static int join_ocb(struct nl80211_state *state,
                const char *name;
                unsigned int width;
        } *chanmode_selected, chanmode[] = {
-               { .name = "5MHZ",
+               { .name = "5MHz",
                  .width = NL80211_CHAN_WIDTH_5 },
-               { .name = "10MHZ",
+               { .name = "10MHz",
                  .width = NL80211_CHAN_WIDTH_10 },
        };

@@ -59,7 +59,7 @@ static int join_ocb(struct nl80211_state *state,
 nla_put_failure:
        return -ENOBUFS;
 }
-COMMAND(ocb, join, "<freq in MHz> <5MHZ|10MHZ>",
+COMMAND(ocb, join, "<freq in MHz> <5MHz|10MHz>",
        NL80211_CMD_JOIN_OCB, 0, CIB_NETDEV, join_ocb,
        "Join the OCB mode network.");

-- 
1.7.9.5
