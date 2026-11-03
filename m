Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793673856;
	b=2hQuA/bCjDGqpB6o871FlhojZIddyjs/idSOyrqja5VdZrqEh5fCU6OFIWR6LxK8XBkK
	 wfoTB9VuAaLdkQ7D/W3w0K8034zGt+6Zk907Rpvp4jq1MOpnKoIz+6r3kJqXWwr5ioY26
	 MmBW97ZoCImyXZ15MwxCQ1vMzKlol1FtOa/9nJnT/Xx0GJSdfVlwM1wSUpEtDEkWwpLGc
	 e0tLCNYF7YmNyEEK15fackGubQQ3st+TJrhoLP0Wfr6hT/K6DkyNkz0IaHc+YU/+vWK1D
	 +4VC2X94Z3cr6fUZa05mAY7U3TvMQv4kB1pjZmjTXHFMo5Z2Zsf/dMS6OagGy6NjXbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793673856;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Message-ID:Subject:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:Date:X-ZohoMailClient;
	bh=NgqP+10Kj1TjSbljMbkotyAWUMurlMB+rQ/6Fddym/g=;
	b=5cy4H2Bf7JxhDs+hFLWm0rpGqBHwGRbOCnbHqBrNmXpB4vbnIbwHgNLyIomtA8uF2HdZ
	 gqdcSwIqqsCUU6Y/jiCPAa0goInwHoz+GT60OYY4wnRjkx0GeDmnxnpS5FTKMCb5pHxQX
	 HzASRNuSGBlJCet0UB28ES5+g84E2QJ8f2B47+U2zIRex1mDAqCjmqvcpmmDuVtr0DySu
	 yT40FePDMo9ftk9EWH86Nflyoxxu0WMwxqyhAUbOpTtjCGoMZXPC+UJzD64xVgWS1px1s
	 6vitJoilxmRtcFqwImK5/Gg0TtJq7+1ZBbZYryVH6UXiglLhtmu0VpRqNguNOOjeDuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=Vu2Wlp3f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
