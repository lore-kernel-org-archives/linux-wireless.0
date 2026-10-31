Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465519;
	b=3D/zwZ6Kfjm1KU77mAUCMvWGkfiMuaweD8daNVgwNQ+bL0KIvx/UWCxQQlrXU059IE51
	 kt5+qRz3t+938T364V+VgfJYVOFRYmT84R4MrCNNZXEIgVrW8NQYfV0TRgoYdOEX1YJFN
	 ThVC40dO7VCk4qSOycHnnF3IrPpZHYS3oLCmIZPtt08VdMRBnyh7eZftjrjiREFUoUMIV
	 Uw22D2+94R27aUIhcT7o6l7kYHt0PC9HrCqXS+y43ayQsH3XJNhvFlOd1szm3oRg25RZ4
	 dhqw/+cG8esLnfj9+D/CFughkwLtGSfTdaFwhjgRk2/DXIBW0vmlXtrnknkDuojOXXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jPvu2Otwqk1FO2ajfraBIJoTH3eB7PsOsvLJH73JLK0=;
	b=PsY05B97KzObPiC3do2IkRab4Rw90sNKohnZ6GMl9OhfdD5FSyPVhSyW41t4WrBxa95Q
	 veWKKhvSkvjghkugOW6EN0vU4M9EnwElrS5kOTS/uCqdyVRZPAshFETkrf5kyxCUjcLnR
	 NHFRzP55y4n2kvbv+coaaUENvXvLQRsnzMYpfTdzJfWpJtwW/sFP5MLKAkqXLqX7f24g/
	 nurfS4DugPhBxzBjv2091lB+5oNTAe8N6fz0HPRdvmTCRg8qWvl4TLx9A4wYEYsSkO4rd
	 ymzzUjSNXIx+rNxQ7svYwatc5v3wJCloF8KpGaUY2MWEOb6E39PhTaRa7tqTGAnybOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xfBhX+Sn;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A36606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17A36606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xfBhX+Sn
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1846bc43c28so1969669c88.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465518; x=1794070318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jPvu2Otwqk1FO2ajfraBIJoTH3eB7PsOsvLJH73JLK0=;
        b=xfBhX+SnxL8TraDKRz4tKHWN+lCQ1MQKg1J/if8rsehSu9UW8BreZC6jmaDixrV8Su
         RiEXd/2HkWjPY+8NkbJKFzbRZX1FcJrnzXwC8LzCEXvlgVxp2B2xodulhZuvB31o/O42
         40D3WP2maDnw5YQWkSa1QIvOaeTKKi/6KEgzB93p0XyDhfmHI+GKsJAxF3T9XI1Lc6ek
         c/w4Sn6NwGIllepHj9vbPk4bDZ5n1rnN+QJXp6GhH4ZL4v5TYAfPLRLFEZ1yKuAyC3tF
         nHQWymubScMq10UyBXe1rzjhx8+j+hyimwfUbSFbPdJxrsZU8wPaPHOoynvtLaEQuXbD
         txFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465518; x=1794070318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jPvu2Otwqk1FO2ajfraBIJoTH3eB7PsOsvLJH73JLK0=;
        b=Zp+cDALg0L4urAQfug+fqbHjvQX5z7NPtXKCv05XTXBtb02xVmyE1g3GG3zkWgoA6W
         9PpV/y4HfWDIPlBtjWg8coHOk1GsWZLNO6HmTaiBA965sTA3vueDl2HnJpVFyJTOhDt2
         jx8uI+z7biLpSPcfJU7ghcYlqXG9beeytaTCQRpD7h3U8+cTa9bHYk7iDMLdmZMqTm3z
         K3MPelc+DeEgv314YUKDWDXBNQQPVjuPYBESt2wgZisNsZ5V+ZvfbudI/Tlf3vqOU+w8
         s6epKFHptR8IpLTxnx6YPfksU2IDL6SzFiiBdtzg3I81uZMdVtoicKH97Alj74O+qMBU
         dXLA==
X-Gm-Message-State: AFq9FYLLeZ51PTp/faFvGdk5+EnLZhbk1T3qcpceGYaSPjd8zKywC+5i
	ZYJhvw0U86VkuW3YqXxSp2OZb1zBMwm3tYPSBwLaJUtmA42DLuG07bFjI90/ZpS9
X-Gm-Gg: AYBFou2928wAVz+e7VqcgE5GWvU8LELA5qDSBqiipsa/bHIkOQQ7VqnZUZwhAjETn9Y
	BnfQU578KynFIVC3SfWho9+BCgpyOnhMPYgu56ruXdixp2XAFQFE3b0XLCEnr+yiHJsHce2jNbD
	aY+lLDKu7j0sH2YJCh9+1/rPPPm48MuVHI0Qs0E1e2cqJLB90tUD9BtSGCAK0d8CwihbEeLKX8q
	aflFUcGcSpPFSAeyHhsASLkzRFws+Wrnp0YO3antWrcHCYCHt9E6z6wiMT3iMK4GyO0k5R/gqFq
	dVL1hhxZWdfsmupzRorpAcayLt9qOuCiUh5ZvBEsXlfpP7SyPBaA3R00YmVwmi6P2TwOIoKqTxB
	kpxUm4pC3kbkwagDQ0Bu4ePhUDYmIi5XWLNseejgMae2nHF2TrJr5IOZTZX4e0ckxmvYZcIymMc
	XlMl6+glSWMCv/iKnfKtfkZXZzirE54mmVgLu9F5l5HiIZqefCiaaXmNhZXMmL8LKd03fSORk1t
	iUi9b4Pq/VZbGWgzyO70ldCSytyc+aTeDTgWha/LbFM7EB9xNJBW4KwLSETnXjhMGkswbXGSVYq
	yCFCgyGnWJcfhFOTQEL4/uaG5b7/4Gj6XhO8ths3G7rc7iqUIjObutMB7jfFfXOMpAQS7ON+5Cf
	tzYhQzf8=
X-Received: by 2002:a05:701b:271a:b0:187:c940:21b7 with SMTP id a92af1059eb24-1ac5c55491bmr6515388c88.9.1793465518029;
        Sat, 31 Oct 2026 09:51:58 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:51:57 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 4/7] wifi: rt2800: don't report an A-MPDU length to minstrel_ht
Date: Sun,  1 Nov 2026 00:51:11 +0800
Message-ID: <20261031165117.2868671-5-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031165117.2868671-1-hjf3108@gmail.com>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
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

Set IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN, which was added for drivers
that can't report the proper AMPDU length and record this workaround
below the TODO comment.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5e1ee016624c6..1301bc24d9413 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -11860,6 +11860,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
 	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
+	ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index db33c1215de97..350e6bf24f7aa 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -374,6 +374,8 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	 * by the hw we could provide the real ampdu_len to mac80211
 	 * which would allow the rc algorithm to better decide on
 	 * which rates are suitable.
+	 *
+	 * Currently, we work around this by setting TX_STATUS_NO_AMPDU_LEN.
 	 */
 	if (test_bit(TXDONE_AMPDU, &txdesc->flags) ||
 	    tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-- 
2.53.0

