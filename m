Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893C73515C7
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 22:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785796265; cv=none; b=d69bJOXWD7m+TRokWVCZO7sXLFp/xnnbNaaGAfabiaq5O72C6t/vuJbkRLLlZsJM599AZEIhFMgqVC+fOfXzVqWDPJN+i9Xn5OHu34YHi1x1xOSvdM6EiEHA5NVECU7DLI6rnp5uRA2cKauBdRReBHnMABTHgTj8KuLin/7Jq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785796265; c=relaxed/simple;
	bh=/q4n3Ihs7Y5ToikCnwdv7lsiFKJSizSC78iykm22v48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+JjT7tGZL1jBbLvcg04QqdPH4q1zOgSHXWLTusEzQgkdeU1K3c+d/vSRiibRhCqhD0pVWhwkeH2gbzV3u52KEFPcLCNkKJscFPLkT5c2EY/O1ETj1GLOQSOlCTpUdwU/XpvdCjQTQIsC1S9E6yNgNnRnN+eOc6QlrSIwVICF2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sh+WKdkn; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sh+WKdkn"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954b3c5cbeso3787815e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 15:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785796259; x=1786401059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/q4n3Ihs7Y5ToikCnwdv7lsiFKJSizSC78iykm22v48=;
        b=sh+WKdknvyDapuclRVhi5a4ZlNA2eZlLPcIueCb+f7GpqYc96YRQuFzG46skddxZmu
         SZfZ/c9pPZSY9gtGK15TjPXxLUq0kD1DidvbRDq3zBEVujb6aGuOGZEOxeLwTGujJzFk
         NDhHKbIgdIWMil9cg6fBAwPlKL1b+6H+EUWEkiIprlcpjxtfsHFa1hVl62W4SgdGhlHi
         O1/tFLZihLl9+62q1fpgOmOF3PvsZ9aYtQXKUCRcNQIhOJJXy0gjH1dE7cOx3nnV0FSe
         vPlS20TJCAOylP2Qy1IxCbDZxxfqFbwnBqWOwWw4OaJsa9x81mtawbeJDQkpsnRTKm1N
         WcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785796259; x=1786401059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/q4n3Ihs7Y5ToikCnwdv7lsiFKJSizSC78iykm22v48=;
        b=YlKWBzbPNFHc5AV55sAiZgH6BV1FkkjQMA8dIWewfA8Xgx91lnFmIpJE4k+BN+DmeY
         538WHmGiBfC2NzFJtMT/RJAOVHd4jfadgS3zctcbtaPvSVaxTki/pUfTWfzQa9DK0D/I
         I09lbOdEFLQbJY4bTH053rtpNaX2XT8e9hGrIw556gdVfaADSx1+4VvSuROBjsljSEk1
         KjCbgQHyzpD1LmD4uaCyOS5Xyzfh385mTU6MC6+trd1wpebRaPnYrJhn601bl1Tilz7Y
         r7JNOv3H5R3Gnwvi//rOTdGT+YCO9icqjMdvhAQUL745LF9qTs6qypmuD031GwjYgCC7
         z7Uw==
X-Gm-Message-State: AOJu0YxCD1FKeV5z5YixueGqd76KDYB78vH+nbxChTlBjYcj1RW2XV8r
	wMqnDRriL/pItcrpUbZiY67afAZJXASLcL0BKtUqF1RlBh85TPZPZq5x
X-Gm-Gg: AR+sD13slrhkrdbhlh4tXZUhw0sn6RmpMqjBM9awK9AJDKe12XtP9LJhAkGaEi0yc67
	OUTeudWTlu7hP4NvRZtT3L5nkA9qkOjYAMosmSmdeM3iWVNscLAP2DMIh2PZTd/E3MIBlqduL7U
	sDWIPrMDI/7ofepwEhjzXKDIkwrKPYa69D8u6WBD+bNkwetQ+sBqxAgVvNI7qBC2hpaWs06DZpc
	dHqYbudzCjzXjXkZZaj52TIEHh0pZrkaKSYotksEYpLOMOBJrI6gqEmI/j8e/3gAakhRrJCY2w4
	4M2Nh/IwmfWlBW0g1AWgGd9PUp3p65wfDoouNqWWB/SxvBbIj7w1j9AH7vEUHju02ez4Kvx5VsN
	aiEEuUrJl3E1cec6q0L/POGECD7RagoqYrWdDLc+vDVPxZ7tPLKiGqWo6N/yFW5KAO815Xd6MaB
	qHnrKNmX1ik50BHhhmBE6g2w7ByIJD8ScpIJ5hRX32DWTxrcKhnw5DNrmnlXmglrlzERSANC4mK
	BtPH98VJc53RHfJ4WfdpCPw4X+7fJ/pRNvCeg/EBWzZOd9WtR+l
