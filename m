Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0KJCVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:50 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:49 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 33/44] compat/2.6.22: constify skb_transport_header()'s argument
Date: Tue,  9 Nov 2010 21:20:15 -0500
Message-Id: <1289355626-25373-34-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.22.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 6675027..7c0c615 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -46,7 +46,7 @@ static inline void skb_set_transport_header(struct sk_buff *skb, int offset)
 	skb->h.raw = skb->data + offset;
 }
 
-static inline unsigned char *skb_transport_header(struct sk_buff *skb)
+static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
 {
 	return skb->h.raw;
 }
-- 
1.7.2.30.gc37d7.dirty

