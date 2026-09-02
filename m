Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988F9469821
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345713; cv=none; b=Tm0D0lcxkGKbtZAMDKvRdIdXkd++IBY81PgfvR+EYO4t1fQIurFJTStj3YHFaJABPowP+sfkdhEWKoTqzRabK/tfj2uNgR77jSQxd6HIjyyJ3n6WzJuehn8Pt9nlPJrl4MXlY1CTuRQ14Bxox4B59pFekhAIzcbEBQq3y+NNMnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345713; c=relaxed/simple;
	bh=X1kI7enujw/BKcxgK8l9mNf0YGyaiGCcyKAncN0yXF4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GkyNKSuoNdRvtuH8mDJHyX1qQ4W1vgMkbA30eOjKiR70n8EYADl091Mc/Jry9I9e1yM05zhlfM2yP+YQwwy9HK+whH33bFy03eAObxZg43al/dl/bUedMCsl7dGgpxbpcJ0LAdXxeYO7ndUwSanYaj1tTqbv9IRVtm7S0pSWK1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OdxwBPOj; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdxwBPOj"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48436216a98so579506f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 03:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788345709; x=1788950509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5khuFZT81tX7pSug/4+JUOUpnKVo3evkTPVFZ3Cd+Zc=;
        b=OdxwBPOjd6cSiI/4INa+0peozNc2JeH94Asca4+QeRK0M0F7ECOvN+xWnCLibBC1bb
         nUxe5wuMdEwakzv0OPYlKlB7fSUw/1ylA7VUmtJs1Qj2ZQBOkWEcD17+LESHoE8lK4CV
         kPkEgImfKl0ghnziRPLsjBDVUBrMiiWTM2XG0ygtL/jz/fY3fzquJ500DPda61AVpXCK
         ikj6K9gtdY7RyPo142V5mGcnABbWTyhYKiPtYhfVGZqOOXpx2chFduzs5rCp+nLz9Wgw
         Lw4uayGRE7lj7RvIpjJT1qehXPpX02pAkIFZK3t6hbFWvWvhPSQK1Pzw22PAHBrhN2JF
         VBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345709; x=1788950509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5khuFZT81tX7pSug/4+JUOUpnKVo3evkTPVFZ3Cd+Zc=;
        b=XKFjHPcnMyZ/oJ+Wt042mrWCsHq/hc536V7Foz7zRIdb1K61glRfL71CEVznFi3OgS
         X7oN/TwmSigxsl1sW5gHa60oJd6q+yCtYDNG7zhtlHLDi2FcJi6FUNF0lQLj0tuD67mp
         zIyKA1cXJIuBD1MLOg+128qgEhXzeoLwmTyAxEeRPFOu/AYudeHu12EhYKFQDiWUI7+C
         pm1yV0vqU6YlFksuacA3Di/msw4tml1hIOdDP08pUofbzGBNikbOt2xJpIcdL/wnrlpj
         K6I22JdmKnVxzWISmaN/vw9tOoasVFQIYIshED6eZPhg44VrW9L9NyAUwz+yJx4dmFFC
         BL6A==
X-Forwarded-Encrypted: i=1; AKwUvBzJZHIawUfEiMDDsHG7oCyOedhf340BAfBkme7mc15USWvYF/4tVfYMCDpuRb408JD9SMRjmTE30HRzHQbdrw==@vger.kernel.org
X-Gm-Message-State: AFuF++nnxU1S64pymmMn5Njqa9BC82LWGR6TJ4igg7cpim+W22vI6kHY
	v6N+O8EbpHv80WhqW/X5DiOeb1uI6F5SDGLJtwQNUKXYcqlA5HpkPzik
X-Gm-Gg: AYBFou2u8he1jiwyCSQ0vrDShQbK5I0KWd5FpQOt64Y+WBfYOkasYZDl0IZ0H0OxL6L
	miMUVCvs4sh4+yFb5o8oLDEVY8Shke6c7MSxNPAUFoWZrokyhHDJ7hYACc7e2ZiveCqd48mNeqa
	z3LX5mdTOMQ5ssSTobmv0wMwazCqnqtLhaTx3B14BcYBg8IXoWnOZEVg7BkZuJQcGRw3ZDYlXws
	YsWvo/jV9N4BAPp7AR9gEX347xvW6AF8cw5OS55zA91m4gtqPQZzPzS3LoPDxex/jwTS5w8sOBC
	XgXsZldnLvP9V/Lyv8anh4JgPXxHLNaJjmRtWQ+VRk/TiWUA0TsZvtmW4Mis+CtjqaDCG1z5gGv
	2n1UFDH1jSTmyTxrhSgnglUtoq//I0jgQWfb+mrw0cJxguOYBMeyHaDAe0oZPqal7r7ZtlQA6wR
	JpXYelK4e8hmkGHQBvOyhxoSCaQ+vy5UscVpbd5ZzpWcBzZ766ABGmw3RHLvIxXnt2OLc=
