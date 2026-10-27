Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793125118;
	b=chH86oznhKZ9M/UJHBPH10iaMqwOymsBQPRHjq5qIehShbrV6mhKL0G55ZDsY7cNdzyz
	 +Fz0nzldIgnULl8mX2HeKO3gqOtsFJn533K+NlyqJc3aqI7d08mb919rTKYeWe9s0jZJ8
	 +WlDnzABUCvpTPmf6i+zZFMYatsfrJ9sdG23vjPO0OVAwiINwZqNSQT1tv7ITK+ctqpEn
	 n1Q60cONYI4cUoD11uXgx8erVoPn2vQG/luOgGrOysxLN0tPx5zuWoGxGxDz2HoMMMnWA
	 XP95kU9Y9hyNl+SeXg+7bWoU8+dP5BJ3j1lhNAMw7bW7uSFlAD3gyiPUESeo4XEdA8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793125118;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:
	 MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=9w8avXhEQnt+ubfLntLAY5OD7jP+c5wq6VSJzsxGAQU=;
	b=lJQoLtU9cNfr/9eo4Vocp7BUfBQtkbHUrMqvYm20btk6X+3/QWZKtWQIpVaxh/6WPRcJ
	 xOAbH2P0dURyLpiCkUmCTdFIOk47fhL7vKgCUMbq/UrV1ceccTQMM5mP6AxIJC0go7d5Z
	 wD6tKuhRuNVradRr2qiTz9vQ6Ue8MYun4bkHpO1k9Bh5s8wl2cgm8APb9PjhwEQXRmswM
	 mTRi28go5nSsHZRbXmlyQeju+E5+sJ3zCujUUo2ZBR2OVo5Nvx9YUQNE5C8TD+XHoVHBB
	 Rq+50dqJo5Ad27OPDM8YOKwlnNWTKK7sY1KF1Ns6FoLOXck72ZLbnDScwXN42eIzCpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lBJuhnhx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C97606A320
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76C97606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lBJuhnhx
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2e8c710847so17753966b.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:18:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793125117; cv=none;
        d=google.com; s=arc-20260327;
        b=JjVsTMHzZqmDlvgJZyiVb5owubDmQcgTvcFl2Oq+pruCUMVwYl6jg4yE4jgF12q5YG
         EVXWqDA1avPsSCYwRXr3CgAdzdIOrto1kAs100hrqfDC8m7HQrgHoGS74+mXupOaILQ0
         Yn3eU6s0cp7vJAWLb0CqfRR0V4gt9j9SB1u0PUz7iVeR0+Bxojm4oi2nVlIw2Zj7yRED
         iUDt3iLO78ZgoKv8aUkOmFIphyt3Gj78bUcX1rR6XYCb/nDuArp8OYHsHnOdN+R0WGi9
         AznHNXl0Up7Nm9CcA6w9T3WLxuaCR6paw2TMV+2Zg4dpMpPqu7PmXx/fLqgfAbREmFly
         8VgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=9w8avXhEQnt+ubfLntLAY5OD7jP+c5wq6VSJzsxGAQU=;
        fh=CH4nd+rWz3U0ddHU8IfQPLeqruXXmWSUt5Sj2Tt1rH4=;
        b=asW8xyRPRJT7Azqtedi1L6iNxvlU4ya4Ksq7bpTdEQGFCXzPLol6rP8zHye01LADVF
         ioHGgZlyn+Qz0LReF2L8XbsiuD+0Fbu2QbUvF3fG8IMYxC4yd4DgozrxlEaxVfKszmaA
         c1GECyoIc+TYGVrXGUFaUny3JFIHcv5q1wdIbCKSyB3FmJckQfR9xsvobmas7lZ6ODsf
         P2b+yXGSCUF5Xo7C6UWPIepyO4uFoopbCgCGoH7tPJPhn7+jy3e0adeRR23KS/aVsEsJ
         aOBvUw/NDctOFWFNL8ZXuDq+qUzaN9/8rjuq8B6m2r/pUGaRCvbDF+QhE5JTuFm+5Ihm
         PeJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793125117; x=1793729917; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9w8avXhEQnt+ubfLntLAY5OD7jP+c5wq6VSJzsxGAQU=;
        b=lBJuhnhxKlD/Z4+tEsvPXpB16/c/H3pPU6r5Ji96cx9WVotX9CC1zIKKhoVaZcZWVo
         vtOUqtZ/QFPcvkrrDTHNRSCZ1QQBNMugBYYmoPD0nb/odwqGoexHhw4uEM0LIknYx7Vw
         K/lD+Z2SluLNrZgEvmWCWiStQCKjuc4b5TGd2lOgRIF97Lb6xN9fJvYSAat3idjBsGhT
         e5msTCv28ZsA4Mz0LLE8rb/mdPCXo4mgVR8+ENKpF1cPb8/65ZxLDkdzIj78g1+dC6na
         tB6pUlmcUhYzaXzi5jtH2A3NTorPZGZPeRnkkYBTd2ZegMOz6KNvVHDfU+NtB3eh+yFB
         428A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793125117; x=1793729917;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9w8avXhEQnt+ubfLntLAY5OD7jP+c5wq6VSJzsxGAQU=;
        b=B6ZsVLfPUqUGKt0yosaodVVuNn44Fatqjnv36q2sFo3fLy0VgTTPBQc6Rm5I3iNz+n
         uW/Abn8XN170KLnvvtHEP2Jvov5qA8tzg1tY2zrnBnNDwFD4ySA9GA2L3JdEeb35F+Yz
         pGax+okarxRihritZDky9yN9BihER0hoogFB4Ea1NrpQ0iqgiwaJ6x8JmnWSZNXDpJxA
         S6nu+hji4oVX7Kc0K+PxrCoUj8G7Q8flAAvNDlzQV3R6BglBS7seZtm3OEMjSp4d1hUN
         jjdB0SwV/GDCj15JSIlwSevftx4/suOIzWGDdPdwHtqpoXPqAcyz55vJmTqGTFoy2odh
         9ZmQ==
