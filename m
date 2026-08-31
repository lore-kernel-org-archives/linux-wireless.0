Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFAB43C043
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198655; cv=none; b=QeIsGpt5fw/N4psDeQ+o3G7X5z3c+qB/MHdgBd+jWmT0EOnk/tKz/jQdtae+j9JGJYdWlg3irCLqAPbB6g1px5DhQ22MPdmZqAaJUkbnAEZddLqEMvQpucP4CpmDxbe+fc8x99Sgx4ULbposVpTxVnW986Nb/4j4wu7c1zNi+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198655; c=relaxed/simple;
	bh=f7mDMcO7MOoGwU5a4HMZACKcjZrzHAGreEBv6nYXHUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBIv57TUXXh/05vhwzA9xjZVHHEtPAmq3HsuCRZ4PmLRq85ryC2ChgGp4tqbBM1Gh3/1FVq/f352hMpIgmbkgN5UpdeBz1kdUQE04b0kpxQDGiES7Kkwd3hvT/+tFJsXvBCURcdY4YoEAM/J9alIIamv4iPUOE2t031Wf12KlBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dWQgWf31; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWQgWf31"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c25099bb1fbso503721366b.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 10:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788198652; x=1788803452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=82qJM/jwNMouhJ0qLuGlNwey8nWDI0Y1wFlKVbUceaM=;
        b=dWQgWf31nCijYqVpPmTbKFACdVfOsHscRSOjuEx5lnWx+Xm7h/qlVLpVWeTakDBIHM
         15GCkpGTcnd9in+GsiR/8d24O47fiTnJ/O2OVBeQoSjqMIed7sWfS9tk7UCmdyXxh/dU
         7HhsVoaGdFu4Ka/PEpGQF+t8+nhi+fyXD5V/+q7te5HdOrUHx0ZyOz52i7uZqJ3pj2wZ
         ALy0BmQHtFRwzo4k08wRUeoC0CSNqyjWQXic4RO6pHuDg5pH3VWQZA42dDvcOoYEOiFz
         wzUDO8Pa7zVJVLhbEMUTID1MXnmfIlozfHE6qItMYGKVbvAuAe8RaUhdUrey6Ofy5gPi
         LqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198652; x=1788803452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=82qJM/jwNMouhJ0qLuGlNwey8nWDI0Y1wFlKVbUceaM=;
        b=rHrqj2gkbB4kVRf6AMkbbeOYq4H3MAAwjqOhG0jdJ9Oo1CzvZAj8Q1E3LsCrJk8ed0
         ZZjovPfUZ/PGxkqZL3PCywjAy1kWITAPANIyAafr/dafr3keh73nyxNxiuK32tCiQ5ji
         NT8cfxfC0V5gNbYKukiY9begqJtjA5o/ztJALE4zMY6jeLkbDsJZhGpuky967tWHeLHb
         nNaEncF5zWjixE8vlPvYcpEnviTY6kVK/nrfNqV4JiTJiCt+R8EcTQsD6PDE8tuYupj/
         LxrTAStwrY8GM0dzxbuJOTsN7elUyE9Om3KCCdTmRTLwFPBADZyD65ZhC5rEef4O+EGR
         c01g==
X-Forwarded-Encrypted: i=1; AHgh+Rq6CB7RA7VMt3bLB9RAgKTz1MNzDbzxhdFHmllgG541KVEqpbktHpFiBXAZHbUIeZ9sR01yadQSc6g3TofI4Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nVouWIjqZ9NISG73IIyRGyV31TBFkA20WMM+STpvDdklwBUyOP
	rfm8JOCYDI3I72wJs12l8Ebg/lquDTxRzGawiYGU9YZgqrSbYtEnzacw
X-Gm-Gg: AR+sD120j2VpMZPi20JVLjcDef8oC7f14bG27BXERejndxqvBcVDhwq8B4yadAg23HW
	DHK2+0o94dCw6U/uZD4ULXg6MEvukYRkYgDALecB8AhaX2TKge1Vlt889CiJk2Fu7omS4zro5iG
	KFAgxrHfNzGfjVnFF+B9LorfwYu/pGJ0w+Y/LiSub/85BLQn2IqKVPw73V3y7WKFKSdNi6KNhQJ
	AM2MXDrC1d32IfAU/mk+LbPg0IB5LKzEojUR3xeio6/9MIcYfa1uoYClYVVNhLC4WOBfFKd/Acm
	/AyUN69AiPuR0MyZD1Y1Re/DfFhgYN/SJ1r9h17Yq2BfUN9pNF9ManN9uPuuEC+HCL1K+A0wmSn
	UW+zoQPoglDJ/lXiaMihz1KjFH/xc0LGFpUXOWKfxLofX5noE729XotVPT9VflUd6AoCogKAayn
	/04QOhwdFbLtObymVUpUGMSUxIopG9U7D+xUfFMMpiU0Tor+bC4mJHBStNih5e1uYDsD7xx6ajH
	VbvwBqxzj7jCDo2irCgRVi+cMJ1
