Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab0KJCVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:38 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:37 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 30/44] compat/2.6.22: nuke pci_{clear,set}_mwi()
Date: Tue,  9 Nov 2010 21:20:12 -0500
Message-Id: <1289355626-25373-31-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All 2.6 kernel have had them.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.22.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 174a269..e0cdab2 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -96,15 +96,6 @@ static inline void skb_copy_from_linear_data_offset(const struct sk_buff *skb,
 /* This will lead to very weird behaviour... */
 #define NLA_BINARY NLA_STRING
 
-static inline int pci_set_mwi(struct pci_dev *dev)
-{
-	return -ENOSYS;
-}
-
-static inline void pci_clear_mwi(struct pci_dev *dev)
-{
-}
-
 #define list_first_entry(ptr, type, member) \
         list_entry((ptr)->next, type, member)
 
-- 
1.7.2.30.gc37d7.dirty

