Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A2D32D0FC;
	Thu, 13 Aug 2026 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633617; cv=pass; b=t1/qEreVHjSfkpL6fyKfgtksj84TjH5qIEo1oa/E4A9mDH1t//1BLYC/spEcawVuTIxnoNlUU/gUYhfCdsFTnUmDu0DM5EAe1K1H+ibWmibR1Mt8HWAmY7iLnUVZI9i/VPptz4pGRnpIUeBgYBMuqMZKxLEHgc+6w8/6594TTkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633617; c=relaxed/simple;
	bh=7Ta0iIdvrlwWwMSDb8WYexLfBGCaLNIhAKZbAbNo6XI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ri/rh6caTZHFOYeUdwIUmLb0ga+MUX/+1Vz4TiqhQ79/6r2O57Ao4y4PFaYdDQ1WV/oXgYZgHt5lyg8KMZc2VQprQ12Ml7LmnpSQNnwHmsrVkW4oO4h3mYtYXdyr8vRSQgd01J9NuSftMKW8y5cCB29DteUJiwg3XEMituvRRWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nfraprado@collabora.com header.b=YpaCOOaH; arc=pass smtp.client-ip=136.143.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nfraprado@collabora.com header.b="YpaCOOaH"
ARC-Seal: i=1; a=rsa-sha256; t=1786633608; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BOj8lqqSnW+ee/wTB10MukrVd0qpsHvwL83kF4efX2uihE31hFcE3TmPiH7hp4Tbv+nVdV7K5hjbP1lle1kEiGMMYjk3WbAUN2Hf1WVVWU0vJZaQ/K03n9j1UBTf3h8oXACOaF0CrEL0GUzHoQzry3PRr1yV8zdj479vCecn3J0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1786633608; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=51811k6Vs/YG5s1LjEnUnVvDFQtU8ePqH0bxWUymUfk=; 
	b=lIbDp55FPXA6nhzZeqdDD6P/407lKCwqonstiEUP4ilVvgU5vgkLWTDS3C7vKE2MIwGdrL4JCV3qdgPhsR3pLeRKjv3jYRIXhJFO9HKz6CQUEBuhuOgnlcvIEsS2eE8tTeKg7OitMf19xl7R5Lc6FqPc+FE5WVw/NY0wehENAxw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nfraprado@collabora.com;
	dmarc=pass header.from=<nfraprado@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786633608;
	s=zohomail; d=collabora.com; i=nfraprado@collabora.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=51811k6Vs/YG5s1LjEnUnVvDFQtU8ePqH0bxWUymUfk=;
	b=YpaCOOaHQg9hqqiekqwOiOloE5rFaIIXrkjc4/6sdDzCgNsnDWihuKHsORYNQugm
	hUqqEcaUhpH786zG66oSDSjMKqFaTMc9qPcz/gMBP+PaFku0RJo7/A8bV69BK8HYHZb
	VoQVL448mAmD/NpLRC8llCExT0B3/PQ6RTWCEC4o=
Received: by mx.zohomail.com with SMTPS id 1786633606668792.0049224972487;
	Thu, 13 Aug 2026 08:06:46 -0700 (PDT)
Message-ID: <cb527333b776e453259f2c73afa483d8f2a4fd9b.camel@collabora.com>
Subject: Re: [PATCH] wifi: rtw89: Don't return default channel from disabled
 bands
From: =?ISO-8859-1?Q?N=EDcolas?= "F. R. A. Prado" <nfraprado@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>, David Lee <sc.lee@realtek.com>
Cc: "kernel@collabora.com" <kernel@collabora.com>, 
 "linux-wireless@vger.kernel.org"
	 <linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, Zong-Zhe Yang <kevin_yang@realtek.com>
Date: Thu, 13 Aug 2026 11:06:45 -0400
In-Reply-To: <6f52ebbc7b784b5ab25d54399a8e411f@realtek.com>
References: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
	 <6f52ebbc7b784b5ab25d54399a8e411f@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-10 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZohoMailClient: External

