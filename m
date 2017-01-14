Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35607 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdANCRK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 21:17:10 -0500
Received: by mail-io0-f174.google.com with SMTP id j18so57305788ioe.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 18:17:10 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: don't complain about 'unknown event id: 0x63'
Date: Fri, 13 Jan 2017 18:16:57 -0800
Message-Id: <20170114021657.147016-1-briannorris@chromium.org> (sfid-20170114_031746_708511_0C2766D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marvell folks tell me this is a debugging event that the driver doesn't
need to handle, but on 8997 w/ firmware 16.68.1.p97, I see several of
these sorts of messages at (for instance) boot time:

[   13.825848] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
[   14.838561] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
[   14.850397] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
[   32.529923] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63

Let's handle this "event" with a much lower verbosity.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h        | 1 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 55db158fd156..cb6a1a81d44e 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -550,6 +550,7 @@ enum mwifiex_channel_flags {
 #define EVENT_TX_DATA_PAUSE             0x00000055
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_RXBA_SYNC                 0x00000059
+#define EVENT_UNKNOWN_DEBUG             0x00000063
 #define EVENT_BG_SCAN_STOPPED           0x00000065
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 #define EVENT_MULTI_CHAN_INFO           0x0000006a
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 9df0c4dc06ed..96503d3d053f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -1009,6 +1009,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					    adapter->event_skb->len -
 					    sizeof(eventcause));
 		break;
+	/* Debugging event; not used, but let's not print an ERROR for it. */
+	case EVENT_UNKNOWN_DEBUG:
+		mwifiex_dbg(adapter, EVENT, "event: debug\n");
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR, "event: unknown event id: %#x\n",
 			    eventcause);
-- 
2.11.0.483.g087da7b7c-goog
