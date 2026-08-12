Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E8E36680E
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561556; cv=none; b=jtjuZ4owvJ6w+n3uaZDBTdmh4wodh190Eg7rHRzcL1OtPwL89bjNd0eG+KNoz2VZ4TK0XP9L+ybi7ym4m/rOQL38iWTI4qc84kU/dz6Y0zX4jIknNaC7Wsuy+cFvgtzvj0nmW9pxPkfsYLixWpJ5l6KMq8/jUxlntGXVINmFM5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561556; c=relaxed/simple;
	bh=T6g45jeUAECgXRrwnm3vMiXwhhpytNHNv6gdJIOVCIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=anRaSrVebMfyqiaVMD6H85rw0PjbpV4RBFeh9y8tgiJXQEYTndG1GKUKaHBg37e3vx3Efb4q4DwGG4pEpXfIG0nwre7BUs1PQreRnsvOWUhh+BwCAQMaO5XuqXFNzJ2kuJe0T9CiGFggbvdwkOwLIeip77lRs7eBQFUGHI+kUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KlK4TUVI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlK4TUVI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47db714766aso120399f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 12:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786561551; x=1787166351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OneEcsd3WS4X/wyCuCDPzIsiDC1m3+a/nq+CgJxUeKk=;
        b=KlK4TUVII0q9tOSDRCukGT4oYq8K09DcaogxRDviWkvlhN6E4iuF911E5MpuOMtn1a
         UNgcryvl25f5vpDvH0mwuIdwGlusM+0afQfwINWKLkDZi0yoi32elZAHL9zLCfBy/2a0
         edVV3H0qLYh0papRrfh6DRqcx1Su0KOhKnm+gOVADVlBg0ve/WoV/e0OL+dQN6/x+K1/
         4cRG5bbUzUVoNg6rEb7PXz/nAxDqL6ErakyYdkz5A9NalrhNXWR7mTN7v8xu01kSIJ70
         a7m0CEqq5MCYgSivvIlcoucfUCy76eRtX/RIEytjsvGAcez81SZ+6GXK8+l/JH5tgQUY
         YDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786561551; x=1787166351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OneEcsd3WS4X/wyCuCDPzIsiDC1m3+a/nq+CgJxUeKk=;
        b=KPt0jTymhgLU9xF0K20a6uFEEsFSDv+WSLMwWKhpVY2YTdC9OBjwBNw/l9Y6h6EhHD
         B8oYQRwFoRsLZlsJmLc2oS8f6znTXL97XU3quWsq5b5QazR26hjYHRdab72wy+fW0gHP
         LGabapcW6EdlcOYd+JUewnnlqW7P22VXiAdIvhWyE4Mn3dxNSaaWrEWC8QIDSzEc83Wh
         +eeBK0sfROtRzsu4zmkEUjWyMtZXOrpaeJVDI3HLJtI7O44e6PeDY9XQFlbcZXg3bJWX
         ux3nufiefsMv7iZmj9pOZfU5qYbgfFitBtOy/B4uoPCbXuo+CUtTDZFfnTZgS/V6ja2b
         S3ew==
X-Forwarded-Encrypted: i=1; AHgh+RpypOdLSOP5di62Y317A7YJqOwFYvi98Y10OLHr1ZUMFnS78XHKYMFhNSss+bnaDXYPZt274K9VADzwLLbXAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLMX9gRtgtf2rkBsMaiUBbQyETjdLddDvNn525axjJTuuGvUps
	gsU9TFxNbxzMgOcQ0Lv3wLoaIbNACoYeGz6mL1PZ5sIwFXD0i8Y0RJXK
X-Gm-Gg: AR+sD11eTlfRoaFpQarUPIj/OYK4Un7O6NeRroaDHjz9So2tWmZDPIcFWDK78Ol2sDl
	UhaFTNG+UkBRVYbME/f3ZV/ForZ3q1VjCH/Ms7AxUS2LAOtatVU/BMLFMGHRdqFujEl6d8FMxWu
	sTFaRBilmLwWbTS8J2jnJbnmZaXW+DJGSXP7mn+ZloGeEEtuxHqUPGygAZW/BjdELYd5EqFeNA3
	2qXaJit5qYabO4tRC6VkgvN2A9mjNkkzbosbW8bAMAKFSWrvGawe5SbMPUXpKF/t+lB04fk9knU
	/ufdk/hq3E2DsFfuld8HvrAvERIoYtDn6iLocrQpOOHNmCcf2gtH7jocQY9SR5TZgojI+kaM+uf
	jX0p3OS6kaHoTe2ltR6JcIhYQWcjbc1hgUDE9+/z6jAO3N8/pZODWjaArhvO+FPui7nvcfA0uIy
	WozPtfa8CXpptI2DfQl5XcrAGp5l/1Y0Lo6sl95M3UCi13pA0gEwGbi5UjSIAAQdzQinJNFZHI4
	3KY/7sEgydurR5mBImYuqAjsLVxlrizKX6qEsLvx6MDe8TLjQ6heAC/QT5EtJSYTjlcigF1WG8l
	QD23Vw==
X-Received: by 2002:a5d:58cb:0:b0:47f:8554:a341 with SMTP id ffacd0b85a97d-48158e95fa6mr1891878f8f.13.1786561551185;
        Wed, 12 Aug 2026 12:05:51 -0700 (PDT)
