Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793058644;
	b=4LjgGi/jSd4dCj85Zrin4wYQ+/RjKaCmoeyQCIssWA+B3Lp5udl7YurXc0SPRKgWgG/G
	 ApDT4ARLa4Mo7XrdD7jGUeua8Et4KAxPht2D0NDght+4ZJCGxJUyTl1+3smv/NYaImiXi
	 55TI8rabaoCkjSq07ds2tjvLnDBl6oLVg2MlznNMzwgmRUh9ryANnuZr3t2zRNd/QpK+c
	 ok8Hjt3doRQ6gy7UY4cPjs8J+NMv+MtwF596VqFGiaAMI2ZMJviTwAR/cfWXR6VMz4u43
	 BJ40s3todCrSd3xEVb3mrYrdW7N1I0yNqWBNszzvcJTM21DkLxqCEkRDZuEt3u/m2ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058644;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:
	 MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=lDdApQt65kh6SFmuVULuPonyez/cOMlGOZ18dqH+3fc=;
	b=qFzaXcIx4E3PPfiSyfljplO6rJVrgoeunj2v+MgMaCmDNHH/nDGI8rmNkgegptMErklS
	 3uIPLcWTURqvQEFDjemQbYHJiFOAoCUraPsFU3V0Hs4ri0AKDN6iDLuHd8L/MKPfCtBWJ
	 64cxzW6lPCkW7qXldMa2Um+4nxOs0gWjgcwSWLDPZ6hMYx9tyXVspDa/Gwzvx4vRYpxdb
	 s6Jy7ZPAy0ajXCPf0s4R9I7P4fWp+/+y0ReihzvRouDmahBruulNdMK5wkeKmv+yfsEAW
	 2ayR3gTUi9Vk7h0gEJ9tvhu7ZncbSMLKLTP6xVT2KgixgCdGdedTI5OCw/d6KnhlAnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l6i3Sz0M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BF606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:50:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 653BF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l6i3Sz0M
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6af9a90e4bbso3848234a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 16:50:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793058643; cv=none;
        d=google.com; s=arc-20260327;
        b=n+PJyR0yc3B6IV6O7JEZZpgRVS2w76m78LT754eQzVLfPt9HyjAquC1fKhhx4e/V0V
         7Ma/klgSg6vpPtG9NY9YdAbL0qkMy4pev9/MUklS9eZ1ydYFlsjYOxQmlESu0DWsNYfQ
         66onkaAEahdErNXOJ8311THFApcKJG3VjgTn9XK3pnhGTv1QSygeUfib9r311gcTuA8t
         yj72f/GV0HxqLjrEhJTdgH1Eo3VsbaVES/UMBPAYBCCcoMkRFYqn+SbfoooyeQsfWcMV
         x+g3A9Blv0ZemcT50wReOLMURvKDCNxzwdLcBJOg6p64odoaHYY7XFwzKV5rsC/yfAkf
         eutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=lDdApQt65kh6SFmuVULuPonyez/cOMlGOZ18dqH+3fc=;
        fh=CH4nd+rWz3U0ddHU8IfQPLeqruXXmWSUt5Sj2Tt1rH4=;
        b=mXYtA4NjGF3/3QbPyaJuo4WMQs6bUWxTRK7ECQ5ZPj7UT//K2wTGmP4dyBoTf0L3Ut
         SGcCDNo4xM70yfR9izbZdQ9Gp+gaWyCBq2qkCN5+666jikHbllR+IcHnGho143Xu0HNr
         TZXTFKTD3sWxJSvBG7MTjC5uPuKYDo2LCG0ubP/KKY5gKYNR1qybYO27MeBasslZFrfw
         mRWRd17dh73rZxiNV0wf4nm/FCaGtS4S9kT97nPWE9/zY4RWo+e0CA7iZfIt6qpn723U
         ltDvfAK3F4AUVHyq+4+HdSfqiX5cHd2D6fZPWmuq5+FJYKKRRUChUsc449Mv3s0t/EMD
         I/Kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793058643; x=1793663443; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lDdApQt65kh6SFmuVULuPonyez/cOMlGOZ18dqH+3fc=;
        b=l6i3Sz0MMo30LIRkekWvCqKIJoV0j05Rhew+UJd9GoSGa/CTEVLZMCKkzIVuhMXqeK
         V8a9pVAfxLELu1t64JMuAPr4qB6YmVz9/8RzGj6LOLSiuH86IfxDUGA8IULGL4INFZtu
         zoVf+tddWVEGy+SNsHRH0CpDXdXVtcvLoAH4Kzkx1KL1f9xZQsuagrzeIgX74/EwGnSK
         Uk6Y0H3yj8hy7A+kvgL6dzGOjojmlqeUnM9908hlAJiixBkeLX2UY25Wv9GboFGQ/yCF
         Z2VUao1Lw30Tk0EZjt9VuQOVSKPRjGypVDb+76qq1EmjYXR8JdTSGM/RD/aY1bhH+frB
         d6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793058643; x=1793663443;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lDdApQt65kh6SFmuVULuPonyez/cOMlGOZ18dqH+3fc=;
        b=QEfVifSnLrJZiYc8Ts6zOveTVIx8TE9XJ/DFZZCH/igqDM9fdCnlHNrFV8rFMfOrxC
         tKFDEpL4SGytD2K3y88EAKLJVrAJ8p4TGuqIMt461dpkHPS7ScE0/OfVRZnr9qoII3Ey
         wx5ReyvuSmvnf5ttiFEvvV4Le/vjeNrs26VV0EdPQZwCixPBIy9s18o8EMLLAjLjUHGv
         Br1SmAeigSn6UC99oFJvkHwVa0+STMeDyLiBZ5qGqlOhE2ntauGm5LyN8EVPqWsBYfv/
         LpZe4FColLTciyc+MhoXydMhCiKRfLqvGjBKA92Tbv3qDB1alJijSaAE9jZQNfgcnfcu
         7/Rg==
