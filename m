Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793669768;
	b=yN6WSqcBftC3DWEEPXCJmWFmhUH0UEaWxuTu6LByA3n/3U+GlgyYT4fVZJ84HpTpyLZx
	 yq7Keh2D7+frzr1WEvD15eYhJSBNDXkQdL9dhNVsHWiY4Ckgdlisav8aA3dq+ZVkSTELA
	 mwQXzzjI9EAnTvj8Ad4Q3wYH+2ovpKOniuSRTgfZZ3H3b849J6zgsQqP+sCHJWuzuK0bt
	 44Ifee7tgUS7lAAuZ3Q5wZ6u5LggEENxCq6tibiPozEh7X4s87AkUHJ19+t2SPTr6iP0Y
	 D/aoBWFeB6UG57+CIvswL+ONxECpYoxBqF8kvI/Tqamr0ZSHEFG6XgJ5khQQh1TrAZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793669768;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=IjuGhCcCTuCuUyonTeZihguYjeVmf9zvdSu6F8123DA=;
	b=crfKEOAJJVv6b+tg997Rv3S8ZKsYFQsEXTrx3CqgcvXXTez4Osp+PJmm5pvO3iX2Kmgo
	 i/l4JDpSfRNaersqooNCE9LktD3feoJa+mG+VVMcj3OgmWRT8rkf6EeMofJVaie2Fxkmg
	 h3nsv0nZ68bQ+eyIRspNrIiYJB29qMtzacBHWCr0lWt8Sj0RrwaDnUdgzSFtUOXXObmG1
	 TpYfsPg9JZIUCK+N7H5zVxVV4W2gucLYzVzFgytwFeNQVRiny1Jow2ZaQB7BaFS5zt55u
	 0ECrhCcZ9TBcFmaGvGsQEeLGkr6UhfJ2JuEs8sEIWFzZochLfgztw5d2MJvhRag8LoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ByKvAj4Q;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951CE606A326
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 01:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 951CE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ByKvAj4Q
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso1428235a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 17:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793669767; x=1794274567; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IjuGhCcCTuCuUyonTeZihguYjeVmf9zvdSu6F8123DA=;
        b=ByKvAj4QeQwNvcFHm11q0juUzlrShvKq2c9i/2mchJnjvZJJkVgiO3kpeHlh607/Le
         zYWhTrynVOO/M67IoFvpVoY+rGUvRlc1T8DHLTZXIIL/mMA/7+oyGkmGdrPoFaIPisb8
         C8yznWXr7oeXf6mqfqWd7+IUH4jLT4lqcP2mdkmc2hUyzQ1MnzNrEzCT/4chYxTItR8P
         1w/HTp/nT8X3aVKtdG/tSdWg7d/sFidjSKy5YPmzKSIh+jbMrDu7ekret882YxMH+PsG
         QEDwsv1oQtDlcaloPbXt98a0QKuJ/WnD57+VtZgILprG0Eas974AfYtHUzzUb3rAPYFP
         TeTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793669767; x=1794274567;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IjuGhCcCTuCuUyonTeZihguYjeVmf9zvdSu6F8123DA=;
        b=EKW+VraVHcNa40/riWsmi/nrSUOuBYNjc+aC2hnIb35/vxMFZ6prZfKowMRH8q/Jhq
         CVkofI36g+65PTUc57vcExPf0Z5kg4E9Jx5POAXIJyhrNT021T+11ukVKJZzjnwNvhmI
         5Mu3bY6FpVJi8Ed+fI8lBKOwJF7+kwWi+qfTYgYaB4n56SZ/ghd2tMlPDZBaq02uHqod
         tJlzYH2Jtv6ZDu45CERG7U82HrR+1F3VhH1xv8VoUVLIAGwf911SWbjTerxOY1zzw6xc
         hFgH0aW5MMQ9gWPaMtDuMIstlxu/iqTfj29wAr+uF96TlJNgSoO5HFhvY9MKt4Z341HM
         rQcA==
