Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038555;
	b=aQWaWmQH59b9ZFNXVVVIG3NS8ZAKrwD3zWRvnVM+QFDtLsER0odxAirmPpq83d9xOteb
	 IfsIlMYQ1LxsYI5hSHAJ4HknJXxipQFphvd0VgBZvBnyKrevob1gD+mnkEEPtjaEMCS7x
	 eai9zNGwOLQDd3YwX+w+fCGjFF5cNzmUneyW1VmZBjxtHvUrWzS9DabLPNKVwD2FzYf1/
	 WK/NFSHnb0Q4YdFSEDfCFbBQ2fugraGmRdzgyUoezQGufqMXRRg/06jBwsmF2ZI7xIZYG
	 WSi8iRoadzsbYIudbmRrvcndbh1cAfTWQqVTNgTKGDppsHhl1aKPBspc6gFmVYz0LkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038555;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sfTjKOSajMf1wfY66E+ZCAtL9zvEweN3E+SNMy4fiFU=;
	b=RodarNSJLuf3iWNQBbFV6ASGFliU+SqbODWYhbK+eHBHAq4EkzJOOiMWDFkOlDfujs3I
	 vfq9Mf8e6hbIzLyLo6uzhf0Wcvin3gVRvLadhJPDzimMi8vo2D9QJGTnm+701zZLJmMoF
	 DWAsjiGUVLdK597YUpydbN2Pf7+Wv1rWa5bTTXcL6YPjSYyb6LYqZNPGxzGuUZJcnYBO6
	 8eH2Ij6CVRpSUpEUY4uWsXQbN+pY5iwOiT9IhwQxz61Xx+ZQP5PnY6L6hmfEDy45TgN/g
	 imk/enKcXV+NdIq36szRvOTpOXfU5BAiTZjfy02gR1GFpDSz8V41C5SBw53zh9g2wNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eaHQHlNu;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F02E606A323
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F02E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eaHQHlNu
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e04773687so1098605f8f.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038553; x=1793643353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sfTjKOSajMf1wfY66E+ZCAtL9zvEweN3E+SNMy4fiFU=;
        b=eaHQHlNuME9DbGpBN+5nVC9RIQ0Zgq0wYE+XSlQKrqx5CquvwHGb9U5qj4rdZr0xcU
         WmKbW0eXUZCPcveuA4YOGElL12tiEIaAN/gNbKQpKR7UL1lEU0rgcFrdi1vo5SVAQjyC
         TwTwuz5azVidJGAvLXZufSBXem8Cr9xNXC5VkGuC338zVNatXtLJBGbNK1pIsPr7juw5
         dKyKrAwk1vjNJEbzgpw+V16cRk9Cua7sAcLOknFDDcsTwIeripUxWa6PWSRkNYgxlQbI
         NagD4PBkhtnkdNyZ/RwUy8Xz48gvZveKG/7lvKEqocRvE/59YN/yJOOJ1ZqQLE8jUM9U
         JS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038553; x=1793643353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sfTjKOSajMf1wfY66E+ZCAtL9zvEweN3E+SNMy4fiFU=;
        b=p31e+ov4gV4+byN45hEl4wA5XhVTB6NVMaPDq9e68ia1Bs/6LQPWLefDuUxWL9XOh0
         kXdIFJjFgbgC8KOofaE8zLcYBwsfDZmmFV5BY3hFOBCBUEhRKUeEFpH2ySuivjG+hcLN
         ifz7mJ+PuyND4gqXgqiGHbCbjjhAGEdBZH5WWmPxS/3DIRDl9N3ZmaKXM96ChoU2IkX8
         LNU425hXkh9+qaEfy/R7DIk/3Y4y80YUawyHFayfiyMd77bYGSpsfbOoGaGLjClhnRLA
         ReVFFBsu5/GUc+X/ffb6yeLHXA0bovt9Oacn+N/GRkldLrYoYQA7I+C2Op0AzNe8nrrJ
         aChQ==
X-Gm-Message-State: AFq9FYLhuGkUX5dkioNbo2ORc6I3C5lsVbJopNBxev10jFjlYp0cX/HP
	U25RJNltzBrK/QvxspwKJZLzWEVzPAnn2882QgWJlneOfbbQ+fR+2crypJoQgC6M
X-Gm-Gg: AYBFou2uwrqTCiwf/GzxNoMGGjQA4fVsQB0+YZWSUnGC2tKqtxLatqyX4mTBz6yS5dS
	knFxNDqqUWGqRtjvSTG9+P1I+jv+TM4wkHZN/RTey4KqOodY38Co1pzKDm9k/p8Q1LEdvtOW0S+
	K9GUoanu3f+PYNOjDHFLqQ1Lk73cbcDCHI+FUEEmFW5o03Sr3pul9k0O9zgw8BFUSjCEYroTemb
	saHNXuPLY1iyyzNLbMy4KSOmFjf2SnT707ZBPMt5yQnN54vci0y/8m5rP5wft7Uge2IBF/Y1Ujf
	/Ik0GChCCdkkP3zEboy3kyZb+JCnUE9SyexX4APo5OTq9IdojEzQ/yg4F+FnpgQOP8aPttrH4Nz
	mVPybZjR20gbHkvlVMNkNwee0vi4m80eTu8SQZXFpGSBmPDEcJlBKgbsPjEQP3NAYj4V4st1vfs
	nTtD8VZ24whDFKVRSbFkIUTC1FVE7+0is6H+xWkyzeRgENvb/RguLJTT4w9IrVwuVzoR/Aw4L+f
	ooyNv400CaANU86Yh70ceIjk3kt0rxWvQCOLaQSNmycZvKuYApahOXaLheYhKRGsfCnVJW41Crm
	lA8n
X-Received: by 2002:a05:6000:2206:b0:48e:b1a:fa3 with SMTP id ffacd0b85a97d-48e54a0a7f2mr2114417f8f.35.1793038553474;
        Mon, 26 Oct 2026 11:15:53 -0700 (PDT)
Received: from luca-HP-ProBook-650-G1.lan ([2001:b07:6454:c33e:6c42:b004:d90b:d191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20967847f8f.45.2026.10.26.11.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:15:53 -0700 (PDT)
From: Luca Casati <luk00casati@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com,
	b43-dev@lists.infradead.org,
	Luca Casati <luk00casati@gmail.com>
Subject: [PATCH wireless-next 5/5] b43: N-PHY: add the missing override to the rev7 TX_PU command
Date: Mon, 26 Oct 2026 19:15:43 +0100
Message-ID: <20261026181543.77763-6-luk00casati@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
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

brcmsmac's NPHY_REV7_RfctrlOverride_cmd_tx_pu also sets field 0x4 of
rev7 override bank 2 (REV7_RF_CTL_OVER5/6); b43 left it out. With it,
the override writes match brcmsmac and the wl driver on a BCM43228.

Found and fixed with the help of an AI coding assistant (Claude Opus 5.5),
by comparing mmiotraces of b43 and wl on the same card.

Signed-off-by: Luca Casati <luk00casati@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index cd50614ff..05e8ce19b 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -220,6 +220,7 @@ static void b43_nphy_rf_ctl_override_one_to_many(struct b43_wldev *dev,
 		b43_nphy_rf_ctl_override_rev7(dev, 0x4, value, core, off, 0);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 1);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x1, value, core, off, 2);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x4, value, core, off, 2);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, 1, core, off, 1);
 		break;
 	case N_RF_CTL_OVER_CMD_RX_GAIN:
-- 
2.43.0

