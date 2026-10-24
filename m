Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792801008;
	b=TZrUQRZ9BdfUCCLzKpFHvBKOpYyEbsPPof87re/TUYENxd8YljFzmjaIcKUdRE7+d95a
	 rqCaX6qeqHNrs52IA0xGi6aLFJ4UuCNm28ufIv7Q4yUzw0HqGfGez30Fq2CG51MVMy+z5
	 vfYgc4yZVURGBLiJsd1JiI8WeF0MnM588FuRm0DzUZlqbmrcw40RkrL14dsiGg03u8zN/
	 hHunDm+iyFc5ewSRvF2C8us3usama6Jc+qpAWIrWUqPCV5wNbuMxEgO28jZ3jN6Lwdqx8
	 VL/S++3eCXQxIwtDEJf+dYzU+MzY1rJE8Lvgvg3zXJgrVZhIY7jDn3TlzGrRCg9JOVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792801008;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:Content-Type:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oCEF+KBqzRXVI9kXaksILDOhECNROpNKBNcCjxaLlvk=;
	b=gt7cOUiaKiqEKZpYxTGWU9suWm/7+WpIUIUH4sIeT7VtnE+8OQb9BLXASu1nB2y6W/Z/
	 b4bBN1rSWWG9PbcuOFm/O6oLiQyDwZ1Yrui5YJE8Hc/lNnK6EFa5W6wrNwvRF5S9lI1JB
	 Ar5KTWWumMjlYxYjfYOavPhk9Q0+p+I4C3jBloQqbzd5O8Adbgm8+6T3wXqsLga3FqZKT
	 si0n+U8j4ADqbU5CqfEmamocM+SLbYwoPBa0FodgXi+/ddKSl8e+90djVUbTWKKMKwrVh
	 tZrr/xP8dv5p7vZKrpBIn4dBqrVYYEy22IX32avcTYStcOXagaaWnG6FZuaj3RlINcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=mr5DNqbr;
	arc=none smtp.remote-ip=95.215.58.45
Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED60606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 00:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ED60606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=mr5DNqbr
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+UKNMAy3zFfzUCx70++B+7CLr1RnmhHkpNuwkN08yTg=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792801004; v=1; x=1793405804;
 b=mr5DNqbrJhsrB3vhMQZAY+5rEr+iKj/l04OV34XzkXFQPfyQqM9oXVxRTULqyyq5P3LhPA04
 HxwJ4KJBV0LySjVgHFgNulKEVm3cfLzaHCeibmU3SiqditQGTqB3yXzbf0ixpv/KAZZFEOJ2OSY
 cWG02qz8uWr9xfsmtff1vy4NSNfHFBdbTlg3w33eFqV/ufXJTMbQm8h+cTfzrsqW1dHaqXD80Ik
 CGGy0Db0q7O9IoDGkAgSYBt9xFWAG8NJvvFIQrhw+lZXqvYtonNJvJNsAx46rbLmUZJ7iwYVsQL
 uhVevYdgEWwxP4RX7b9zTDTaZjR4Ywf0gBqdqlgGUePGg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d323aab877a9f785;
	Sat, 24 Oct 2026 00:16:44 +0000
X-Mizu-Trace-ID: d323aab877a9f785
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jason Hodge <jasonvhodge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	mingyen.hsieh@mediatek.com,
	yu-ching.liu@mediatek.com,
	emery.hsin@mediatek.com,
	Yi Cong <cong.yi@linux.dev>
Subject: Re: [BUG] wifi: mt76: mt7925e: resume fails with -110 on MT7927, occasional system hang
Date: Fri, 23 Oct 2026 17:16:37 -0700
Message-ID: <20261024001637.22946-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAEC_7rB38g-S-1xkJQ=uz1BjLBX-wpsS5VCqCC7c8vH==jt05A@mail.gmail.com>
References: <CAEC_7rB38g-S-1xkJQ=uz1BjLBX-wpsS5VCqCC7c8vH==jt05A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
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

Jason Hodge wrote:
>   mt7925e 0000:03:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110
>   mt7925e 0000:03:00.0: PM: failed to resume async: error -110

Yi Cong posted a patch for these same two errors on October 22:

https://lore.kernel.org/linux-wireless/20261022085100.132368-1-cong.yi@linux.dev/

When the resume handshake times out, the driver already resets the card
to recover it, but still hands -110 to the PM core. The patch reports
success once that reset is scheduled. It applies cleanly to 7.2.11.
I've added Yi Cong to Cc.

Thanks for the detailed report and the unload workaround.

Devin
