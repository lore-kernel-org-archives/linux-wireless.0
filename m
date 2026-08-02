Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5841B85F8
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 23:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785712860; cv=pass; b=jkbYsNwPhzfpXdfgO1pZ6J0IM1XzTzQJhAVUcflM0YyYPhc9W/sBtdigwatxHlUkR27DMRC9nV7j7gkeoxjQ7VhGJmvWm9MYaiWmo7I5Nq5Xc48zrygfzfmQvq4SsgqNLUShHveIijfLYI1iLByR6v2XPedVBDNxXWznGko9OdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785712860; c=relaxed/simple;
	bh=tAiHNJtpvqnW3mJ6Kge49v/UVlMR4ZICyQmhRm4uowg=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=lh1L3Y4aQkMea1VYSi4qQpEwBx6hQlaNhjUUdKQQJOr5Up+cotPQiqnIaKjoqP6iqFarG0LjoZKLQgkZ7Fcoej4aC/0J3ovn2jpzAAdPPojgnF4Lr8F4M7taSpIzIxugCQBo1SB+QiVyWFBhQSQIhH8me4O50EmZtwl9H7E8cJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s9P/ED1T; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s9P/ED1T"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so428842666b.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 16:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785712857; cv=none;
        d=google.com; s=arc-20260327;
        b=Cp64EaXmqIgTsMEhLjRuC2CK9nhBLp5g19qQ3x14AIXuzTi94bc7+PYTHTQ/Vfqf6b
         /zVh39po425xBT+r8P08E5ZGIyatNsKk0YdSlu1Pe4KvXW3VpYk6YZSMlrnHmT29N7li
         Ppx2NV1jKIxXQmFGFr7fcu6xB29CtVJA1ZZgwaeq1fXpw/N3tdgb3HFWfkLkGq6eKHOZ
         BxOCd0AqEp/eL08zHfVZVWntF8JN8IcwAGKhUb3YN2bPcO04xE4q7CvXtFR9vHdUdqk+
         SUDWir/T2FM8wgE2FDBWufrZPYHyiKnr0h9eYOzDV0yRbwOGB6dkLGwpW37XmI0wnL3N
         V6+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=GpnhTy9VhTfgus07R9luoxqIJ3Uscqq/lVYAIyMKBGE=;
        fh=RzU3EvUoyFmgsUV8O/iTIYF4lyMkb8A7UDHZmMaZVNg=;
        b=hFqHz6C4wyj1HJm6sjcVgDzoSVX7XTxMqS43HbdU412RwpPRc247INAh1kEnSp9ngU
         CwBn7Q+UVokBdozSVxvsTtH5eqW/5n+OAAEJHOVWMc9Mf1cOfoc+3apAAwc1DqGxAxO1
         Tzh12jO5VZ8eV+oUo8uoBdo7hkZ/GdYeMGVnk4ubknmt2G+/eZW1e4Frbt3J2RawMavz
         tZ5r7iI8ebsEyQ3PRW5mjCu8kzj5Y+uq37AWFBZ9WBkIvFu7a5YXemrs2S2BOkedampE
         mf0IsYHP9rinxPhy4cc4wT2nQxiUXrERfqgrClNH0hE/M6f58BESNoQgx5OyZB8AkbFF
         gLUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785712857; x=1786317657; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GpnhTy9VhTfgus07R9luoxqIJ3Uscqq/lVYAIyMKBGE=;
        b=s9P/ED1T0mQL42M5bh5/+OVAeIwyXINCMp5jLDCO3vfFhDgSP+nXOwhwXhHPBJK/Tt
         y30degv+rN/NygGCafWhTqav176WbYz6cUHmmB7IVc6+hCKZHWu0wrjoAF1YqOMXc11i
         tLcZ6TvIrcs+DyTmjkPPkWDnNuD18q+wyx6rWp6W49j630/s0OXTRfgIbJbtwUzu8GUJ
         e0I3DgU8v6aeI9XDtRE/kS0P3TRjoENtUCQT2kZYE4sb5IUaAo+J115NO/susWSG1mJG
         8NRIzH8cxwpTGY3/mOoglzNGo2zgp9gtyfw7I3czcXsG2GMaWWSGzbkNM8MNsE7ol5vD
         uvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785712857; x=1786317657;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GpnhTy9VhTfgus07R9luoxqIJ3Uscqq/lVYAIyMKBGE=;
        b=TG431kMmr60+3/i0/Zft0gDLeigfITJ2WyBCfPsiwp6twsw0bk6lv9haaV2k2kClwd
         XlIWGdyb6ptq2mZoYJSeb/157qIpEoT+L3/5RAVAvalWHIJh9Hq0qOR9+cKfMDtLczW3
         48Kf5dAkXrFBtN3wkTXvA4hRFuCbXeZY61JWvOHTE8ECjREMFtJhoaFtUL6cU2+Hm0XY
         pzfkavBPvTwP5b5z0n359d1ZjeXowqL+snQtEWIcmB7CWqqfkkNfZIQKMpimjrgvXXod
         uNLR/xV9sWC6Kf7fqqKj5Vkgkdp9LiD+qE7IfXgrVBuWMb150vxF2c/YtHnfGAUJEZkm
         1xbg==
X-Gm-Message-State: AOJu0Yzlu7cI8IY8+ZrDJ/fSzkpBFmuoN7cFJM4LKuHqEmjoSxmVDA1f
	vehDbJARWVCy/6tzQJirZL14I0JuOELxeJycwzRsk/3hUwARahnbR9WsA+mD8dNQ1T5sDYF8rkm
	64BWErKBRBkEncHiQQahqx1LWLSL6zWDJzA==
