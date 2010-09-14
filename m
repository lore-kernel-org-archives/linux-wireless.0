Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34831 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0INViJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 17:38:09 -0400
Received: by bwz11 with SMTP id 11so5978484bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 14:38:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: use generic_file_llseek in debugfs
Date: Tue, 14 Sep 2010 23:38:03 +0200
Cc: Arnd Bergmann <arnd@arndb.de>,
	"John W. Linville" <linville@tuxdriver.com>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de> <1284495763-7506-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1284495763-7506-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201009142338.04104.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 September 2010 22:22:30 Arnd Bergmann wrote:
> The default llseek operation is changing from
> default_llseek to no_llseek, so all code relying on
> the current behaviour needs to make that explicit.
> 
> All these files use debugfs and they typically rely
> on simple_read_from_buffer, so the best llseek operation
> here is generic_file_llseek.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 3e9b0e8..6559381 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -181,6 +181,7 @@ static const struct carl9170_debugfs_fops carl_debugfs_##name ##_ops = {\
 		.open	= carl9170_debugfs_open,			\
 		.read	= carl9170_debugfs_read,			\
 		.write	= carl9170_debugfs_write,			\
+		.llseek = generic_file_llseek,				\
 		.owner	= THIS_MODULE					\
 	},								\
 }
