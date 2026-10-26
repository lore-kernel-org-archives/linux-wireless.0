Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045769;
	b=MtCDfeRj+S56SAPeZHKa8CmPxDZQY8FO8wJwwKVTAyFpqV/H8dNhiicFNm0CpBqJnV6V
	 N4EaHvXQZd31aSl47AfTZpU33evcNb7plbxsJRTl6LrJnwX+PD7VOQI0lnuBieuONzoGC
	 xYYBLWUOcMHje7VMIhOtGvOU4N6KzOmqnB5Cgwxy/6lHM3iqnYIvz/gw55gLMwyFbWTA6
	 DToKgmU7NEU3IxpX+ccsCVr2tIkKL4U4mwDySVs5jYyfMWWM9dmaRa8N+dLrED3TJurna
	 H6fkfhDa8VOpGgMSsLTVL4XeZPBYdnTviWqL2f2/JEXIkTPL/SnornElev+6C5UE2bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045769;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8ZkJMjWlhMk4Veu++rAUd1hw9BdTfvoHNAmC3I1U9k=;
	b=SqRMK1l+TBg6drLhdx1P23gxCGYbvDT0VcLb4MDnfU5YEKu08eNqQoM9DFk8HWJ8vYab
	 L+erMV+ERP6OX/n7DKRAXUgKPQ8hJWOwPQ+8X1Utvh8mAmKvm/uGqrCxIrLA1wGZdB9r6
	 C5W9bYP1sd2z/1poIhiUHfrPA8ok3UXXL7hp1V91YfCM+XD8XdGMbQqSnUSQSs4kM6KIK
	 o4c6u268Du+vtnMckgXbin2e1DpQnpOmBJX+4FRElbtnBbo9y2AszcfKFNtpE9k7tCDkP
	 hKsm6CLSMg5c4l1vt/VwsyN9+3KsfHTcCJsjiDLfLkoIqA5Yjl8PUI1xNJeI20XaUuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ODZHIYQz;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ADB606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 20:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99ADB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ODZHIYQz
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-181516de561so187772c88.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 13:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793045768; x=1793650568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G8ZkJMjWlhMk4Veu++rAUd1hw9BdTfvoHNAmC3I1U9k=;
        b=ODZHIYQz2E+WESqPCtOXOANaKxkx9uHuqZabDw6NrL3jIxjHezvUw9FbLNvlcDZh4d
         M1fr63jjIywiS90B9wE9SoJtxO87Le26YCPrB4prfAS9gLZvdMFzB2sPAf7I+dIJ1Hk+
         /E9067A/HcX/HQreZUCMoK0F1y3bUNrfZRBc6zwwBo1rnbSqAFVoFuxYVB1oIT/P8Cv0
         Qwi6GmbZstmMbmtlOrfb99CmhwWsaqIoWTlPl/9yx/LAwMMuWQHCyiQ7cjQZjHNnBR7K
         7FIg2JSwUVp2N6nF964g/SzpbykzH3NRcFVwfp2+lrLKTQkVoLH5Pv5pZHtESg5tmokA
         hCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793045768; x=1793650568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G8ZkJMjWlhMk4Veu++rAUd1hw9BdTfvoHNAmC3I1U9k=;
        b=LuZ7IRz3NiudTv2wJmMuC+CbMnbeIIY3wnwTDcxMl9OgN10gpE/Ov0ZP3ysXI2AL06
         2xqwrBQ0BQZq8eVoos/JLh3IvNtQWmnfIl5W24S9Le2rt4L5GJcKGc+4jGY0P7xq9P2d
         Wm7JqrgEx9ppbaCvaCdwTcLDAVMZGzxUpqB3jhsPu6enVzgarjYlk3lokwfyF4GGtx9Y
         U5O28pG1MIoJdmSgp3jTzim7x+OiMWdW6pN4+TzpLygrQsq1fR7lJEo1kxkBEII4Y+aR
         Q62eBEHabfsQEM2pG/Nk5zovpxHQ4dRl/hWlkYzy4kIaotpHtYvd3bztDdrKEzleHWKl
         F4XQ==
X-Forwarded-Encrypted: i=1; AKwUvBw5oZVOreVk+YA7Z7ts8TxfuT7pIXUAKTV81ESKx7e4riYIaDJXSfEDy9NyGSpvRLr4Y7av8IyrDss3go27iA==@vger.kernel.org
X-Gm-Message-State: AFq9FYI79HKgzF0YnTMbiLns4gb4CX9A2GLd3exMwBQQfFFhqvpQhaqH
	bh0ofZFMZUBH79dawgZo1w6WeJBNqCKZQiEYUwd9ap1LFV7VOGVuv4CG
