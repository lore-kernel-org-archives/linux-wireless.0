Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44210 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2JOJJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 05:09:27 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so3290437lbo.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2012 02:09:25 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	linuxkbugs@vittgam.net,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()
Date: Mon, 15 Oct 2012 14:14:32 +0000
Message-Id: <1350310472-602-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20121015_110930_565732_0CFEA48E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver does not count space of radiotap fields when allocating skb for
radiotap packet. This leads to kernel panic with the following call trace:

...
[67607.676067] [<c152f90f>] error_code+0x67/0x6c
[67607.676067] [<c142f831>] ? skb_put+0x91/0xa0
[67607.676067] [<f8cf5e5b>] ? ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2200]
[67607.676067] [<f8cf5e5b>] ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2200]
[67607.676067] [<f8cf899b>] ipw_net_hard_start_xmit+0x8b/0x90 [ipw2200]
[67607.676067] [<f8741c5a>] libipw_xmit+0x55a/0x980 [libipw]
[67607.676067] [<c143d3e8>] dev_hard_start_xmit+0x218/0x4d0
...

This bug was found by VittGam.
https://bugzilla.kernel.org/show_bug.cgi?id=43255

Cc: stable@kernel.org
Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 935120f..768bf61 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -10472,7 +10472,7 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 		} else
 			len = src->len;
 
-		dst = alloc_skb(len + sizeof(*rt_hdr), GFP_ATOMIC);
+		dst = alloc_skb(len + sizeof(*rt_hdr) + sizeof(u16)*2, GFP_ATOMIC);
 		if (!dst)
 			continue;
 
-- 
1.7.11.7

