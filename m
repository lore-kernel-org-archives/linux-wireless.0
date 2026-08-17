Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273FA3E4506
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 23:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009730; cv=none; b=mhmM5rCW342UaYUKphvjGqD5GIrY0Yzf5GDdX2ZYuFlMKpePathHBa8JBJlN3nbyu7z/LFZaUUsbF7rG18AYBXWLVre+bojkjGO1sBSCCf8ymH/h4OEbg4qJjuk1pxB0wFL3u47St7YTs6mSCxPBITMJymK3aYCW+DalBUlmTw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009730; c=relaxed/simple;
	bh=+FSm6Pd5Qrc6WiSlUy8cufs5ZsMoo2RzLUPmBaAh3L8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G2uk88RLY75zkIYW9lsGd2Pwr90uw+CdZwaOHXmJidt7sTUkURVz4tUwrJkx1Y3f7HuEAlPRjdhVpWJeP56CNKHgXT3UB+crkv+cFLIwAVN2Rq7mDFUerUrvf8+p3vAjLzY+lRzMyG7xG2wk+gbNuRokCK0lOd3yO4Xoi8EEWSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPp5XdRX; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPp5XdRX"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-97bf90f4b41so1647089241.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 16:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787009728; x=1787614528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qwqA6q08zrALDjNDnvuQJbv08KYcmrebUvDWpLD8J6Y=;
        b=iPp5XdRXeZMYMM6mnNOID/5afVPax3pItw97e29YrvRiF/O2fIG/ZiyRr7BTXeumeS
         5e0I7RCA9NDdby/J0xm+dEygWZixM7jgdpr5QTeKNZ6Y8r7VnW9vp/8z80jeET8IHoMU
         DPd9GpbbOtkpEVUGFKySiV98zZlh1iR7waKjitqs5Iwi8hd1K8XDvXslNadwEx4Cj2k8
         1sbJgcmfDD0HY0OWw3PDSIwIKSi19Xwu4yA5mh7QfVSwWf/QBIczBadbbddD7u1lHuSE
         LqScDOXtOhVYUE55IRf49oMPQRCQTvEM3PpVxtok6geW85dDoeCLHHfB/CuZmAIrrlcv
         fdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787009728; x=1787614528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qwqA6q08zrALDjNDnvuQJbv08KYcmrebUvDWpLD8J6Y=;
        b=g67YHlnhkIgtRmQaH87sEOZSuKttU+8Iuokvj4tYsjhaI0DmPF7EplhsvJnNxhRDlP
         G70B+fptFlTcIb9qsJgKVjILRlQ0/NZY1MQK8Jz9RYqMfLHTxrqcHBw/uXtPIls0l8iz
         2mjhwU1JE3+7UxBtpUXdoQ3RXEJDFBAJscwkPJiGssOubdp4vUoqmldJJ4Ey5ksvhu6M
         hqOptcT68EyOFa9QwztutYAhNZnT64+XtGcRJJrRLAIUojajGGU8TKiNA8u+VD26ybH5
         LhCBLCJwtoY8p40i1IsK1tHQ9+D+XbWzoxFt/X7bAzZPIOzpQd8Hzxh9epoNwdaU7MTT
         MVAg==
X-Gm-Message-State: AOJu0YzJcI4HcEQgUk/D9fzsH5HNnTSF9vAI6FF7V2gmF2ls+L/n1nAH
	/R5RHw4PTZWN8WOmWQdKbyfqHhhstPFCMPkkv8Va7bGUrI7bBj5dancpRVkL5g==
X-Gm-Gg: AR+sD10JVqRfiXfgk2/ppef+FmXVZABjp7WUMWlkFdCSVh7Zb9e1ko01bfb29speX+j
	dmYqL+wBSGOTDZtp34Wt7209a5x/sxkR9DuSpjnCDB6eDWrUHkT7pEMZsJQDRjC0p0qax8ThxA5
	J22Sx9AwrEZl4ogzzMnouPamjJ5XaxIjhA4y8nbXNvy6j+sbRYg8E8il41I350KyGTPo84xms+Q
	47z0oDADnfDi64DWX7F/2HNV3FasmpYLqVPH1W/bpDaysyPDHSodt/4fSDLB3wkJerD37hWT0Ai
	NYFUjpBLNk/NQeAFtHbDtR8Vlj9HhWvuespKhwYQcUPIjVNVcd66IAZERq8IxJtqpZPOpBExaGa
	rGUxkcETt2IkpRFo557KTBEFst6h2Qkwnxd/PF6oWSgZCr2aYIApIPAzASpwG6LzHiJVQL9Np5V
	czk+w4hra5SSNRUoWmAu8FGzakcLq063quDHMnSbyMm4STr4Fa62Y3XodiQLn0nRK45lEm9Cmd8
	PLuQ6iWha2ZXmmVQZGIRB4yGU2RvIbeJFDWbZLlim8jsg==
X-Received: by 2002:a05:6102:1496:b0:738:9c30:2b7c with SMTP id ada2fe7eead31-76f2c541b8bmr6683493137.6.1787009728024;
        Mon, 17 Aug 2026 16:35:28 -0700 (PDT)
Received: from fedora.fibertel.com.ar ([200.55.79.212])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-773c3111383sm1966240137.4.2026.08.17.16.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 16:35:27 -0700 (PDT)
Sender: Mariano Baragiola <mariano.ignacio.baragiola@gmail.com>
From: Mariano Baragiola <mbaragiola@linux.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH] wifi: mac80211: avoid trimming injected FCS twice
Date: Mon, 17 Aug 2026 20:35:21 -0300
Message-ID: <20260817233521.2747027-1-mbaragiola@linux.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When packet sockets use PACKET_QDISC_BYPASS, mac80211 can parse the
radiotap header while selecting the queue and again before transmit.

If the header includes an FCS, both parses trim the skb. Validate the FCS
on both parses, but trim it only before transmit. This keeps queue
selection read-only and avoids trimming shared skb data twice.

Fixes: cb17ed29a7a5 ("mac80211: parse radiotap header when selecting Tx queue")
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4f95da023746..0becd3361010 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7615,11 +7615,12 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
  *
  * @skb: packet injected by userspace
  * @dev: the &struct device of this 802.11 device
+ * @trim_fcs: trim the FCS trailer when present; validate it otherwise
  *
  * Return: %true if the radiotap header was parsed, %false otherwise
  */
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
-				 struct net_device *dev);
+				 struct net_device *dev, bool trim_fcs);
 
 /**
  * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..fdac729ca580 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -964,7 +964,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 	/* reset flags and info before parsing radiotap header */
 	memset(info, 0, sizeof(*info));
 
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, false))
 		return 0; /* doesn't matter, frame will be dropped */
 
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 91b14112e24f..97990039695d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2097,7 +2097,7 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 }
 
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
-				 struct net_device *dev)
+				 struct net_device *dev, bool trim_fcs)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_radiotap_iterator iterator;
@@ -2154,7 +2154,8 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 				if (skb->len < (iterator._max_length + FCS_LEN))
 					return false;
 
-				skb_trim(skb, skb->len - FCS_LEN);
+				if (trim_fcs)
+					skb_trim(skb, skb->len - FCS_LEN);
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
 				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -2470,7 +2471,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * selected chandef above to accurately set injection rates and
 	 * retransmissions.
 	 */
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, true))
 		goto fail_rcu;
 
 	/* remove the injection radiotap header */
-- 
2.55.0