On Thu, 2026-08-13 at 00:52 +0000, Ping-Ke Shih wrote:
> N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com> wrote:
> > rtw89_get_default_chandef() assumes the lowest frequency channel in
> > the
> > 2GHz band is available on all hardware, and always returns that as
> > the
> > default channel. This is no longer the case after commit
> > 355626a2c232
> > ("wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band"), and the
> > current logic results in kernel WARNs and null pointer dereferences
> > on
> > boards with that quirk set.
>=20
> Could you share the kernel WARN?

Sure, here are the details for those issues:

Warn:
  Origin:
https://github.com/pkshih/rtw/blob/38c58d541cfe286880cdadebc5d726fe18e3b615=
/net/mac80211/rx.c#L5542
  dmesg:

    WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:5376
ieee80211_rx_list+0x759/0xda0 [mac80211]
    Modules linked in: tcp_diag inet_diag rtw89_8852cu uinput
snd_seq_dummy rfcomm snd_hrtimer snd_seq snd_seq_device ccm algif_aead
des3_ede_x86_64 des_generic libdes md4 wireguard libcurve25519
ip6_udp_tunnel udp_tunnel nft_fib_inet nft_fib_ipv4 nft_fib_ipv6
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
nft_chain_nat ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 iptable_mangle iptable_raw iptable_security nf_tables
ip6table_filter ip6_tables iptable_filter uhid cmac algif_hash
algif_skcipher af_alg bnep qrtr_mhi amdgpu rtw89_8852c intel_rapl_msr
rtw89_usb cros_ec_hwmon cros_ec_sysfs cros_ec_debugfs cros_ec_chardev
cros_ec_cec qrtr gpio_cros_ec ath11k_pci btusb amd_atl rtw89_core btmtk
intel_rapl_common ath11k btrtl btbcm amdxcp btintel qmi_helpers
drm_panel_backlight_quirks snd_hda_codec_atihdmi mousedev
snd_hda_codec_hdmi kvm_amd hid_steam gpu_sched cdc_acm bluetooth
mac80211 snd_hda_intel
     drm_suballoc_helper spd5118 cros_ec_dev kvm snd_hda_codec
drm_buddy snd_hda_core irqbypass drm_ttm_helper wmi_bmof
snd_intel_dspcfg polyval_clmulni leds_valve snd_intel_sdw_acpi
ghash_clmulni_intel ttm snd_hwdep aesni_intel cros_ec_keyb cfg80211
drm_exec cros_usbpd_notify snd_pcm matrix_keymap r8169 rapl
i2c_algo_bit pcspkr amd_pmf sp5100_tco realtek snd_timer rfkill
mdio_devres drm_display_helper amdtee snd cec cros_ec_lpcs libphy
i2c_piix4 mhi i2c_smbus soundcore k10temp cros_ec mdio_bus libarc4 ccp
video cros_ec_proto tpm_crb amd_sfh wmi platform_profile tpm_tis tee
tpm_tis_core amd_pmc 8250_dw mac_hid pkcs8_key_parser ntsync
hid_playstation led_class_multicolor hid_nintendo ff_memless i2c_dev
crypto_user dm_mod loop nfnetlink zram 842_decompress 842_compress
lz4hc_compress lz4_compress tpm libaescfb ip_tables x_tables overlay
vfat fat nvme extcon_steamdeck steamdeck_hwmon leds_steamdeck nvme_core
nvme_keyring serio_raw nvme_auth hkdf steamdeck [last unloaded:
rtw89_8852cu]
    CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Kdump: loaded Tainted: G    =20
W           6.18.39-valve1-g967933a3759d #1 PREEMPT(full)=20
b7338bed92ca656968bea48f7630a30e271de506
    Tainted: [W]=3DWARN
    Hardware name: Valve Fremont/Fremont, BIOS F7F0106 04/28/2026
12:12:27
    RIP: 0010:ieee80211_rx_list+0x759/0xda0 [mac80211]
    Code: 00 39 41 04 75 ca 48 85 f6 0f 85 57 ff ff ff 48 89 de eb bc
