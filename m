Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1E337647B
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 19:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203711; cv=none; b=A8Glcz8etVXa3R22pNScNNr01tBf7ZHZ1DIc4LaIuc1O8FeNCiiOfxrY/zPMUvz447tqsXqgyns0h6QUs9bJYfVJSbqAdk5McxDTwOVDk30+47euR8pkpEUytKu8zY2J8Mf+SqyMf/75l0HbtLHmQjpHSY+f3isVW679wYKATnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203711; c=relaxed/simple;
	bh=Z7kFPgQ88Wv2Xf8E4x/R5vvxXua56XhG0Lj1CxJOuUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L+CgCOmyZkMCKucZyYLSlTZIe+K91Y7Dz8kbVpleb6U8T9uiG8Ru2PB+odjXqeZKBM4BU0qIVwwgxVN5RCfY0xLQl+MEn/IpxrCEVD8dVZQCHGFJ2HmfK0zshR22EU9l3M4E/tr4lwygzYH+BF2duuNc84TYlXTQoFwklxsx+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ea9HuC5P; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ea9HuC5P"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39266382df6so3282592a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 12:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788203709; x=1788808509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1yjLc9wE+XWjLLJII/RbL4oTPqzzDgXzF/PpO/HPdQ=;
        b=Ea9HuC5PzmRwm5Nai15zSaxspwUNEZtcMtQ6ihkINKeZIn6BHLCVixZQ+Vywxhyg4G
         D2EHvafQOXq5QcJ1aoKigD8fwWthAPvIr2IJCgmohPRf4LS6wJA1l3p6c70WHE1Z9yPl
         VYc9sYTP8MExddqq8lLnJ2xDXQnoCXlPy83H+hW0ipEzNTlbioUTzSpnXAsQxjR6QuIe
         VVW1bM6Ea69W7c6dz7c0ZiHjrTU/0TnhMprEBwWnhYWYESh/ZrpwSFti2fgh1orl1nHl
         zDGyALKwRuPKarEeEm0fKYaUMIk/fBhOYrFAsGck/TqeRveJp0M2tmBHN1kK0OPj9QQ9
         Mlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788203709; x=1788808509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1yjLc9wE+XWjLLJII/RbL4oTPqzzDgXzF/PpO/HPdQ=;
        b=RgmOf9LZhzQM46tgbxy6B+MjGrvHlbjAfi+75moAjKeZwI13gZvXEYgrXOi6dYerMG
         aE4U+M0HxetbXAhSXJ1YkajDomejxZKt+uF0N82p016cEdsfWVBNvNZJAESjqsH8RFJN
         P93gruAK5XgyOwkFJq1vlUcrGRgQZAaHvmIsgGYHFjeMXF7oVj20XP2hDXbc0ra3FYHi
         fZL7v6i4REG+BRZCUsZHvty0SOwrCN+GvH4vZtLxvq0Qcl+bdTeWV8GVV5wUnHXg6Kh/
         INmkp/VRLSAfHqP3sbfxXqrpi5TmKNvcOOy+QscAw9IKnaPFbTl8KhdX24W9rUC1qeOT
         Sfyg==
X-Gm-Message-State: AFuF++lZndB19Q6vwJMqfWbAoquErXxR8xO+cKRkYdG9iTEXItlt0NQ7
	6cRv98XM+zakEO2JzVNsSvoyrUCowAuqIK9C/uzzInMCxWKoMXqk7O8W
X-Gm-Gg: AYBFou1EfNq1xdnIHt1wKn2NIyPTmy3EkmdnZZ128V2eNyzdD5nU6hmeAIT+FwuAOJA
	VXXnzk1wvWRhm8Mm9kwtJqms+q3VA9xjcquDKHfu7T7SQLN/ZsWU6L35onoeziKRYovJtIXcf4c
	Wdef/s5ADbLVhTYCSgPIaIyKH8/2AdG7RVh8+0cVbhMH8tM0a1FyGtNc6sKeM+y0Hob5I3f9+NM
	3sCoMkK2n5ZHcmvYReAWdJ2ygne4tKAeRmhOi/QskYsmhEitWnIOlo+pP6udew479+JFKWIQnSY
	ku9/CK/VWeuy7mC8Bv1ohKuNwmN/1Kb28ZIqbNbnl7Os8gO34hDGD2F/w3iFJs1R3FMG4PmwVN3
	COrszW6Wlq21TD8C9xZn4JzWCEWE83Xj4dg0L3EBOtLqoXX2tV8nt0lanRXCU1NdnWjXK0Baw4K
	6lTIyrtuwzrt6Hr5l4Tf25LKbJIW20Agc/188DhoOoaewjHHmyPlSloBjzyM0BK0Szi5rJ29nLU
	WLt0ZvIOArFIrvNF5DA
X-Received: by 2002:a17:90b:1d4c:b0:398:ea31:2474 with SMTP id 98e67ed59e1d1-39907b5cd26mr4101952a91.9.1788203708934;
        Mon, 31 Aug 2026 12:15:08 -0700 (PDT)
Received: from 192.168.50.3 ([183.193.115.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd1dcfbsm1110665a91.2.2026.08.31.12.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 12:15:08 -0700 (PDT)
Sender: Weiming Shi <thebestswings@gmail.com>
From: Weiming Shi <bestswngs@gmail.com>
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	co+a27ae3497f0074da@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH wireless] wifi: ar5523: reject negative reply lengths
Date: Tue,  1 Sep 2026 03:15:02 +0800
Message-ID: <20260831191502.3321906-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reply length is supplied by the USB device as a 32-bit unsigned
integer, but ar5523_read_reply() stores it in an int.  Values with bit 31
set become negative and bypass the existing signed upper-bound check.
memcpy() then converts the value to size_t and overruns the command's small
stack output buffer.

  BUG: KASAN: out-of-bounds in ar5523_cmd_rx_cb
  Read of size 18446744071562067968
  Call Trace:
   __asan_memcpy
   ar5523_cmd_rx_cb
   __usb_hcd_giveback_urb
   usb_hcd_giveback_urb
   dummy_timer
  Kernel panic - not syncing: Fatal exception in interrupt

Reject negative lengths through the existing overflow error path.

Cc: stable@vger.kernel.org
Fixes: b7d572e1871d ("ar5523: Add new driver")
Reported-by: co+a27ae3497f0074da@bugs.sh
Closes: https://lore.kernel.org/all/K9HvthWDvq4gyjBVMeGsnsvA26mYMZ9v4gW7%40bugs.sh/
Assisted-by: Claude:gpt-5
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 66ac396858a5..176e5de6a64e 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -73,7 +73,7 @@ static void ar5523_read_reply(struct ar5523 *ar, struct ar5523_cmd_hdr *hdr,
 		olen = 0;
 
 	if (cmd->odata) {
-		if (cmd->olen < olen) {
+		if (olen < 0 || cmd->olen < olen) {
 			ar5523_err(ar, "olen too small %d < %d\n",
 				   cmd->olen, olen);
 			cmd->olen = 0;
-- 
2.55.0
