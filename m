Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5D3C197A
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 03:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789702813; cv=none; b=A6LwWuQ4luJNhTJTKCbPK5VDmymykBF+7d3MZCBVuskN46gl88cD673UUJtuCn+UkJROOUrpmHR4aM/0TD5YlCUJmN3vOX6B9wvPGLq9ZIc2b+yOEQG04gcdmhy7ORVvQc2XoUKKWdi4nTFhaeVt2UZfCjG/aRxMihHoH+XcS2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789702813; c=relaxed/simple;
	bh=KKItR8FZ9hix+/TL0aQ9eu6vPKiFhpC7kUkQVOqGo7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lfRkAbbOAsjYQSI28Qjc9d7sCmUdfx41+lCYar2o/RuSdCpG9zf2PddXzf5lIj5Kzin8YCMALsHRZhPcQM7j6RbluH4DZI7/z9k5S10NYWpVeKDdtHXgJHJxiuBpUEXgzJsnL5M9RMUHxUPXom3P7bSiEQExwZbT69Z7eWwuyO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SI0B0ema; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SI0B0ema"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2dd77300825so2823365ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 20:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789702811; x=1790307611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ubHKRJ5xVQmev0vSOqthTpsahkuZO16pcf4T5Ysx2tg=;
        b=SI0B0emaz9dnKc2Ypxl8n4Y8s0CJM55tXYONZv1Fs9rMpag7s9CQvZuz9RvJhjojFL
         VOyk+iVjWv4Ik97Iic7agVfXzh5I1uJ7m0nQ/ygg4xwS7XFOGGttuv59+YirhPszPTdf
         3ONQnPctVkHEr/sTViBWB4QiEP2gqii2fWyJSHcSIfJIQh+lKTJXoJIBaS8NGTN9jyUe
         VclpWzG/16tNlmsE9i/KA5ANhQ8mJkGi38ssT+OZP2aNknZPmuROTocgNYKI3xGpq9oA
         qhD7qXmRetCvKdy85XcbraarEybbUKT3Iw5B8dnZ1q47qaojx8kkmqYqUBs4SNiGi0BU
         OPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789702811; x=1790307611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ubHKRJ5xVQmev0vSOqthTpsahkuZO16pcf4T5Ysx2tg=;
        b=aufQU/S/ezI20qoPwxEVL7ZZIfHeyk/YpeOCieANEL9XHRrjnoNBFLzIWXQgX6WWf4
         COyIQnb/mcVlROyz3PNeCjxnFWxoeahYtRYSzG1z5PFqT+uGPO2yMEANQUjwRraYVmcn
         cBblxEuTYEGq+YyKyoJGj7QIbjJCmsmAnWnTax8LJCDm9ZxQd58I5AXNv+JFY5hriM5T
         QHL+aKMK5c2IhYQKt9YhJeME9CGhCQDGql5xpsistPqjXb8dOe+T0Awem/nd7OtzcyWE
         oIONoOd8AHLlLOmDEByiAPBb8M7bESHLVO8an113OO4fyJpmc908d0hghkwx8bBzb7MM
         KEmQ==
X-Gm-Message-State: AFuF++lcYtCy1nNzjjLu7x2mmani2rokQkT2uxmrXV4ps9GCmUWTcuBx
	R/TqH3bVi/ERyvvnKvatJMgkuhijm5DLeILer6HOSuJJc+AnrBYlg2le
X-Gm-Gg: AYBFou2WFLY5PLEIJbXhNB78eUYlNnww0DqvTPxxkiFR+OxKb+UBlfKbRZ4jWgwdIXK
	oSwSnTZ2XmSEjMk/BHlP4tcP36zPH769Lhhhb6t9t8mkvNiAo51E0Gl89m0Y7RDEg7nLwNCRG58
	/8vOGFxDPrkz5uCFvCV9KdOby4lQv6UJH6G7WJBXksmekdsdgtNyEXu+DYI0A+i7xxt9SXjoBAw
	DruYLjtMYka3BilM/7AnmHR/NFzd/r1voTv6aiADn+6gBm281lRtKv9vlpsy6zHfYjQh/V4mbhu
	u0D573QWq81SUeP/IWbWl3cokw7PkXygSsgk82mOZF5nUQ7VY0w/NnxY8g1csILC0EO9TnqmnWY
	uX7asRHjy/cOgVrp7vDUKTSj366mYCWx7VrL8S3ecy5COaqA2AgTQRzF0W9vnXRvzQfEDTuUEeS
	dUK1PMSFatbS8MrSfXwRqoHbsxr/odyk6Xzwtwn2kPwR709sF9NlO+CqQTeYuXmnci+rlQqKXpP
	NakKFVX/+r8Qdp9XOemHGHj+ZavGa3dFpzwsFI=
X-Received: by 2002:a17:903:2350:b0:2dd:4168:7bd3 with SMTP id d9443c01a7336-2ddb1adec54mr28702315ad.12.1789702811157;
        Thu, 17 Sep 2026 20:40:11 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:79da:8b9b:16b2:8431])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c284a8a2asm706032eec.1.2026.09.17.20.40.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 20:40:10 -0700 (PDT)
From: Yuchao Zhang <ndaugoing@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 0/1] wifi: mac80211: drop oversized fragments to avoid extra_len overflow
Date: Fri, 18 Sep 2026 11:40:03 +0800
Message-ID: <20260918034004.85078-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes and mac80211 maintainers,

During static analysis of fragment reassembly in mac80211, we identified
a potential 16-bit integer overflow in ieee80211_rx_h_defragment() that
can be triggered by a sequence of oversized fragments, leading to an
undersized allocation in pskb_expand_head() followed by skb_over_panic()
in softirq context.

In commit 69f132236827 ("mac80211: shrink struct
ieee80211_fragment_entry"), entry->extra_len was narrowed from unsigned
int to u16. Since up to 16 fragments (frag numbers 0..15) can be received
in an IEEE 802.11 sequence, a sequence of large incoming fragments can
cause entry->extra_len to exceed 65535 bytes, wrapping around modulo
65536. When the final fragment arrives, pskb_expand_head() only allocates
tailroom for the wrapped-around extra_len, and the subsequent
skb_put_data() loop overflows the buffer, triggering skb_over_panic().

Because valid MSDUs in IEEE 802.11 are far below U16_MAX (standard MSDU
is <= 2304 bytes, and A-MSDU cannot be fragmented), we prevent this wrap
by dropping the frame and purging the queued fragments if accumulating
the incoming fragment length would exceed U16_MAX.

This approach keeps struct ieee80211_fragment_entry completely untouched,
preserving the structure memory reduction from the aforementioned commit.

Best regards,
Yuchao Zhang

Yuchao Zhang (1):
  wifi: mac80211: drop oversized fragments to avoid extra_len overflow

 net/mac80211/rx.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.53.0