X-Gm-Message-State: APuU4Z/yhUvK5fA3qk6nUE2OOfMwjiXkYjFQL3Okym0ajofrF6iXePf6
	pK43zz6d1D2TILbkEMkWw/CyOy74Nk1inkR/KmFDI79n9vVQDpI0uTPMYC7tUxXgf6c=
X-Gm-Gg: AYBFou0B854c4RL/mU1V8PT6+B1ZL9Tx8kX8SzSQyy+WrOmOB4Thp5y4XijpDawWlWo
	K4e/WK3EU5Arv8g/rRejuXCbSzpyIujEq3AiPgnfIXtg/f4+xacZR469ArOLYWnfb34wFLfrZeo
	fQjZUnk2ITcmK9OthxqW/4ETu6Roakv4oHfw+cNieZV1cjCjfKZxk0xYc+gkfMht/3hfXDOXPFW
	cmooXB+/Un+TDZIiIhYZBBcRrNggCMVxu2Nvsxd6wN+bTMkqLLkiWqTzBT4MPVVWkA1IpOY1wjl
	8J6yFcH0Rd97xzTV45nOoLcGwPWfpmiLPxc13DFkuJ/QIgPVV3R79IFnpxfeBlbvvsSt9wzN2fL
	lW6x5zQPU5a7+2qmxXIyh5tGBKf2HvCvXCnJnPb0n1BSaUoUBOVNMmqaA27OGAtv6lcgAxAve/X
	vu+CLFUtcvwFx/cjT9xk5HZebiV/CotFsnnlueiN8itjjIk2PisobO4KSXTXL/TkR34p7G5k7AH
	c8N7wlgj6IP0VRoZUrOh7PfzgxrecdjSH4g4hM0/jGTO9AZOpBYgSNeRgbHvGuoTSB/IrSpLVn6
	3rwoljnn0/akOftaumuqhwoub2hmC83caPrtl6w+OsyOTrbT35Uh1w==
X-Received: by 2002:a17:90b:2549:b0:3ac:a7ee:678c with SMTP id 98e67ed59e1d1-3ae89536be7mr9431265a91.2.1793669766596;
        Mon, 02 Nov 2026 17:36:06 -0800 (PST)
Received: from Griffon ([115.128.232.148])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c6b3493sm1584681a91.13.2026.11.02.17.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 17:36:06 -0800 (PST)
Date: Tue, 3 Nov 2026 12:36:00 +1100
From: Antonio Dolcetta <antonio.dolcetta@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-mediatek@lists.infradead.org
Subject: [BUG] wifi: mt76: mt7925e: MT7927 RX data path stalls while
 associated, TX still works; reassociation recovers
Message-ID: <auk6gJo_ArbALtfG@Griffon>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1KlInuWTrVTeA2Jd"
Content-Disposition: inline

--1KlInuWTrVTeA2Jd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On an MT7927 (14c3:7927) driven by mt7925e, the RX data path
periodically stops delivering frames to the host while the station
stays associated. TX keeps working and frames are ACKed by the AP, the
MCU event ring keeps moving, but the RX data ring stops advancing. The
condition persists until the connection is torn down; a plain
disconnect/reconnect (no chip reset) recovers it in a few seconds.

Hardware / software
-------------------
  Device:    MEDIATEK MT7927 802.11be 2x2 PCIe [14c3:7927],
             subsystem Lenovo [17aa:e0e4], laptop Lenovo 83F5
  Driver:    mt7925e
  Kernel:    7.3.1-1-cachyos (x86_64)
  Firmware:  linux-firmware 20261019, mediatek/mt7927/WIFI_RAM_CODE_MT6639_2_1.bin
             + WIFI_MT6639_PATCH_MCU_2_1_hdr.bin (the only MT7927 release so far)
             HW/SW Version: 0x8a108a10, Build Time: 20260414133750a
             WM Firmware Build Time: 20260414134255
  Userspace: NetworkManager 1.58.1, wpa_supplicant 2.12
  AP:        eero mesh, model J010011, eeroOS 7.17.2-139,
             WPA2-PSK (CCMP), 5 GHz ch 40 (5200 MHz), VHT80 2x2 --
             the link is VHT (802.11ac), not EHT/MLO
  Upstream:  ISP modem/router NL20, firmware NL20.NC.VHA-R6B025.EN
             (not involved in the stall: the station cannot reach
             the eero gateway itself)

