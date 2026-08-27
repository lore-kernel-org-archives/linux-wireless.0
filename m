Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27BE306754
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809810; cv=none; b=KaDkKpq0x7/ja6tByJbeXVZUmfhwRXxnPL02uD0snzUeUlYMv7iRifnWUPzMzVztp/zgW73SjXKOy//ehbI7+pd1ziH9VAZNOLyLiJjTvgCqd+hKkfEFpsMswsTEgeb1r9y3RLj2lTs2WW3NrR9VtM5rP6KXmr+pk5nH7UKzTN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809810; c=relaxed/simple;
	bh=zvW75BzJkUlkfpa+LKmcOycgmqn6N03FUluK1LxvrLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUiq++0Ub56wTjbLZM0UlruDXrkPhkv2U2FjsKdIlLF4vwLh7x+x7fO4JJECBRoiN17izR+cVqVNd+s3H4nxzN5PIkQ6OdUlhxsL7kyiwPHA6khLIJTJmb7r3VwY3dztP/UgNvb/BHdQ6SA8pKpc/6XSWPzftvqGr/nZJ2IYILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=h96FiXGB; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="h96FiXGB"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1c7364550so465179a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809808; x=1788414608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aarTjA5RJY1XMj15kc+NRwmAMiySgWGpZZbBbmU9S4M=;
        b=h96FiXGB1QeH8o2U2+lH0xRL02g+kUXLsSXrq9sH35CWZc0iijHaXvU7F3SiQo9xUD
         oZIYLB7mnOk3nq8lTHVJJtoRCx6itixqGV+RQbao0tC9oqB0oonpKGfTmJmdgU23THj/
         YfovFqXlM71tPZ7cOKOYzqU/uk7uzPdenU5WPzgfBIRWXyV0JkVraKjQJYQMHEwkhrFE
         rukGSx5PuoXMfCsCkOC+Z/i5ZgUguOUP5H+/aUOeJf0UngLUJpfiDoSsNN+oJIK9Qt89
         EbNkTfYIdM76Rk/jwMUEzKI7mo+ki/P25WnrAjcQ6llOylWY+aC7pT2WucTxUiAwXcVE
         7zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809808; x=1788414608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aarTjA5RJY1XMj15kc+NRwmAMiySgWGpZZbBbmU9S4M=;
        b=c/GRYLi31/gCyRgSq13GQWePX4G5o+GDzFkFDnzjJ2Gb9nXQUXZyZnRfDX45dh679I
         rYvGpUUJEHWXKOTsWbTMHANvzmX6AXnw0p+aqnR+d+3inmM2JZcZ6HozhToFYVtJEeBl
         dYKqWoixnuOU25AE52IPrazOxl2tLZT2WjhGBEEZVcERP/gZTqqtLsIiW+ozChVh3qzi
         FSrBYSi0jF1YDjE0d62wEKb3RAYaUwiWl10lyVmdbJBoKGcMeGzAlPDfIGrXPgu73Wfy
         zxCrU7eEm+alb0OxW0C71JZcCIh0v7NhL2MZ+vsoFUt+LedHT9lrnyiLweCW0XZtQf3q
         1pSA==
X-Gm-Message-State: AFuF++nksM3rPnSwYk9yXJox/w1gmCipkmar+dbqAwfcRbq67Nk/gKN1
	V8pQ0NgwZ5G9vBN7wcZ+cwOiNpavp3QW9SrM1SNZ+NfG2T2TKnkDfv8cIwQB6LhEEyHt+YGSeux
	6Hk+EOE8=
