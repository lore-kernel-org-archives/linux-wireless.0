Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F8D34EEF7
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814359; cv=none; b=R2GSGqDnPLp4mpvBdjlHuHod8LH25zpptysE+5tJnhcL1CckkjL52Pmmc4+9EWyT1tkcqeUOUaUPUsRrlXF9s1hozNbBvOdEFPTkRgHKIie5jlw5Zh51bUZ53egxgl7s2ABlV+OScTCal4ipDdAKD0tyK6J3P2qkXm08VrDnA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814359; c=relaxed/simple;
	bh=VVw7LapAM+gzWBsN0jJ+xIAeOmWJ4KAeGeFG921LMSk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=T/LTeg0vlHL7+WuFzS2T52O5/L2kp9CvXfn7eH+6621GdWSX8jGAxvZrUs93qjF+5o6QDeTZdvmAa78EcJgL1SiB3d8vsiB+wlYfhsq1ni165ZNP+PwQLzyaazHVtw6Ed6bZeYS3Om9p6Jb8I7W1DGo/momSDHqiQ9J3OQjoXUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aerlync.com; spf=pass smtp.mailfrom=aerlync.com; dkim=fail (0-bit key) header.d=aerlync.com header.i=@aerlync.com header.b=WbdmfjGc reason="key not found in DNS"; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aerlync.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aerlync.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=aerlync.com header.i=@aerlync.com header.b="WbdmfjGc"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc7e132d3eso1139935ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 06:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aerlync.com; s=google; t=1784814358; x=1785419158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3XKXt3Dv8GeRudVWcQjcGXD8VK7YC1stger/woZ8rGQ=;
        b=WbdmfjGcptY++0aOwrx2bv2nOLeREXL6Hvfad11IQvuaETZx5mURVYfEM95hViZSmS
         0kJwb3WnIck0h4ftf3l1NrmNZIldXu2720q/g+w+dCUJNtxSJY0v9zhrXlazZXTk7rx0
         r9bOTbhYpDkYpApBsNW+RLpJPWNa9qM9VGVkUOGzQVgYgRDh5WpP5MS10CDr/fN24uBW
         MEDMoBo3Bj8VPkJB94RH2AzOcFyFRGBXvD3qsmU1C0BV8smtaG3fvz6KmjzEokJ6g50S
         GST8+4yl3mtvtT2kh2RQv9smsTpoINa7eLtu8h+vC14j/iZl7UHvMzczRz+btV4cIups
         SYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814358; x=1785419158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3XKXt3Dv8GeRudVWcQjcGXD8VK7YC1stger/woZ8rGQ=;
        b=lM97aktXEqtpKjC+dgQ0ZhJCrH1iwBbXB56sTeCrIDv4IvUDm/DWA4ib/9qmEeND1E
         VKrGmjGRdU2dyWDlyziG8Jos/ew73G984iya3Tcn2aZb63uGcqEnYDl9q2VPmquaGfTI
         f23gWcTfmULorgyU+qB/yjrTaVbVyD9g9KmSRHybPhv5SzG78iAZse+7g0e0QVDwGz12
         /ALBI9DI8a4Jh5n/szRuqkRSI5CfbNvlis7CVgk20oPJKYMhm8cpWmWWyXO2kI8j8Q5i
         fYSaUnPQJP4VZ+/0XK5ReUZEFzrH3NlWcy37kqF2sYxdubt2fdIMFdqNQnbBHF9ziDMR
         Qwhg==
X-Gm-Message-State: AOJu0Yw4ZDIW9+XlRV8wLbyyG9e5VqIvBXS3rHPjVfDQA4lXy+3tByxo
	LBXuuKA0kyw65PhrJJq7XtUoQELD4gZYV4FiHcZ+bYy2PUtns3X49brMLc9L+piul88eEz4r8Rg
	UZGbmSDw=
X-Gm-Gg: AR+sD12y2IILya6LdSgFCwmmVh2at3FOE1w0hVqR6RRw/yc0NSL/cjct8LZ1B8gb3/q
	Z8QYq6uf9NGjqcXMV6yN82tLQDCk5ugtvivXf6+yQj/IkKqDQyudtzb2KFBMmeiP6y64rf6ZSWq
	XBlanXJTJGwD73QYi6DcdvLyZB0BQ4HbQbkqB3WzVjlfB1W6LOgqn9Z8K6sZizTXw6Jfc6ZXGP0
	aowaEwJEy2kU6cmk/pBNMhuAMKHJItBquX6CbYFgPqMKagmL2SvcQsbEvh0KXQnIu0JM6SKYUpd
	yLa6LCuxxahlGvSdNA1WJ5pOm7ks1w2OowuZ0GprPwJ6ztbZRFU8gK/dvOe7v2KW3H9yRJ1IfK0
	1/GucursXdyXuo6LtoPfB1TZ2fhmRkbpfWYWmnOQMa2yKDHXag/7AUmO2z7FYHZ7UX2iVMZi1nI
	KeQZ7GbigzNPFQVJbvrsY+dovA5A==
X-Received: by 2002:a17:903:186:b0:2c9:e846:a582 with SMTP id d9443c01a7336-2cfb679d9cfmr6656635ad.0.1784814357493;
        Thu, 23 Jul 2026 06:45:57 -0700 (PDT)
Received: from localhost.localdomain ([60.243.50.177])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3149198adb8sm11030981eec.4.2026.07.23.06.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 06:45:57 -0700 (PDT)
From: Srinivas Achary <srinivas@aerlync.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ramakrishnan@aerlync.com,
	Srinivas Achary <srinivas@aerlync.com>
Subject: [PATCH v2] wifi: cfg80211: change mesh_setup::ie_len to size_t
Date: Thu, 23 Jul 2026 19:15:50 +0530
Message-Id: <20260723134550.35167-1-srinivas@aerlync.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ie_len field in struct mesh_setup stores the length of the
information elements (IEs) buffer. It is currently defined as u8,
which limits the maximum supported length to 255 bytes.

The IE length is derived from memory buffers whose size is naturally
represented by size_t. Using u8 may truncate larger values and can
result in incorrect length handling.

Change ie_len to size_t so it can represent the full buffer length and
match the type commonly used for memory sizes throughout the kernel.

Signed-off-by: Ramakrishnan Rathinasamy <ramakrishnan@aerlync.com>
Signed-off-by: Srinivas Achary <srinivas@aerlync.com>
---
Changes in v2:
- Add the "wifi: cfg80211:" subsystem prefix.
- Replace the non-standard Co-authored-by trailer with Signed-off-by.

 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f5abf1db7558..c9af5abdec1f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2803,7 +2803,7 @@ struct mesh_setup {
 	u8 path_metric;
 	u8 auth_id;
 	const u8 *ie;
-	u8 ie_len;
+	size_t ie_len;
 	bool is_authenticated;
 	bool is_secure;
 	bool user_mpm;
-- 
2.34.1

