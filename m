Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793216260;
	b=x8IcFiDmiIbqZHYRo0IBNFsyTTlT68I2kpqYA6VPjbk5J/UTtzYbOm4lq4fUN2bQfo+3
	 PsTu866mg+jLWnXyIClL3m5yorODij2US0i30AnFLIibznkISGp2aqJGfndIapAHhMd1R
	 miyhRZ/PLMx651I3HZIhGpHTb4dJeNqqv66H2BvQJpGbbaBNJrax9rez2pMYorbw5qaDp
	 oAO1sri06dkqy6whFOhC1dkYtPsWdg/zTt78+7tQpxWGSI7ixAQzTAQSuc15DyUW5zLD8
	 mqwG5zgzKqfP8u7Te9m2j25aq9ghHlLV3bbrmK7L6tD7mVvKFIiL+SJXqUr5uHbNtMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216260;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=xMKzz/zv+5Rfr5oKbtqBM5Fa9jOgikAOOKdPzQOK76k=;
	b=H7gqNLkngIOVd0PEYhtYHzdHrz+vDqXblZl53HeybeCv3nKb01kEbpnoDjkA+J3CeNBm
	 DNL552awqSp3V4ya0Au8m/+x0nViNggphVsiqcLgMX9yZZRk10KhnVyAon045fUQ4gDar
	 MxVph6K4JTeoi7v+7CNkVIC/0oRIaLpkubpSIGei39T+OgQhv0BWko3kal59H4MmSmMPb
	 4LIIdugIAWIIxrTnMUXCwpaKUKNPqd0fr9kM1BmZoW/7alI6i/f2CSaGMb8aL1ZmtkUtj
	 y3SoXIchdVT7FDPgbxDaOqmxd25CiUz/BJXKDZAkcNm2Qk90QTxtPmK/j0j/7tXSs/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvwxZGok;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8B1606A322;
	Wed, 28 Oct 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvwxZGok
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793216260;
	b=pKatPeZK2Wd5zY7whEi2DzKlESvLDdBwzRxoZOYyUWNL4wLVPfwRm6v3Vs26mAT2TIv6
	 KKXjFR7vWGOdieCYLIcSofwliD18CTkvUXXyjF6YyuYWzEij/429rXFAjeQVevLdkH6RR
	 1a4JXTQCMQqhvF4PMWnsZXcj3x6/UbzAbKNwREjXLOU5t8B1B7DU84lFeWfa6blCaaWrt
	 EyG2SEWrHi4rAC/pYCQsGiiNc/SLFxPadDSzy97+KeOmuBnBpMel0wIPRdUIoXpg8rTtW
	 yR/R5LYVbsomyNsUQ0tXO2llEcpqFjjxGAulpdL+eCgnKjAMy0o5NI+6tTwW+0q+Jsg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793216260;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=xMKzz/zv+5Rfr5oKbtqBM5Fa9jOgikAOOKdPzQOK76k=;
	b=rEaFzqUIcbPYSepW40kH6hnvFRhCirIhrdiR4lz4indZml9LEcXKNUcBBfzGtBfm+8fz
	 Dxgay7SWUZCz2kUgv5sOk1HxtAeWV6IL90O6VD3o5YICA0CgKqhhiuMViimobsCAW62nD
	 TFmZ8YD4b/0bKkbD7lS3W+ujEJDfL+yjse7Ogf4T442pt8XRUNM3R0uLjW+r/LeVaqiw4
	 nkDT6PyYp4Bnj0mFl43dCtMW8Nf8KKJnKRrWkXLLY/3lFJuBHGOuivP2DlPeA47jv1E8B
	 VNVVdlJlcakXecnwbM3+Hbw7h/2Bj+w/1BDY4wSsLoCZdIwT3RDUdAsIyZ2PurEyjhQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6816A1F01829;
	Wed, 28 Oct 2026 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793216260;
	bh=xMKzz/zv+5Rfr5oKbtqBM5Fa9jOgikAOOKdPzQOK76k=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=hvwxZGok4ksCv7C1vi0Phy2E3Wp05wRg3JYjXzE+cez82AO3a36+K5/rnW7TQYjC2
	 +baRRonbfU8nr0uf38xtwmA/9cLb6cd8JFf8GJRLH0k0+SAnlu0SpmQGUbJAjS71Tc
	 jEp+mLZtULtyLRYaDnd/aSsErN5MymOmkaFGV+hhc8aKW+BvZrp+Ef7g/AcPv7B1RX
	 2BQWfGi0RYQ/5lhGVzzPJkWWHYtBSipih0LzpsyqeG8YpGX3uQujbtc6vH2qsK5HqI
	 GaB/FwBfvFnKqdnw1vfOYG3SJ0mRYapSt9S4MF/V6YIkchHgcG39jPWKIbkBkw8GYO
	 IiNow8S7jKBPg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BA5A04557B;
	Wed, 28 Oct 2026 19:37:38 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Subject: [PATCH ath-next 0/2] wifi: ath11k: HT, VHT and every stream for a
 QCN9074's 5 GHz band
Date: Wed, 28 Oct 2026 14:37:37 -0500
Message-Id: <20261028-b4-ath11k-qcn907x-caps-v1-0-c7daa6f1c02c@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAFP4moC/yWMQQrCMBAAv1L27EI21mj9inhI1tVGIbbZKIHSv
 xv1OAwzC6jkKArHboEs76jxmRrQpgMefboJxktjsMY6MvaAoUdfRqIHzpwGs6/IflKUXWByMgT
 Xb6HFU5ZrrL/xCVqASWqB89/oK9yFy/cL6/oBaXYnwoQAAAA=
X-Change-ID: 20261028-b4-ath11k-qcn907x-caps-e5bc16e9b643
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793216257; l=1245;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=AjLNAMDDcP3b7jONTJ7plUs667CPRyqbSeh47AQDCV0=;
 b=eepb0BWoUWa5l0hDbw8eqkM/9iE1u5wIBrAXSJKQv3JWjZHtU5z5u+kESbCPEJLQlPOM7J8Jb
 PoxVW7lmYIJBWKeQfTT11hovGVlQKdHZxIgvw4EK3FEHN31iMCZSXzK
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com

Two fixes to the capabilities ath11k registers, found on the QCN9072 of
an Arista C-360 (it takes the QCN9074's hw_params), which covers 2.4, 5
and 6 GHz.

The first gives a 6 GHz capable radio's 5 GHz band HT and VHT: without
them it used legacy rates only on 5 GHz.

The second counts a stream for every chain: the QCN9072's chainmask is
0x5, and ath11k offered one stream for it on every band.

With both, the QCN9072 as a 5 GHz client associated at HE-MCS 10, 2
streams, and ran 310 Mbit/s down and 438 up to a local server, where
before it managed 3-23 Mbit/s. The IPQ8074's radios, whose chainmasks
are contiguous, register the same capabilities as before.

Both apply to ath-next; the second is written on top of the first.

---
Christopher Griffin (2):
      wifi: ath11k: give a 6 GHz capable radio's 5 GHz band HT and VHT
      wifi: ath11k: advertise a spatial stream for every chain

 drivers/net/wireless/ath/ath11k/mac.c | 45 ++++++++++++++---------------------
 1 file changed, 18 insertions(+), 27 deletions(-)
---
base-commit: 7b14c8f4a9615579b09cbcdc4515b65ae6124753
change-id: 20261028-b4-ath11k-qcn907x-caps-e5bc16e9b643

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


