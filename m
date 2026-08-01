Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E901F12FB
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 18:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607320; cv=none; b=R/be6hs7Q5wL2k8PEyYVA8/PmHBD78mCenhg1/4oQTPH1mz437ZbBOWuXOc1+Hc9CRxokIKvfocMcKsr9B38yeu6Rqr5Z9ATHI63UqBAI3oxz93EzymcuTQXvU646a3wdyXNzQ+llaq6Q6GrjR7qHTUUVUv3eoZTkKKfyTmJyko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607320; c=relaxed/simple;
	bh=NoRO0YWi3XqQjzt6kyMB79k85tg9ohVVdmI+pYF1aXg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=UfQ3tlMNnzEiqoaDG6+m0e6THzLsiraffknYz7IolcpTtsHO3UyXsVibXeniGzdcRf0LnqjrOCTf9G8ykzC5MtwFHAUd9x/JETPRXLkzbFwPsa15KzQOT5GZX3rZkMsvLerKlRCKL9VLrgh1o++3EnNRctMpUQOn3Sw0XoopSxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=o6t8Fgao; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="o6t8Fgao"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:From:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=joaoAaEUNqIZVlyjYjIttPHChItNIZeqXdx5BBAGFds=; b=o6t8FgaoiQVHD5TAFA3Ih9m3WA
	z/kMhYp26uQrpNpXACEG2rqJjWNXNyu4cVK24hJW89a7F587FqxZuaXVZDNeDYUb/BPzLxNyYHpyF
	HLcoVIjCwouLXkpysU2d3g23EIqQAsBfy5DFVnXO5walDnDFv70Yl6RRBLVGEDseAFU0=;
