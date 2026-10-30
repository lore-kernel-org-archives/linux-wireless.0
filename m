Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793397597;
	b=Jg3eNi+UGlacPnuZZINOMbHVdtZhQp5zgG4w/r0BGJYNCS56SfDg3nNJ1dEErPxHuLLN
	 8NvoyRgWvssn6WJLLKP1xV6BiBPTMoL26bR50LXe5wvve4DHsuirwkI59ifrxbUXo3AWg
	 51YVhTJQB+aGDB6HOKeuPNbuT/PrRG7ezseHUjGZc8w6UAi5oJsM68/j0/w0+WOR0sJYf
	 IeTo8LSGkRWdXS50WE2DjIcpyyaCbknltRCkd7gPt2EnEN7G5TNKTpEOuqr4EjRYr4Tgt
	 B1me4mIQEuAC3DqVASmFLwBMm8RvyY1AJE+MRkW6NUh7ywb6eTx3Pryn5cQQrEYJaSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793397597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cqVPzAxRYBnfkyaou+ZmBagBM9cb7geifcCND68rtOU=;
	b=hIlXPGw1DJv3929tnK3dmRNO7iIx8JwN5kPSg0HjItQMbzbu0PgUU1jcrYskMwmgzZmd
	 oaLI4frmLUqyPHe5ivxLapvFeYkR6iZf8R8GDCVcWIe81aDgC/OjBuSdqRft/jrG08Cff
	 Oy/c1aj6wPV4WrywToPDMzt6SmrLyTtHvx4JO7QWkyHAtUZ6UPKHfAfiCQa36U53FJVgt
	 KHc0HfkesPtct/gURKArq6cyOqfQTt9fKDQtgvRdLQPniH85cTL/Z/qu6Y4ONlhoZCE8B
	 cTP6HarvyYacVlc+7h9kUYrB04ovib1LW0UAcxurkYYj1n5XPTY/GYyOIVIadb3CjaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xHPTiUxQ;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF5606A333
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BEF5606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xHPTiUxQ
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso12921305e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793397595; x=1794002395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cqVPzAxRYBnfkyaou+ZmBagBM9cb7geifcCND68rtOU=;
        b=xHPTiUxQxKUdyd/EaSzHOImOy3GuKB/zxcHmflNS1dg1DgOLot8Vow7pGI+iuNaH2P
         tnN1LWEwiIL8DU5gqGs8jUlDih25km7SPhB2SsFNSOLFbAqt4wpSpl9IPOOcZSnrl1Mr
         Ga8ucI4GPk4RabaPCKN0GJOG9Ks1crXraHfqpe+OeVK3GUkhxBaj4tD3Nc/zaj5upuiT
         dhmXLYmcZPiWCWzfN7obJUFhmAqEEHjt44efiMOgfj9xaZjvK3LVZDB8ByyP5LlZQLyv
         4QZYcPxsljDjU0EnpANUgBWSV3/FGDe96vk2v3WaE50gqyoKSm5gsUs2uwEXSjjUA7Tj
         QAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793397595; x=1794002395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cqVPzAxRYBnfkyaou+ZmBagBM9cb7geifcCND68rtOU=;
        b=COfHeImu7ifsSNJPLziE75XM8GUhbHJxZ5PYNYkh17+uVP2+jeMIw6fhndwRasUcA1
         bq9CGIUEdHU7yI9BLfNv8olcrz+Gb0GKUzwjKDv0CywnkLC+NwRQkwTTgs9i/cjcZh3t
         S8k3cbBVF25tOEUVv/ceuVOo6VUu00jz9lYZ6XEwO40NM1pndfalgvHhpvNKIEMqnfM8
         AXm/yzx3rYngAZU5E0orLoqZDxSJ1ov5hqLFG73K6Coix/pMq6WPmXn90CmqYC9o1rWF
         cG2/B/tt7TK4U279T6b9Xr4aivHJk4E7KRm8lYKz7libYxJYclqv7fqQw1nv2NOkVqrw
         3hvw==
X-Forwarded-Encrypted: i=1; AKwUvByevRlxVWIEsrFP0q9grrG/HHxZTIwcYEiSJbSV6VUd2fpw97fHacxXsQyqe+ie7GuCR6x+b8g29Q7T7/hdjA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJYV9Js1pjEENxJ2KQd/QT9SoNEbYzgf9j9m9AxoivGVwuk1zV1
	MemlIvm0FXCMzpL8GS+g4wN4ewidkhRuHBWX94ZtF4cPM6CrU9l9Q4Ly
