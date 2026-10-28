Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197101;
	b=x2QOsAKL476H8xAtdPHetF243reAtoE63B2KQCpyC+fAJHkoTISqplgKgoK59BKGIClM
	 LCKNM+9U5WAypjQSHlvVWSd/bZonunwDozuvlMCN+bmL7IkOQlXFqsUUh7Fw8aj82ipsT
	 47ZKfTU0novgTtiJhZOfYlOUdGd95Qg72dfCAV3KcEk/n24mbt7QfQKOwtf9sZ15RBe0W
	 tkzgW7CEcr0cqCJcpE/pkTBG1bdBdBNJ0IkH2Hpyu+husvniRlTlg7b0G6iyLBus+VI01
	 GRyckjiwuLZKbfGP+i4z0ZfCi5md/GrapxQdDzM/a5Z3uazmcxQPPwOtOus4kXWh2wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197101;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ZR9JdhuF78bRej8mJoidoAF0AkalLMRPKfyvzekZdY=;
	b=slbmoGKx58XSHJMl+dlk8u2SsRR2VuzTCpzHgF9xy/A03MABwg10CCqnW5qXkXQaIrV3
	 2eHtp7JWvEnmhgyOAyx7+Mrhdy0fVF8MRbs2uTmPkoA1KD5qxe6kSVXG7hqjd6LZGhPRh
	 KKEmSNwgDJV6DUCpE/7tkg2YLLsTPEvMVhwO87KlgzY0ndy8+CD5HdaWXR2OmKvjbCzfN
	 0XRUBND0U8vgEEHmLnWwPbtN69MSI44djiC77AscAuAqUt8hZ9a/KBd/xVVxWD/Xr4E3T
	 FCJPTUibRT+tsN36aA5A7rubxahNwX65XYk6kbHJSaxQ9tzJaw1FDUGAJcRSV1eUjIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VhnqMuww;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50563606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50563606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VhnqMuww
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a06b436dffso536645b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197100; x=1793801900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ZR9JdhuF78bRej8mJoidoAF0AkalLMRPKfyvzekZdY=;
        b=VhnqMuwwpYoXUUq8HBDgtbGF2pn4aHei9eYe4dMZ/XjiwQG9KIlkAEc1P/PEjXdQAl
         vrZtgmBokQIbKuinmrHuw1l/blqSZ21FZvUAIgy57+4phsXU4UdunMk4NiUxSL1HcEIg
         kM4UDLrgMp2fWJnhx18qRwg6bkic7QJbX44vCt8nmUJAARGPR+p8eHMwjvOXYiGfBjrb
         WbJEiUWK5Dku3OYJF1eXQT0WkDBaO/JpWsDgLJUH4UKmj4+kl54/rs+SqSt/RCx/bSeH
         d8iQWQKiuC636Ps3t6Hzrdcu5lMn4NuxQQqCm7nQ6fAQVTpQM4s793VYKCKWJSFMIEOz
         4wQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197100; x=1793801900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1ZR9JdhuF78bRej8mJoidoAF0AkalLMRPKfyvzekZdY=;
        b=rSISlAa0FUFQ6SmpEEAWwL74yuJRIhtzFHhffEfIOS3mNHsVpbErBwU0Xn9N19P3C6
         4Pfn1aSsEalVvtM7hHn6yyzypPzud2D4ckzgSiolr4sU5ZrpJthMZQTkhLxtQB812LGA
         BzzQiODJYP7XnxcxG6Kttj2TlIa6T37O7Yl2DaGRmOkWpaGiAgPnLJa3R5e0jFrZLKc/
         kXsHB/Rv6GLYqKGifP5Odn6J5EqgXZvgNoRNqzdwT67f4C6PX2Ip2evo/UYzjT3J0E1k
         Sh0DGNygILTEMhzEVrCO3uGnx+SC3CNZn8I7i+ooS1xCXaSEUyPlGk1lWwYmWOYzqjtE
         5qGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrZCFPPfIrxpN/9Yqjto4khVxYIGvL9Xox7b0oWDvSyF/mQzyLtqsqUSvfYl2ZwyXfBpHRnhaYobPts/bzCg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKBECX30nlwb6pj0msh3A4dEi4+oX8To+6wANdn6pNuWD8p37bh
	1UZFvydNq6AmBvwVQKGp/SR0Cb1PtYh0uQvp1Th/irTCXRiMTkPK0OHh
X-Gm-Gg: AYBFou2rQ++TU5Rdwl8MUMn/IzTdXoPz45Edq3lypbm18MJXhSGI+0b4k4hs5039E+k
	YngVqhrIQuaWZOAnSHfk7Jj7pAyyucOWbezH+w2eyt4HerYzeclQdm/RLDlIgPkK7VVJliG7Yvh
	l+Nf9I2zYFqOSY/mn6uwPS8g9eJTdQ3Ukd4pmjcSzynMkD4h5JEOHh03t0I+oxihqw9x27a7lFN
	cQlZbNzmswzXMjYCTXVYlwj3e6K1cztMJxywgNgzlgzvoKL4qOxsQMI8RynwKYVvsvWaPBe/yUu
	0xSxScCcHTFBijw5z+S3jupQtZWSxA53Z3vVGBvkNabrp90/qxLU3jIo/cS6PATf+OGBhxqS538
	6bxsrcwNZ2hXSNWuy7LtlrKfJSQw2tpitZGeANwQGiG3uOngFbbPSkacNsMtnIoXKObeVPbJl2v
	LrN6K1n/jycK9pE4mM7VRRxEMNS8hfbCho2EUEu1pQ17cDCqRcAc0J0SWiK5Fvi5lwGx45UW2sH
	dwJaASbklwgT+cwrKA+Aq7sS+Df04Dy/BkrcrVwD9Lk8QDErFP0qkUHfayGzaefYvImKnv81CKt
	D1iOjTzhj+7sEHHPSNc0fklVdPhCmQ99QM47kU5o6+6OA3P4qI/Ad2/ByYx4J4oHAJV74I4uoOW
	sjJ3alnfn3ApawiA=