X-Received: by 2002:a17:907:6d13:b0:c1f:e9d9:64d4 with SMTP id a640c23a62f3a-c25571275f4mr1837703266b.11.1788198651895;
        Mon, 31 Aug 2026 10:50:51 -0700 (PDT)
Received: from lenovocachyos.home (c83-251-3-7.bredband.tele2.se. [83.251.3.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25878ba94csm283274266b.47.2026.08.31.10.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:50:51 -0700 (PDT)
From: andres parra <andres.parrab@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: andres parra <andres.parrab@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] wifi: rtw89: add NL80211_IFTYPE_P2P_DEVICE support
Date: Mon, 31 Aug 2026 19:50:43 +0200
Message-ID: <20260831175044.208200-1-andres.parrab@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <fe4778c07f644ed38a03c467ef1293d7@realtek.com>
References: <20260822174229.65643-1-andres.parrab@gmail.com> <fe4778c07f644ed38a03c467ef1293d7@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

Thanks for the quick, detailed reply -- really appreciate it. I applied
patches 11-14 from your series (git am -p6 straight onto a clean sync
of core.c/core.h/chan.c/chan.h/debug.c/fw.c/ps.c/regd.c/util.h against
current mainline, since I don't have a full rtw-next checkout set up
yet) and tested on the same RTL8922AE hardware.

Results:

- Built clean, loaded clean, zero WARN/BUG in dmesg through the whole
  test.
- Real P2P-Device wdev appears (confirmed via `iw dev`), same as with
  my own patch.
- Real P2P discovery, GO negotiation (P2P-GO-NEG-SUCCESS), and full
  group formation against my actual Wi-Fi Display TV, tested twice:
  once with raw wpa_cli, once through a real WFD casting application
  (different encoder/bitrate settings each time). Both completed
  successfully, real DHCP lease on the resulting P2P-Client interface,
  real video actually displaying on the TV.
- No regression to normal STA association/roaming with your patches
  loaded.

On the two things I asked about:

1. Cross-band cost: confirmed reproducible with your patches too, and
   it matches your explanation exactly -- forced the STA link onto
   5GHz while the P2P-Client link stayed on 2.4GHz (same channel it
   started on), and casting became noticeably choppier, then smooth
   again once STA moved back to 2.4GHz. Consistent with TDMA timeslot
   sharing rather than a bug in either patch set.

2. Same-band channel-switch disconnect: reproduced it with your
   patches too, while writing this email. My AP did a real, ordinary
   channel switch on the STA link (CTRL-EVENT-STARTED-CHANNEL-SWITCH
   -> CTRL-EVENT-CHANNEL-SWITCH, 2462 MHz -> 2412 MHz, i.e. channel 11
   to channel 1, both 2.4 GHz), while the P2P-Client link was still
   active on channel 11. Result, same signature as with my own patch:

     p2p-wlanX-Y: CTRL-EVENT-BEACON-LOSS
     p2p-wlanX-Y: CTRL-EVENT-DISCONNECTED bssid=<GO> reason=4 locally_generated=1
     P2P-GROUP-REMOVED p2p-wlanX-Y client reason=IDLE

   No automatic recovery -- the group is gone, casting stops, no crash
   or kernel WARN/BUG (dmesg clean, system otherwise fully stable,
   STA link itself reconnects fine on the new channel). So this one is
   confirmed **not** fixed by patches 11-14 -- same behavior as
   before your series was applied. Happy to test whatever you'd
   suggest, or dig into rtw89_entity_mgnt/chan.c myself if that's
   useful, now that patch 11 gave me a clearer read on that code.

Test flow, as asked, for reference:
  wpa_cli -i p2p-dev-wlan0 p2p_find
  wpa_cli -i p2p-dev-wlan0 p2p_connect <TV MAC> pbc go_intent=0
  (watch for P2P-GO-NEG-SUCCESS / P2P-GROUP-STARTED in
  journalctl -u wpa_supplicant)
  -- then wait for or induce a real AP-side channel switch on the STA
  link (I couldn't force mine reliably; this one happened on its own
  from the AP), watch for CTRL-EVENT-CHANNEL-SWITCH on the STA link
  followed by whatever happens to the P2P-Client link.

Given your team already has a complete, working implementation with
real fixes I wouldn't have found on my own (the 6 GHz regd recalc
issue, the entity-pause/tracking interaction), I'll hold off on
pushing my own patches further -- happy to keep helping test yours on
real hardware instead, since that seems like the more useful thing I
can offer here. Thanks again for taking the time to look at this and
point me in the right direction.

Andres
