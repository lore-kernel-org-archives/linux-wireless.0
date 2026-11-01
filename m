Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793566699;
	b=BLJtyFnNCEVzM8fWhXCF/x1GfVHjTQDN1+bIvaRtk6CgZn4Mvjtb2n5LjUiUcfOMGopU
	 apIEZVHzJjDFoXRcRnF8elb2YiXUe/jKjW0BDaCFLpSSO9EYr/vOVXR1Rut9ZxXlIsxQp
	 a8yHJRYstOldL4LFpV1rLSzhBP3Hxvj2e6/byRUPlSM2QB3KR7DRDZO/Iw2vHL5XY3NAF
	 y9T/oqe+IgJzrIJscLNN/AjPq8C4H46LEF9kQRNc/v8X8blLeUvrDJ55FX4gP0VGvpHCM
	 rPzBQ7wdTXyVNUv7Z69SLZrab0gdCu5rlzw0wrqivPlKLhJggaDcP6MYvX1zF/NzrDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793566699;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EatRaOk5FsW6bG/r7gLBVDmf186l+yQEdWvonTJkkJA=;
	b=WvhnI/Vosi4ZIusv6qTg0rL0UcUWOA/wBYgzN6IlWkFZYQQ6iaxEfd/cTZaNdrTGX9wD
	 DHzFxTTuBEnQFEsZ1dQPAYdfPXx5si78e+q9JdVYmMcClsmP2km5RRT6kZF2QTmFn7YaW
	 xcyYib5eHkpCnoEEXoEsHFAEUhPtDokR25wBjRu12z+J6zwwU3UzXp4rATYOi18zAbI2x
	 OD7EO9kdffseBrVUVsMxMBZUbWpnzeKJo6O6XOJc4wnc0pbVxRQ0Z2HnO3EPvfIpZ+12a
	 UE/VKvOK/P6RdK+9BLPny1Q7rknN/m+WY48+Ut6l0Vl0CRwU1KYZq4Gb6Dxzc8JTbbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjVy4QrS;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA87606A327
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DA87606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjVy4QrS
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so17931975e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793566698; x=1794171498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EatRaOk5FsW6bG/r7gLBVDmf186l+yQEdWvonTJkkJA=;
        b=EjVy4QrS+xIi8+Bxx+wdM9VUiJUwbuMmi1YRWNdM4wsivLqbfhh9kSUjqoM3UHbyDy
         5CgoRo7BDRWOxZiJoD6rMNEgXki3PH+9hJvy/iwvhxmwEja7CwzCepxTfgWJ50XV1cU+
         cii2qKVabdqfv984KGouJLZF0imJXL+36J8m8udDNDBKJGkSkcC4Iy/MpkKiO3PetDC9
         GHhh4nGUqsh4PbFPpfzBvtMNnFsV7tmW3rjR4IEZ3aiWjWUY1pba+O7RO7K59Q20YHFp
         m0KUHiX/trDZogQQWGdYf3HFV/wXqmo+LKvNlboe0jfO11yaW/4GaJStSeJPLgtV/0ja
         dkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793566698; x=1794171498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EatRaOk5FsW6bG/r7gLBVDmf186l+yQEdWvonTJkkJA=;
        b=Tep816WOc888Rp8f/PZTfj9bbOSs+nL+eQTLrb5T6Vz3iLSk5JwCk8Ci/elM18refR
         f0NMFSwuX52WnitWZvUNaZaeObh8ujTdLVulvSuRYe80fFQbsic7jF/4k9kzD+DwKSJY
         qiSBzhlXE2jpsMhkqq3SHMu0+FdcE7u1DV9+QstOZvX+BWlc5Xt7dpsJ9RViMwJxG+57
         b7pm5OpDfO67A7NS0fAwIT0wwAEHGzODFl/lnOrj5RwBO5u6Vh8ltCgstMU6/L45y6iC
         19O0SA0H/i/ZRFBZiaIains3cQS9uJ/T3c8flWTNCO7PjaTt7S/6d0ZxPQA64guMDSnY
         csBg==
X-Gm-Message-State: AFq9FYIWbw90v/sjUPHWAFJnSeYVURCI3G1M50E0pgFh5Ooj0Eog9h+r
	j/LGXsaa3jRu2biRUV0bNBe+a5k+42xE0Ls8Iry3WcIrIdeKOievBhA=
X-Gm-Gg: AYBFou0POkRYSSSyQ+8SdmM16XPdglFfJlUG+krGlY5Z8nOEIP36lo0aVZCz8xeuFe1
	ngjwDgYo/TlQD1b78hGdFUmHF198uUrrHvUjQkClp2KpfspFzKdGaggsAP/5LrSzA+YzyEL5yCQ
	y9JUWEaZtBzTSKi7scfTIjvEMVbg25NAaWOkxkEKurgQ6JP2C6yzC+I9n5T5ZMR2V4Or5GlMljo
	GD3t6DFWcHJZb404yAVVkwLHhLuN4tSWJm9Yc9G6cjnc63Yblf6tXrTqwUKrE4B8xohj138e4+h
	j8obo/S8IiNRO25UlkrJSqdFYvbppqAz5Np1dwjb60Jkgg/fic5UhbUjQzVt+PpDaznC6choH1e
	gMbI0/WvtJoB/Jw+hypBWUikvjlYowPtbg4Apbtn1eJxjD6ZcNTVvZN8WMIdcfefEL/1tF/4PoL
	QV1LjPyVhWCtoH8zXy5tBf2W32NdNYWr2PP5ARndGwcjylWoci2ztGA8/mW/BUHbmYyX+jkMwLN
	jMSIvFqPW53ef9wsh6lq9qO9iqylMjKRsqBNEcOd7bviaw6vJZd8GKXUSOJfKld18kOrTa88C9Y
	+9gVkK+crIJ5xl6M4go=
X-Received: by 2002:a05:600c:46d1:b0:4a2:1867:10e8 with SMTP id 5b1f17b1804b1-4ac17b2c8a7mr191454345e9.25.1793566697821;
        Sun, 01 Nov 2026 12:58:17 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9eaeesm16002280f8f.49.2026.11.01.12.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:58:16 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 3/3] wifi: mwifiex: cap TLV length in IBSS connected event handler
Date: Sun,  1 Nov 2026 20:58:02 +0000
Message-ID: <20261101205802.2909524-4-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101205802.2909524-1-tristmd@gmail.com>
References: <20261101205802.2909524-1-tristmd@gmail.com>
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

From: Tristan Madani <tristan@talencesecurity.com>

In the IBSS connected event handler, the buffer-bounded evt_len is
replaced with the TLV header length from the firmware. An inflated
value drives the IE parsing loop past the event buffer.

Cap the TLV-derived length at the remaining event data size.

Fixes: 432da7d243da ("mwifiex: add HT aggregation support for adhoc mode")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 1f746e8f6b3e18..3f683698e4a60d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -45,6 +45,8 @@ static int mwifiex_check_ibss_peer_capabilities(struct mwifiex_private *priv,
 		 */
 		evt_len = le16_to_cpu(tlv_mgmt_frame->header.len);
 		curr += (sizeof(*tlv_mgmt_frame) + 12);
+		if (evt_len > event->len - (curr - event->data))
+			evt_len = event->len - (curr - event->data);
 	} else {
 		mwifiex_dbg(priv->adapter, MSG,
 			    "management frame tlv not found!\n");
-- 
2.47.3