X-Gm-Message-State: AFq9FYK+jw2h+jAykB56oHg67SglEQTG7lEsxOL4/XQUcQtWx9EOmo7c
	ZzMYx5EbQoNsh0ycNgQ0HIvKgIi2/VptOct9e9TM7iQ198E1ehWl1TsrtHPnio+HN/GtNoYx/2S
	MO32iRJyKlfcmzsY5NkWoDgbiBK25FSv8WP9K
X-Gm-Gg: AYBFou2jgdE2l+49InBLNO73DgE1pgsYBGM6il0u8P+qMBc2w2iczGTaOvakoIfmvUn
	VGjRYGDDiqhJan2D410T+D/tAZdyGlVZ7OaC7Leat++eMAYHfdXRtwUdOvR5EIAc3BdqDrpHGca
	8/wmjCSs9KySV45yN/8MpalCkvl6NjoS2Yd0NjQsoiXxQ2V3Nvug240Y5DJ/QM8YjVBxPCgCS6x
	Ptgy0J5A3SlQvnIo4m87a3POomxBPZDaDBd/oU3OLeWb9Qx1IS2z2Ybyn5NhJz2G/LLIfZ0t1mE
	TP+d0a1rkVhBVtr71DxRLt+HZeZCkM3ApsSwT/VO+8FjAKjaloUvjjo2f7lJ1YM4blxaUzQs1mt
	o1Ke6dtg/G9o+Pg3CbluVrQ2eKYINdrj+yQ==
X-Received: by 2002:a17:907:2da3:b0:c33:392f:7ca1 with SMTP id
 a640c23a62f3a-c49bdf37690mr5486266b.17.1793125116635; Tue, 27 Oct 2026
 11:18:36 -0700 (PDT)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Oct 2026 11:18:35 -0700
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Oct 2026 11:18:35 -0700
From: Ivan <ivan.vin.ctf@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 11:18:35 -0700
X-Gm-Features: AclHuK-7col2tica1Q9cSyDhBzPWi36C52EjDkeF-7ZQ36mXdtwPLYrHG4CuaeA
Message-ID: <CA+hZKYJsbtLf1UR0SrGLd+HchCPhPEFksp3fMzF-+w6a5-VR6g@mail.gmail.com>
Subject: Re: wifi: mac80211: two more check-sdata-in-driver WARN sites
 (drv_bss_info_changed, __rate_control_send_low) - same family as the 2026
 set_bitrate_mask fix
