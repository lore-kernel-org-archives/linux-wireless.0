Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792594695;
	b=VmQW0P3Wv9at96AxG2l2oflq2FKgILAL5SgP6xhLqK4e6uXPZbfVtuBXxhSgGrGoI34G
	 U8iK+ODaHxBV/bScHVlTZ1burfkjvChrFKpgcwu4pFTkHs0IQxmrTJsONUT8Hu5HomtJE
	 dzCJfAV6ON2UuxYMB/awSmF3i0dn3JSRhIHNUfyiyYvx/1IlLEcJMWlf/qIWA3zMsccFQ
	 3sFJejKEpSBc8lVGrL4HKJ6KMdZ9OjHO/Txh4YqaTBt0QFAYi5z+xIQnNbTtaAkuoi4Xi
	 tbkm/bKGd6KfMPQMk40tJ0ZLGQsSxbhMNItjslKN2SX0FDDazQcFCw47eNjk4ZB6U6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594695;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hkWxYIZuoyGBV/b4mNoBewDUXIu1CyNuAuzdw5QNZA4=;
	b=tU6+ngsSFSeTxPSX64Voq/R93+G6DvoR5Y6GumwDmNIoAIT42H/Ct/caXBSx/Uk9UJ3K
	 3CkirpNzKGeZZNrWfQuG62nJ8O49pxxUo3p86XjwUeyGY+xD9spXqcy1m1tHDOflQg4/a
	 xTo9PTCPNBO1caDMLwFfOs8+TApoWT6LaaDsAGfkW9O0ODXC3iYvAuj4nD71AqKNCA9bm
	 0L/K/tLLu5F4JQaHCb+3ZN+L3v3IDThjFCm5qOeFKQw150PXW6jgrnVkVjSKc2JgLYsYO
	 wlqgN7PwdwZN7FsXqdMjTVNGsW/klj5J1061ZtyIN8CNfVNjFRtieprFmqDxxLxZq8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Fh8FwM8j;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D17606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 14:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56D17606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Fh8FwM8j
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-14fd9dafb0dso240126c88.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792594694; x=1793199494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hkWxYIZuoyGBV/b4mNoBewDUXIu1CyNuAuzdw5QNZA4=;
        b=Fh8FwM8jbElmwgtoQS1HHK0QJx9AmKU+OuV9nTsMFY4UTwasrRUUYdKWbBcPjND7KK
         BqwR1tw6OwGjTvhoTzI09KqvxOUn1tlq9LcpJZlg2AmR1mMxXOyVOXubc9J8JCuaxyI0
         U7GBNO+UPuCcFGRP7b5XWj6/A9gH8o8OOftCG6SOWvI53+3XhQiJQXNWyDn/kfC1xkKz
         KpYGhat+M7nbYms7Mb51UXi/Mjn9PbM1Qvi++1q0c1HhNuXsTHSjJSE73U5uS6pjaDuo
         dbU44Tnl602EholdY9Zwr9DxtR6Q92ZqYGMili3wMg1CLH9w1h2p0p2SYU9I2bUR51wV
         f6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792594694; x=1793199494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hkWxYIZuoyGBV/b4mNoBewDUXIu1CyNuAuzdw5QNZA4=;
        b=p2qv5t9QLaZYxLVKGutMMkYWqXpnkPaxqZ2pNc3rW7Qbs3j5yEIY6kHycL8tyUAee1
         0AtPfBQMxbZ0lnz6jC2fbppHpZx/UgBDad6o7dozt+q4PLqMkN0FcBGbXBEUsIbEozWu
         EBT2dUxb+RPFWpF6SIixnrZtsIcPl/qtuxTs3My0kVbnxP6gTIUNf6c4iV2dYsF23a6i
         hgodVqnZyUFdV9+k/o3eqW9ZdBOesl8sva/8G/Dr1hzrjGZa1rPNpR2wr6XW/5UomnHg
         xKu1G5SMmVy7JxgIguv/z2zCtpFHyg8KgHaKyFeJ6/f/7osXWrLGDPjL02mJ+/xWgBO/
         tguw==
X-Forwarded-Encrypted: i=1; AKwUvBzakhXY5Sh0zv+cxfmYmGmnq5nHCxGdxSACPqR+Qu4vVrB1rEkW9dawdlrfDmo+/coT7EksKDqqLiuhLgqlQg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8N2A3f7GdsPDSCAPp1Sh6jd04iVrgkQAxsiZfLgwkYgQBkrA+
	7LlCZ3h3wYY18wWgIK0GHfC4p5MLArbZUFRTY0o0KTmijXmoBqDdjvP0