X-Received: by 2002:a05:6a00:2302:b0:8a0:72e8:732e with SMTP id d2e1a72fcca58-8a6e6ff2f26mr1844183b3a.29.1793197099245;
        Wed, 28 Oct 2026 07:18:19 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5e302sm1284996b3a.7.2026.10.28.07.18.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:18:18 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Javier Lopez <jlopex@gmail.com>,
	Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] wifi: mac80211_hwsim: serialize radio removal with frame commands
Date: Wed, 28 Oct 2026 22:17:51 +0800
Message-ID: <20261028141751.6728-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028141751.6728-1-enderaoelyther@gmail.com>
References: <20261028141751.6728-1-enderaoelyther@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Destroying a radio while a frame, TX status, or PMSR command is in
progress can make the command access the radio after it has been freed.

The command handlers keep using the result of an RCU rhashtable lookup
after the lookup has finished. Socket release and network namespace
teardown can concurrently remove and free that radio.

Serialize non-dump generic netlink command handlers and asynchronous
removal paths with an hwsim-private mutex. Use the same serialization for
virtio dispatch, which invokes the handlers outside generic netlink.

LLM assistance was used to find the bug and review.

Fixes: e9ed49bf4c2c ("mac80211-hwsim: Add support for HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. A forced
QEMU/KASAN race between HWSIM_CMD_FRAME and socket-close removal changed 13
unique use-after-free reports to 0, with no lockdep splat after the change.
Network-namespace, virtio, TX-status and PMSR paths were not run.
A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 .../wireless/virtual/mac80211_hwsim_main.c    | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index fcbc7f4355bd..61d0e2c1d00c 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -673,6 +673,7 @@ static const struct nl80211_vendor_cmd_info mac80211_hwsim_vendor_events[] = {
 };
 
 DEFINE_SPINLOCK(hwsim_radio_lock);
+static DEFINE_MUTEX(hwsim_radio_mutex);
 LIST_HEAD(hwsim_radios);
 static struct rhashtable hwsim_radios_rht;
 static int hwsim_radio_idx;
@@ -6310,6 +6311,7 @@ static void mac80211_hwsim_free(void)
 {
 	struct mac80211_hwsim_data *data;
 
+	mutex_lock(&hwsim_radio_mutex);
 	spin_lock_bh(&hwsim_radio_lock);
 	while ((data = list_first_entry_or_null(&hwsim_radios,
 						struct mac80211_hwsim_data,
@@ -6323,6 +6325,7 @@ static void mac80211_hwsim_free(void)
 		spin_lock_bh(&hwsim_radio_lock);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
+	mutex_unlock(&hwsim_radio_mutex);
 	class_unregister(&hwsim_class);
 }
 
@@ -7153,12 +7156,28 @@ static const struct genl_small_ops hwsim_ops[] = {
 	},
 };
 
+static int hwsim_genl_pre_doit(const struct genl_split_ops *ops,
+			       struct sk_buff *skb, struct genl_info *info)
+{
+	mutex_lock(&hwsim_radio_mutex);
+
+	return 0;
+}
+
+static void hwsim_genl_post_doit(const struct genl_split_ops *ops,
+				 struct sk_buff *skb, struct genl_info *info)
+{
+	mutex_unlock(&hwsim_radio_mutex);
+}
+
 static struct genl_family hwsim_genl_family __ro_after_init = {
 	.name = "MAC80211_HWSIM",
 	.version = 1,
 	.maxattr = HWSIM_ATTR_MAX,
 	.policy = hwsim_genl_policy,
 	.netnsok = true,
+	.pre_doit = hwsim_genl_pre_doit,
+	.post_doit = hwsim_genl_post_doit,
 	.module = THIS_MODULE,
 	.small_ops = hwsim_ops,
 	.n_small_ops = ARRAY_SIZE(hwsim_ops),
@@ -7172,6 +7191,7 @@ static void remove_user_radios(u32 portid, int netgroup)
 	struct mac80211_hwsim_data *entry, *tmp;
 	LIST_HEAD(list);
 
+	mutex_lock(&hwsim_radio_mutex);
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
 		if (entry->destroy_on_close && entry->portid == portid &&
@@ -7189,6 +7209,7 @@ static void remove_user_radios(u32 portid, int netgroup)
 		mac80211_hwsim_del_radio(entry, wiphy_name(entry->hw->wiphy),
 					 NULL);
 	}
+	mutex_unlock(&hwsim_radio_mutex);
 }
 
 static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
@@ -7248,6 +7269,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
 	struct mac80211_hwsim_data *data, *tmp;
 	LIST_HEAD(list);
 
+	mutex_lock(&hwsim_radio_mutex);
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry_safe(data, tmp, &hwsim_radios, list) {
 		if (!net_eq(wiphy_net(data->hw->wiphy), net))
@@ -7270,6 +7292,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
 					 wiphy_name(data->hw->wiphy),
 					 NULL);
 	}
+	mutex_unlock(&hwsim_radio_mutex);
 
 	ida_free(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
 }
@@ -7364,7 +7387,9 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 	skb_reset_tail_pointer(skb);
 	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
+	mutex_lock(&hwsim_radio_mutex);
 	hwsim_virtio_handle_cmd(skb);
+	mutex_unlock(&hwsim_radio_mutex);
 
 	spin_lock_irqsave(&hwsim_virtio_lock, flags);
 	if (!hwsim_virtio_enabled) {
-- 
2.56.0

