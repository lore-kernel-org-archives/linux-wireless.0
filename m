Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5D84A64FC
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 12:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440367; cv=none; b=V1FeeIfXnudlofopceTKh8Pw8ktWXrxjqwL9Yx+KoAmIk90359ZVRbP9iJCaV+0JVb324AyHu01ABdQsnQQa174ztcXxy4vTTQgG/DZDxaRrTzPF9UGCGpl/qTq1SOMSNJ/5lZgfFIqpNngc74i0n44sMsKUH+dVbet4k25Lhvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440367; c=relaxed/simple;
	bh=uLgdnxfLeG1up6nHp0UCJHgWN+XeuopVXhCQgVlHoYI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To; b=UzpNyBBh8Bf26xodXRpj6jTLq/UEAqsQrRPHhKZ0Bpfc37DIIWfCN8IuZGLmO4JTuPu5VGiGKitsvhnChjeuPfDWESCZ6PDvCeDKPIOp/m/iSFcLlXxkERquBLc8Eqy6k34XlAHXN1rz2IsHL6ScakaqgRyjWOZ/GDucXw6RD9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=RGns+CVv; arc=none smtp.client-ip=95.215.58.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="RGns+CVv"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uLgdnxfLeG1up6nHp0UCJHgWN+XeuopVXhCQgVlHoYI=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788440360; v=1; x=1789045160;
 b=RGns+CVvq2T9BbZVIoZ+doP3kWnbYPwa/ZUmRl6rErZcwQUaooQ3Bn/I78hiC59M5t0l5u6y
 m5AP6SqrNG5lbNGWoqnyQV9mwU4SkT8O2XMmdBBHJAZnJE61/PKps/XGK3uttm6FkQHClnMjIMC
 RlvJeAOhv+h38jPjbiNKV5djv2gYEKIDxZVbqz0V0PXRpi+fgG5nf3rUr4yrMqRuvR04J4Fjc55
 7+IhqAzBUIuEa3rRSGcCYw6PkkeA2U+ntuPdzmyM6mPbghPCSyzuvogt55mvqOvCh1zWfbeD+1b
 U+FomnJoig7N5TnNRRmDuz86CeVViRRKhFI/S1hBjxkuQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dc46ac61033885ce;
	Thu, 03 Sep 2026 12:59:20 +0000
X-Mizu-Trace-ID: dc46ac61033885ce
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Sep 2026 14:59:19 +0200
Message-Id: <DL5P72WYQVOQ.23G9D01OY3BAA@cknow-tech.com>
Subject: Stack trace when starting iwd with Intel BE200 M.2 Wi-Fi+BT card
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.22.0-9-ge948bb7230f4

Hi,

I have a FriendlyElec NanoPC-T6 LTS (arm64, RK3588 SoC) and plugged in
its E-key slot an Intel BE200 card. I'm using TF-A + U-Boot as firmware
and bootloader, not something with ACPI support.

That's probably why I'm getting these warnings in dmesg:
```
[   11.313596] ACPI: <n/a>: failed to evaluate _DSM 2c176672-0b22-294b-814f=
-75e4dd26b5fd rev:0 func:0 (0x1001)
[   11.313641] ACPI: <n/a>: failed to evaluate _DSM 2c176672-0b22-294b-814f=
-75e4dd26b5fd rev:0 func:0 (0x1001)
```

My kernel does have ``CONFIG_ACPI=3Dy``, but it's not used on this device.

When I start iwd.service, I get the following stack trace:

```
[12144.572968] ------------[ cut here ]------------
[12144.572984] WARNING: net/wireless/nl80211.c:10730 at nl80211_get_reg_do+=
0x244/0x270 [cfg80211], CPU#6: iwd/2361
[12144.574304] Modules linked in: algif_aead des_generic libdes md4 snd_seq=
_dummy snd_hrtimer snd_seq snd_seq_device algif_hash algif_skcipher af_alg =
8021q garp mrp stp llc bnep iwlmld aes_ce_blk mac80211 ghash_ce gf128mul sn=
d_soc_simple_card pwm_fan snd_soc_rt5616 leds_gpio btusb libarc4 snd_soc_si=
mple_card_utils snd_soc_rockchip_i2s_tdm gpio_ir_recv snd_soc_hdmi_codec ha=
ntro_vpu snd_soc_rl6231 ofpart btrtl snd_soc_core btintel spi_nor rockchip_=
vdec snd_compress btbcm v4l2_jpeg synopsys_hdmirx rockchip_rga v4l2_vp9 snd=
_pcm_dmaengine rk805_pwrkey v4l2_h264 rockchip_rng btmtk mtd snd_pcm rockch=
ip_thermal v4l2_dv_timings v4l2_mem2mem iwlwifi videobuf2_dma_sg videobuf2_=
dma_contig bluetooth snd_timer videobuf2_memops snd videobuf2_v4l2 ecdh_gen=
eric soundcore videodev vsi_iommu cfg80211 panthor videobuf2_common mc rock=
et drm_gpuvm gpu_sched drm_shmem_helper rfkill drm_exec cpufreq_dt evdev su=
nrpc binfmt_misc pkcs8_key_parser nvme_fabrics efi_pstore configfs autofs4 =
ext4 crc16 mbcache jbd2 r8169 realtek phy_package mdio_devres
[12144.574461]  of_mdio fixed_phy fwnode_mdio libphy mdio_bus xhci_plat_hcd=
 rk808_regulator xhci_hcd nvme nvme_core nvme_keyring nvme_auth onboard_usb=
_dev rockchipdrm dw_hdmi_qp dw_mipi_dsi fusb302 tcpm rtc_hym8563 dw_hdmi fa=
n53555 aux_hpd_bridge analogix_dp drm_dp_aux_bus drm_display_helper gpio_ro=
ckchip cec fixed phy_rockchip_usbdp sdhci_of_dwcmshc typec rc_core display_=
connector dw_mmc_rockchip sdhci_pltfm rockchip_saradc drm_client_lib sdhci =
dw_mmc_pltfm drm_dma_helper phy_rockchip_samsung_hdptx industrialio_trigger=
ed_buffer kfifo_buf spi_rockchip_sfc phy_rockchip_naneng_combphy dw_wdt phy=
_rockchip_snps_pcie3 nvmem_rockchip_otp spi_rockchip cqhci dw_mmc pl330 roc=
kchip_dfi drm_kms_helper dwc3 ohci_platform i2c_rk3x drm adc_keys ohci_hcd =
ehci_platform industrialio ehci_hcd udc_core pwm_rockchip usbcore ulpi phy_=
rockchip_inno_usb2 usb_common
[12144.588844] CPU: 6 UID: 0 PID: 2361 Comm: iwd Not tainted 7.3-rc1-arm64-=
cknow #1 PREEMPTLAZY  Debian 7.3~rc1-1
[12144.589720] Hardware name: FriendlyElec NanoPC-T6 LTS (DT)
[12144.590200] pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[12144.590809] pc : nl80211_get_reg_do+0x244/0x270 [cfg80211]
[12144.591317] lr : nl80211_get_reg_do+0xbc/0x270 [cfg80211]
[12144.591815] sp : ffff80008657b750
[12144.592107] x29: ffff80008657b770 x28: ffff00013282ddc0 x27: 00000000000=
00000
[12144.592736] x26: 0000000000000000 x25: ffffb244e7ef36c0 x24: ffffb244e1f=
98d00
[12144.593363] x23: ffff80008657b8e8 x22: ffff000101c28400 x21: ffff000101c=
27000
[12144.593991] x20: ffff0001335bd014 x19: ffff80008657b7b0 x18: 00000000000=
00010
[12144.594618] x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffff=
fffff
[12144.595245] x14: 0000000000000001 x13: ffffb244e6646eb8 x12: 00000000000=
00000
[12144.595872] x11: 000000000000016f x10: ffff000104b6b9dc x9 : ffffb244e20=
41b54
[12144.596500] x8 : ffff0001335bd014 x7 : 0000000000000000 x6 : 00000000000=
00014
[12144.597127] x5 : 0000000000000014 x4 : 0000000000000000 x3 : ffff0001328=
2ddc0
[12144.597755] x2 : 0000000000000001 x1 : ffff000106fc83e0 x0 : 00000000000=
00000
[12144.598382] Call trace:
[12144.598599]  nl80211_get_reg_do+0x244/0x270 [cfg80211] (P)
[12144.599108]  genl_family_rcv_msg_doit+0xe8/0x160
[12144.599520]  genl_rcv_msg+0x1fc/0x280
[12144.599846]  netlink_rcv_skb+0x70/0x158
[12144.600186]  genl_rcv+0x3c/0x60
[12144.600467]  netlink_unicast+0x1e8/0x2f8
[12144.600814]  netlink_sendmsg+0x1ac/0x420
[12144.601162]  __sock_sendmsg+0x64/0xc8
[12144.601488]  __sys_sendto+0x114/0x190
[12144.601813]  __arm64_sys_sendto+0x2c/0x48
[12144.602169]  invoke_syscall.constprop.0+0xac/0x110
[12144.602596]  el0_svc_common.constprop.0+0xc0/0xf0
[12144.603012]  do_el0_svc+0x24/0x40
[12144.603308]  el0_svc+0x40/0x260
[12144.603591]  el0t_64_sync_handler+0xa0/0xe8
[12144.603962]  el0t_64_sync+0x198/0x1a0
[12144.604286] ---[ end trace 0000000000000000 ]---
[12145.058595] ACPI: <n/a>: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3=
-1f738e285ade rev:0 func:0 (0x1001)
```

Despite the stacktrace, the wireless connection does work:
```
root@nanopc-t6-lts:~# iwctl station wlan0 show
                                Station: wlan0
---------------------------------------------------------------------------=
-----
  Settable  Property              Value
---------------------------------------------------------------------------=
-----
            Scanning              no
            State                 connected
	    ...
            RxMode                802.11ax
            RxMCS                 10
            TxMode                802.11ax
            TxMCS                 7
            TxBitrate             1225100 Kbit/s
            RxBitrate             2161300 Kbit/s
            ExpectedThroughput    1020936 Kbit/s
```

Similar results and stacktrace with kernel 6.18, 7.1 and 7.2, so it's not
a recent regression.

I also have a NanoPC-T6 Plus, which is quite similar, with an MediaTek MT79=
25
M.2 Wi-Fi+BT card and there I do not get the ACPI msgs or the stack trace.

Happy to provide extra info, run tests, etc.

Cheers,
  Diederik