X-Gm-Message-State: AFq9FYKg12iWjQ80L/U32Mrj9fcZSBQafRiVjf140SlNFiFwrecpRN3W
	T61IPSVGU2+pLToK7x//d3iMtUKruoMpEvSzMcMmi1bZzZmvjuNBZzD/Thu+mRyWAVB8JqMmRrL
	UmCSo9qLm63uIzKrpP40of04hsEpElgJHC+3e
X-Gm-Gg: AYBFou3ha3Lh8lh2jTTjwQXbCLWgrKlCdrJ8vitvDHCDJVu81Fskj5v1C2BXBvijEVp
	LVBr2XxXCSIRO1Bbo6Ciur5+DpNNEMuZFclMrfLDsSwTcjqAVleZOni3iM+Zq2E1YSWqDiOxTvR
	sUfr3LbMkJLGitOnicYuofyfMLvNvTWr7VdP2zxb4HSA3KnkPK/GH5PTJYhvaqOleS+A8uA1Aqh
	k86XsL4O3VoaHEqAwSuoz2eQaL/i6oqZZVTdRYNaObJv55PFlIIqvy9QMPwxg2zkPayUngrXdzh
	YBazv4us4Qgh0nQPhQLG2A5xEz9Q9xq9QaHNfdP6F5mRlhIq1MZA5kJdHD6D9aR9c2pHkFWUt5Q
	w9IPs5wEz9d7KPO3VFzWA/XvKt52/lrivEw==
