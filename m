Received: from mail-ua1-f97.google.com (mail-ua1-f97.google.com [209.85.222.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941E7368D4F
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093956; cv=none; b=LsVzL1BNbRSjFUu8ZRz2MJAORqdhUXlcgsy3QQmaOtVunMgRKuZZD6sUqQ+Yx5A+Cvi9jax2643OmnjkBah7Bdtlsf6d6+poN8opIykZIlpl/D179WaetcvIZCz3hY4zSlHD/b81/R3O5hyEoIH+CQg/ZmUH8HC9nxbt9hNySs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093956; c=relaxed/simple;
	bh=hcohRlpq8qr6Iln6NBE25urI5BiALzMz4vzUbZ3NqLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inGhutY/Ke44444Yjl/yQCasVxPlZfeBx1y8GYJyik2QHmB6SBlDGBHEiPCk10vw8TTkExtEDNTMsVal6LaPiqgGWZlowirPfhHk3hbdYhclMQtD7bjmOuVOl1YISK2bRYqyuhBr2QqEWRcr6xSNFHR/eIlDnG8A+fXrxhUpZtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MC+ZJl8g; arc=none smtp.client-ip=209.85.222.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MC+ZJl8g"
Received: by mail-ua1-f97.google.com with SMTP id a1e0cc1a2514c-966d70b9e1cso1302588241.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093953; x=1785698753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CsP0cDJTGhn8IIzqW9flLkfEOO6Wkwk5wNmVMwSOrV8=;
        b=rpMq+CX3TBCSOZI4PcqVP2WbbFLyzeqErL0W/92r3w1NxQzGWLVATso1W08S9eAeW3
         FhkFHzQbP7IUlbqwLHNv16yV7FpxwU+b1OFQLIx/t/BHitUmcNIO8fnnzTfgAoqpwkHq
         /dWGtSt/y3SuKK9whBG+MX7WQkEvMORNYpQ4rhTFrcB8Bz5qt+e5r47+W2FRxtXMHrcp
         dgSqV/tEpk5J3r3kRco4QsIWc8URtspQbmCyDBziN2u/R53yCbe7N+TgRmOtzxaUc2Qu
         TNHk/Eqquv+TLLu8GF71cTWLncUmJERvOIA/oZ6AdcFPeMsIN/6cQJavjSYrn6bVinVt
         oitw==
X-Gm-Message-State: AOJu0YxYpqassQ3bwaOxzR7BxWAM+NaLPQ0Z9q6goAsikJwmdvy4K3Ny
	9bQN3VoTnlcfPRWsdqaC0X4IwSb3BRmbstVByHHNTdFkAXf65JWeYdejnix9DK6g2b71hEZ0tuw
	nZsjpOpinHqWTx8zWJXR8/kxACxWTqd4y93vYX0OlLSP+uE75y2kjL7z7tQIYW+T3ahqoJ4JJen
	9xz2a9J5u9YIzgDloMjJgMS6IGPcErGpxXz8rqJ+kyvJzOshCRuU2TMgfmeo8/LkZtNKVyBLnmB
	6yBIssUcRaVg6HYh6tj28SYLH7S
X-Gm-Gg: AR+sD12t4KwTjgEvkD2ZIN/GIfjpYnmLyopchJT4XRgaDavTxwl8TGPgYpt3pKCzbZU
	6qKdXaGHupwCPUdus0bniTON+jYyrpqY41PrtftZFgcbiiKOjOkYLUbcqtFWReRzDMTzmItVCBb
	qgPoafE7Biu3yFp6myMEJAPrLDbUn+E/x3HYcsvDDzV2Yg2RYBSzb3NUg0iPLc6l+jAYA4EEh+u
	WODXx9i3c/fHXhyfh3sha7zJ1lDcx+l4BcuIfGnOG31PNBib069jxJTxWX5I3iFsCoSDYgtZclu
	MY83B8Cv/UISdn1H/FJF71GkkGtMaruJEjV/kk1BwsMhLo9zUO3K36XclvnrJJ3CdNnp9ICDRSj
	soeXijWseRQD8eWbkhnfc8HnnMnWVyq8ddDOOpIweNWeR+vDBy3Ip8Zg2H3c3CqUviCdtgxhQka
	d1HhuEyUmyQJqAEFrjFI0vyf/DYlb/cRRuCrICu/s=
X-Received: by 2002:a05:6102:a49:b0:74d:cea4:df9e with SMTP id ada2fe7eead31-75040bd39f6mr3678406137.23.1785093953328;
        Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-750362f828asm374652137.24.2026.07.26.12.25.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e5a616d07so218492a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093952; x=1785698752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CsP0cDJTGhn8IIzqW9flLkfEOO6Wkwk5wNmVMwSOrV8=;
        b=MC+ZJl8gzKReOL4LC+uk9Ahsck3I53egG8bK5I70/+J7ZIhQdBbAQ4eQmESZ5kpNPS
         pgEBb7kaozZUrAKy8agjcAW7k3BT8iVbarO5wpc7NIqltOfVSRHYLYeLZlF+whXNjS+i
         ozrYWtOy3VddSeAmMvs9nFiV3kmZn13GkAFVU=
X-Received: by 2002:a17:90b:3c08:b0:37f:fd1f:d30f with SMTP id 98e67ed59e1d1-38f294ea11emr5530475a91.12.1785093951941;
        Sun, 26 Jul 2026 12:25:51 -0700 (PDT)
X-Received: by 2002:a17:90b:3c08:b0:37f:fd1f:d30f with SMTP id 98e67ed59e1d1-38f294ea11emr5530468a91.12.1785093951410;
        Sun, 26 Jul 2026 12:25:51 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:25:50 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 01/10] wifi: cfg80211: pre-assign cookie for remain_on_channel, mgmt_tx, probe_peer and tx_control_port
Date: Sun, 26 Jul 2026 21:25:32 +0200
Message-ID: <20260726192541.2816743-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Having a single place for cookie assignment and keeping that
responsibility in the cfg80211 subsystem is a logical choice as it
handles the userspace nl80211 API. add_nan_func already does this:
cfg80211 calls cfg80211_assign_cookie() before invoking the driver.
Apply the same pattern to remain_on_channel, mgmt_tx, probe_peer and
tx_control_port by pre-assigning the cookie in the nl80211 command
handlers before the rdev_* call. For tx_control_port the cookie is
only pre-assigned when the caller requests an ack (cookie pointer
non-NULL).

Drivers may still overwrite the value for now; subsequent patches will
remove per-driver cookie generation. Update the cfg80211_ops kerneldoc
to note that the cookie is pre-assigned and drivers must not modify it.

Assisted-by: Claude:claude-sonnet-4-6
---
 include/net/cfg80211.h | 12 ++++++++----
 net/wireless/nl80211.c |  5 +++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15c08b24502f..a30550f356ab 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5048,11 +5048,13 @@ struct mgmt_frame_regs {
  *	channel for the specified duration to complete an off-channel
  *	operation (e.g., public action frame exchange). When the driver is
  *	ready on the requested channel, it must indicate this with an event
- *	notification by calling cfg80211_ready_on_channel().
+ *	notification by calling cfg80211_ready_on_channel(). The @cookie is
+ *	pre-assigned by cfg80211; drivers must not modify it.
  * @cancel_remain_on_channel: Cancel an on-going remain-on-channel operation.
  *	This allows the operation to be terminated prior to timeout based on
  *	the duration value.
- * @mgmt_tx: Transmit a management frame.
+ * @mgmt_tx: Transmit a management frame. The @cookie is pre-assigned by
+ *	cfg80211; drivers must not modify it.
  * @mgmt_tx_cancel_wait: Cancel the wait time from transmitting a management
  *	frame on another channel
  *
@@ -5107,7 +5109,8 @@ struct mgmt_frame_regs {
  * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
  *
  * @probe_peer: probe a connected peer (AP: STA MAC required; STA: no MAC),
- *	must return a cookie that is later passed to cfg80211_probe_status().
+ *	uses the @cookie pre-assigned by cfg80211 (drivers must not modify it)
+ *	which is later passed to cfg80211_probe_status().
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
@@ -5218,7 +5221,8 @@ struct mgmt_frame_regs {
  *     user space
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
- *	tells the driver that the frame should not be encrypted.
+ *	tells the driver that the frame should not be encrypted. When @cookie is
+ *	non-NULL it is pre-assigned by cfg80211; drivers must not modify it.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ac0c0da45241..bfb3005c23a7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14630,6 +14630,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
+	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
 				     duration, &cookie, rx_addr);
 
@@ -14871,6 +14872,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	params.chan = chandef.chan;
+	cookie = cfg80211_assign_cookie(rdev);
 	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
 	if (err)
 		goto free_msg;
@@ -16359,6 +16361,7 @@ static int nl80211_probe_peer(struct sk_buff *skb, struct genl_info *info)
 		goto free_msg;
 	}
 
+	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_probe_peer(rdev, dev, addr, &cookie);
 	if (err)
 		goto free_msg;
@@ -18574,6 +18577,8 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 
 	link_id = nl80211_link_id_or_invalid(info->attrs);
 
+	if (!dont_wait_for_ack)
+		cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_tx_control_port(rdev, dev, buf, len,
 				   dest, cpu_to_be16(proto), noencrypt, link_id,
 				   dont_wait_for_ack ? NULL : &cookie);
-- 
2.54.0