Received: from p54a43140.dip0.t-ipconnect.de ([84.164.49.64] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqE1z-00A1BF-24;
	Sat, 01 Aug 2026 20:01:55 +0200
Message-ID: <fcde5dc7-5870-49f6-8e19-636fa5734884@nbd.name>
Date: Sat, 1 Aug 2026 20:01:55 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76-next 2026-08-01
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Language: en-US
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Here's my mt76 pull request for 7.3

- Felix

The following changes since commit 4a0bd262df757b25fc4e2a53c947317c119ced4e:

   wifi: mac80211: fix per-STA profile length in cross-link CSA parsing (2026-07-28 16:04:16 +0200)

are available in the Git repository at:

   https://github.com/nbd168/wireless tags/mt76-next-2026-08-01

for you to fetch changes up to 4df22710a77d2365e56d720bc4106e54c1dfa2ff:

   wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations (2026-08-01 17:55:26 +0000)

----------------------------------------------------------------
mt76 patches for 7.3

- fixes
- mt7925 NAN support
- mt7928 support
- mt7996 AP powersave improvements

----------------------------------------------------------------
Ahmed Naseef (1):
       wifi: mt76: mt7603: add 0x7592 EEPROM chip ID

Bryam Vargas (2):
       wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
       wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy

Chad Monroe (7):
       wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations
       wifi: mt76: mt7996: fix non-MLD station num_sta leak
       wifi: mt76: mt7996: select net_setup_tc handler at runtime
       wifi: mt76: fix stuck TX queues after SER with no active interfaces
       wifi: mt76: mt7915: trigger L1 SER on PLE MDP RIOC hang
       wifi: mt76: serialize scan-link teardown with dev->mutex
       wifi: mt76: mt7996: hold dev->mutex in remove_interface teardown

Charlie-cy Wu (3):
       wifi: mt76: mt7921: refactor regd update to fix recursive mutex deadlock
       wifi: mt76: mt7925: add regulatory wiphy self manager support
       wifi: mt76: mt7921: add regulatory wiphy self manager support

David Bauer (2):
       wifi: mt76: mt7915: configure noise floor reporting on reset
       wifi: mt76: mt7603: free beacon SKB on error

Devin Wittmayer (5):
       wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
       wifi: mt76: mt76x02: report rx FCS errors to mac80211
       wifi: mt76: mt7925: ensure tx headroom in usb_sdio_tx_prepare_skb
       wifi: mt76: mt7925: cancel mlo_pm_work on stop
       wifi: mt76: mt792x: do not advertise active monitor

Dmitry Antipov (1):
       wifi: mt76: mt7915: simplify mt7915_sys_recovery_set()

Dmitry Gomzyakov (1):
       wifi: mt76: connac: add MT7991A (0x7991) to is_mt7996()

Eason Lai (3):
       wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete
       wifi: mt76: mt7921: Add PCIe AER handler support to prevent system crash
       wifi: mt76: mt792x: Fix memory leak in SDIO TX path

Emery Hsin (21):
       wifi: mt76: mt792x: consolidate rx interrupt masks into all_complete_mask
       wifi: mt76: connac2: apply new rx all_complete_mask
       wifi: mt76: mt7925: replace shared rx irq masks with per-chip definitions
       wifi: mt76: mt7925: add MT7927 per-chip rx irq definitions
       wifi: mt76: mt792x: add per-chip PCIe register struct
       wifi: mt76: connac2: add per-chip PCIe register definitions
       wifi: mt76: mt7925: add per-chip PCIe register definitions
       wifi: mt76: mt792x: replace shared PCIe MAC macros with per-chip struct
       wifi: mt76: mt792x: rename WFDMA DMASHDL enable bit to follow the convention
       wifi: mt76: mt7925: rename WTBL registers to chip-specific format
       wifi: mt76: mt792x: add tx_done ring to common DMA queue allocation
       wifi: mt76: connac3: update basic rate table starting index
       wifi: mt76: mt7925: fix MMIO dynamic remap window size
       wifi: mt76: mt7925: add MT7928 FWDL support
       wifi: mt76: mt7925: add MT7928 irq_map with chip-specific rx masks
       wifi: mt76: mt7925: add MT7928 DMA configuration
       wifi: mt76: mt7925: add MT7928 TXD/TXS/TX_DONE support
       wifi: mt76: mt7925: add MMIO register remapping table for MT7928
       wifi: mt76: mt7925: align scan IE and EFUSE TLV lengths to 4 bytes for MT7928
       wifi: mt76: mt7925: add MT7928 per-chip PCIe register definitions
       wifi: mt76: mt7925: add MT7928 PCIe support

Ethan Nelson-Moore (2):
       wifi: mt76: mt7925: remove code guarded by nonexistent config option
       wifi: mt76: mt7996: remove code guarded by nonexistent config option

Felix Fietkau (54):
       wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
       wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
       wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear
       wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
       wifi: mt76: mt7996: don't report a zero TX bitrate
       wifi: mt76: mt7915: write RX header translation bit to the correct register
       wifi: mt76: fix 4th chain ACK RSSI bitmask in sta_poll
       wifi: mt76: mt7996: fix TX DMA mapping leak for AddBA req frames
       wifi: mt76: fix stranded frames in mt76_txq_schedule_pending
       wifi: mt76: allow TX aggregation on the VO queue
       wifi: mt76: fix uninitialised RXDMAD_C descriptor info
       wifi: mt76: fix RXDMAD_C buffer recycling race
       wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
       wifi: mt76: fix HE DCM max-RU capability encoding
       wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
       wifi: mt76: fix out-of-bounds access in mmio copy helpers
       wifi: mt76: mt7915: unwind state on add_interface failure
       wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER
       wifi: mt76: decode the full VHT Rx STBC capability field
       wifi: mt76: fix ER-SU 106-tone RU check in RX rate decode
       wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
       wifi: mt76: mt7996: don't leak MLD group index on remap alloc failure
       wifi: mt76: cancel reset and rc work on device unregister
       wifi: mt76: report data NSS for STBC frames in RX rate decode
       wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields
       wifi: mt76: only consume the WO drop bit on WED v2 devices
       wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
       wifi: mt76: mt7996: skip key upload when adding an offchannel link
       wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER
       wifi: mt76: fix queue reg access when building WED and NPU together
       wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
       wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset
       wifi: mt76: mt7996: clear stale link state on full reset
       wifi: mt76: set MT76_SCANNING when starting a hw scan
       wifi: mt76: mt7996: fix MIB TX aggregation counter registers for mt7990
       wifi: mt76: mt7915: fix double hif2 init on the non-WED path
       wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
       wifi: mt76: mt7915: release hif2 reference on probe IRQ failure
       wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed
       wifi: mt76: mt7996: do not leave state behind after a failed WED attach
       wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1
       wifi: mt76: mt7915: report RX chain signal for all RX paths
       wifi: mt76: mt7915: update SKU power limits after changing antennas
       wifi: mt76: mt7925: fix infinite loop in UNI event TLV parsing
       wifi: mt76: add PS buffering support for HW-managed TIM drivers
       wifi: mt76: mt7915: handle MCU PS sync events
       wifi: mt76: mt7996: handle UNI PS sync events
       wifi: mt76: set the EOSP bit in the QoS header of the last released frame
       wifi: mt76: mt7603: fix U-APSD service period termination
       wifi: mt76: mt7603: tell mac80211 when the PS queue has run empty
       wifi: mt76: mt7603: restore hardware PS buffering after a service period
       wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
       wifi: mt76: reject out-of-range link ids in mt76_vif_link()
       wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()

Filip Bakreski (1):
       wifi: mt76: mt76u: use a threaded NAPI for the RX path

Howard Hsu (1):
       wifi: mt76: mt7996: reject iTWT setup requests from MLD stations

JB Tsai (1):
       wifi: mt76: mt7925: Fix unregister deadlock

Jared.Huang (2):
       wifi: mt76: mt7925: update clc before setting sar power table
       wifi: mt76: mt7925: fix msg len mismatch between driver and firmware

Jeff Hsu (1):
       wifi: mt76: mt7925: skip DMA re-init selectively

Jose Ignacio Tornos Martinez (1):
       wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations

Kenneth Kasilag (1):
       wifi: mt76: mt7996: expose per-band MAC addresses to cfg80211

Laxman Acharya Padhya (2):
       wifi: mt76: mt7921: validate CLC firmware records
       wifi: mt76: mt7996: validate default EEPROM firmware size

Michael-CY Lee (2):
       wifi: mt76: fix non-AQL packet accounting for MLO stations
       wifi: mt76: assign link_id when sending probe request during scan

Peter Chiu (4):
       wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP
       wifi: mt76: mt7996: add mcu command to set bssid mapping address
       wifi: mt76: mt7996: leave PS when a 4-address connection is established
       wifi: mt76: fix queue assignment for disassoc packets

Prashant Rahul (1):
       wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event

Rex Lu (2):
       wifi: mt76: fix RX data queuing of RRO 3.0
       wifi: mt76: check txfree done event on the WED hw path

Runyu Xiao (1):
       wifi: mt76: mt7615: avoid waiting for mac work under the mt76 mutex

Ryan Leung (1):
       wifi: mt76: mt7915: add thermal zone device registration

Sean Wang (18):
       wifi: mt76: mt792x: advertise mgmt frame registration
       wifi: mt76: mt7925: guard BSS capability lookups
       wifi: mt76: connac: add NAN connection type
       wifi: mt76: mt7925: add NAN MCU helpers
       wifi: mt76: mt7925: add NAN MCU handling
       wifi: mt76: add init_wiphy callback
       wifi: mt76: mt7925: wire up NAN operations
       wifi: mt76: mt792x: build iface combinations dynamically
       wifi: mt76: mt792x: advertise NAN data support
       wifi: mt76: mt7925: stop init retries on hung bus
       wifi: mt76: mt7925: skip reset work on hung bus
       wifi: mt76: mt792x: stop USB register access after bus hang
       wifi: mt76: mt792x: drain USB UDMA before WFSYS reset
       wifi: mt76: mt792x: enable USB UDMA TX timeout
       wifi: mt76: mt792x: quiesce USB paths on disconnect
       wifi: mt76: mt7927: set band index for sniffer mode
       wifi: mt76: mt7927: use real monitor vifs for dual-band monitors
       wifi: mt76: mt7925: support new WoW pattern TLV

Shayne Chen (2):
       wifi: mt76: fix handling channel context with different bands in mt76_switch_vif_chanctx()
       wifi: mt76: mt7996: fix capability of EHT-MCS 15 in MRU

StanleyYP Wang (4):
       wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar
       wifi: mt76: mt7996: fix reg addr remap when addr is 0
       wifi: mt76: mt7996: remove repeater muar config
       wifi: mt76: mt7996: add scan dwell time hw cap

Wentao Guan (1):
       wifi: mt76: mt7925: cancel pending mlo_pm_work

Zhi-Jun You (2):
       wifi: mt76: wed: fix kernel panic on non-DBDC MT7986
       wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986

shengwei.lu (1):
       wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum

  drivers/net/wireless/mediatek/mt76/channel.c          |   98 ++---
  drivers/net/wireless/mediatek/mt76/dma.c              |   48 ++-
  drivers/net/wireless/mediatek/mt76/dma.h              |  112 +++---
  drivers/net/wireless/mediatek/mt76/mac80211.c         |   20 +-
  drivers/net/wireless/mediatek/mt76/mcu.c              |   12 +-
  drivers/net/wireless/mediatek/mt76/mmio.c             |   18 +-
  drivers/net/wireless/mediatek/mt76/mt76.h             |   11 +
  drivers/net/wireless/mediatek/mt76/mt7603/beacon.c    |    2 +
  drivers/net/wireless/mediatek/mt76/mt7603/dma.c       |    2 +-
  drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c    |    1 +
  drivers/net/wireless/mediatek/mt76/mt7603/mac.c       |   73 +++-
  drivers/net/wireless/mediatek/mt76/mt7603/main.c      |   89 ++++-
  drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h    |    4 +
  drivers/net/wireless/mediatek/mt76/mt7615/main.c      |    5 +-
  drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c   |    5 +-
  drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c  |    5 +-
  drivers/net/wireless/mediatek/mt76/mt76_connac.h      |   16 +-
  drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h |   42 +++
  drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c  |    8 +-
  drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c  |  267 ++++++++++++-
  drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h  |   47 +++
  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      |    5 +-
  drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c   |   17 +-
  drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c    |    2 +-
  drivers/net/wireless/mediatek/mt76/mt7915/init.c      |   41 +-
  drivers/net/wireless/mediatek/mt76/mt7915/mac.c       |   34 +-
  drivers/net/wireless/mediatek/mt76/mt7915/main.c      |   25 +-
  drivers/net/wireless/mediatek/mt76/mt7915/mcu.c       |   43 ++-
  drivers/net/wireless/mediatek/mt76/mt7915/mcu.h       |   15 +-
  drivers/net/wireless/mediatek/mt76/mt7915/mmio.c      |    3 +-
  drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h    |   20 +
  drivers/net/wireless/mediatek/mt76/mt7915/pci.c       |    9 +-
  drivers/net/wireless/mediatek/mt76/mt7915/regs.h      |    1 +
  drivers/net/wireless/mediatek/mt76/mt7915/soc.c       |    2 +-
  drivers/net/wireless/mediatek/mt76/mt7915/testmode.c  |    5 +-
  drivers/net/wireless/mediatek/mt76/mt7921/mac.c       |    5 +-
  drivers/net/wireless/mediatek/mt76/mt7921/main.c      |    2 +-
  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c       |   35 +-
  drivers/net/wireless/mediatek/mt76/mt7921/pci.c       |  112 +++++-
  drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c   |    3 +-
  drivers/net/wireless/mediatek/mt76/mt7921/regd.c      |  219 ++++++++++-
  drivers/net/wireless/mediatek/mt76/mt7921/regd.h      |   57 ++-
  drivers/net/wireless/mediatek/mt76/mt7921/regs.h      |    5 +
  drivers/net/wireless/mediatek/mt76/mt7925/Makefile    |    2 +-
  drivers/net/wireless/mediatek/mt76/mt7925/init.c      |   37 ++
  drivers/net/wireless/mediatek/mt76/mt7925/mac.c       |  241 +++++++++++-
  drivers/net/wireless/mediatek/mt76/mt7925/mac.h       |    9 +-
  drivers/net/wireless/mediatek/mt76/mt7925/main.c      |  279 ++++++++++++--
  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c       |  267 ++++++++++---
  drivers/net/wireless/mediatek/mt76/mt7925/mcu.h       |   43 +++
  drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h    |    9 +
  drivers/net/wireless/mediatek/mt76/mt7925/nan.c       | 1098 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/net/wireless/mediatek/mt76/mt7925/nan.h       |  421 +++++++++++++++++++++
  drivers/net/wireless/mediatek/mt76/mt7925/pci.c       |  305 +++++++++++++--
  drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c   |    8 +-
  drivers/net/wireless/mediatek/mt76/mt7925/pci_mcu.c   |    2 +-
  drivers/net/wireless/mediatek/mt76/mt7925/regd.c      |  250 ++++++++++++-
  drivers/net/wireless/mediatek/mt76/mt7925/regd.h      |   57 +++
  drivers/net/wireless/mediatek/mt76/mt7925/regs.h      |   67 +++-
  drivers/net/wireless/mediatek/mt76/mt7925/usb.c       |    8 +
  drivers/net/wireless/mediatek/mt76/mt792x.h           |   85 ++++-
  drivers/net/wireless/mediatek/mt76/mt792x_core.c      |  146 +++++++-
  drivers/net/wireless/mediatek/mt76/mt792x_dma.c       |  124 ++++--
  drivers/net/wireless/mediatek/mt76/mt792x_regs.h      |   25 +-
  drivers/net/wireless/mediatek/mt76/mt792x_usb.c       |  138 ++++++-
  drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c    |    6 +
  drivers/net/wireless/mediatek/mt76/mt7996/init.c      |   30 +-
  drivers/net/wireless/mediatek/mt76/mt7996/mac.c       |   96 ++++-
  drivers/net/wireless/mediatek/mt76/mt7996/main.c      |   75 ++--
  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c       |  205 +++++++---
  drivers/net/wireless/mediatek/mt76/mt7996/mcu.h       |   42 ++-
  drivers/net/wireless/mediatek/mt76/mt7996/mmio.c      |   93 +++--
  drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h    |    9 +-
  drivers/net/wireless/mediatek/mt76/mt7996/regs.h      |   24 +-
  drivers/net/wireless/mediatek/mt76/scan.c             |   26 +-
  drivers/net/wireless/mediatek/mt76/sdio.c             |   11 +-
  drivers/net/wireless/mediatek/mt76/tx.c               |  102 ++++-
  drivers/net/wireless/mediatek/mt76/usb.c              |   75 +++-
  drivers/net/wireless/mediatek/mt76/wed.c              |    7 +-
  79 files changed, 5358 insertions(+), 609 deletions(-)
  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/nan.c
  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/nan.h