X-Received: by 2002:a05:600c:5252:b0:493:f42e:1b3f with SMTP id 5b1f17b1804b1-4980c6a4284mr133318525e9.3.1785796259099;
        Mon, 03 Aug 2026 15:30:59 -0700 (PDT)
Received: from m715q (host-87-19-5-249.retail.telecomitalia.it. [87.19.5.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807bad893sm225223725e9.3.2026.08.03.15.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 15:30:58 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until association
Date: Tue,  4 Aug 2026 00:30:17 +0200
Message-ID: <20260803223020.1370646-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cfcb2f3748aa51b7001ee41c6dd4d578b0cdca28.camel@sipsolutions.net>
References: <20260730161531.3535100-1-andcov23@gmail.com> <1dceded216618b1d7bb7b79846f15712161f2cc8.camel@sipsolutions.net> <CAOEJtZHV8HLxe70B7Rugkh2o34Sy9cr26BXji5LWB7b74JTL1A@mail.gmail.com> <cfcb2f3748aa51b7001ee41c6dd4d578b0cdca28.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

> I think I'd mostly like to understand how it interacts. SMD Transition
> won't actually handle this particular path, but client-side has a similar
> issue where the key is available before the STA entry for the AP is fully
> available.

I compared this with your posted group-key RFC. Its SMD-specific GTK/CIGTK
slots are separate from this pairwise PTK path, but the generic key-slot
refactoring also covers sta->ptk[] and moves the ASSOC gate. This AP-side
mechanism requires an existing, lookupable sta_info and a PTK slot, so it
cannot represent a key arriving before that point or handle the earlier
client-side phase as-is. The deferred flag can still live on the individual
ieee80211_key after rebasing. With the new tailroom handling, the ASSOC-time
retry would call ieee80211_key_enable_hw_accel(key, true), since it is
updating an already-linked key and must adjust tailroom accounting after a
successful hardware upload.

> Now looking at the code I also wonder devices could just deal with the key
> installed before the station is marked associated?

mt7915's set_key() currently returns -EOPNOTSUPP until its AUTH-to-ASSOC setup
marks the WCID ready, while wlcore allocates its per-peer firmware HLID during
that transition. Outside the EPP-specific
NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION opt-in, I could not find a mac80211
capability that guarantees early set_key() is safe for an ordinary AP-side FT
PTK, so I did not assume that every driver can be called early.

The OpenWrt PR also provides a useful A/B result for the
SW_CRYPTO_CONTROL interaction. The initial revision deferred the key with
ret left as -EOPNOTSUPP. It removed the error on mt76, but the error remained
on EAP1200H and OnHub, whose standard OpenWrt profiles use ath10k-ct. A
follow-up moved the deferred branch ahead of the sta->uploaded check and set
ret = 1. The subsequent report for the same device set showed the error gone:

https://github.com/openwrt/openwrt/pull/23181#issuecomment-4500287395

The revised path removed the reported error on those configurations. This is
consistent with synthesizing ret = 1 having permitted software crypto, but it
does not show whether ath10k accepts set_key() before ASSOC, because the
callback was skipped, or whether the key was later uploaded to hardware. It
also illustrates precisely the SW_CRYPTO_CONTROL issue you raised: only an
actual return value of 1 from the driver authorizes software crypto. I do not
want mac80211 to synthesize that permission.

For an upstream solution, would you prefer a genuine dormant-key state, where
the key is neither uploaded nor authorized for software use until ASSOC and
upload failure has a defined path, or should affected drivers handle the early
key themselves, either by installing it immediately or caching it until their
peer setup completes? The latter could use an explicit capability so mac80211
relaxes the ASSOC gate only for drivers supporting that ordering. For a
SW_CRYPTO_CONTROL driver that cannot install or cache the key early, an
explicit return value of 1 followed by a mac80211 retry at ASSOC is another
possible contract. I would avoid adding that, however, and understood your
question as suggesting that driver-side handling should be investigated first.

I have kept v2 local while clarifying this direction and dropped the stable
CC as suggested.

Best,
Andrea