Host-side power management is disabled and the device was awake
during the stall:
  iw power_save off, mt7925e disable_aspm=Y, PCIe L1/L1.1/L1.2 = 0,
  device power/control=on, runtime_suspended_time=0, power_state D0,
  debugfs mt76/runtime-pm=0, mt76/deep-sleep=0 (driver disables both
  on MT7927). runtime_pm_stats doze time / low power wakes only change
  across system suspend and were flat during the stall.
  Not checked: whether the AP considers the station to be in PS
  (e.g. a stuck PM bit), which would also look like RX-only loss.

Symptoms
--------
- Happens every few hours with no regular schedule (observed after
  40 min and after ~5 h of association). In both fully logged cases
  the association had been established right after a resume from
  deep (S3) suspend; I can't yet say whether that is required.
- Nothing logged by the kernel, mt7925e or wpa_supplicant when the
  stall starts: no roam or rekey logged (wpa_supplicant at default
  log level), and beacon loss stays 0.
- Signal is strong (-37 dBm), beacon loss 0, the station stays
  associated and iw reports normal bitrates.
- Gateway unreachable; ARP entry for the gateway goes INCOMPLETE.

State captured during a stall (2026-11-03 10:42)
------------------------------------------------
Interface and station counters, sampled before and after 4 pings to the
gateway (~3 s):

  if_rx_packets    9702364 -> 9702364   (+0)
  if_tx_packets    3689450 -> 3689454   (+4)
  sta_rx_packets    812022 -> 812022    (+0)
  sta_tx_packets     87562 -> 87566     (+4)
  sta_tx_retries      7042 -> 7049      (+7)
  sta_tx_failed          0 -> 0

  iw station: signal -37 dBm, beacon loss 0, tx failed 0,
              inactive time 485 ms, connected time 2380 s

debugfs, two snapshots 5 s apart:

  mt76/rx-queues   queue | hw-queued | head | tail
    t=0              0   |   1535    |  770 |  771
    t=+5s            0   |   1535    |  770 |  771   <- not moving
                                                    (healthy baseline:
                                                    1304 -> 1381 in 5 s)
    t=0              1   |    511    |  167 |  168
    t=+5s            1   |    511    |  175 |  176   <- still moving
    (queue 2: 511 / 511 / 0 in both)

  mt76/xmit-queues
    t=0      WFDMA0: queued=0 head=1574 tail=1574
    t=+5s    WFDMA0: queued=0 head=1578 tail=1578  <- TX progressing
             MCUWM:  queued=0 head=93 tail=93 (both)

  mt76/acq: all ACs queued=0
  agg_status: RX BA on TID 0, TX BA on TIDs 0/6/7, nothing pending
  aqm: no backlog, no drops

So the firmware is alive (MCU events still arrive, TX descriptors are
consumed and ACKed over the air), but no data frames, including
broadcast/multicast, are delivered on RX ring 0.

Recovery
--------
Escalating recovery, each step followed by pinging the gateway:

  1. nmcli device disconnect + connect (reassociation)  -> recovered in 8 s
  2. debugfs mt76/chip_reset                            -> not needed
  3. reload mt7925e                                     -> not needed

After reassociation the same AP/BSSID works normally again. Earlier,
toggling rfkill also recovered it; in that case the deauth on the
stalled device produced:

  mt7925e 0000:82:00.0: Message 00020027 (seq 7) timeout
  mt7925e 0000:82:00.0: Message 00020003 (seq 8) timeout
  mt7925e 0000:82:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260414133750a
  mt7925e 0000:82:00.0: WM Firmware Version: ____000000, Build Time: 20260414134255

Since reassociation alone fixes it, my guess is that per-station state
in the firmware (WTBL / key / RX reordering) gets stuck rather than the
whole MCU hanging, but I can't tell which from the host side.

I can reproduce this regularly and am happy to test patches, enable
extra debug (fw_debug etc.) or capture anything else that would help.
A full diagnostic log of the stall (state before and after recovery)
is attached.

