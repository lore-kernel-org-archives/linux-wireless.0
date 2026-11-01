Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793532037;
	b=nDXSjclOrb2kAJfjKe81UDKeMUTKMyyeeObeGYM9wkUBSh372adY6nvgb1JH3rrzNKZ/
	 6oAbORYapXkPotN5NrZq4XsQNICnPZwhU2Ir2XGmGK81uJ+7WriQC6nMouvUJk38R+d8P
	 FZW1ja+XA3VwtYt3cz84Eaa/909GOk3NyLGbDM9Ehh/0s40Qrn/lSknLs5taGDzoDCU+a
	 03fXk1Q7FamCxcPcCUy9zU/mbV24TePCr51ia1ii5J3IqB4Kpv3U+aG4QRC5DDgZOhxYo
	 EKp1HqEpTKPgfPTMo1FGNs2K1B7OCyx8+5Ti5QQX8BgpiGJ/YKhGnUrezvAT60WHiHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793532037;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Message-ID:Subject:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:Date:
	 X-ZohoMailClient;
	bh=4erZr5sIm2gdOrR78cojJyuy5BKy+pudLRqlSTwD9KY=;
	b=LLuhUdfpRnqTv5SINP0KovTKD2bzY233ArJVrL6dV/w/EMzAFKr9e0KKiHSs8vBJ32E7
	 WZ2/alh8BhJq86KIe8ep+6JMBfaen8FI0bkiKw4K4dXMpCWeXSTSwuEHWfMvHS3PwcNol
	 IcqWv/0+hySjaOgxHRWWLOZ7Bwg86ZgM7Hf26/b7QLU4Rw/J3GejJkVKvD8s0BFvXAeb2
	 XvSMjHNNlgN97TvglrFVwa8y+Y4P+YprmXEtE1T+CbcAsD0PDA+645IFG0rcGv3Ci7iRa
	 1Uk1ahZ5WSzmdjswjgTO2Lty4gO8YPmnIcBJ01LIm9pQpty/GaRYvMbVIWUx/sVhE3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=orcNIYHz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.55