0f 0b 41 0f b6 41 4c 3c 05 0f 86 ff f8 ff ff 0f 0b e9 ba f9 ff ff <0f>
0b e9 b3 f9 ff ff 80 3d 72 40 21 00 00 0f 85 a6 f9 ff ff 41 0f
    RSP: 0018:ffffccc600003bc8 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: ffff88cc0e240960 RCX: ffffccc600003cc0
    RDX: ffff88cc0e2403e0 RSI: 0000000000000000 RDI: ffff88cc0e240960
    RBP: ffffccc600003cc0 R08: 00000000ffffffff R09: ffff88cc0f094d00
    R10: ffff88cc0e240960 R11: 0000000000000000 R12: 0000000000000000
    R13: 0000000000000000 R14: 0000000000000000 R15: ffffccc600003e94
    FS:  0000000000000000(0000) GS:ffff88cffe396000(0000)
knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00000000b9db2858 CR3: 000000012c820000 CR4: 0000000000f50ef0
    PKRU: 55555554
    Call Trace:
     <IRQ>
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? rtw89_vif_rx_stats_iter+0x72/0x6c0 [rtw89_core
cc2978209104e6e9870df546aa63c2dfe663dabd]
     ? srso_alias_return_thunk+0x5/0xfbef5
     ieee80211_rx_napi+0x55/0xe0 [mac80211
e7188b79ec75a1fb508ead80c70218c2a2d5655b]
     rtw89_core_rx_to_mac80211+0x202/0xd70 [rtw89_core
cc2978209104e6e9870df546aa63c2dfe663dabd]
     ? srso_alias_return_thunk+0x5/0xfbef5
     rtw89_core_rx+0x53f/0x1280 [rtw89_core
cc2978209104e6e9870df546aa63c2dfe663dabd]
     ? __entry_text_end+0x1020d7/0x1020db
     ? kmem_cache_alloc_noprof+0x71/0x5b0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __build_skb+0x4d/0x60
     rtw89_usb_rx_handler+0x124/0x2d0 [rtw89_usb
bae8c268ee39b94df55cfdd699a060bf16cea37d]
     process_one_work+0x193/0x350
     bh_worker+0x187/0x1b0
     tasklet_action+0x10/0x30
     handle_softirqs+0xe1/0x290
     __irq_exit_rcu+0xc6/0xf0
     common_interrupt+0x85/0xa0
     </IRQ>
     <TASK>
     asm_common_interrupt+0x26/0x40
    RIP: 0010:cpuidle_enter_state+0xb5/0x410
    Code: 5c 02 00 00 e8 dc fc 08 ff e8 57 f2 ff ff 48 89 c5 0f 1f 44
00 00 31 ff e8 b8 74 07 ff 45 84 ff 0f 85 2e 02 00 00 fb 45 85 f6 <0f>
88 7c 01 00 00 49 63 ce 48 2b 2c 24 48 6b d1 68 48 89 c8 48 c1
    RSP: 0018:ffffffff8dc03e18 EFLAGS: 00000206
    RAX: ffff88cffe396000 RBX: 0000000000000003 RCX: 0000000000000000
    RDX: 00000026674b5715 RSI: fffffffbffde5c58 RDI: 0000000000000000
    RBP: 00000026674b5715 R08: 0000000000000002 R09: 000000000000000f
    R10: 0000000000000000 R11: 0000000000000000 R12: ffff88cc016d7c00
    R13: ffffffff8ddf87e0 R14: 0000000000000003 R15: 0000000000000000
     ? cpuidle_enter_state+0xa8/0x410
     cpuidle_enter+0x31/0x50
     do_idle+0x14f/0x290
     cpu_startup_entry+0x29/0x30
     rest_init+0xcc/0xd0
     start_kernel+0x993/0x9a0
     x86_64_start_reservations+0x24/0x30
     x86_64_start_kernel+0xcc/0xd0
     common_startup_64+0x13e/0x141
     </TASK>