X-Gm-Gg: AYBFou1FgYJNpBOy2v/wDX1Tv9+GjemuIbRpNMqspRoTwiP/sISYvJu39uULCs0xRx6
	TpRNpE+QsVnctq8CFHeUJNJkXtIyhIPRPWAX6ItblD3nGPvD7m+jp7TiPOtDnFRuR1XMekUJYoT
	vn8ckU/+/DNkjt6vq4TsMtUqmB2JW29On9mQUOMRQnCJJB3NCg990XjvkhHO9o3cBAIS97C8acB
	2GLRjbQKe6B5k4qNRh4mRQmSN1QJYo8Gtsj0PobILZdFNH3KHQU1G5PVnihdl5myKS2WC3h3wQd
	uw5ION/1wqyF/57Wl2vZeE39MtxJeLkmp0MewQGHjnBXXBr6aPz8+YmSUTg160j7pwiJc8Nhe2t
	l6TY7v/d3Rn/5KuDc5Z15ekkcaQb0aShRHqdZ11x1ErgXkyHX5CulS9GJ1G1DGbILT4remyXIds
	ZKPR9onEYPjFujGhaEdcN9AuG8HvhfoKQBQyGlb6i7sk+xQNB+oi/s10tUTfOl7DE87SEBmu2lW
	rjnwg0J/FKPWkoIlLK5FB4PeB3CM29lxkh9AtnmlBPfv07mD70EgVtZ/Ojrw7wsvl4pWRZpCOY9
	uLZPXPUp+ApeYLXCFKcNDpG8xRcmGxlvXpNZ9dz68CyjoGGmaZdev2kc6ACuoVqv2J9MnvyC14t
	IxgXnfGEHIRyW/5y9x/A=
X-Received: by 2002:a05:7023:a89:b0:183:3140:3ac1 with SMTP id a92af1059eb24-190a599a2damr3082389c88.24.1792594694400;
        Wed, 21 Oct 2026 07:58:14 -0700 (PDT)
Received: from dell-pro-max-tower-t2.cse.unsw.EDU.AU (pag-t2-pc.cse.unsw.EDU.AU. [129.94.173.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035926035sm6213108c88.1.2026.10.21.07.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:58:13 -0700 (PDT)
From: Weigang He <geoffreyhe2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: reload TDLS header pointer after skb_linearize()
Date: Thu, 22 Oct 2026 01:58:07 +1100
Message-ID: <20261021145807.3018338-1-geoffreyhe2@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ieee80211_process_tdls_channel_switch() sets tf = skb->data before it
calls skb_linearize(), and reads tf->action_code afterwards.

ieee80211_rx_h_data() queues TDLS channel switch requests and
responses to the interface after pulling only
offsetof(struct ieee80211_tdls_data, u) bytes, so the skb can still be
non-linear when the interface work handles it. Drivers that build
paged RX skbs do this for every frame that does not fit into the skb
head, e.g. iwlwifi (mvm), which is also the only mac80211 driver
that sets NL80211_FEATURE_TDLS_CHANNEL_SWITCH. If the remaining data
does not fit into the tailroom, skb_linearize() moves the data to a
new head and frees the old one, and the action code is then read from
freed memory. Depending on what that memory holds by then, the frame
is handled as before or ends in the WARN_ON_ONCE() of the default
case.

The frame only has to be a data frame with the TDLS ethertype from an
authorized peer, e.g. relayed by the AP from another station in the
BSS; the read happens before the sender is checked to be a TDLS peer.

Load tf after skb_linearize(), as the request and response handlers
already do.

Found by static analysis tool CodeQL.

Fixes: 8a4d32f30d11 ("mac80211: add TDLS channel-switch Rx flow")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
---

Notes:
    Compile-tested only (ARCH=x86_64 and ARCH=arm64 allmodconfig, W=1). Not
    tested on hardware, and there is no reproducer. The frame can come from
    any station of the BSS via the AP; it needs an iwlwifi (mvm) device, the
    only mac80211 driver that sets NL80211_FEATURE_TDLS_CHANNEL_SWITCH.
    
    The CodeQL query behind this report was written with LLM assistance, and
    the fix and changelog were drafted with LLM assistance; I have reviewed
    them.

 net/mac80211/tdls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index f663d28d9209c..71db07aa301b7 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -2021,7 +2021,7 @@ void
 ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
-	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_tdls_data *tf;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	lockdep_assert_wiphy(wiphy);
@@ -2037,6 +2037,7 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 	 * The packet/size was already validated by mac80211 Rx path, only look
 	 * at the action type.
 	 */
+	tf = (void *)skb->data;
 	switch (tf->action_code) {
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ieee80211_process_tdls_channel_switch_req(sdata, skb);

base-commit: 71a77ab76e74131a101f4d2d2afb0dcbf81b4e3c
-- 
2.43.0

