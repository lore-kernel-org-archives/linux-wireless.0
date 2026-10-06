Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7E3E63AE
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791284996; cv=none; b=LdzqDOv9mSlfo6p7sEYICHqzCBhcKtA0QyL9CfRhmRqNFUA92GnUANBtofdbeCWhDeRNmtpiE0pnIgdAUvAwg/kLrkj3R8Kfq255eJwBvxg1RujS/QvJBCDPO92J3DQ5wfm13lF/3w+4OC31zFj68f/NAzVDQJBhcgLDsqbiy+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791284996; c=relaxed/simple;
	bh=RKZ5uQdCq9vgfW9agoYzzkWxITQdOY748pAUZffaX4o=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cBvIDrgE7gCUAHKM8l9Gp//c011v7lvhF1/ro+Gk27+hiVqPCjE4nQencdbwsxW/RQMl4ksT4I+mWBWOLbMwm2mhaSkGAFghZhKb0lkMPyGWU/f+b8NHaV4h6oMJGUWr3b1uJ0lCz9yWcgNXnlDEzOYh7oB9BfkdWPXjHhXbI6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kbZV/uOI; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kbZV/uOI"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48b0d19cf7eso429412f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 04:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791284993; x=1791889793; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uDKi7dVmNPIxakQV+lW7XvjB/FjevhhlwJT3hC0eTtk=;
        b=kbZV/uOINiyezsDYcmQN0J20aifePqHQvIZvGSCbsH5ni9s8QqR9YZ1D+GizVBJRWY
         7OI2ZGkSHa3pUm/BwDPPKKxToKn1MzdoECz6sNrDlWN4xYk996lWVrS9WznjqmxtIM5+
         JkVTF7QYjvKuSx1Ty17HV64DiBXIccfbCAR+btmVifWXkLNLy9m6yK9Genjn4Spiirgy
         COfsaZ9Nuoj0vjpk0gHp/gn0HE6IvRVuydWsfch/hm1RjtHarid8beZ/Vq/l5r7wLZGB
         U7x1EAZ0Hepec2rFkK4hVqJ9m2ONRCb5+398E0T04j4QFpOIByPVKz+7ITYMPivDQFRW
         SJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791284993; x=1791889793;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uDKi7dVmNPIxakQV+lW7XvjB/FjevhhlwJT3hC0eTtk=;
        b=0nDmhjTeIgHi2qz4yGdNU1LN7t6HEYDSrtbpY2FgJ0TWvM4oZ4J8EcTs9TMKNpNi3R
         xP2NhqY+E/nUF0cVNwNPYFZuznYJ2uipKTCGpvwEcjzx8VCS8hb5ZEOaF+e5ZeGKJuWi
         SL+Ra1pJy1QCnbkYDbJkSGSyZLaNvISwSTZr0Q/bjHwIjBUQauduINb4SYe4zBCyUEzn
         DN/EibTES025qxZpRJaML9/5zYwv3WLlWRA9jR0Yn3nFOcN88w/F3pwhDOIc6syT0chY
         whkbqSMZCvSxkuZO0bmFiEvWoJ8TeK53XHDclZ/+Iif8egRvGxOHorqPsV1cV4JvRdkl
         slUw==
X-Forwarded-Encrypted: i=1; AKwUvBxVT67SJPTtopncBc9ysGJlxBc247dpNL5n24n8RSjjeiI1oWGyk3CWsHdQKC0PA7LPTw3VOOHoBl9zLBFk+g==@vger.kernel.org
X-Gm-Message-State: AFq9FYII9vjkpYV0J7I04aJKoJaQSirRqeqFTlEBxfMaRRTmbaDfmnR0
	K+vgjIha3UwKtasILlhud8rjKeZaY9i/Lwd4QDI5B/Fk0xPoUz49MZ+H
X-Gm-Gg: AYBFou2srizLyeX0Kljg14F6217NCfERFQ0C2oz9MGsIsbw1SQnWdEQnm0MW2Zos8EG
	nwroqrFPKGn09cnjJD0hdMX76crn8pAJMuWTj/xqeFMAjNe8svD7uNpoGEyIiyRxNWrW0TWyz2u
	fr91NxYGR2wxI+nMqr1ymwN4II7vf7N1J3dBmSZPmgHlC/KuVUc61xAB4zx94OB1zAMID2kQZbC
	QGoQUUd1GPYGCqbaSCzY14ag/ZdqHB/9wybnZ94z+fOztHfEMJxw2+TUPAsATIanwXDgfTEVedq
	rWvVEopxIa7hBzBluwGH/tYyxSjCz6IMEHkj64XElPlBn9iQtHbysNoq5+9ZkWiml3sn++4Ccn/
	+azIC7GrmHhyd6G2ISZ4e38LflE66J6GcI72xFZu9HZ6IG0g5PtxCskFQzCg1WMPKxpTDogIH7K
	BOxXNvPM+walxMGc6YER1VlYdACOIUTV2cu7LfzlU+iPGHrpE7OnGeytF/CZDHP6jZ/R23Ldh8l
	pROH+0A/yuSZ9ho3yJAYbuZgFB+2IZcwkfQyZjm6xVgYwE8yaYgaWdWOBVzZjNcJtltWDHFwG24
	rPtq5UJX3nTAgnvX4bK4elnB
X-Received: by 2002:a05:6000:98f:b0:487:13a9:80d with SMTP id ffacd0b85a97d-48c6d1898c6mr2578726f8f.10.1791284992412;
        Tue, 06 Oct 2026 04:09:52 -0700 (PDT)