Thanks,
Antonio

--1KlInuWTrVTeA2Jd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=mt7927-stall-log-redacted.txt

internet.sh diagnostic log

===== Time =====
2026-11-03T10:42:11+11:00

===== NetworkManager =====
STATE      CONNECTIVITY  WIFI-HW  WIFI     WWAN-HW  WWAN     METERED      
connected  full          enabled  enabled  missing  enabled  no (guessed) 
DEVICE         TYPE      STATE                   CONNECTION 
wlan0          wifi      connected               <SSID>    
docker0        bridge    connected (externally)  docker0    
lo             loopback  connected (externally)  lo         
p2p-dev-wlan0  wifi-p2p  disconnected            --         
enp129s0       ethernet  unavailable             --         
connectivity check: Error: Timeout was reached.

===== Wi-Fi link (wlan0) =====
Connected to 68:4a:76:xx:xx:01 (on wlan0)
	SSID: <SSID>
	freq: 5200.0
	RX: 730106947 bytes (812022 packets)
	TX: 11368170 bytes (87562 packets)
	signal: -37 dBm
	rx bitrate: 780.0 MBit/s VHT-MCS 8 80MHz short GI VHT-NSS 2
	tx bitrate: 468.0 MBit/s VHT-MCS 5 80MHz VHT-NSS 2
	bss flags: short-slot-time
	dtim period: 2
	beacon int: 100
Station 68:4a:76:xx:xx:01 (on wlan0)
	inactive time:	485 ms
	tx retries:	7042
	tx failed:	0
	beacon loss:	0
	signal:  	-37 [-51, -37] dBm
	signal avg:	-36 [-50, -36] dBm
	tx bitrate:	468.0 MBit/s VHT-MCS 5 80MHz VHT-NSS 2
	rx bitrate:	780.0 MBit/s VHT-MCS 8 80MHz short GI VHT-NSS 2
	last ack signal:-33 dBm
	avg ack signal:	-32 dBm
	connected time:	2380 seconds
power_save: Power save: off

===== Power management (Wi-Fi card + system) =====
device: /sys/devices/pci0000:80/0000:80:1c.7/0000:82:00.0
card   power_state: D0
card   power/control: on
card   power/runtime_status: active
card   power/runtime_suspended_time: 0
card   power/wakeup: disabled
card   d3cold_allowed: 1
card   link/l1_aspm: 0
card   link/l1_1_aspm: 0
card   link/l1_2_aspm: 0
bridge power_state: D0
bridge power/control: auto
bridge power/runtime_status: active
/sys/module/mt7925_common/parameters/disable_clc:N
/sys/module/mt7925e/parameters/disable_aspm:Y
pcie_aspm policy: [default] performance powersave powersupersave 
mem_sleep: s2idle [deep]
NM wifi.powersave (2=off, 3=on): default
last suspend/resume this boot:
2026-11-03T01:35:53+11:00 <host> systemd-sleep[331233]: in suspend-then-hibernate operations or setups with encrypted home directories.
2026-11-03T01:35:53+11:00 <host> kernel: PM: suspend entry (deep)
2026-11-03T10:02:51+11:00 <host> systemd-logind[930]: Lid opened.
2026-11-03T10:02:52+11:00 <host> kernel: PM: suspend exit

===== Addresses / routes =====
wlan0            UP             192.168.4.39/22 fdxx::redacted/64 fe80::redacted/64 
default via 192.168.4.1 dev wlan0 proto dhcp src 192.168.4.39 metric 600 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.4.0/22 dev wlan0 proto kernel scope link src 192.168.4.39 metric 600 
Current DNS Server: 192.168.1.1
       DNS Servers: 192.168.1.1
     Default Route: yes

===== Neighbor table (FAILED/INCOMPLETE gateway = stuck Wi-Fi link) =====
192.168.4.1 INCOMPLETE 
fe80::redacted lladdr 68:4a:76:xx:xx:02 router STALE 