Received: from sender5-of-o55.zoho.com (sender5-of-o55.zoho.com [165.173.182.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E2606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 11:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F4E2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=orcNIYHz
ARC-Seal: i=1; a=rsa-sha256; t=1793532030; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RVKKXsNXyURfsqZY4ujRL3Dn7B757Zkke3hSFjvRG2QH1WcDRFiDyJUDkXWNF8qU/3txUJrCPiqzSD483Yeo5Bl3BSEQ1skL/OsSMYQRgP1PQwSBER8b9ZFz8qGIcneSqQNNXx5/2WkWekItTi7G+GS5yZ4urm8u8LEXzxq4R3Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793532030; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4erZr5sIm2gdOrR78cojJyuy5BKy+pudLRqlSTwD9KY=; 
	b=Y/zFVSFS9JGhQo8pUUdQ6eV7zpr5fDntPFl8o+Sxt0hQZ2u0T+y0uvk188oniCNEkAF7AvIVLC73+74vxeYHS/STlYWT9jEhvt+ifDZgUnE3+JD2uKneZZJYuQmppdcYDHbPVCzE1WzQc8G/y8pm4MRJAuhtStQmGNy9ZMj+dzs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=orcNIYHzWDibX9Fo6K1rtrTt8JquT9Kq/R80BckY4zYGoIuv1Va7qokpGGZIFaF4dMqC//f1ZHwQd9Y9GR0YZGdRjWcMhe2C8rq9gOqcA60ghDXypj9FEpuFkWdquSV9lhAIP1u9UzkqSdeq7LGSZn7SB99lFuQwj7woQzXLo0Z7fDI0Uen96gWCP0Gb49dHGGiR4svx2TMO2K2feQ4zA7mnEEOAbUv5HxxQkbBSlc844TG0ufdTzOkDk6PitHGIIgr34l2pWboe5AEPYOYZBQCaXZRSSG5sNTlMml/zBADslR1+p5hDKuzyeC7tpj+zbc7IVtQBaO8EIxt5dEWUAA==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=4erZr5sIm2gdOrR78cojJyuy5BKy+pudLRqlSTwD9KY=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793532026810318.31155932117804;
	Sun, 1 Nov 2026 03:20:26 -0800 (PST)
From: ph4ntom-rev <owner@ph4ntom-rev.uz>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, kvalo@kernel.org
Message-ID: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
Subject: [PATCH RFC net-next 0/2] wifi: rtw89: fix monitor mode RX filtering
 and enable raw packet injection
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 1 Nov 2026 03:20:26 -0800 (PST)
X-ZohoMailClient: External

Hi Ping-Ke, Kalle, and linux-wireless maintainers,

This RFC patchset addresses long-standing limitations in rtw89 regarding
IEEE 802.11 monitor interfaces (NL80211_IFTYPE_MONITOR) and raw frame
transmission / diagnostic injection (IEEE80211_TX_CTL_INJECTED) on Realtek
802.11ax PCIe hardware (specifically verified on RTL8852AE [10ec:8852]).

While rtw89 includes scaffolding for monitor mode (pure_monitor_mode_vif
and rtw89_core_tx_update_injection), standalone monitor operation hits
four distinct host-driver obstacles rather than a firmware limitation:

1. MAC Promiscuous RX Drops:
   Band 0 MAC registers (R_AX_RX_FLTR_OPT 0xCE20, R_AX_CTRL_FLTR 0xCE24,
   and R_AX_DATA_FLTR 0xCE2C) default to filtering out Control frames (ACK,
   RTS, CTS, BlockAck) and non-matching BSSID Data before reaching host
   DMA rings. Setting promiscuous mask 0x55555555 and syncing CRC32 drops
   with FIF_FCSFAIL unlocks all 16 IEEE 802.11 Control and Management
   subtypes across channel switches.

2. NULL vif Dereference on Monitor TX:
   In rtw89_ops_tx() and rtw89_core_tx_write(), vif_to_rtwvif(vif) is
   evaluated unconditionally in local declarations before checking whether
   info->control.vif is NULL. Injected Radiotap frames from mac80211 pass
   a NULL control.vif, triggering an immediate kernel oops.

3. Injection Descriptor Rate Handling:
   When Radiotap headers omit an explicit bitrate, mac80211 sets
   rates[0].idx =3D -1. In rtw89_core_tx_update_injection(), casting this to
   u8 yields an invalid rate index 255 and leaves desc_info->en_wd_info
   unset for non-management frames. We map negative indices to a valid
   OFDM 6.0 Mbps fallback (RTW89_HW_RATE_OFDM6), enable hardware rate
   override (use_rate, dis_data_fb), and bound retries (tx_cnt_lmt =3D 1)
   when IEEE80211_TX_CTL_NO_ACK is set.

4. Firmware Scheduler MACID Stalling:
   When mac80211 allocates a standalone monitor VIF, a mac_id is assigned,
   but default CMAC/DMAC tables are never populated and no H2C join is
   issued, leaving the MACID context paused in the firmware scheduler.
   Attempting to join as RTW89_SELF_ROLE_CLIENT triggers firmware 5-second
   beacon-loss timeouts. However, registering a non-associated AP context
   (RTW89_SELF_ROLE_AP with RTW89_NET_TYPE_NO_LINK) initializes the MACID
   queues without generating AP beacons or tracking client beacons. Clearing
   R_AX_MACID_SLEEP_0 (0xC2C0) and sending rtw89_fw_h2c_macid_pause(..., fals=
e)
   cleanly unpauses hardware transmit queues.

Empirical Live Validation (Linux 7.1.5+kali-amd64, RTL8852AE):
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- Promiscuous RX: Captured 20,000+ live 802.11 frames on channel 11
  (2462 MHz) with standard LINKTYPE_IEEE802_11_RADIOTAP encapsulation.
  Wireshark inspection confirms reception of Beacons, Probes, ACKs,
  RTS/CTS, BlockAcks, and cross-BSS QoS Data with full dual-antenna RSSI
  reporting (-18 dBm / -24 dBm).
- Packet Injection: Evaluated using standard aireplay-ng -9 against
  active APs. Recorded 100% transmission and delivery success (30/30 probe
  requests acknowledged, average ping round-trip 1.3 - 1.6 ms).
- Firmware Safety: 100% host-side driver changes. Requires zero firmware
  binary modifications; works with unmodified signed /lib/firmware/rtw89/
  images from distribution linux-firmware packages.

Reference repository with architecture notes and packet capture screenshots:
https://github.com/ph4ntom-rev/rtw89-monitor-injection

Patch 1/2 addresses Band 0 MAC RX promiscuous register configuration.
Patch 2/2 resolves NULL vif dereferences, descriptor rate fallbacks,
and the monitor MACID scheduler initialization.

We would appreciate feedback from Ping-Ke and the community on whether
this approach or an alternative vif-tracking model fits best upstream.

Signed-off-by: ph4ntom-rev <owner@ph4ntom-rev.uz>