X-Received: by 2002:aa7:d748:0:b0:6aa:734b:1a22 with SMTP id
 4fb4d7f45d1cf-6b442fe75demr6196241a12.28.1793058642449; Mon, 26 Oct 2026
 16:50:42 -0700 (PDT)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 16:50:42 -0700
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 16:50:42 -0700
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
Date: Mon, 26 Oct 2026 16:50:42 -0700
X-Gm-Features: AclHuK94kVaBEum0G-ej-UjmsG2yTXJXxsdCwzXrU_iTzThRdeOmLEM4huMMjOE
Message-ID: <CA+hZKY++ASgXKe_Yr6rWBiLXW4-FWJPDdwu7UB=RmE4nPAd2GA@mail.gmail.com>
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

Sure -- full WARN block and call trace below (from 5.15.216 KASAN). The
path turns out to be a plain nl80211 command reaching the driver op while
the sdata is not in the driver (flags: 0x4):

  wlan0: Failed check-sdata-in-driver check, flags: 0x4
  WARNING: CPU: 0 PID: 64140 at net/mac80211/driver-ops.h:172
drv_bss_info_changed+0x4d8/0x580
  RIP: 0010:drv_bss_info_changed+0x4d8/0x580
  Call Trace:
   <TASK>
   ? ieee80211_get_mesh_config+0x40/0x40
   ieee80211_bss_info_change_notify+0xae/0xd0
   ieee80211_set_mcast_rate+0x41/0x50
   nl80211_set_mcast_rate+0x2d9/0x5a0
   ? __mutex_lock_slowpath+0x20/0x20
   ? nl80211_set_mac_acl+0x400/0x400
   ? rtnl_unlock+0x13/0x20
   ? nl80211_pre_doit+0xb1/0x5e0
   genl_family_rcv_msg_doit+0x270/0x390
   ? genl_family_rcv_msg_attrs_parse.constprop.0+0x2a0/0x2a0
   ? cap_capable+0x208/0x2a0
   ? ns_capable+0xe5/0x110
   genl_rcv_msg+0x384/0x610
   [... netlink receive path continues]

So the driver-side entry is NL80211_CMD_SET_MCAST_RATE:

  nl80211_set_mcast_rate -> ieee80211_set_mcast_rate
    -> ieee80211_bss_info_change_notify -> drv_bss_info_changed (WARN)

Reproducer: syzkaller multi-program sequence with mac80211_hwsim + USB
ath9k emulation in net namespaces. Minimal shape (syz prog excerpt from
the auto-repro):

  r0 = socket$nl_generic(0x10, 0x3, 0x10)
  r1 = syz_genetlink_get_family_id$nl80211(...)
  ioctl$sock_SIOCGIFINDEX_80211(r0, 0x8933, {...'wlan0\x00'...})
  sendmsg$NL80211_CMD_SET_INTERFACE(r0, ...)   # iftype change on wlan0
  syz_usb_connect_ath9k(...)                   # virtual ath9k NIC appears
  syz_usb_control_io(...)                      # ...
  sendmsg$NL80211_CMD_SET_MCAST_RATE(r0, ...)  # -> WARN, sdata not in driver

16 crash instances collected (log0..log15), same signature every time.
Honest note: syzkaller's auto-minimizer could not reduce this to a single
program -- the WARN needs the multi-program interleaving (interface
type change / USB ath9k probe race against the nl80211 command). The full
repro package (prog + C + logs) is ~2MB per instance; happy to share it
however is most convenient -- I can paste the complete syz prog inline,
or put the package somewhere for pickup.

Regarding 5.15.223: our fleet runs 5.15.216. I am setting up a 5.15.223
kernel + VM now and will follow up within a couple of days with either a
confirmation or a clean "cannot reproduce".

> This one is a known bug, fixed in mainline by
> ab9177d83c04 ("wifi: mac80211: don't use rate mask for scanning").
> It is already in 6.1.y and 6.6.y.

Thanks for the pointer -- good to know it is covered upstream. One
question: is that fix also queued for 5.15.y? We hit it on 5.15.216.

Regards,
Ivan Vinichuk

Reported-by: Ivan Vinichuk <ivan.vin.ctf@gmail.com>