X-Gm-Gg: AYBFou3VQJubFkB/dOGo/A6WYwEhYLJncnwZaZhvp3WBI+X0AAVpVQeWN8oQfEkDyx6
	5DhhxF+THUl8kvuEqSVHrCh2V+nN8pzCehhGX1lsCtrToofIMyr7f1YQrw+VKsfGWscd0fswZlR
	fBmKUkHNQYrE9OAX8MzK9dRs+DL58MtwBeu/RU9Q+tr6BNBsBYyklu0nb0vq4XTzuni6fdDhKJO
	MlKgsyNrUc9rgqobjUgQwAmZD987koYUcZ1K/JOGunVYhJciq7PQTSFNg6jn3AiyBn+/yNl1mLy
	HJPHp6mlF+IcKZOWuF2e8XSp7a5o28f8i/piP0VXiHUl5SVfp7M/rEBsCm78wzMlsei3B7xd/ua
	hbDpVASQwn7+g57BGC3ITmIBOsdki3wYpm0y6BX8aQUODM+NxkUPpJsIO0xh7UiK6/pWRgKo0Wd
	BhG1XsdCoHq20VJvGjiFQjYknqq2E8Ui6YbGgfsi3JabRM6ARgSjWbUj169VcEZMv3HfBwT1OPC
	Zo/SU2uvbv7MH52RL6z0mrCIoY+09KU+6Qr6v9uQcps39Zd69i2UNXF8gLXnBPOL5n1UQGalaN9
	V9ZOqwKP1g5JNGE3mcPToKyzh//NpXhHowRtOGJ32uR8
X-Received: by 2002:a05:600c:a0b:b0:4a1:a6e0:4ce4 with SMTP id 5b1f17b1804b1-4ac183d2043mr76677775e9.33.1793397594525;
        Fri, 30 Oct 2026 14:59:54 -0700 (PDT)
Received: from linux-virtualbox ([176.123.27.73])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf723b5dcsm87207155e9.14.2026.10.30.14.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:59:54 -0700 (PDT)
From: Salah Ahmed <haddad2inc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wifi: mac80211: keep the tpt LED solid below an idle threshold
Date: Sat, 31 Oct 2026 00:59:37 +0300
Message-ID: <20261030215937.18103-3-haddad2inc@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030215937.18103-1-haddad2inc@gmail.com>
References: <20261030215937.18103-1-haddad2inc@gmail.com>
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

The phy throughput LED blinks whenever the counted traffic is non-zero:
tpt_trig_timer() walks the blink table from the top and only falls back to
solid on when no entry matches, which needs tpt == 0 exactly. An access
point transmits the broadcast and multicast it bridges even with zero
associated stations - measured at roughly 2 KiB/s on a quiet LAN - so the
LED blinks at the slowest table step (334 ms) forever and stops indicating
whether anything is actually being transferred.

Count anything below 12 KiB/s (96 kbit/s) as idle instead. That is the
threshold the userspace activity monitors used on these devices were tuned
against: it is above the background of a quiet LAN and well below any real
transfer, so the LED is solid while nothing moves and still tracks the
blink table as soon as a station transfers data.

Signed-off-by: Salah Ahmed <haddad2inc@gmail.com>
---
 net/mac80211/led.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index b5600d223..78fffe122 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -9,6 +9,16 @@
 #include <linux/export.h>
 #include "led.h"
 
+/*
+ * Below this throughput the tpt LED stays solid on instead of blinking at the
+ * slowest step of the table. An access point transmits the LAN broadcast and
+ * multicast it bridges even with zero associated stations (measured ~2 KiB/s),
+ * which is enough to keep the LED blinking forever while nothing is actually
+ * transferred. 12 KiB/s (96 kbit/s) is the idle rate the userspace activity
+ * monitors this behaviour was derived from were tuned against.
+ */
+#define IEEE80211_TPT_LED_IDLE_KBIT	(12 * 8)
+
 void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
 {
 	if (!atomic_read(&local->assoc_led_active))
@@ -270,6 +280,12 @@ static void tpt_trig_timer(struct timer_list *t)
 
 	tpt = tpt_trig_traffic(local, tpt_trig);
 
+	/* Treat anything below the idle threshold as no traffic, so that the
+	 * LED is solid while the radio only carries background broadcast.
+	 */
+	if (tpt < IEEE80211_TPT_LED_IDLE_KBIT)
+		tpt = 0;
+
 	/* default to just solid on */
 	on = 1;
 	off = 0;
-- 
2.53.0

