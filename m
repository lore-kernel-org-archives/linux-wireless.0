Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33723 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdCDP6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 10:58:15 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, outreachy-kernel@googlegroups.com,
        kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 1/6] staging: speakup: fixes braces {} should be used on all arms of this statement
Date: Sat,  4 Mar 2017 21:27:35 +0530
Message-Id: <20170304155740.26105-2-arushisinghal19971997@gmail.com> (sfid-20170304_165908_919554_9383F7B0)
In-Reply-To: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
References: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checks reported by checkpatch.pl
for braces {} should be used on all arms of this statement.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/speakup/main.c           |  3 ++-
 drivers/staging/speakup/speakup_decext.c |  6 +++---
 drivers/staging/speakup/speakup_decpc.c  |  6 +++---
 drivers/staging/speakup/speakup_dectlk.c |  6 +++---
 drivers/staging/speakup/varhandlers.c    | 12 +++++++-----
 5 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index a3daf4ae5c0a..47cea629ba0b 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -408,8 +408,9 @@ static void say_attributes(struct vc_data *vc)
 	if (bg > 7) {
 		synth_printf(" %s ", spk_msg_get(MSG_ON_BLINKING));
 		bg -= 8;
-	} else
+	} else {
 		synth_printf(" %s ", spk_msg_get(MSG_ON));
+	}
 	synth_printf("%s\n", spk_msg_get(MSG_COLORS_START + bg));
 }
 
diff --git a/drivers/staging/speakup/speakup_decext.c b/drivers/staging/speakup/speakup_decext.c
index 5f9f3a7543db..6ebd56e07e71 100644
--- a/drivers/staging/speakup/speakup_decext.c
+++ b/drivers/staging/speakup/speakup_decext.c
@@ -193,11 +193,11 @@ static void do_catch_up(struct spk_synth *synth)
 		spin_lock_irqsave(&speakup_info.spinlock, flags);
 		synth_buffer_getc();
 		spin_unlock_irqrestore(&speakup_info.spinlock, flags);
-		if (ch == '[')
+		if (ch == '[') {
 			in_escape = 1;
-		else if (ch == ']')
+		} else if (ch == ']') {
 			in_escape = 0;
-		else if (ch <= SPACE) {
+		} else if (ch <= SPACE) {
 			if (!in_escape && strchr(",.!?;:", last))
 				spk_serial_out(PROCSPEECH);
 			if (time_after_eq(jiffies, jiff_max)) {
diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index 600eb057f830..dc860c4b8279 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -410,11 +410,11 @@ static void do_catch_up(struct spk_synth *synth)
 		spin_lock_irqsave(&speakup_info.spinlock, flags);
 		synth_buffer_getc();
 		spin_unlock_irqrestore(&speakup_info.spinlock, flags);
-		if (ch == '[')
+		if (ch == '[') {
 			in_escape = 1;
-		else if (ch == ']')
+		} else if (ch == ']') {
 			in_escape = 0;
-		else if (ch <= SPACE) {
+		} else if (ch <= SPACE) {
 			if (!in_escape && strchr(",.!?;:", last))
 				dt_sendchar(PROCSPEECH);
 			if (time_after_eq(jiffies, jiff_max)) {
diff --git a/drivers/staging/speakup/speakup_dectlk.c b/drivers/staging/speakup/speakup_dectlk.c
index 26036050cdb2..2429232ee649 100644
--- a/drivers/staging/speakup/speakup_dectlk.c
+++ b/drivers/staging/speakup/speakup_dectlk.c
@@ -258,11 +258,11 @@ static void do_catch_up(struct spk_synth *synth)
 		spin_lock_irqsave(&speakup_info.spinlock, flags);
 		synth_buffer_getc();
 		spin_unlock_irqrestore(&speakup_info.spinlock, flags);
-		if (ch == '[')
+		if (ch == '[') {
 			in_escape = 1;
-		else if (ch == ']')
+		} else if (ch == ']') {
 			in_escape = 0;
-		else if (ch <= SPACE) {
+		} else if (ch <= SPACE) {
 			if (!in_escape && strchr(",.!?;:", last))
 				spk_serial_out(PROCSPEECH);
 			if (time_after_eq(jiffies, jiff_max)) {
diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index 5910fe0b1365..d37d24e26641 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -258,10 +258,11 @@ int spk_set_string_var(const char *page, struct st_var_header *var, int len)
 		if (var->p_val != var_data->u.s.default_val)
 			strcpy((char *)var->p_val, var_data->u.s.default_val);
 		return -ERESTART;
-	} else if (var->p_val)
+	} else if (var->p_val) {
 		strcpy((char *)var->p_val, page);
-	else
+	} else {
 		return -E2BIG;
+	}
 	return 0;
 }
 
@@ -281,17 +282,18 @@ int spk_set_mask_bits(const char *input, const int which, const int how)
 			spk_chartab[*cp] &= ~mask;
 	}
 	cp = (u_char *)input;
-	if (!cp)
+	if (!cp) {
 		cp = spk_punc_info[which].value;
-	else {
+	} else {
 		for (; *cp; cp++) {
 			if (*cp < SPACE)
 				break;
 			if (mask < PUNC) {
 				if (!(spk_chartab[*cp] & PUNC))
 					break;
-			} else if (spk_chartab[*cp] & B_NUM)
+			} else if (spk_chartab[*cp] & B_NUM) {
 				break;
+			}
 		}
 		if (*cp)
 			return -EINVAL;
-- 
2.11.0