Received: from Mac.home ([95.35.242.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150d5eb2csm9179875f8f.30.2026.08.12.12.05.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Aug 2026 12:05:50 -0700 (PDT)
From: Shmulik Cohen <anuk909@gmail.com>
To: stas.yakovlev@gmail.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shmulik Cohen <anuk909@gmail.com>
Subject: [PATCH 0/3] wifi: ipw2x00: fix management frame length handling
Date: Wed, 12 Aug 2026 22:04:09 +0300
Message-ID: <20260812190412.18333-1-anuk909@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The libipw management receive helpers derive the information element
length by subtracting a fixed structure size from the reported frame
length:

	stats->len - sizeof(*beacon)	/* libipw_rx.c:1300 */
	stats->len - sizeof(*frame)	/* libipw_rx.c:1240 */

stats->len is a u16 and sizeof() has type size_t, so each subtraction is
evaluated as size_t and wraps instead of going negative. Truncated to
the u16 length parameter of libipw_parse_info_param(), a frame shorter
than its own fixed fields becomes a length near 64 KiB, and the parser
walks the receive buffer as if it held that many bytes of information
elements.

Patches 1 and 2 add the missing checks in libipw itself, so neither
handler touches its fixed fields or derives an element length from a
frame too short to contain them, whatever the caller passes.

Patch 3 bounds the reported length from above in both drivers. Neither
management path had an upper bound: ipw2100_corruption_check() does not
inspect frame_size for management frames, and ipw_rx() only rejects a
frame shorter than the header length.

All of the lengths involved are reported by the device, so per
Documentation/process/threat-model.rst this series is a set of
robustness fixes rather than a vulnerability report. I am not claiming
otherwise, and I have no evidence that any particular firmware reports
a management frame length below the fixed fields; the checks are cheap
and the arithmetic is wrong regardless of who supplies the length.

Verification
============

Built and run on arm64 under QEMU at f5bbbfec59b4e ("Merge tag
'probes-fixes-v7.2-rc7' of git://git.kernel.org/pub/scm/linux/kernel/
git/trace/linux-trace") with CONFIG_IPW2100=y, CONFIG_LIBIPW=y,
CONFIG_KUNIT=y, CONFIG_KASAN=y, CONFIG_KASAN_GENERIC=y and
CONFIG_KALLSYMS_ALL=y.

Before patches 1 and 2, KUnit cases that call the two handlers with a
2340 byte allocation, which is IPW_RX_NIC_BUFFER_LENGTH, and a reported
length of 24 report:

  BUG: KASAN: slab-out-of-bounds in libipw_parse_info_param+0x100/0xee0
  Read of size 1 at addr ffff0000021a092e by task kunit_try_catch/33
   libipw_parse_info_param+0x100/0xee0
   libipw_process_probe_response+0x354/0xc08
  The buggy address is located 10 bytes to the right of
   allocated 2340-byte region [ffff0000021a0000, ffff0000021a0924)

  BUG: KASAN: slab-out-of-bounds in libipw_parse_info_param+0x100/0xee0
   libipw_parse_info_param+0x100/0xee0
   libipw_handle_assoc_resp+0x2e8/0x3e4
  The buggy address is located 4 bytes to the right of
   allocated 2340-byte region

After patches 1 and 2 both cases pass under KASAN. The KUnit cases
exercise static functions and are not proposed for merging, so they are
not included here; I can send them on request.

Patch 3 is compile-tested only. Both drivers and CONFIG_IPW2200_QOS were
enabled and the driver directory rebuilt at W=1 with no new warnings
relative to the unpatched tree.

What was not done
=================

I do not have ipw2100 or ipw2200 hardware, so nothing here is tested on
a real device, and patch 3 in particular has no runtime test. The
reproducers are KUnit cases that call the handlers directly with the
lengths the drivers can pass them.

An unrelated observation while tracing these paths, in case it is of
interest: the CONFIG_IPW2200_QOS block in ipw_rx_notification()
(ipw2200.c:4470) looks unreachable. It is entered only under
case CMAS_ASSOCIATED, which establishes that notif->u.raw[0] is the
state byte, value 12, and it then tests
IPW_GET_PACKET_STYPE(&notif->u.raw) against IEEE80211_STYPE_ASSOC_RESP.
That masks the first byte with 0x00f0, giving 0x0000 rather than 0x0010,
so the two predicates are mutually exclusive and libipw_rx_mgt() is
never called there. The frame and its length look like they were meant
to start after the state byte. I have not sent a patch for it because I
cannot test the intended behaviour without the hardware.

Tooling
=======

Per Documentation/process/generated-content.rst: the defects were found
with AI assistance (Claude, claude-opus-5) during a review of length
arithmetic in kernel management frame parsers, prompted to look for
subtractions of a fixed header size from an unvalidated on-the-wire
length. The tool identified the call sites and the truncation, drafted
these patches and the KUnit cases, and ran the KASAN and W=1 builds. A
second model was used adversarially to attack the result; it refuted an
earlier fourth patch and an earlier version of patch 3, both of which
were dropped, and every remaining claim was rechecked against the
source by hand. checkpatch.pl --strict reports no errors, warnings or
checks on any patch in the series.

Shmulik Cohen (3):
  wifi: libipw: reject too-short beacon and probe responses
  wifi: libipw: reject too-short association responses
  wifi: ipw2x00: bound management frame length to the receive buffer

 drivers/net/wireless/intel/ipw2x00/ipw2100.c   | 4 +++-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c   | 9 +++++++++
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 6 ++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.50.1 (Apple Git-155)