X-Gm-Gg: AR+sD128EbzfEX8yusMRDeFIm6uT4lDEq9L3kF9paKeMbmH6TnoPSXAMJa0Hq9rS79c
	6z8Ru3JgSOUCp3FK10ugWUSZmDi8MtJ2ZHR6iLyZWakVF4atqE/a8PuVFQBCFK70uhKk4gI2DE5
	+WwyqrK0/zcJQXwkS8+Sbehnf513LL65/S/x7TPWvPtzXrF3UVYtUTnlyhVImCl1jxBhxQguDN8
	LLXW9Oy1gnroyoK98jWIX6XnuSvSmnReKKOUDxbxZudzPbuf3zCRYb9TxVmcPhCsJ1o44lqwDDD
	mfWOSyRzA4Rpnv0UjDQKxlOKx1+Qfj9oF/58e29E8pSsrhfWB1glzOIhavRAEBCDmSRghrUmfFk
	OUm9GFLYjGJC7aZ9GwVyNvGDuvhHFL4aJAGyhBsMAzf5W+AhV3IC5j3oXhmVASWrrCCeuiRJRj2
	3A8seuGvYz4VQj6WJVB6jMy4Nc0Ie0k3csY90krTxaxFqJBXNQ7fKOQy+6/r0oij+TMWQzWHy8B
	EYY/ewPWJZy8AK0pnpfbwppVEcxuVF2v9cfVksarWdzuScKR8WCFGs5IaA1k4ifjgpkpkBZQSvS
X-Received: by 2002:a05:6a21:3113:b0:3c3:bbe6:95c9 with SMTP id adf61e73a8af0-3cf86be5edamr26212971637.16.1787809807830;
        Wed, 26 Aug 2026 22:50:07 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:07 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 2/8] wifi: mm81x: release buffered broadcast frames after DTIM
Date: Thu, 27 Aug 2026 15:49:11 +1000
Message-ID: <20260827054917.255584-3-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
References: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since we set the HOST_BROADCAST_PS_BUFFERING, mac80211 handles the
buffering of broadcast frames. Make sure after each beacon we call
ieee80211_get_buffered_bc() to release buffered broadcast frames
after each DTIM beacon.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 4d0131246710..0bbedcdd0b3d 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -66,6 +66,9 @@
 /* HW restart delay time before terminating hardware IF work items */
 #define MM81X_HW_RESTART_DELAY_MS 20
 
+/* Maximum number of multicast frames to release after a DTIM beacon */
+#define MM81X_MAX_MC_FRAMES_AFTER_DTIM 4
+
 /* clang-format off */
 
 /* mm81x chips do not support 16MHz */
@@ -1287,6 +1290,20 @@ static void mm81x_mac_ops_tx(struct ieee80211_hw *hw,
 				      MM81X_SKB_CHAN_DATA);
 }
 
+static void mm81x_mac_send_buffered_bc(struct mm81x *mors,
+				       struct ieee80211_vif *vif)
+{
+	int count = MM81X_MAX_MC_FRAMES_AFTER_DTIM;
+	struct ieee80211_tx_control control = { 0 };
+	struct sk_buff *bc_frame;
+
+	while (count-- &&
+	       (bc_frame = ieee80211_get_buffered_bc(mors->hw, vif))) {
+		IEEE80211_SKB_CB(bc_frame)->control.vif = vif;
+		mm81x_mac_ops_tx(mors->hw, &control, bc_frame);
+	}
+}
+
 static void mm81x_mac_beacon_work(struct work_struct *work)
 {
 	struct mm81x_vif *mors_vif =
@@ -1318,6 +1335,9 @@ static void mm81x_mac_beacon_work(struct work_struct *work)
 	mm81x_beacon_h_fill_tx_info(mors, &tx_info, mors_vif,
 				    cfg80211_chandef_s1g_pri_width(&mors->chandef));
 	mm81x_skbq_skb_tx(mq, &beacon, &tx_info, MM81X_SKB_CHAN_BEACON);
+
+	if (!test_bit(MM81X_STATE_DATA_QS_STOPPED, &mors->state_flags))
+		mm81x_mac_send_buffered_bc(mors, vif);
 }
 
 static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
-- 
2.43.0

