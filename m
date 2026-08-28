Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4913BED32
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787944258; cv=none; b=dn/hRLuTIws6KUvj11RYqzsVrBFoUASA4E0tSMn45ywYRi0KUcbFDymkH/H4qyltqaupFR/CISL4nm0YyLMovJqOnE9cirkDIh5m/3hI1L1WVMZwktf2/VrvkCGSJZ+DTnGirMI7bOVtVKRVhmesCEpsqWOPh7q3nF+79GGFLcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787944258; c=relaxed/simple;
	bh=36nLVAjVnyXQ9NM1V1+VNywtVenoPVkoSYIpnXSwhjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7vno4DND0rN0mHFBn3gjgEbHNvAmOQb2z6NHk3pxL5tThYUyv5ywbNRsazlbRWnw2DDfwyGBN3Dzv0u2pA0WDkjdFZIN9E/STTBQkq8Yuitii3+bDV1ggRIQTkFgbKJQnShiP9hbQRU5fLS4wP+LFmzwFsF4DgSXcft8LymNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOubuykF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOubuykF"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-495590dde14so12994685e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787944254; x=1788549054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SoUMcMxZ4jSXfVyBbNxTOmQ0cjlOeDjZWBJ+hZQ/vkM=;
        b=KOubuykFkd/Zm10i9hogf8FcNAJnnLoy2MEc4DWGfjmPO+8lhatipPJOMJIW3+iTcf
         AvFim3g0WPe+sFbPouMhjh9VvWPx35rtQ5MVkZua442Ci9D3XJ0auOJoGlt5j4eG9Esm
         aGbKctCOhTe+Iaba8d4koR+J3GB0/sIEDqFo5xU+OwZOh73Z8YoXGY+zTbv/edq0aR96
         1D7hv2VvTGyoOlN6mJ4R32Fk4xfYHQooHhaqGCIaH5Ch3YoK3HynfLh8FWTeUWIpCqSq
         IBUFnVjK8jf9e1WwjrhOeOGXAUgKVjz1QzP6JsvdGa87IXbtuwZrM+5S6bm5W2OK8Ly3
         d1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787944254; x=1788549054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SoUMcMxZ4jSXfVyBbNxTOmQ0cjlOeDjZWBJ+hZQ/vkM=;
        b=C811AeVYVInWhpDQA9cgrt/3ohPnoOeoF5vsT8MZIbHvqkGejoo3K7CcIkvqz+SR3X
         eZVtNCXN2hJ+6yt09Me9dfhUtjxBsjmsyaLETTxgM3HwCOUqLaTamnUFBL6a+krdmtdo
         l5CZHjTVy5p3gvT0twb4xOfVRVxUOSl6CQMhb6H2d8iA/TBvWAkIgGNDeftg/61Y6NjH
         0qynL3kZ1gW5Oug8Fnj9UaQoU0oEzZ1YqV9JyqPF6ylOLCoWp5PmCcXRvSOmD2AQIBAx
         K2fbKVp/L4Z5xrRFiN9yE58kG7Ith52XOvL8SotlRd3JRSHTLJbmbojtmjV18ox9yWvo
         d1gA==
X-Forwarded-Encrypted: i=1; AHgh+RrPr7D/71OT/a2j32UEpJVuz3EeazqmF8Z7n/mFPye55+Ok9sg2N5bq+DJsRkvLs+VGzPXvZAyx0kQVu0G5RA==@vger.kernel.org
X-Gm-Message-State: AFuF++mtCLVe8cPRlTsRsHr1Tl9h23+nH7Q+V7j2F48W9gxXqSTvTGSC
	+faJrmjxPtpcmXWufUWZewkM/dRYA0+U0aZB1coLHy7GBUl8Cz72f/GW
X-Gm-Gg: AR+sD11bPGmlaPGjDJqRVBQeWeS7sF2WortGcFegPTKs9MvhBoBgwWPUTx5f3cr/eLn
	YPdLGzv4ZcLvUfiYWsUr8CwerYeR+0//wiwE+lZdydraGER0kL+zkbCOUuT4Ofv//ZGXofA+LlM
	KmBLfFE/VqhBQ5NCSSSqTPdf2WH72NS3//pG/GC3uWcXr0yitq7By4sczpMoFwuFLcy3EYJkIim
	QABCF7e6TSk+RmzdAnabi6J85+f9f6SeIapqteatPxorjD9/kT6aNOu3LjKuVEPR5agwB68k4Fv
	9A+w5M/Ys0VV2Wv6OxI6dXOAYHbx/fWOYzue0oIwv+6ZSH+kuB03oTGk6W3qtfUue51xkfdOy//
	R4pElu4C56bDryDe4TutoI0R7m81EUFBXUJ7lUM+UQUo92mLgPsDgkbGlDgDEDF8GzcLtN62Una
	iKnrRVUexG/Kc0600A9wuamsiGAU9GTI71TMNAnRRrPX23VclheE2uxU2ZGTVTILojDG7xMsiw8
	e8r