X-Received: by 2002:a05:6000:2582:b0:482:fbb0:a262 with SMTP id ffacd0b85a97d-484914b94aemr6379556f8f.20.1788345708202;
        Wed, 02 Sep 2026 03:41:48 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e72df2sm5998947f8f.1.2026.09.02.03.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 03:41:47 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: [PATCH rtw-next 0/2] wifi: rtw88: usb: keep bmc traffic from exhausting the TX page pool
Date: Wed,  2 Sep 2026 12:41:44 +0200
Message-ID: <20260902104146.3853102-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

Hi Ping-Ke, Bitterblue,

this follows up on the discussion under the v3 routing patch [1]: with
that patch applied, a single dozing station is still enough to route all
broadcast and multicast traffic through the high queue, and since the
chip only drains that queue in the ATIM window after DTIM beacons while
the frames occupy the shared TX page pool, ordinary chatter empties the
pool and the AP stops accepting stations. Numbers and the ATIM window
experiment are in the thread [2]; the short version: at the default 2 TU
window the queue drains ~3 frames per DTIM, ~40 frames/s of mDNS takes
the pool from 1803 to 16 pages in about 100 s, and enlarging the window
to 4 TU or more makes the same storm harmless.

The series follows the order Ping-Ke suggested (bound first, then
filter):

Patch 1 caps how many frames the driver hands to the high queue with a
small token bucket set below the measured drain rate; the excess goes
out on the access category queue right away. This is the guarantee: the
pool stays healthy under any storm, including ARP/DHCP bursts.

Patch 2 admits only ARP, EAPOL and DHCP to the after-DTIM path, matching
the vendor driver's default high queue filter, so ordinary chatter never
reaches the beacon-paced queue and the budget is left for the frames a
sleeping station actually needs. At runtime the filter is evaluated
before a token is taken, so chatter does not consume the budget.

Not included: raising REG_ATIMWND. It would add drain capacity, but the
queue stays unbounded and a wider window costs every PS station awake
time after each DTIM; if the firmware is fine with a larger window on
the USB chips I can add it as a separate patch. The mac80211-side
buffering (IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING) needs a beacon-time
event; the firmware seems to have one (C2H_BCN_EARLY_RPT, used by the
vendor driver for TDLS), that is a follow-up once we know it works in AP
mode.

Tested on a Verdin AM62 AP with RTL8822BU (USB2, 20 MHz, WPA2, one
Windows client in power save), free page count read at 0x240, on top of
rtw-next with c710c7c2e038:
  - baseline (rtw-next as is), one client in power save, ~80 bmc frames/s
    generated on the AP: free pages 1803 -> 16 within 30 s and pinned for
    the whole storm, 18 "error beacon valid" / rsvd page failures, and
    after the storm three reconnect attempts failed (no association
    until the client left and the pool recovered ~90 s later)
  - patch 1 alone: 1803 pages throughout the same 180 s storm and a
    120 s DHCP-port storm, no beacon errors, ping over the existing link
    6/6, reconnects 3/3
  - patches 1+2: 1803 pages throughout both storms as well, no
    beacon errors, ping 6/6, reconnects 3/3; the filter keeps the
    budget for ARP/EAPOL/DHCP, so the DHCP-port storm is the case where
    the token bucket actually engages
  - join/ping cycling without power save (10 cycles): unchanged
  - with an iPhone (screen off) as the only associated station instead
    of the Windows client: baseline 1803 -> 17 in 30 s and three join
    attempts from a second device fail; with both patches 1803
    throughout and the second device joins 3/3
  - the same series on an RTL8821CU AP (i.MX8MP, PREEMPT_RT kernel,
    411 free pages when idle): baseline drops to 16 pages within 30 s
    and stays there, ping and three join attempts all fail; with the
    series the count stays at 411 through the multicast storm, dips to
    357 and recovers during the DHCP-port storm (the budget doing its
    job), ping 6/6 and joins 3/3. No atomic-context or lockdep
    complaints on the RT kernel.

[1] https://lore.kernel.org/linux-wireless/20260814053426.2473247-1-mehmet.fide@gmail.com/
[2] https://lore.kernel.org/linux-wireless/20260901091830.2506562-1-mehmet.fide@gmail.com/

Mehmet Fide (2):
  wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
  wifi: rtw88: usb: only let the frames a dozing station needs use the
    after-DTIM queue

 drivers/net/wireless/realtek/rtw88/usb.c | 82 +++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/usb.h |  5 ++
 2 files changed, 84 insertions(+), 3 deletions(-)

-- 
2.54.0