===== Ping gateway 192.168.4.1 (with traffic counters) =====
PING 192.168.4.1 (192.168.4.1) 56(84) bytes of data.
From 192.168.4.39 icmp_seq=1 Destination Host Unreachable
From 192.168.4.39 icmp_seq=2 Destination Host Unreachable
From 192.168.4.39 icmp_seq=3 Destination Host Unreachable
From 192.168.4.39 icmp_seq=4 Destination Host Unreachable

--- 192.168.4.1 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 3075ms
pipe 3
-> gateway: FAIL
if_rx_packets               9702364 -> 9702364      (+0)
if_tx_packets               3689450 -> 3689454      (+4)
if_rx_errors                      0 -> 0            (+0)
if_tx_errors                      0 -> 0            (+0)
if_rx_dropped                     0 -> 0            (+0)
if_tx_dropped                   136 -> 136          (+0)
sta_rx_packets               812022 -> 812022       (+0)
sta_tx_packets                87562 -> 87566        (+4)
sta_tx_retries                 7042 -> 7049         (+7)
sta_tx_failed                     0 -> 0            (+0)
(rx +0 = card receives nothing; rx >0 but no ping replies = unicast RX/decrypt broken)

===== Ping upstream router 192.168.1.1 =====
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.

--- 192.168.1.1 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3062ms

-> upstream: FAIL

===== Ping internet 1.1.1.1 =====
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
From 192.168.4.39 icmp_seq=1 Destination Host Unreachable
From 192.168.4.39 icmp_seq=2 Destination Host Unreachable
From 192.168.4.39 icmp_seq=3 Destination Host Unreachable
From 192.168.4.39 icmp_seq=4 Destination Host Unreachable

--- 1.1.1.1 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 3054ms
pipe 2
-> internet_ip: FAIL

===== DNS via system resolver =====
-> dns_system: FAIL

===== DNS via 192.168.1.1 =====
;; communications error to 192.168.1.1#53: timed out
;; no servers could be reached
-> dns_router: FAIL

===== DNS direct to 1.1.1.1 =====
;; communications error to 1.1.1.1#53: host unreachable
;; no servers could be reached
-> dns_direct: FAIL

===== HTTP =====
curl: (6) Could not resolve host: example.com
HTTP 000 in 3.064063s
-> http: FAIL

===== Driver debugfs (root) =====
mt76 debugfs files: acq chip_reset deep-sleep eeprom fw_debug idle-timeout led_pin napi_threaded regidx regval runtime-pm runtime_pm_stats rx-queues txpower_sku tx_stats xmit-queues 
--- mt76/runtime-pm
0
--- mt76/deep-sleep
0
--- mt76/runtime_pm_stats
awake time:       19439016
doze time:        73653853
low power wakes:         6
--- mt76/idle-timeout
83
--- mt76/xmit-queues
WFDMA0:	queued=0 head=1574 tail=1574
MCUWM:	queued=0 head=93 tail=93
MCUFWQ:	queued=0 head=0 tail=0
--- mt76/rx-queues
     queue | hw-queued |      head |      tail |
         0 |      1535 |       770 |       771 |
         1 |       511 |       167 |       168 |
         2 |       511 |       511 |         0 |
--- mt76/acq
AC0: queued=0
AC1: queued=0
AC2: queued=0
AC3: queued=0
--- mt76/tx_stats