X-Received: by 2002:a05:600c:c493:b0:499:a5c8:c6f3 with SMTP id 5b1f17b1804b1-49b91c20914mr137793525e9.3.1787944253452;
        Fri, 28 Aug 2026 12:10:53 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b49cc61cfsm165049015e9.6.2026.08.28.12.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 12:10:52 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Mehmet Fide <mehmet.fide@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Fri, 28 Aug 2026 21:10:51 +0200
Message-ID: <20260828191051.178481-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814053426.2473247-1-mehmet.fide@gmail.com>
References: <20260814053426.2473247-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke, Bitterblue,

thanks for the ack on this one. It has not been applied yet, and before
I post anything on top of it I would like your opinion, because I now
have a case where the same lockup comes back with this patch in place.

What happens
============

The patch made the after-DTIM routing conditional, but nothing bounds
that path. mac80211 sets IEEE80211_TX_CTL_SEND_AFTER_DTIM on every bmc
frame while a single station is dozing, so one client in power save is
enough to put all broadcast and multicast traffic back on the high
queue. The chip drains that queue at beacon pace while the frames
occupy the shared TX page pool, so ordinary chatter such as mDNS
exhausts the pool and with it every other transmit, including the auth
and assoc responses other clients need. The AP still beacons and looks
alive, but nothing can join until the device is rebooted. That is what
our field report looked like.

Measured on an AM62 based AP with an RTL8822BU, one associated client
in power save, and 40 broadcast frames per second generated on the AP
itself. Free page count at 0x240:

  t=0     1803
  t=30s   1148
  t=60s    716
  t=90s     16   <- 0.9 % left
  ...       16   pinned for as long as the traffic runs

and at that point dmesg starts printing "error beacon valid" and
"failed to download drv rsvd page". When the client wakes or the
traffic stops the pool recovers; in the field both conditions persist,
so the AP stays dead.

How to reproduce
================

  - any rtw88 USB device as an AP, one client associated
  - put the client into power save (a phone with the screen off will
    do; on Windows set "Wireless Adapter Settings -> Power Saving Mode"
    to maximum and reconnect)
  - from the AP itself send roughly 40 multicast or broadcast packets
    per second, for example in a loop:
      socat -u - UDP4-DATAGRAM:224.0.0.251:5353,ttl=1
  - watch the free page count:
      echo "0x240 4" > /sys/kernel/debug/ieee80211/phyX/rtw88/read_reg
      cat /sys/kernel/debug/ieee80211/phyX/rtw88/read_reg

Do not ping the client while watching. That wakes it, mac80211 flushes
the queue and the pool recovers, which is what hid the problem from me
in the first run.

What I would like to do
=======================

Mirror the vendor driver. It never lets chatter into the hardware high
queue: xmitframe_hiq_filter() in core/rtw_xmit.c admits only ARP, EAPOL
and DHCP (CONFIG_RTW_HIQ_FILTER, default "allow special"), everything
else leaves on its access category queue. With the same rule in rtw88
the pool stays at 1803 in the test above, a DHCP flood still takes the
after-DTIM path, so the filter is selective rather than a blanket
disable, and plain join/ping cycling without power save is unchanged
(10/10 here).

The trade-off is that a dozing station can miss non-special multicast,
since we do not buffer it in software the way the vendor does.

Before I post a patch:

  1. Is such a filter acceptable as the fix, or would you rather see a
     hard bound on how many bmc frames may sit on the high queue, which
     would also cover an ARP or DHCP broadcast storm?

  2. Or both, filter first and bound on top?

  3. Is there a way to learn the DTIM boundary on USB that I have
     missed? With one the driver could hand the chip a single burst per
     DTIM and the pool could not run dry at all.

The patch is ready in either shape and I can post it as soon as you
tell me which one you prefer.

Thanks,
Mehmet
