Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D677A3CFF50
	for <linux-wireless@vger.kernel.org>; Wed,  8 Jul 2026 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783540785; cv=none; b=dT+lPlXOdPZpsm/Dnsd9gDYVfT+UCxqAjqd+WMALQS03/EDzhEGiPwDeVwtBYOIcyIAGj7LbX5mAQGNgI7m71ehAV6ekSkV6nCJfdM2IoarbyrLUJepxHwQ/BFZgyZx9E8//mNkt6h9rNcyqcvmqmiLtfO8s4WuEm5UwH4HeJ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783540785; c=relaxed/simple;
	bh=GJLezcDcoaMUm/tnTlPXLxiRt46ZIpeFhgWkpaquQlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED8SRRQgbGjwqHX3RsFoDpGlor76AAuQsLdu76T065aBCvCVIFBv5FUwB76BiXwVPqU9KhblSOQ0PZ/3wBPYfvy4kCwnzTRxo+5P66KrEFJrJy7k6nxE7Vrz7lDXMLaTBbqCUvQQAoKnxImUwoCCftI91zjyJp9qm0pOdXcvQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnwHXxQ2; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnwHXxQ2"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so750440a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2026 12:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783540783; x=1784145583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W1HHhOy/pNu3cFDB2zGZwuguDV/w8raM85RkD4E2vwE=;
        b=RnwHXxQ2FNj/iq3NJPpDL98NpgM7n3Qq7rQykUSf9kz+8t+BexcZoqA/XjeQVaJQe6
         bXpJG/LsGdXqea6SLwCnPKkKqm/WHRtGCBMC9UCVs9qbqAfFoPU75hKg56XB8lvyNwr7
         8UW05o9SUJAJCG1pbmOBZBFF1ey4QLbc63oYOHqiLmqvHni6vwHv2BooQDNj1SKrsegD
         Qd/VJAKPQXTBpefQ9rwa5RqX38HEPGIbUyfLr/CvIhKvuzntnGLASuQm+JPV6KuZcHzc
         EsSoz5vv2j04kKeL3tmzrBv6lOMsE5sHJuYW7Wh/md8WviOtDis/0rsm8oEkBIQlPVT5
         xMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783540783; x=1784145583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W1HHhOy/pNu3cFDB2zGZwuguDV/w8raM85RkD4E2vwE=;
        b=lR8ou/zkNUN+RkPaCSZbWkWE8B0oFbUzMamOev6f7ogXCrZZ5NZ7k1RP+rG0ctybA/
         3V4WOyZrik29UZLhNuEcRmKIC+Xyr9xila5u/MZ6rPnnTlixrm2LRJsZodfXUVMRUYDO
         vNY5Ce52h8sUgEQffKrOEJjgdKemmpwYgOCz7hmnn2KmfJE2kOU9BjfjvwmD5K2aLZaN
         bAH0Si32bRvtQtE4C5hBKA0hujwSadUKCpXBnTitH5ryDOX9xIFCJ3hiwly5T7jCyOYb
         Vcy4C7xf5FZtkUSrytX1jpQouACJZzVlY5pwtt/eZUHAydtWvTgDKdVRC5lraX9R5lRf
         CDGw==
X-Gm-Message-State: AOJu0YwZuFAqn/h81hkzj5FydQCkHaYH+DZLc9kEb5rB2EK67nufckrm
	RH8rhzNTEGoDoOepwTir4EfEdT/EhWi5fy4wQqDvR9T7+lc1FzRoJNe1ROjYknqLyTI/ng==
X-Gm-Gg: AfdE7ck/V2jOraYzY5KQL5wYvfj3/L1T9WzCBIS+xBJ0BffgmaHmR1tMZvYqej43z9b
	CzN1fIHt8dKi4/pqJzfEEny+aTqzoYrtOOFUle0GgDfxvZ6cF+PUM+Awklv0oORW9HGv5be+bQ4
	WM1TOhIjl/KTd8KmWfBHvyltoxXbHMdo9SFZeoH65oiPZ0GBt23m762fGkT+lj1RA/+YTv/AL2h
	RDjVZCEq9hksKQBr+3L8TXtnXVWJla+sa6WQZTYQidjg8l3DkdlMYE4wWAst0dUoMuqtE46mX4K
	J/lEqYXuJ6Y8MH4Jlzns0ia+ywCv4Xvr+jfC7jhS23bVm5vHXEKjG8df0XZsEo7OJco9ihuNIOR
	PAWFbwGYJYyrSWDSfBS+JP8o0/z7jBkxfrAoHMtKF7jnvDo/eNC2xTUGzZvWjXEGx8u/bR0Wm8W
	i+bT3tXraDoJHOlApk24I08NQoLz9252YSBUrEasYTeZ/I5Yd/TeIv
X-Received: by 2002:a05:6a21:4d8d:b0:3bf:6c08:fb8c with SMTP id adf61e73a8af0-3c0bd312faemr4425750637.60.1783540783226;
        Wed, 08 Jul 2026 12:59:43 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a8f521sm22585395eec.22.2026.07.08.12.59.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 12:59:42 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jaewan Kim <jaewan@google.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	John Crispin <john@phrozen.org>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Zhao Li <enderaoelyther@gmail.com>
Subject: [PATCH 2/8] wifi: mac80211_hwsim: authenticate PMSR report senders
Date: Thu,  9 Jul 2026 03:59:05 +0800
Message-ID: <20260708195911.84365-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260708195911.84365-1-enderaoelyther@gmail.com>
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hwsim_pmsr_report_nl() looks up the radio by HWSIM_ATTR_ADDR_TRANSMITTER
and, when data->pmsr_request is set, parses the reported peer results,
hands them to cfg80211_pmsr_report(), then unconditionally clears
data->pmsr_request and calls cfg80211_pmsr_complete() to end the
measurement.

Unlike the sibling wmediumd data-path handlers
hwsim_tx_info_frame_received_nl() and hwsim_cloned_frame_received_nl(),
which check the sending socket's netgroup against data->netgroup and its
portid against data->wmediumd, this handler did not check the sender at
all, and its genl op carries no GENL_UNS_ADMIN_PERM flag. In non-virtio
(wmediumd) mode any process in the netns that can reach the hwsim
generic netlink family could therefore send a report. The transmitter
address is not secret, so such a process could inject spoofed ranging
results for another radio's in-flight request and, because the handler
always completes the measurement, terminate a ranging operation owned by
the real wmediumd session.

Reject reports whose sender does not match the registered wmediumd
instance, mirroring the sibling handlers: in non-virtio mode require
the sending socket's netgroup to equal data->netgroup and
info->snd_portid to equal data->wmediumd before touching the request
state.

Fixes: 2af3b2a631b1 ("mac80211_hwsim: add PMSR report support via virtio")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index bc0818b525224..6bf9736098b67 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -4211,6 +4211,15 @@ static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
 	if (!data)
 		return -EINVAL;
 
+	if (!hwsim_virtio_enabled) {
+		if (hwsim_net_get_netgroup(genl_info_net(info)) !=
+		    data->netgroup)
+			return -EINVAL;
+
+		if (info->snd_portid != data->wmediumd)
+			return -EPERM;
+	}
+
 	mutex_lock(&data->mutex);
 	if (!data->pmsr_request) {
 		err = -EINVAL;
-- 
2.50.1 (Apple Git-155)