Phy0
Length:        1 |   2    1 |   2   19 |  20    1 |   2   37 |  38    1 |   2   55 |  56    1 |   2  103 | 104    1 |   2  151 | 152    1 |   2  199 | 200    1 |   2  247 | 
Count:         0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 | 
BA miss count: 0
Tx MSDU stat:
AMSDU pack count of 1 MSDU in TXD:  1597106 ( 71%)
AMSDU pack count of 2 MSDU in TXD:   280916 ( 12%)
AMSDU pack count of 3 MSDU in TXD:   124344 (  5%)
AMSDU pack count of 4 MSDU in TXD:    78107 (  3%)
AMSDU pack count of 5 MSDU in TXD:    66382 (  2%)
AMSDU pack count of 6 MSDU in TXD:    19946 (  0%)
AMSDU pack count of 7 MSDU in TXD:    15170 (  0%)
AMSDU pack count of 8 MSDU in TXD:    38855 (  1%)
=== station 68:4a:76:xx:xx:01
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/agg_status
next dialog_token: 0x4
TID		RX	DTKN	SSN		TX	DTKN	pending
00		1	0x01	0x000		1	0x01	000
01		0	0x00	0x000		0	0x00	000
02		0	0x00	0x000		0	0x00	000
03		0	0x00	0x000		0	0x00	000
04		0	0x00	0x000		0	0x00	000
05		0	0x00	0x000		0	0x00	000
06		0	0x00	0x000		1	0x03	000
07		0	0x00	0x000		1	0x02	000
08		0	0x00	0x000		0	0x00	000
09		0	0x00	0x000		0	0x00	000
10		0	0x00	0x000		0	0x00	000
11		0	0x00	0x000		0	0x00	000
12		0	0x00	0x000		0	0x00	000
13		0	0x00	0x000		0	0x00	000
14		0	0x00	0x000		0	0x00	000
15		0	0x00	0x000		0	0x00	000
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/aqm
tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags
0 2 0 0 84350 0 0 0 0 11359306 87561 0x2(RUN AMPDU)
1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
6 0 0 0 4 0 0 0 0 360 4 0x2(RUN AMPDU)
7 0 0 0 22 0 0 0 0 10262 27 0x2(RUN AMPDU)
8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/airtime
RX: 121957197 us
TX: 20022788 us
Weight: 256
Deficit: VO: -662 us VI: 256 us BE: -340 us BK: 256 us
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/num_ps_buf_frames
AC0: 0
AC1: 0
AC2: 0
AC3: 0
--- aqm
access name value
R fq_flows_cnt 4096
R fq_backlog 0
R fq_overlimit 0
R fq_overmemory 0
R fq_collisions 0
R fq_memory_usage 0
RW fq_memory_limit 16777216
RW fq_limit 8192
RW fq_quantum 300

===== Driver debugfs, 5 s later (compare queue head/tail) =====
mt76 debugfs files: acq chip_reset deep-sleep eeprom fw_debug idle-timeout led_pin napi_threaded regidx regval runtime-pm runtime_pm_stats rx-queues txpower_sku tx_stats xmit-queues 
--- mt76/runtime-pm
0
--- mt76/deep-sleep
0
--- mt76/runtime_pm_stats
awake time:       19444058
doze time:        73653853
low power wakes:         6
--- mt76/idle-timeout
83
--- mt76/xmit-queues
WFDMA0:	queued=0 head=1578 tail=1578
MCUWM:	queued=0 head=93 tail=93
MCUFWQ:	queued=0 head=0 tail=0
--- mt76/rx-queues
     queue | hw-queued |      head |      tail |
         0 |      1535 |       770 |       771 |
         1 |       511 |       175 |       176 |
         2 |       511 |       511 |         0 |
--- mt76/acq
AC0: queued=0
AC1: queued=0
AC2: queued=0
AC3: queued=0
--- mt76/tx_stats