Received: from ?IPV6:2003:f9:4f0b:7500:a48d:bd6:9cf8:701f? (p200300f94f0b7500a48d0bd69cf8701f.dip0.t-ipconnect.de. [2003:f9:4f0b:7500:a48d:bd6:9cf8:701f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c62100facsm10206159f8f.0.2026.10.06.04.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 04:09:52 -0700 (PDT)
Message-ID: <9e45352a-3e06-4d4e-a9a9-66617fae4b05@gmail.com>
Date: Tue, 6 Oct 2026 13:09:51 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
 <sean.wang@mediatek.com>, linux-wireless@vger.kernel.org
From: vakevk@gmail.com
Subject: mt7921e / MT7922: connectivity failures during phone-initiated TDLS
 setup
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

With an MT7922 (mt7921e) in station mode, an Android phone on the same
AP regularly sets up a TDLS link to the laptop when it opens a
connection to it (iperf3). This causes two failures:

1. TX from the laptop over the TDLS direct link never reaches the
    peer. This happened for 6 of 6 links. The phone tears the link
    down after 0.1-0.4 s (reason 25) or after ~10 s (reason 26).

2. In 3 of the 6 links, all unicast TX from the laptop to the AP also
    stops being delivered. This starts within 0.4 s of the link being
    enabled, persists after the TDLS teardown, and recovers on its own
    after 24-86 s. The connection to the AP is not lost and there is
    no reassociation, rekey or kernel message.

Blocking TDLS frames (ethertype 0x890d) with nft avoids both.


Environment
-----------
Device:    MT7922 [14c3:0616], subsystem Lenovo [17aa:e0c6]
Kernel:    6.18.54 (NixOS)
Firmware:  WM ____000000, build 20260724143402
            HW/SW 0x8a108a10, build 20260724143257a
Userspace: wpa_supplicant 2.12 via NetworkManager 1.56.0
AP:        AVM FRITZ!Box [model, FRITZ!OS version],
            5 GHz ch 60, 160 MHz, WPA2-PSK (CCMP), reg domain DE
Peer:      [phone model / Android version], -41 dBm at the laptop
Params:    disable_aspm=N, disable_clc=N; runtime-pm=1, deep-sleep=1


Timeline (local time; "enabled" = TDLS_OPER enable_link)
--------------------------------------------------------
enabled       teardown (reason)  TX to AP lost  MPDUs sent to AP
                                                 during the loss
12:37:23.194  12:37:33.4 (26)    86 s           ~1760
12:39:24.123  12:39:24.2 (25)    24 s           ~710
12:40:16.452  12:40:24.2 (25)    no             -
12:40:39.447  12:40:39.9 (25)    no             -
12:40:42.516  12:40:52.3 (26)    no             -
12:41:21.200  12:41:31.2 (26)    no             -
12:42:55.426  12:43:06.7 (26)    80 s           ~1590

In every link where data was flowing, mac80211 started a TX BA session
to the TDLS peer on TID 0 within 25-560 ms of enable_link (TX_START,
then TX_OPERATIONAL 2-81 ms later). The three outages began
0.1-0.4 s after enable_link.

The station already had an active TX BA session to the AP on TID 0
(agg_status, aqm flags "RUN AMPDU").


Observations during the AP outages
----------------------------------
- RX from the AP keeps working. The AP's unicast ARP requests and
   IPv6 neighbor solicitations to the laptop arrive (tcpdump on the
   STA), and the laptop transmits a reply to each. The AP keeps
   re-requesting, so the replies are never delivered.

- The AP acknowledges the laptop's frames at the MAC level:
   * Per ethtool -S, tx_ampdu_cnt is about equal to rx_ba_cnt.
   * ba_miss_count stays low.
   * Station dump for the AP shows tx failed = 0 and few retries.

- In mac80211, all queue stop/wake events (reason 7 FLUSH, 8, and 3)
   are balanced.

- No kernel log messages from mt7921e or mac80211 appear during the
   capture.

- Recovery coincides with no host-side event in the ftrace
   (mac80211 + cfg80211 events) or in the wpa_supplicant debug log.

- The MPDU counts in the table come from summing the ethtool
   tx_mpdu_success deltas over each outage window.


Observations during TDLS links
------------------------------
- The station dump shows the TDLS peer with "TDLS peer: yes". TX
   packets to it increment with 4-13 retries each and tx failed 0, but
   pings to the peer get no replies for the whole link lifetime.

- On every setup, wpa_supplicant logs "Failed to set TPK to the
   driver" (rdev_add_key returns -ENOENT before the station is
   authorized). The retry after the STA entry is complete succeeds,
   and TDLS_OPER enable_link returns 0.

- wpa_supplicant adds the peer with aid=1 ("TDLS workaround").


Reproduction
------------
1. Run iperf3 -s on the laptop.
2. Run an iperf3 client on the phone against the laptop, in either
    direction. Both directions were affected.
3. The phone initiates TDLS (discovery, then setup) within a few
    seconds. Throughput drops to 0. In about half of the attempts,
    pings from the laptop to the AP also fail.


I have a full capture and can share it on request:
- ftrace of mac80211, cfg80211 and mt76 events
- tcpdump of control traffic
- wpa_supplicant debug log
- per-second station dump, ethtool -S, aqm and debugfs snapshots

---

I debugged this for a couple of hours with an LLM which also wrote this 
report. Apologies if that is undesirable. I don't understand the details 
well enough to write it up myself.