X-Gm-Gg: AR+sD11rMelVTP213TSR2uB2BzmN3LDgfxOn7Bt7RWHYBPmeUWG1JOBF3PQvwP7GUdU
	zHF65n2DAsnvRok0XUqn8/FIity6xYZ3YTKz8jsa1fJYPdVWTJAh5eCxtjeYM6y3QGLEUtq9hGA
	z5cqGi8AzoKPQ7vqOAPbguMPPPqY4AQMi4M9dYFB7zW9ISWLdaWKGlDRWo2AVSPAt/aqKQjky5W
	WthcJf5F6wsRsB5neR/87+XcqXdAo2qmOHmW3lSgsXy49h2cpi0ftD58uNMAJg7q+aHJttvBYK3
	gv3IEMesggfJn+l6fXkMqP127ea5aTlMpH03M3U8cm5WV/fTeaIWRCjTTHuLdjn3Jx1kMJ6+ojf
	CaUE=
X-Received: by 2002:a17:907:3c93:b0:c1c:64d4:5ba3 with SMTP id
 a640c23a62f3a-c1fe7efb692mr580583966b.20.1785712857015; Sun, 02 Aug 2026
 16:20:57 -0700 (PDT)
Received: from 24047573820 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 2 Aug 2026 16:20:55 -0700
Received: from 24047573820 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 2 Aug 2026 16:11:40 -0700
From: Facundo Karanik <facundo.karanik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 2 Aug 2026 16:20:55 -0700
X-Gm-Features: AUfX_myBTVGBJrkfBlzC96giSapLxO2U7AxY6YzFQS9SLnjdrqlzc-JzU3yaUGA
Message-ID: <CAHNRTq83iAAFyYNB5D0eg3HJggJNq3xjO8Z1zi9=+yGe4uy_Lw@mail.gmail.com>
Subject: [PATCH] wifi: mt76: mt7615: skip MT_TXD5_TX_STATUS_HOST for MT7663
 group frames
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Under the right circumstances, a broadcast or multicast packet can remain
stuck in the firmware/hardware queue. Following group packets then stop
completing and accumulate. On my system, this appeared as excessive airtime
queue limit (AQL) debt, which eventually stopped batman-adv traffic on that
interface.

For a packet to potentially get stuck it must have the
`MT_TXD5_TX_STATUS_HOST` bit set and remain pending while group traffic is
held for the next DTIM because a station is in power save. The queue stalls
when such a packet is present on the queue and the final station (still
treated by the firmware as power-saving) is removed, whether explicitly or
through normal teardown after the client disappears.

In summary, the packet must:

1. Be broadcast or multicast.
2. Be pending under group power-save/DTIM handling.
3. Have the `MT_TXD5_TX_STATUS_HOST` bit set.
4. Remain pending when the final power-saving station is removed.

The fix is to leave `MT_TXD5_TX_STATUS_HOST` clear for MT7663 group
frames. These frames normally use PID 0, the no-ACK packet identifier, and
(as far as I was able to find) the driver discards TX-status reports
carrying PID 0. The report therefore has no consumer or useful
per-recipient result. If a future path assigns another PID to a group
frame, `WARN_ON_ONCE()` records a stack trace while the status-request bit
remains clear.

My broader interpretation of this failure is that the firmware/hardware
does not expect a host TX report for packets that are not aimed at a single
station. The last power-saving client leaving might have been enough of an
edge case to surface this expectation as a bug. This is speculation, of
course.

After applying this patch, every single packet matching conditions 1, 2
and 4 cleared the queue without any issues. I also did A/B testing with all
conditions present. The stall occurred in 100% of tests without the patch
and 0% with the patch (which, of course, removes condition 3).

I let it run for about a week without either the stall coming up again or
any regressions showing up. The hardware used for testing is a TP-Link
Archer C6U v1 (MT7663E PCIe), running OpenWrt 24.10.3 and Linux 6.6.104. I
do not have any reason to believe this will break on newer kernel versions
or different hardware, although I was personally not able to test either.

This patch very likely solves the issue below, but it still needs to be
tested on that setup:

https://github.com/openwrt/mt76/issues/598#issuecomment-939419710

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Facundo Karanik <facundo.karanik@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index aad232c5a6fa..5c846f136961 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -823,8 +823,21 @@ int mt7615_mac_write_txwi(struct mt7615_dev *dev,
__le32 *txwi,

 	if (!ieee80211_is_beacon(fc)) {
 		struct ieee80211_hw *hw = mt76_hw(dev);
+		bool mt7663_group = is_mt7663(&dev->mt76) && multicast;

-		val = MT_TXD5_TX_STATUS_HOST | FIELD_PREP(MT_TXD5_PID, pid);
+		val = FIELD_PREP(MT_TXD5_PID, pid);
+		if (mt7663_group) {
+			/* Host TX status has no useful per-recipient result
+			 * for group frames. On MT7663, requesting it can
+			 * stall group traffic when the final power-saving
+			 * station disconnects. Force the request off, and
+			 * warn if the no-ACK PID invariant is violated.
+			 */
+			WARN_ON_ONCE(pid != MT_PACKET_ID_NO_ACK);
+		} else {
+			val |= MT_TXD5_TX_STATUS_HOST;
+		}
+
 		if (!ieee80211_hw_check(hw, SUPPORTS_PS))
 			val |= MT_TXD5_SW_POWER_MGMT;
 		txwi[5] = cpu_to_le32(val);
-- 
2.51.0