Phy0
Length:        1 |   2    1 |   2   19 |  20    1 |   2   37 |  38    1 |   2   55 |  56    1 |   2  103 | 104    1 |   2  151 | 152    1 |   2  199 | 200    1 |   2  247 | 
Count:         0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 |        0 | 
BA miss count: 0
Tx MSDU stat:
AMSDU pack count of 1 MSDU in TXD:  1597110 ( 71%)
AMSDU pack count of 2 MSDU in TXD:   280916 ( 12%)
AMSDU pack count of 3 MSDU in TXD:   124344 (  5%)
AMSDU pack count of 4 MSDU in TXD:    78107 (  3%)
AMSDU pack count of 5 MSDU in TXD:    66382 (  2%)
AMSDU pack count of 6 MSDU in TXD:    19946 (  0%)
AMSDU pack count of 7 MSDU in TXD:    15170 (  0%)
AMSDU pack count of 8 MSDU in TXD:    38855 (  1%)
=== station 68:4a:76:xx:xx:01
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/agg_status
next dialog_token: 0x4
TID		RX	DTKN	SSN		TX	DTKN	pending
00		1	0x01	0x000		1	0x01	000
01		0	0x00	0x000		0	0x00	000
02		0	0x00	0x000		0	0x00	000
03		0	0x00	0x000		0	0x00	000
04		0	0x00	0x000		0	0x00	000
05		0	0x00	0x000		0	0x00	000
06		0	0x00	0x000		1	0x03	000
07		0	0x00	0x000		1	0x02	000
08		0	0x00	0x000		0	0x00	000
09		0	0x00	0x000		0	0x00	000
10		0	0x00	0x000		0	0x00	000
11		0	0x00	0x000		0	0x00	000
12		0	0x00	0x000		0	0x00	000
13		0	0x00	0x000		0	0x00	000
14		0	0x00	0x000		0	0x00	000
15		0	0x00	0x000		0	0x00	000
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/aqm
tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags
0 2 0 0 84354 0 0 0 0 11359474 87565 0x2(RUN AMPDU)
1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
6 0 0 0 4 0 0 0 0 360 4 0x2(RUN AMPDU)
7 0 0 0 22 0 0 0 0 10262 27 0x2(RUN AMPDU)
8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/airtime
RX: 121957197 us
TX: 20024897 us
Weight: 256
Deficit: VO: -662 us VI: 256 us BE: -145 us BK: 256 us
--- netdev:wlan0/stations/68:4a:76:xx:xx:01/num_ps_buf_frames
AC0: 0
AC1: 0
AC2: 0
AC3: 0
--- aqm
access name value
R fq_flows_cnt 4096
R fq_backlog 0
R fq_overlimit 0
R fq_overmemory 0
R fq_collisions 0
R fq_memory_usage 0
RW fq_memory_limit 16777216
RW fq_limit 8192
RW fq_quantum 300

===== Verdict =====
Gateway 192.168.4.1 unreachable while Wi-Fi is associated -> stuck Wi-Fi link (PC/driver or access point side).

===== Journal: last 15 min before script start (network-related) =====

===== Recovery: reconnect to AP =====
Device 'wlan0' successfully disconnected.
-> FIXED by 'reconnect to AP' after 8s

===== Re-check after recovery =====

===== Time =====
2026-11-03T10:43:20+11:00

===== NetworkManager =====
STATE                  CONNECTIVITY  WIFI-HW  WIFI     WWAN-HW  WWAN     METERED      
connected (site only)  none          enabled  enabled  missing  enabled  no (guessed) 
DEVICE         TYPE      STATE                   CONNECTION 
wlan0          wifi      connected               <SSID>    
docker0        bridge    connected (externally)  docker0    
lo             loopback  connected (externally)  lo         
p2p-dev-wlan0  wifi-p2p  disconnected            --         
enp129s0       ethernet  unavailable             --         
connectivity check: full

===== Wi-Fi link (wlan0) =====
Connected to 68:4a:76:xx:xx:01 (on wlan0)
	SSID: <SSID>
	freq: 5200.0
	RX: 77885 bytes (211 packets)
	TX: 124659 bytes (267 packets)
	signal: -38 dBm
	rx bitrate: 866.7 MBit/s VHT-MCS 9 80MHz short GI VHT-NSS 2
	tx bitrate: 585.0 MBit/s VHT-MCS 7 80MHz VHT-NSS 2
	bss flags: short-slot-time
	dtim period: 2
	beacon int: 100
Station 68:4a:76:xx:xx:01 (on wlan0)
	inactive time:	4 ms
	tx retries:	82
	tx failed:	0
	beacon loss:	0
	signal:  	-38 [-47, -38] dBm
	signal avg:	-37 [-47, -37] dBm
	tx bitrate:	585.0 MBit/s VHT-MCS 7 80MHz VHT-NSS 2
	rx bitrate:	866.7 MBit/s VHT-MCS 9 80MHz short GI VHT-NSS 2
	last ack signal:-35 dBm
	avg ack signal:	-34 dBm
	connected time:	1 seconds
power_save: Power save: off

