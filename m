Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE53744E645
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917161; cv=none; b=OAF46ntWIzePINuSoW91j3FcEoBRkKeRRtgnLVfsMZjuCS+3MrqnDeJEKcTGJ0yrswQBHmpyfQ1/t+ykBmSojDvDBkDyPlMMpYgvLpnLa3X6Um7Y3n1hBo997ksEPFloXNGnOEwpNxPWHdBzGXrHA3JD+7PocbVDNSepxzAgO5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917161; c=relaxed/simple;
	bh=PxkQWYYdTZKVkN0O2liDYtjhcIKsaMhtxR8vV+ojAZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tX9AGrfWTr86MSuCqVuFYstBbztcsHaGuOnqYAmU87FBCPDNLGX8cKdmBJ9uQgkHtdlgWpKrHKN5plSXoDt88WgSAbmkXuM3u8VZswMOR85syeaPpveDmuEUSCWsGX14/Vibzs8ua86IztTFyWite4JCyozNdgpvcuz2evC+c3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wDNuOvL1; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wDNuOvL1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i/x2hxr/1+VWy5nn8O+/ObJcxV86QooNG0CMNCOCe7M=;
	b=wDNuOvL1XBSM3gXgw+N/S/j94vjvpMPsG5lSwBFCqDf4sFfUOlM5d4+X70GYvGJjH+2Q4c
	9tNrGK/zPWLVK8TLos/x82OhG+51+w6kd/Jv9dVQHjPQ875Qw+GCXYYykiqDBJg2WWVj9L
	mlyErPQvGrTg6dm4Nmw/KJjKzqlntiI=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 00/19] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Date: Fri, 24 Jul 2026 20:18:39 +0200
Message-ID: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

This is the first of two series adding support for the Realtek RTL8723B
802.11n chipset and its RTL8723BS SDIO variant to rtw88. It contains
only the changes to the shared rtw88 core that the chip driver depends
on. The chip itself, the build glue and the MAINTAINERS entry follow in
a second series.

Sending it this way was suggested during review of v2, where all of this
arrived as a single large patch. Splitting it per change should make it
reviewable; the trade-off is that nothing here does anything on its own,
since every change is gated on a chip that only exists once the second
series is applied.

Why so many changes are needed
==============================

RTL8723BS predates rtw88 and there is no rtw88-style firmware for it.
The only firmware available is the Realtek vendor blob (version 41), and
its H2C/C2H protocol, its association behaviour and its SDIO transfer
contract all differ from the firmware the existing rtw88 8723 family
devices use. The chip driver cannot paper over that on its own, because
the differences sit in code that lives in the core: the firmware command
encoders, the C2H dispatch, the coexistence antenna handling, the
association path in mac80211.c and the SDIO transfer path.

Each patch here is one such difference. They fall into five groups:

  - firmware (patches 4 to 8): the vendor C2H report events, the vendor
    byte layouts for rate adaptation, RSSI and media status, the four
    commands rtw88 does not implement, and the reserved page handshake;
  - coexistence (9, 10): the PTA antenna path has to be programmed
    directly during scan and reasserted when associating;
  - SDIO (11 to 14): software free-page and OQT accounting, the fixed
    management descriptor offset, RX aggregation and interrupt
    acknowledgment, and TX back-pressure with a retry on page
    starvation;
  - association (15, 16): the vendor join sequence, which programs the
    BSS parameters directly and waits for a beacon from the target
    before authenticating;
  - PHY and capabilities (17 to 19): calibrate once at power on, restore
    the per-rate TX AGC, defer the connect report, gate LPS on
    throughput, and advertise the correct HT capability.

Patches 1 to 3 are the chip type and helper plus two one-line fixes that
have no better home.

Scope
=====

Everything is gated on rtw_is_8723bs(), which is false for every chip
currently supported, so behaviour for existing devices is unchanged.
There are two deliberate exceptions, both called out in their commit
messages:

  - patch 2 extends an existing RTL8703B zero-length-packet check to
    cover the RTL8723B as well;
  - patch 13 changes the SDIO interrupt acknowledgment to write back
    only defined status bits instead of the raw status word. That
    applies to the other SDIO parts too. It is done this way because
    masking per-chip would leave the shared path inconsistent, but if
    you would rather it were scoped to the new chip only, say so and I
    will respin it.

Testing
=======

Tested on RTL8723BS hardware together with the second series: scan,
authentication, association, WPA2 handshake, DHCP, bidirectional
traffic, reconnects and module reloads. Throughput on one AP at strong
signal (-32 dBm), 2.4 GHz HT40, is roughly 40 Mbit/s down and 18 Mbit/s
up, with no "failed to get tx report" warnings and a clean log.

Every patch builds with W=1 with no warnings on its own, and sparse and
smatch are clean at the tip. checkpatch --strict is clean across the
series. The other rtw88 bus and chip modules continue to build.

The implementation is based on the initial RTL8723B work by Michael
Straube <straube.linux@gmail.com>:

  https://github.com/mistraube/rtw88/tree/rtl8723bs

Based on the rtw-next branch from pkshih/rtw.

Luka Gejak (19):
  wifi: rtw88: add the RTL8723B chip type and SDIO helper
  wifi: rtw88: rx: mark zero length packets on RTL8723B
  wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
  wifi: rtw88: fw: handle the RTL8723BS management TX reports
  wifi: rtw88: fw: send rate adaptation and RSSI info in the vendor
    layout
  wifi: rtw88: fw: send the media status report in the vendor layout
  wifi: rtw88: fw: add the vendor firmware commands used by RTL8723BS
  wifi: rtw88: fw: fix the reserved page upload on RTL8723BS
  wifi: rtw88: coex: add the RTL8723BS scan antenna workaround
  wifi: rtw88: coex: reassert the antenna path when associating
  wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
  wifi: rtw88: sdio: handle the RTL8723BS management TX path
  wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
  wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
  wifi: rtw88: record beacons from the target BSSID before
    authenticating
  wifi: rtw88: run the RTL8723BS association register sequence
  wifi: rtw88: calibrate and tune the PHY for RTL8723BS
  wifi: rtw88: match the RTL8723BS firmware connect and power save
    behaviour
  wifi: rtw88: advertise the correct receive capabilities on RTL8723BS

 drivers/net/wireless/realtek/rtw88/coex.c     | 223 +++++++
 drivers/net/wireless/realtek/rtw88/coex.h     |   3 +
 drivers/net/wireless/realtek/rtw88/fw.c       | 166 +++++-
 drivers/net/wireless/realtek/rtw88/fw.h       |  17 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 542 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/main.c     | 186 +++++-
 drivers/net/wireless/realtek/rtw88/main.h     |  35 ++
 drivers/net/wireless/realtek/rtw88/reg.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rx.c       |   8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     | 460 +++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h     |  20 +-
 drivers/net/wireless/realtek/rtw88/sec.h      |   1 +
 drivers/net/wireless/realtek/rtw88/tx.c       |   5 +-
 13 files changed, 1596 insertions(+), 72 deletions(-)

-- 
2.55.0