X-Gm-Gg: AYBFou1b0RU+NGgjDtm2KxjNL3luyyiz5BWVZZhc2gwV0wB0ovOKAgMUXn5I25/u9vm
	aha2WWjRLFC8QbAr2g9+tS1mQtGwum31A1W+ZHWzGNKqt5zDghMWR5NXHW3NiXxU2ouWl4c75O/
	ZXJCTcQ/Q/odD5ESg80IpuEDdUO9u3Sz54V24alWrzFtHFPBbk3+T/KOb+hYqZ7LmrUQGTdPsSo
	PB9E888zAm0fiboUtLLLs4dnlQ7g/wc0bgjZxBJHWUU8wJcn4JUYl0obP3Ncx28kMQAFTviLtRi
	i6ccGpY+6ZZnu/Ed4z0bh65K4UxioHwccp8cuaXGWgrxvyaQtaBuqVppHHL5NwlEqKIFPEqAFt6
	YzqRE4kcTfbEBeowbGVBK3jDZRB2EF1DAHfLnf4Nw6oNMMWSgxyuRMDAOHkwwrLHvNFjrjIZODQ
	BF+nO6+7dSJIqRf1OTYcgUmdqxOj9oX0vyLhvOO7KUa2QGrjancZ3rBeE9wv4l1Q47ECITNIHD3
	xfmLdVtRUtynkIc4qv6xVFwiXnb7tj1zRc+OarNZdrZYEB96PhDAj125ijB3V58HwuGMC5/e345
X-Received: by 2002:a05:701b:455c:20b0:143:1bb1:3305 with SMTP id a92af1059eb24-1a3c9cc2353mr731661c88.22.1793045767511;
        Mon, 26 Oct 2026 13:16:07 -0700 (PDT)
Received: from ZephyrLabServer.internal ([165.162.64.148])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a01fa4c58sm25994089eec.21.2026.10.26.13.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:16:06 -0700 (PDT)
From: John Macias <dencity7@gmail.com>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mac80211: use HT CCFS2 when computing the AP's HE and lower bandwidth
Date: Mon, 26 Oct 2026 13:15:29 -0700
Message-ID: <20261026201529.3471565-1-dencity7@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <116e1f238e2d78817a2ac5b42b00e0faeabf16bc.camel@sipsolutions.net>
References: <20261026040148.2633920-1-dencity7@gmail.com> <116e1f238e2d78817a2ac5b42b00e0faeabf16bc.camel@sipsolutions.net>
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

On Mon, 2026-10-26 at 12:07 +0100, Johannes Berg wrote:
> This, by itself, is wrong.

Thanks. I think I see why: CCFS2 only applies to a STA that can
interpret Extended NSS BW, and my patch applied it to every station.
Please drop it.

I looked further and may have found the actual cause, but I'm not
certain. Below I've separated what I measured from what I concluded
by reading code. Corrections are very welcome.

Setup: IPQ8074 (Netgear RAX120v1), ath11k, firmware
WLAN.HK.2.0-01792, HE160 BSS on channel 36. Clients: MT7925 and AX200.

What I measured:

- Before any change, "iw phy" on the AP reports VHT Capabilities
  0x738f09fa, prints the Supported Channel Width as "(reserved)", and
  shows "VHT extended NSS: not supported".

- In the beacon I captured for the original patch, the VHT Operation
  element has Channel Width 1 and CCFS1 0, and the 160 MHz centre is
  in the HT Operation CCFS2 field.

- Both clients report a 160 MHz link. On the AP side the peers were
  set up as 11ax-he80 and the AP's transmit rate to them stayed at
  80 MHz (MT7925 download about 810 Mb/s).

- With the change described below, "iw phy" prints "160 MHz, 80+80
  MHz" and still "VHT extended NSS: not supported". The AP then
  transmits to both clients at 160 MHz HE-MCS 11, with unmodified
  mac80211 and without my earlier patch.

What I concluded from the code, without confirming every step on the
device:

1. My reading of 0x738f09fa is Supported Channel Width Set 2 with
   Extended NSS BW Support 1. As I read Table 9-272, that combination
   isn't defined, which would fit iw printing "reserved".
   ath11k_create_vht_cap() copies the firmware's value unchanged.

2. ath11k sets SUPPORTS_VHT_EXT_NSS_BW and
   IEEE80211_VHT_EXT_NSS_BW_CAPABLE only when the firmware reports an
   NSS ratio. "extended NSS: not supported" suggests this firmware
   doesn't. I didn't print nss_ratio_enabled itself.

3. hostapd_eid_vht_operation() moves the 160 MHz centre to CCFS2 when
   the driver's capabilities include Extended NSS BW Support. That
   would explain the beacon above. I didn't capture a beacon after the
   change, so I'm assuming it now uses CCFS1 because the AP transmits
   at 160 MHz.

4. ieee80211_calc_ap_he_and_lower() reads only CCFS1, so the AP limits
   every station to 80 MHz. Since the hardware doesn't claim extended
   NSS support, this looks correct to me, and my patch was the wrong
   fix.

The change I tested clears IEEE80211_VHT_CAP_EXT_NSS_BW_MASK in
ath11k_create_vht_cap() when the firmware gives no NSS ratio.

Questions where I may still be wrong:

- Is ath11k the right place for this? Or should mac80211 or hostapd
  ignore Extended NSS BW Support in the capabilities when the driver
  doesn't set SUPPORTS_VHT_EXT_NSS_BW?

- I also tried applying CCFS2 per station (only for STAs that set
  Extended NSS BW Capable). On this hardware it changed nothing: both
  clients stayed at 80 MHz. As far as I can tell, that's because
  mac80211 clears that bit for every station when the driver lacks
  SUPPORTS_VHT_EXT_NSS_BW. On hardware that does support it, an AP
  that signals 160 MHz through CCFS2 would still be limited to 80 MHz
  by ieee80211_calc_ap_he_and_lower(). Is that expected, or is it
  handled somewhere I missed?

If the ath11k change looks right to you, I'll send it to the ath11k
list. I can also capture the beacon after the change, or print the
firmware's NSS ratio, if that would help.

John