===== Power management (Wi-Fi card + system) =====
device: /sys/devices/pci0000:80/0000:80:1c.7/0000:82:00.0
card   power_state: D0
card   power/control: on
card   power/runtime_status: active
card   power/runtime_suspended_time: 0
card   power/wakeup: disabled
card   d3cold_allowed: 1
card   link/l1_aspm: 0
card   link/l1_1_aspm: 0
card   link/l1_2_aspm: 0
bridge power_state: D0
bridge power/control: auto
bridge power/runtime_status: active
/sys/module/mt7925_common/parameters/disable_clc:N
/sys/module/mt7925e/parameters/disable_aspm:Y
pcie_aspm policy: [default] performance powersave powersupersave 
mem_sleep: s2idle [deep]
NM wifi.powersave (2=off, 3=on): default
last suspend/resume this boot:
2026-11-03T01:35:53+11:00 <host> systemd-sleep[331233]: in suspend-then-hibernate operations or setups with encrypted home directories.
2026-11-03T01:35:53+11:00 <host> kernel: PM: suspend entry (deep)
2026-11-03T10:02:51+11:00 <host> systemd-logind[930]: Lid opened.
2026-11-03T10:02:52+11:00 <host> kernel: PM: suspend exit

===== Addresses / routes =====
wlan0            UP             192.168.4.39/22 fe80::redacted/64 
default via 192.168.4.1 dev wlan0 proto dhcp src 192.168.4.39 metric 600 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.4.0/22 dev wlan0 proto kernel scope link src 192.168.4.39 metric 600 
Current DNS Server: 192.168.1.1
       DNS Servers: 192.168.1.1
     Default Route: yes

===== Neighbor table (FAILED/INCOMPLETE gateway = stuck Wi-Fi link) =====
192.168.4.1 lladdr 68:4a:76:xx:xx:02 REACHABLE 

===== Ping gateway 192.168.4.1 (with traffic counters) =====
PING 192.168.4.1 (192.168.4.1) 56(84) bytes of data.
64 bytes from 192.168.4.1: icmp_seq=1 ttl=64 time=4.12 ms
64 bytes from 192.168.4.1: icmp_seq=2 ttl=64 time=3.63 ms
64 bytes from 192.168.4.1: icmp_seq=3 ttl=64 time=4.35 ms
64 bytes from 192.168.4.1: icmp_seq=4 ttl=64 time=3.81 ms

--- 192.168.4.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 3.633/3.980/4.352/0.276 ms
-> gateway: OK
if_rx_packets               9702604 -> 9702895      (+291)
if_tx_packets               3689808 -> 3690096      (+288)
if_rx_errors                      0 -> 0            (+0)
if_tx_errors                      0 -> 0            (+0)
if_rx_dropped                     0 -> 0            (+0)
if_tx_dropped                   142 -> 142          (+0)
sta_rx_packets                  274 -> 565          (+291)
sta_tx_packets                  317 -> 605          (+288)
sta_tx_retries                  102 -> 300          (+198)
sta_tx_failed                     0 -> 0            (+0)
(rx +0 = card receives nothing; rx >0 but no ping replies = unicast RX/decrypt broken)

===== Ping upstream router 192.168.1.1 =====
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=63 time=6.40 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=63 time=3.59 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=63 time=5.38 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=63 time=8.90 ms

--- 192.168.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 3.593/6.069/8.904/1.920 ms
-> upstream: OK

===== Ping internet 1.1.1.1 =====
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=58 time=13.8 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=58 time=13.6 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=58 time=14.2 ms
64 bytes from 1.1.1.1: icmp_seq=4 ttl=58 time=14.9 ms

--- 1.1.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 13.571/14.096/14.893/0.508 ms
-> internet_ip: OK

===== DNS via system resolver =====
2606:4700:10::ac42:93f3 example.com
2606:4700:10::6814:179a example.com
-> dns_system: OK

===== DNS via 192.168.1.1 =====
104.20.23.154
172.66.147.243
-> dns_router: OK

===== DNS direct to 1.1.1.1 =====
172.66.147.243
104.20.23.154
-> dns_direct: OK

===== HTTP =====
HTTP 200 in 0.049035s
-> http: OK

===== Verdict =====
Everything looks OK.

--1KlInuWTrVTeA2Jd--