Received: from sender6-of-o54.zoho.com (sender6-of-o54.zoho.com [165.173.180.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7E4606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 02:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC7E4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=Vu2Wlp3f
ARC-Seal: i=1; a=rsa-sha256; t=1793673849; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OEA1kMHj3q4tE9CWrNYBvYEuPXwU7djKiOzoV37zuTbGWI+yNr0TkwKF3XYh/m8QqN61h+r3WQYaeLdjl+8gNBJ1n24Vyekpq+dCFaHkicUsn51Gmm7zj8Baj21Eb45Njd9L+d1gGk3gx9uk6zmE0paHNIhD6yPREmdlqPz5OTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793673849; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=NgqP+10Kj1TjSbljMbkotyAWUMurlMB+rQ/6Fddym/g=; 
	b=M+QSXJ2W3Seq0W9Jk140eDKEaZRobb5YitSw57iHEtf9/mq0swVqsVxB0638Gxk8EC3Jp2diKBFHUCxMIBDq46/5PKKu/glY4hUwo21PJ611O0ofE6/tuzvWON5PV5rlFyZfCbg0ZSkKxv0aP8qK8Om4m7jbdeZADxvNGVRM32o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=Vu2Wlp3fH9F0ERNUM9xc2FSqDADH9ASQWkPW/5t7zQVlsftfGFrWwqngulD8kne70tUnug+ryF9Ec8AKDuJ+jPLU+wmbjFGyFAcBIFYW/W80L7eKKQC7vmzsEEBwoAIrCLstO+y9+5dHhSWTfop5i6uAj39EWxcDJWxdoRRydElqSQ5n3RdA96HjUy87s8cKAyeMP9gZlbBTblcTs1LNQLbkrIcN5fA8XrUU1lfAJjsNgzWLGCX/GuWZpQ4XNPM0oTZqZUrATHK8J9m+/sJrnvlgPQ1S/wc+lpnNiXkNKgNyKU0TI4j4rzxAGO4Osgg9Rgv9r5mYF8TEjlhbQxg94g==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=NgqP+10Kj1TjSbljMbkotyAWUMurlMB+rQ/6Fddym/g=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793673846860811.4708160948952;
	Mon, 2 Nov 2026 18:44:06 -0800 (PST)
From: ph4ntom-rev <owner@ph4ntom-rev.uz>
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>
Message-ID: <1a19f4ae04e.52fd7adc-309223923.5560034215405031423@zoho.com>
Subject: Re: [PATCH RFC net-next 0/2] wifi: rtw89: fix monitor mode RX
 filtering and enable raw packet injection
In-Reply-To: <48b6758afb7844c8bdd6d8b775fd6bde@realtek.com>
References: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
 <1a19b7cce82.5dc2e93-44860545.1830508576953059669@zoho.com>
 <48b6758afb7844c8bdd6d8b775fd6bde@realtek.com>
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
Date: Mon, 2 Nov 2026 18:44:06 -0800 (PST)
X-ZohoMailClient: External

Hi Ping-Ke,

Thank you for the detailed feedback and review!

> I remember I have seen ACK/RTS/CTS/BA in wireshark capture. Could you share
> the default register of R_AX_CTRL_FLTR? I'll spend time to check that days =
later.

In upstream rx_fltr_init_ax(), R_AX_CTRL_FLTR (0xCE24) is initially set to
RX_FLTR_FRAME_TO_HOST (0x55555555). However, during operational channel switc=
hing,
SER recovery, or when toggling sniffer mode in R_AX_RX_FLTR_OPT (0xCE20), the
hardware MAC filter registers can revert or drop frames unless explicitly
re-synchronized with mac80211 filter flags.

More specifically:
1. In R_AX_RX_FLTR_OPT (0xCE20), B_AX_A_CRC32_ERR must be unmasked whenever
   mac80211 passes FIF_FCSFAIL, which is necessary to capture corrupted/abort=
ed
   ACKs and RTS/CTS frames in noisy air.
2. If B_AX_SNIFFER_MODE is enabled on Band 0 without setting promiscuous matc=
hing
   in the Address CAM, non-matching BSSID control frames are filtered at the =
MAC
   CAM layer prior to reaching the R_AX_CTRL_FLTR routing logic.

For reference on our RTL8852AE test system (PCI ID [10ec:8852], HP subsystem
[103c:88e1]), the default register values on channel 5 after monitor mode ent=
ry
without our patch:
  R_AX_RX_FLTR_OPT (0xCE20): 0x00020000  (B_AX_SNIFFER_MODE set, CRC32 error =
dropped)
  R_AX_CTRL_FLTR   (0xCE24): 0x55555555
  R_AX_MGNT_FLTR   (0xCE28): 0x55555555
  R_AX_DATA_FLTR   (0xCE2C): 0x55555555

We will provide a formal register dump across channel hops in the v2 submissi=
on.

> I did similar steps with program written in C, but no problem.
> Could you share the simple Python raw socket script as attachment that you =
can
> reproduce NULL vif pointer in your side? (I think radiotap_null_data_frame =
above
> is a pseudo code).
>=20
> Does every injection cause NULL vif? Or some under certain conditions?
> In my side, I have never seen that with raw_socket injection.

The difference comes down to how the monitor interface was instantiated:
- If a monitor interface is created as a virtual sub-interface alongside an
  existing station interface (e.g., `iw dev wlan0 interface add mon0 type mon=
itor`),
  mac80211 may retain an associated sdata/vif reference.
- However, when the physical interface itself is switched directly into a pur=
e,
  standalone monitor mode:
    # ip link set wlan0 down
    # iw dev wlan0 set type monitor
    # ip link set wlan0 up
  In this mode, net/mac80211/tx.c (ieee80211_monitor_start_xmit()) is called
  without an associated operational VIF. Consequently, mac80211 explicitly se=
ts
  info->control.vif =3D NULL.

When rtw89_ops_tx() evaluates `vif_to_rtwvif(vif)` on an info->control.vif th=
at
is NULL, `container_of(NULL, struct rtw89_vif, pub)` results in an invalid of=
fset
pointer, and the subsequent check `if (rtwvif->offchan ...)` immediately trig=
gers
a kernel NULL pointer dereference OOPS.

(A similar issue was previously identified and patched in drivers/net/wireles=
s/mediatek/mt76).

Below is the standalone, minimal Python test script that reproduces the OOPS
consistently on unpatched kernels:

-----------------------------------------------------------------------------=
---
#!/usr/bin/env python3
# reproduce_rtw89_null_vif.py
import socket, sys

IFACE =3D sys.argv[1] if len(sys.argv) > 1 else "wlan0"

# Standard 8-byte Radiotap header (no optional fields)
RADIOTAP_HDR =3D bytes([0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00])

# Minimal 802.11 Probe Request (Broadcast DA, Wildcard SSID)
DOT11_PROBE_REQ =3D bytes([
    0x40, 0x00,                         # Frame Control: Probe Request
    0x00, 0x00,                         # Duration
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, # DA: Broadcast
    0x02, 0x00, 0x00, 0x00, 0x00, 0x01, # SA: Local MAC
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, # BSSID: Wildcard
    0x00, 0x00,                         # Seq Control
    0x00, 0x00,                         # Tag: SSID (wildcard)
    0x01, 0x08,                         # Tag: Supported Rates (8 rates)
    0x82, 0x84, 0x8b, 0x96, 0x0c, 0x12, 0x18, 0x24
])

sock =3D socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(0x0003=
))
sock.bind((IFACE, 0))
sock.send(RADIOTAP_HDR + DOT11_PROBE_REQ)
sock.close()
print("Packet injected successfully.")
-----------------------------------------------------------------------------=
---

> We should confirm the TX queue will stop before vif removal. Otherwise,
> it might be racing.

You are completely right. Dereferencing rtwdev->pure_monitor_mode_vif without
synchronization introduces a race condition against interface removal.

For v2, we will guard this with RCU protection:
1. Wrap the lookup in rcu_read_lock() / rcu_dereference().
2. In rtw89_ops_remove_interface() / interface teardown, call
   netif_tx_stop_all_queues() and synchronize_net() before clearing and freei=
ng
   the pure_monitor_mode_vif context.

> For the part 'rates[0].idx < 0', we might need to validate it by mac80211.
> Let's review this part afterward.

Agreed. We will cross-check mac80211 rate selection conventions for injected
frames lacking rate descriptors so this follows upstream best practices.

> I suppose these is for injection purpose, right? I mostly focus on RX side =
before,
> and need to think of TX side further.=20
> I'll update my kernel to 7.1.5 to see if it can happen.

Yes, exactly. The scheduler initialization is specifically required for raw TX
injection.

Our reverse engineering of the RTL8852AE firmware (sec_0_EMEM binary) confirms
this mechanism:
- In firmware, function MACID_Pause_ApplyHW (at 0xb8991360) writes directly to
  hardware register R_AX_MACID_SLEEP_0 (0xC2C0) based on an internal scheduler
  pause mask (dword_B8E16E44).
- When a monitor interface is created without an associated AP or STA join, t=
he
  firmware keeps the assigned mac_id marked paused.
- Calling rtw89_fw_h2c_join_info() with RTW89_SELF_ROLE_AP and RTW89_NET_TYPE=
_NO_LINK
  initializes the scheduler queues without enabling beacon generation or clie=
nt
  beacon-loss watchdogs.
- Following this with rtw89_fw_h2c_macid_pause(..., false) and clearing the b=
it in
  R_AX_MACID_SLEEP_0 allows the hardware DMA engine to transmit queued descri=
ptors.

We will prepare the updated v2 patchset incorporating the RCU lifecycle fix
and cleaner mac80211 rate validation for your review.

Best regards,
ph4ntom-rev <owner@ph4ntom-rev.uz>