To: linux-wireless@vger.kernel.org
Cc: sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 26, 2026 at 10:56:01PM +0000, Sasha Levin wrote:
> For this one we need the full call trace to see which path gets there, and
> the reproducer. Could you send both, from current 5.15.y (5.15.223) if
> possible?

Reproduced on 5.15.223 -- and this time with a minimal reproducer.

First, a correction to my previous message: auto-extraction had in fact
failed on the original crash logs (the bug is flaky under broad fuzzing),
so what I called a "repro package" was really 16 crash logs. Apologies for
the imprecision. We then ran a focused campaign on 5.15.223 (only the
nl80211 race surface, procs=2): the same WARN appeared 4 times in ~80
minutes, and this time syzkaller extracted a clean single-program
reproducer:

    # {Threaded:false Repeat:false Procs:1 ...}
    r0 = socket$nl_generic(0x10, 0x3, 0x10)
    r1 = socket$nl_generic(0x10, 0x3, 0x10)
    ioctl$sock_SIOCGIFINDEX_80211(r0, 0x8933,
&(0x7f0000000080)={'wlan0\x00', <r2=>0x0})
    r3 = syz_genetlink_get_family_id$nl80211(&(0x7f00000001c0), r1)
    sendmsg$NL80211_CMD_NEW_INTERFACE(r1, &(0x7f00000002c0)={0x0, 0x0,
&(0x7f0000000280)={&(0x7f0000000200)={0x58, r3, 0x1, 0x70bd29,
0x25dfdbfd, {{}, {@val={0x8, 0x1, 0x4a}, @val={0x8, 0x3, r2},
@val={0xc, 0x99, {0x40, 0x4}}}}, [@NL80211_ATTR_IFNAME={0x14, 0x4,
'vlan1\x00'}, @NL80211_ATTR_SOCKET_OWNER={0x4},
@NL80211_ATTR_IFTYPE={0x8, 0x5, 0xb}, @NL80211_ATTR_4ADDR={0x5}]},
0x58}, 0x1, 0x0, 0x0, 0x800}, 0x4000000)

C reproducer (syzkaller-generated, 13KB) available on request.

Confirmed on: 5.15.223 (KASAN), "Not tainted 5.15.223 #1", 4 instances
in ~80 minutes of focused fuzzing. Crash report excerpt:

    wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
    ------------[ cut here ]------------
    vlan1: Failed check-sdata-in-driver check, flags: 0x0
    WARNING: CPU: 0 PID: 346 at net/mac80211/driver-ops.h:172
drv_bss_info_changed+0x4d8/0x580
usr/src/linux-5.15.223/net/mac80211/driver-ops.h:172
    Call Trace:
     ? ieee80211_get_mesh_config+0x40/0x40
     ieee80211_bss_info_change_notify+0xae/0xd0
     ieee80211_set_mcast_rate+0x41/0x50      <- (original 5.15.216 trace)

Shape of the bug is slightly wider than one call site: in this minimal
repro a single NL80211_CMD_NEW_INTERFACE creating an AP_VLAN (iftype=0xb)
with 4ADDR on top of wlan0 already drives bss_info_change_notify /
drv_bss_info_changed on an sdata that is not (yet) in the driver
(flags: 0x0). The original 5.15.216 logs had the SET_MCAST_RATE /
SET_INTERFACE flavor (flags: 0x4) with both task and kworker victims, so
the class covers several entry points -- consistent with the family the
recent set_bitrate_mask fix belongs to.

So: still present on current 5.15.y. Happy to test any patch against the
fleet and provide before/after traces.

Regards,
Ivan Vinichuk

Reported-by: Ivan Vinichuk <ivan.vin.ctf@gmail.com>