Null pointer dereference:
  Triggered when running 'iw dev wlan1 set bitrates'
  Origin:
https://github.com/pkshih/rtw/blob/38c58d541cfe286880cdadebc5d726fe18e3b615=
/drivers/net/wireless/realtek/rtw89/phy.c#L672
  dmesg:

    BUG: kernel NULL pointer dereference, address: 0000000000000018
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0=20
    Oops: Oops: 0000 [#1] SMP NOPTI
    CPU: 9 UID: 0 PID: 5466 Comm: iw Kdump: loaded Tainted: G        W
6.18.39-valve1-g967933a3759d #1 PREEMPT(full)=20
b7338bed92ca656968bea48f7630a30e271de506
    Tainted: [W]=3DWARN
    Hardware name: Valve Fremont/Fremont, BIOS F7F0106 04/28/2026
12:12:27
    RIP: 0010:rtw89_phy_rate_pattern_vif+0x2a1/0x380 [rtw89_core]
    Code: c7 e9 a6 fe ff ff 4c 8b 55 80 8b 55 90 48 8b 45 a8 48 8b 7d
98 41 b9 01 00 00 00 48 8b 00 48 8b 40 48 48 8b 84 f8 38 01 00 00 <8b>
48 18 48 6b c7 64 49 d3 e1 48 8b 4d 88 41 83 e9 01 44 8b 04 01
    RSP: 0018:ffffccdf4b247528 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: ffffccdf4b247568 RCX: 0000000000000001
    RDX: 0000000000000000 RSI: 0000000000000088 RDI: 0000000000000000
    RBP: ffffccdf4b2475b0 R08: 0000000000000001 R09: 0000000000000001
    R10: ffff89961b75a860 R11: 0000000000002130 R12: 0000000000000002
    R13: 0000000000000000 R14: ffffccdf4b247640 R15: 0000000000000002
    FS:  00007fc8c4371e80(0000) GS:ffff89998fbd6000(0000)
knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000018 CR3: 000000015d2fc000 CR4: 0000000000f50ef0
    PKRU: 55555554
    Call Trace:
     <TASK>
     rtw89_ops_set_bitrate_mask+0x30/0x80 [rtw89_core
cc2978209104e6e9870df546aa63c2dfe663dabd]
     ieee80211_set_bitrate_mask+0x242/0x3f0 [mac80211
e7188b79ec75a1fb508ead80c70218c2a2d5655b]
     nl80211_set_tx_bitrate_mask+0xe2/0x1b0 [cfg80211
9026e3ef9756f7aa40bbad0fac3294da3b8c486f]
     genl_family_rcv_msg_doit+0xff/0x160
     genl_rcv_msg+0x1aa/0x2b0
     ? __pfx_nl80211_pre_doit+0x10/0x10 [cfg80211
9026e3ef9756f7aa40bbad0fac3294da3b8c486f]
     ? __pfx_nl80211_set_tx_bitrate_mask+0x10/0x10 [cfg80211
9026e3ef9756f7aa40bbad0fac3294da3b8c486f]
     ? __pfx_nl80211_post_doit+0x10/0x10 [cfg80211
9026e3ef9756f7aa40bbad0fac3294da3b8c486f]
     ? __pfx_genl_rcv_msg+0x10/0x10
     netlink_rcv_skb+0x5c/0x110
     genl_rcv+0x28/0x40
     netlink_unicast+0x288/0x3c0
     ? __alloc_skb+0xdb/0x1a0
     netlink_sendmsg+0x20d/0x430
     ____sys_sendmsg+0x374/0x390
     ? import_iovec+0x2f/0x40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ___sys_sendmsg+0x99/0xe0
     __sys_sendmsg+0x8a/0xf0
     do_syscall_64+0x7d/0x980
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kmem_cache_free+0x550/0x5d0
     ? __x64_sys_close+0x3d/0x80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __x64_sys_close+0x3d/0x80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_syscall_64+0x7d/0x980
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __sys_socket+0xd0/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_syscall_64+0x7d/0x980
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? exc_page_fault+0x71/0x150
     entry_SYSCALL_64_after_hwframe+0x76/0x7e
    RIP: 0033:0x7fc8c4432006

> >=20
> > Update rtw89_get_default_chandef() to consider the available bands
> > when
> > picking the default channel.
> >=20
> > Fixes: 355626a2c232 ("wifi: rtw89: 8852cu: add quirk to disable 2.4
> > GHz band")
> > Signed-off-by: N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
> > ---
> > =C2=A0drivers/net/wireless/realtek/rtw89/chan.c |=C2=A0 2 +-
> > =C2=A0drivers/net/wireless/realtek/rtw89/core.c | 21 ++++++++++++++++++=
-
> > --
> > =C2=A0drivers/net/wireless/realtek/rtw89/core.h |=C2=A0 3 ++-
> > =C2=A03 files changed, 21 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/wireless/realtek/rtw89/chan.c
> > b/drivers/net/wireless/realtek/rtw89/chan.c
> > index 6f11335b4968..6512fc9eef29 100644
> > --- a/drivers/net/wireless/realtek/rtw89/chan.c
> > +++ b/drivers/net/wireless/realtek/rtw89/chan.c
> > @@ -297,7 +297,7 @@ static void rtw89_config_default_chandef(struct
> > rtw89_dev *rtwdev)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct cfg80211_chan_def cha=
ndef =3D {0};
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rtw89_get_default_chandef(&chande=
f);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rtw89_get_default_chandef(rtwdev,=
 &chandef);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __rtw89_config_entity_chande=
f(rtwdev, RTW89_CHANCTX_0,
> > &chandef);
> > =C2=A0}
> >=20
> > diff --git a/drivers/net/wireless/realtek/rtw89/core.c
> > b/drivers/net/wireless/realtek/rtw89/core.c
> > index 397ebbfcac09..5ae9523667c6 100644
> > --- a/drivers/net/wireless/realtek/rtw89/core.c
> > +++ b/drivers/net/wireless/realtek/rtw89/core.c
> > @@ -393,10 +393,25 @@ static void rtw89_traffic_stats_accu(struct
> > rtw89_dev *rtwdev,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > =C2=A0}
> >=20
> > -void rtw89_get_default_chandef(struct cfg80211_chan_def *chandef)
> > +void rtw89_get_default_chandef(struct rtw89_dev *rtwdev,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct cfg80211_chan_def *chandef)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cfg80211_chandef_create(chandef, =
&rtw89_channels_2ghz[0],
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NL80211_CHAN_NO_HT);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 support_bands =3D rtwdev->chip=
->support_bands;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ieee80211_channel *default=
_channel;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (support_bands & BIT(NL80211_B=
AND_2GHZ) &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !test_bit=
(RTW89_QUIRK_DISABLE_2GHZ, rtwdev->quirks)) {
>=20
> I'd prefer the style implemented in rtw89_core_set_supported_band()
> before
> this if-branch.
>=20
> 	if (test_bit(RTW89_QUIRK_DISABLE_2GHZ, rtwdev->quirks))
> 		support_bands &=3D ~BIT(NL80211_BAND_2GHZ);

Sure, can do it in v2.

>=20
>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 default_channel =3D &rtw89_channels_2ghz[0];
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (support_bands & BIT(NL=
80211_BAND_5GHZ)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 default_channel =3D &rtw89_channels_5ghz[0];
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (support_bands & BIT(NL=
80211_BAND_6GHZ)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 default_channel =3D &rtw89_channels_6ghz[0];
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 rtw89_err(rtwdev, "Failed to get default channel,
> > no band supported\n");
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return;
>=20
> If it somehow falls into this case, won't it warn or null-
> dereference?

I suppose it could, but I'm not sure what would be a better option
here, do you have any suggestions?

In any case all of the hardware variants currently defined have at
least one of those flags set, so this branch could never be reached.
But if something ever changes, then this error would help noticing it.

--=20
Thanks,

N=C3=ADcolas
