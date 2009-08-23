Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:58104 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002AbZHWQwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 12:52:21 -0400
Received: by pzk32 with SMTP id 32so575266pzk.33
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2009 09:52:22 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 23 Aug 2009 22:22:22 +0530
Message-ID: <1fe543780908230952v5738f6bck943627d0de6c1383@mail.gmail.com>
Subject: [PATCH] libertas: add NULL check on return value of get_zeroed_page
From: Kiran Divekar <kirandivekar@gmail.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From fb132b536facfbdc47a24afe538c50662d16b3ad Mon Sep 17 00:00:00 2001
From: Kiran Divekar <kirandivekar@gmail.com>
Date: Sun, 23 Aug 2009 22:05:21 +0530
Subject: [PATCH] add NULL check on return value of get_zeroed_page

Most of the places in debugfs.c are missing a NULL check on the return value of
get_zeroed_page API call. Added required NULL check at appropriate places.

Signed-off-by: Kiran Divekar <kirandivekar@gmail.com>
---
 drivers/net/wireless/libertas/debugfs.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c
b/drivers/net/wireless/libertas/debugfs.c
index 811ffc3..893a55c 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -45,6 +45,8 @@ static ssize_t lbs_dev_info(struct file *file, char
__user *userbuf,
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
        ssize_t res;
+       if (!buf)
+               return -ENOMEM;

        pos += snprintf(buf+pos, len-pos, "state = %s\n",
                                szStates[priv->connect_status]);
@@ -68,6 +70,8 @@ static ssize_t lbs_getscantable(struct file *file,
char __user *userbuf,
        char *buf = (char *)addr;
        DECLARE_SSID_BUF(ssid);
        struct bss_descriptor * iter_bss;
+       if (!buf)
+               return -ENOMEM;

        pos += snprintf(buf+pos, len-pos,
                "# | ch  | rssi |       bssid       |   cap    | Qual
| SSID \n");
@@ -110,6 +114,8 @@ static ssize_t lbs_sleepparams_write(struct file *file,
        int p1, p2, p3, p4, p5, p6;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, user_buf, buf_size)) {
@@ -148,6 +154,8 @@ static ssize_t lbs_sleepparams_read(struct file
*file, char __user *userbuf,
        struct sleep_params sp;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        ret = lbs_cmd_802_11_sleep_params(priv, CMD_ACT_GET, &sp);
        if (ret)
@@ -433,6 +441,8 @@ static ssize_t lbs_rdmac_read(struct file *file,
char __user *userbuf,
        int ret;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        offval.offset = priv->mac_offset;
        offval.value = 0;
@@ -457,6 +467,8 @@ static ssize_t lbs_rdmac_write(struct file *file,
        ssize_t res, buf_size;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, userbuf, buf_size)) {
@@ -481,6 +493,8 @@ static ssize_t lbs_wrmac_write(struct file *file,
        struct lbs_offset_value offval;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, userbuf, buf_size)) {
@@ -515,6 +529,8 @@ static ssize_t lbs_rdbbp_read(struct file *file,
char __user *userbuf,
        int ret;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        offval.offset = priv->bbp_offset;
        offval.value = 0;
@@ -540,6 +556,8 @@ static ssize_t lbs_rdbbp_write(struct file *file,
        ssize_t res, buf_size;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, userbuf, buf_size)) {
@@ -564,6 +582,8 @@ static ssize_t lbs_wrbbp_write(struct file *file,
        struct lbs_offset_value offval;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, userbuf, buf_size)) {
@@ -598,6 +618,8 @@ static ssize_t lbs_rdrf_read(struct file *file,
char __user *userbuf,
        int ret;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        offval.offset = priv->rf_offset;
        offval.value = 0;
@@ -623,6 +645,8 @@ static ssize_t lbs_rdrf_write(struct file *file,
        ssize_t res, buf_size;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, userbuf, buf_size)) {
@@ -647,6 +671,8 @@ static ssize_t lbs_wrrf_write(struct file *file,
        struct lbs_offset_value offval;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        buf_size = min(count, len - 1);
        if (copy_from_user(buf, userbuf, buf_size)) {
@@ -853,6 +879,8 @@ static ssize_t lbs_debugfs_read(struct file *file,
char __user *userbuf,
        struct debug_data *d;
        unsigned long addr = get_zeroed_page(GFP_KERNEL);
        char *buf = (char *)addr;
+       if (!buf)
+               return -ENOMEM;

        p = buf;

--
1.5.3.4

-----
-Kiran Divekar.
http://www.geeksofpune.org/
http://www.geocities.com/kirandivekar/
