Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C432638AC87
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787605911; cv=none; b=nvBkL5cTSRunpdZlXqLXQ/8OYcq5ivF8INLIbc3VbrLJseqhGhHd7JIV7N5y6mKAgQyN4Y0QkBkdGopZ9vdXS7RWZ/Tnt2+DlhNEYvxCuPJwZBWrqMIHjCx41uH32vW09Acveg3PET0kwRaUHd4k85NV8MiH6lkV6QZ3ethISeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787605911; c=relaxed/simple;
	bh=ejHGVwz2Dhyy9MfuLdCbPoyNwpZ0gan2/viW8zRjxs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4Kp06ZfeBb5JrwahI6+p7+3DjWcubenBh+Y/hjQBgLVLQcU+lkKQrkIMU9EP6IVv27IgAwz3af0Lh1iLljZHuwuBvakdCCNuzZYQVPZDs3DPuTS4xeKldj3QTgiR2BxD4Mu1hk7o5y+hRhejMAZuJPt1VGgPPGgms4Gk2Bo9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XDN3jOmS; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDN3jOmS"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b011edaf7dso4493003e87.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787605907; x=1788210707; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NDKfXK9R/anv7JAPwJXLUqFuPddcBvVm07Or8b8ojdc=;
        b=XDN3jOmSYrGXUJjW/HyTwyX4LekPx8ZJe5K55Cfxx5xo9llGtIF/vVtC+WVB9S8S8s
         6zAm2ho4yf6GpHkpInJl2AutLW2/XzzxtrrITNfgLpWCLVGFK++fOnleODcj03n7hOpO
         9i1yQd6f92PgICn3TylfRzmTKWn8zZvr4Oqq3KYXnu5reKg8PxtM8htUxKWBjca7LlCt
         g1Xb8rIrL+bXYXKR17d2KoJm5sXKrPnXxZCxjVgENqn0ItVWtp6ENx8n01lJQCXC7CZ0
         W8Uy7trA+hb7vnrpPQVpEztY51YcCSvT8coC8N5/wcxJta+DRbL7XKQDf7dOGzLRZXX6
         AowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787605907; x=1788210707;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NDKfXK9R/anv7JAPwJXLUqFuPddcBvVm07Or8b8ojdc=;
        b=WTEjT7DovoW/gGhDeDGGxBBxuiray1aZwWsjo9iZaDIiz9lNoq1wpK9zE5URMgx4RR
         Nw8hU5WFk4OCLGqYkS5VdbGqEo6TYjcxcquEiBhs9JXvr3dvOqgaKvDxWe+4EsRg+HEi
         LMCNb7QcQQGezQvVgPTdHbmEQmf26hozulIo+DgcC8BmTQDBI+xwKnWclZJfpqojO/EE
         IT+Q/DjeDL8pmXbdZNcddNF5vhe7vT08KKe3UWfirI5ipZH3Ufsssd0ZPHJtJXREz3m4
         8e6z4cjWcXDC7Xkcq19UPYxLIJIchdlpPD3yHzYvJ/ZNpU9QRlh+BkSJdZb7LcpV9CZp
         NSXg==
X-Forwarded-Encrypted: i=1; AHgh+RoohxrtifY5qcULm+dbQAWGa1rmOwYnrdoxDuhsXeVg3en0/tEN50vd84WL6M9mG09vFceGzgoRCzsQ9/hHQg==@vger.kernel.org
X-Gm-Message-State: AFuF++m4IMlZnR2D4XIrIoI6o+JjtopfKopS5DZzxBF0zguRu+/Ny1WM
	Auyn3dmBMF90RApBoAEOc9cgTkdnhZgKPv9N05k1j3aE8vkjCcO6H1BS
X-Gm-Gg: AR+sD10uOQV00Ptnbw9JonnJHWdK/FlnFvwnptZ9r5WM5dbQlQlVYXcdVTwwLvdARrO
	bJToAq62LrD4CgeBWX1rmfs6zWGJCYOn+ElA86BPvwljsgmbgb4XrwrSp3UIgwr7jxpfleZG4fy
	Cx5TDSvfv8WBSiloeI1/RjUJz5PmubdRR+YSNScqMO2z4EASUsyzM5whjHV8bzyyE1d+G6f3U1E
	7JS+Cs0bWt9XWrY3VbhjNV2cWZ+zVcUPgkBHwiW9gSYDXSN55ZeweiJWZUs5D2cC2EpYreIB7i8
	8q/gSdJ42BwtrKSs1jZ5Gn6H/N65Sko+C5/VFOzH6hBRoG6BwGX8duo0eSBfkGQxeWfkaqaxxoU
	KNtSp+STJJnIS89qGKuayjmh+5QucYUgBGJChYJlMDuhVExdooqiMxSNWJuBorCy8fIL16oWnsx
	IvjIA4qBtgv5emcHAlFxwwyrbgUT0vss8VaNAIilo4dIP/NTDnYCB15RJVZ4M4iqP8Em/W6E27s
	zU=
X-Received: by 2002:a05:6512:ac2:b0:5b1:5f8f:bc1e with SMTP id 2adb3069b0e04-5b484208fdamr9073606e87.3.1787605906238;
        Mon, 24 Aug 2026 14:11:46 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a1c2e5684fsm16699881fa.2.2026.08.24.14.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:11:45 -0700 (PDT)
Date: Mon, 24 Aug 2026 23:11:45 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: JB Tsai <jb.tsai@mediatek.com>
Cc: nbd@nbd.name, lorenzo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, Deren.Wu@mediatek.com, Sean.Wang@mediatek.com, 
	Quan.Zhou@mediatek.com, Ryder.Lee@mediatek.com, Leon.Yen@mediatek.com, 
	litien.chang@mediatek.com, Charlie-cy.Wu@mediatek.com
Subject: Re: [PATCH v2] wifi: mt76: mt7921: add regulatory wiphy self manager
 support
Message-ID: <aoyxqHYvSuaBeubf@soda.int.kasm.eu>
References: <20260609065036.577329-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260609065036.577329-1-jb.tsai@mediatek.com>

Hi,

On 2026-06-09 14:50:36 +0800, JB Tsai wrote:
> From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
>=20
> Introduce regulatory wiphy self-managed mode support for MT7921,
> allowing the driver to manage its own regulatory domain independently
> from the kernel's regulatory framework.
>=20
> Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

This patch generates an oops on my Framework 13 with the MT7922 and the
network interface does not appear:

 mt7921e 0000:01:00.0: Loading firmware patch: mediatek/WIFI_MT7922_patch_m=
cu_1_1_hdr.bin
 mt7921e 0000:01:00.0: HW/SW Version: 0x8a108a10, Build Time: 2026072414325=
7a
 Bluetooth: hci0: Device setup in 146228 usecs
 Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection command is adve=
rtised, but not supported.
 mt7921e 0000:01:00.0: WM Firmware Version: ____000000, Build Time: 2026072=
4143402
 BUG: kernel NULL pointer dereference, address: 0000000000000004
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP NOPTI
 Hardware name: Framework Laptop 13 (AMD Ryzen 7040Series)/FRANMDCP05, BIOS=
 03.20 06/23/2026
 Workqueue: events mt7921_init_work [mt7921_common]
 RIP: 0010:mt792x_init_acpi_sar_power (drivers/net/wireless/mediatek/mt76/m=
t792x_acpi_sar.c:323) mt792x_lib
 Code: 01 00 00 48 83 78 08 00 0f 84 c2 01 00 00 48 83 ec 28 49 89 fb 48 89=
 1c 24 48 8b 0f 48 8b 01 48 8b 40 50 48 8b 98 40 06 00 00 <8b> 43 04 85 c0 =
0f 84 83 01 00 00 48 89 6c 24 08 4c 89 64 24 10 4c
 All code
 =3D=3D=3D=3D=3D=3D=3D=3D
    0:	01 00                	add    %eax,(%rax)
    2:	00 48 83             	add    %cl,-0x7d(%rax)
    5:	78 08                	js     0xf
    7:	00 0f                	add    %cl,(%rdi)
    9:	84 c2                	test   %al,%dl
    b:	01 00                	add    %eax,(%rax)
    d:	00 48 83             	add    %cl,-0x7d(%rax)
   10:	ec                   	in     (%dx),%al
   11:	28 49 89             	sub    %cl,-0x77(%rcx)
   14:	fb                   	sti
   15:	48 89 1c 24          	mov    %rbx,(%rsp)
   19:	48 8b 0f             	mov    (%rdi),%rcx
   1c:	48 8b 01             	mov    (%rcx),%rax
   1f:	48 8b 40 50          	mov    0x50(%rax),%rax
   23:	48 8b 98 40 06 00 00 	mov    0x640(%rax),%rbx
   2a:*	8b 43 04             	mov    0x4(%rbx),%eax		<-- trapping instructi=
on
   2d:	85 c0                	test   %eax,%eax
   2f:	0f 84 83 01 00 00    	je     0x1b8
   35:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
   3a:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   3f:	4c                   	rex.WR
=20
 Code starting with the faulting instruction
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    0:	8b 43 04             	mov    0x4(%rbx),%eax
    3:	85 c0                	test   %eax,%eax
    5:	0f 84 83 01 00 00    	je     0x18e
    b:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
   10:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   15:	4c                   	rex.WR
 RSP: 0018:ffffd3b6c0257cb0 EFLAGS: 00010282
 RAX: ffff8b9d13290440 RBX: 0000000000000000 RCX: ffff8b9d132925c0
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8b9d13299798
 RBP: ffff8b9d13292e68 R08: 0000000000000012 R09: 0000000000000002
 R10: ffff8b9cc3217b00 R11: ffff8b9d13299798 R12: ffff8b9d13290440
 R13: ffffffffc0fb235f R14: ffff8b9ce6136800 R15: ffff8b9cc2d7f300
 FS:  0000000000000000(0000) GS:ffff8ba04d3f9000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000004 CR3: 000000018ae0e000 CR4: 0000000000f50ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
 mt7921_set_tx_sar_pwr (drivers/net/wireless/mediatek/mt76/mt7921/main.c:12=
97 (discriminator 1)) mt7921_common
 mt7921_mcu_regd_update (drivers/net/wireless/mediatek/mt76/mt7921/regd.c:1=
22) mt7921_common
 mt7921_regd_update (drivers/net/wireless/mediatek/mt76/mt7921/regd.c:321) =
mt7921_common
 mt7921_run_firmware (drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:511 d=
rivers/net/wireless/mediatek/mt76/mt7921/mcu.c:669 drivers/net/wireless/med=
iatek/mt76/mt7921/mcu.c:657) mt7921_common
 mt7921e_mcu_init (drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c:58) =
mt7921e
 mt7921_init_work (drivers/net/wireless/mediatek/mt76/mt7921/init.c:92 driv=
ers/net/wireless/mediatek/mt76/mt7921/init.c:116 drivers/net/wireless/media=
tek/mt76/mt7921/init.c:137) mt7921_common
  ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:234)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  ? __pfx_worker_thread (kernel/workqueue.c:3754)
  kthread (kernel/kthread.c:436)
  ? __pfx_kthread (kernel/kthread.c:948)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ? __pfx_kthread (kernel/kthread.c:948)
  ? __pfx_kthread (kernel/kthread.c:948)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  </TASK>
 Modules linked in: snd_sof_amd_acp7x snd_sof_amd_acp70 snd_sof_amd_acp63 s=
nd_sof_amd_vangogh snd_sof_amd_rembrandt snd_sof_amd_renoir snd_sof_amd_acp=
 snd_sof_xtensa_dsp snd_sof_pci snd_sof fmpm(-) amd_atl snd_sof_utils intel=
_rapl_msr snd_pci_acp7x iosf_mbi snd_pci_ps intel_rapl_common snd_soc_acpi_=
amd_match snd_amd_sdw_acpi soundwire_amd soundwire_generic_allocation kvm_a=
md soundwire_bus mt7921e mousedev mt7921_common snd_soc_sdca snd_hda_codec_=
generic snd_hda_codec_atihdmi drm_buddy mt792x_lib kvm amdxcp snd_hda_codec=
_hdmi btusb i2c_algo_bit snd_soc_core mt76_connac_lib drm_ttm_helper btrtl =
ttm btintel snd_hda_intel amdxdna snd_compress mt76 btbcm snd_acp_pci drm_e=
xec input_leds snd_hda_codec hid_multitouch btmtk snd_amd_acpi_mach drm_pan=
el_backlight_quirks hid_sensor_hub joydev spd5118 wmi_bmof irqbypass pcspkr=
 serio_raw mac80211 bluetooth snd_acp_legacy_common snd_hda_core snd_intel_=
dspcfg i2c_hid_acpi i2c_hid gpu_sched snd_hwdep snd_pci_acp6x drm_suballoc_=
helper cfg80211 snd_pcm drm_display_helper
  snd_pci_acp5x snd_timer amd_pmf sp5100_tco snd_rn_pci_acp3x tpm_crb watch=
dog snd snd_acp_config i2c_designware_platform pkcs8_key_parser tpm_tis amd=
tee snd_soc_acpi i2c_designware_core cec rfkill soundcore tpm_tis_core snd_=
pci_acp3x video libarc4 tpm evdev i2c_dev i2c_piix4 tee mac_hid cros_kbd_le=
d_backlight libaescfb i2c_smbus k10temp ecdh_generic ccp cros_ec_sysfs cros=
_ec_debugfs amd_sfh ecc amd_pmc wmi bpf_preload
 CR2: 0000000000000004
 ---[ end trace 0000000000000000 ]---
 pstore: backend (efi_pstore) writing error (-28)
 RIP: 0010:mt792x_init_acpi_sar_power (drivers/net/wireless/mediatek/mt76/m=
t792x_acpi_sar.c:323) mt792x_lib
 Code: 01 00 00 48 83 78 08 00 0f 84 c2 01 00 00 48 83 ec 28 49 89 fb 48 89=
 1c 24 48 8b 0f 48 8b 01 48 8b 40 50 48 8b 98 40 06 00 00 <8b> 43 04 85 c0 =
0f 84 83 01 00 00 48 89 6c 24 08 4c 89 64 24 10 4c
 All code
 =3D=3D=3D=3D=3D=3D=3D=3D
    0:	01 00                	add    %eax,(%rax)
    2:	00 48 83             	add    %cl,-0x7d(%rax)
    5:	78 08                	js     0xf
    7:	00 0f                	add    %cl,(%rdi)
    9:	84 c2                	test   %al,%dl
    b:	01 00                	add    %eax,(%rax)
    d:	00 48 83             	add    %cl,-0x7d(%rax)
   10:	ec                   	in     (%dx),%al
   11:	28 49 89             	sub    %cl,-0x77(%rcx)
   14:	fb                   	sti
   15:	48 89 1c 24          	mov    %rbx,(%rsp)
   19:	48 8b 0f             	mov    (%rdi),%rcx
   1c:	48 8b 01             	mov    (%rcx),%rax
   1f:	48 8b 40 50          	mov    0x50(%rax),%rax
   23:	48 8b 98 40 06 00 00 	mov    0x640(%rax),%rbx
   2a:*	8b 43 04             	mov    0x4(%rbx),%eax		<-- trapping instructi=
on
   2d:	85 c0                	test   %eax,%eax
   2f:	0f 84 83 01 00 00    	je     0x1b8
   35:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
   3a:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   3f:	4c                   	rex.WR
=20
 Code starting with the faulting instruction
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    0:	8b 43 04             	mov    0x4(%rbx),%eax
    3:	85 c0                	test   %eax,%eax
    5:	0f 84 83 01 00 00    	je     0x18e
    b:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
   10:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   15:	4c                   	rex.WR
 RSP: 0018:ffffd3b6c0257cb0 EFLAGS: 00010282
 RAX: ffff8b9d13290440 RBX: 0000000000000000 RCX: ffff8b9d132925c0
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8b9d13299798
 RBP: ffff8b9d13292e68 R08: 0000000000000012 R09: 0000000000000002
 R10: ffff8b9cc3217b00 R11: ffff8b9d13299798 R12: ffff8b9d13290440
 R13: ffffffffc0fb235f R14: ffff8b9ce6136800 R15: ffff8b9cc2d7f300
 FS:  0000000000000000(0000) GS:ffff8ba04d3f9000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000004 CR3: 000000016923c000 CR4: 0000000000f50ef0
 PKRU: 55555554
 note: kworker/2:0[27] exited with irqs disabled

Reverting the patch fixes the issue for me. Let me know if there's
anything else you need.

Regards,
Klara Modin

bisect:
 # bad: [11260c335ec6071af5543aef73000b28f041c124] Merge tag 'sched_ext-for=
-7.3' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext
 # good: [8d3ae59288f1e7d58d76558a6ee96d533bc5019f] Linux 7.2
 git bisect start '11260c335ec6071af5543aef73000b28f041c124' '8d3ae59288f1e=
7d58d76558a6ee96d533bc5019f'
 # good: [a93f3bf4e1d60777b1659b812c9e818cfc53b449] Merge tag 'hid-for-linu=
s-2026081901' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid
 git bisect good a93f3bf4e1d60777b1659b812c9e818cfc53b449
 # good: [5a8cd539ac19f7a68e68e1d25ef9ca2ff55b8500] Merge tag 'bpf-next-7.3=
' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
 git bisect good 5a8cd539ac19f7a68e68e1d25ef9ca2ff55b8500
 # bad: [ca800a9302764c445de0da0e84d2252400a770ee] wifi: nxpwifi: bound uAP=
 association event IEs to the event buffer
 git bisect bad ca800a9302764c445de0da0e84d2252400a770ee
 # good: [edc84a9396acf1a0e78c46230dd0bcee1b84ac53] Merge tag 'wireless-202=
6-07-26' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss-next
 git bisect good edc84a9396acf1a0e78c46230dd0bcee1b84ac53
 # bad: [636a883e2feef5e4ff95695d3c372ceff03960f5] wifi: mt76: mt7603: rest=
ore hardware PS buffering after a service period
 git bisect bad 636a883e2feef5e4ff95695d3c372ceff03960f5
 # good: [a4803d1801c701603e2403ba5eb2b8ed55667e58] wifi: mt76: mt792x: dra=
in USB UDMA before WFSYS reset
 git bisect good a4803d1801c701603e2403ba5eb2b8ed55667e58
 # bad: [6689b4a65e88d7b019e687fa9d6943ca070f3e43] wifi: mt76: fix out-of-b=
ounds access in mmio copy helpers
 git bisect bad 6689b4a65e88d7b019e687fa9d6943ca070f3e43
 # good: [1f83a8378eb26c47ff947709e67d7145a84a3907] wifi: mt76: mt7921: ref=
actor regd update to fix recursive mutex deadlock
 git bisect good 1f83a8378eb26c47ff947709e67d7145a84a3907
 # bad: [4a2f4be532e3ea4e2b536e411793a05aaa51af25] wifi: mt76: mt7915: avoi=
d nss underflow in mt7915_mcu_get_sta_nss
 git bisect bad 4a2f4be532e3ea4e2b536e411793a05aaa51af25
 # bad: [86897f106669c07eea4c34b54c3268d448d41426] wifi: mt76: fix RX data =
queuing of RRO 3.0
 git bisect bad 86897f106669c07eea4c34b54c3268d448d41426
 # bad: [6bb5066cfcd4296ac5e0b6872f43f96a43bfe566] wifi: mt76: mt7996: fix =
EAPOL source BSS for non-MLD stations
 git bisect bad 6bb5066cfcd4296ac5e0b6872f43f96a43bfe566
 # bad: [9b80bd9cab40c402a75e8dc850e97503ad3b8bbc] wifi: mt76: mt7921: add =
regulatory wiphy self manager support
 git bisect bad 9b80bd9cab40c402a75e8dc850e97503ad3b8bbc
 # good: [e9f3f1cc133fc2ea51a11be7cfe51733081d176a] wifi: mt76: mt7925: add=
 regulatory wiphy self manager support
 git bisect good e9f3f1cc133fc2ea51a11be7cfe51733081d176a
 # first 'bad' commit: [9b80bd9cab40c402a75e8dc850e97503ad3b8bbc] wifi: mt7=
6: mt7921: add regulatory wiphy self manager support

> ---
> v2: fix regd.c build warning
> ---
>  .../wireless/mediatek/mt76/mt76_connac_mcu.h  |   1 +
>  .../net/wireless/mediatek/mt76/mt7921/mcu.c   |   3 +
>  .../net/wireless/mediatek/mt76/mt7921/regd.c  | 209 ++++++++++++++++--
>  .../net/wireless/mediatek/mt76/mt7921/regd.h  |  55 ++++-
>  4 files changed, 245 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drive=
rs/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> index ed5c441748d8..c10a2c4e7ee2 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> @@ -1363,6 +1363,7 @@ enum {
>  	MCU_CE_CMD_FWLOG_2_HOST =3D 0xc5,
>  	MCU_CE_CMD_GET_WTBL =3D 0xcd,
>  	MCU_CE_CMD_GET_TXPWR =3D 0xd0,
> +	MCU_CE_CMD_SET_REGD_CH =3D 0xd1,
>  };
> =20
>  enum {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7921/mcu.c
> index 25b9437250f7..2e0769d18f87 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
> @@ -1403,6 +1403,9 @@ int mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *=
alpha2,
> =20
>  	/* submit all clc config */
>  	for (i =3D 0; i < ARRAY_SIZE(phy->clc); i++) {
> +		if (i =3D=3D MT792x_CLC_REGD)
> +			continue;
> +
>  		ret =3D __mt7921_mcu_set_clc(dev, alpha2, env_cap,
>  					   phy->clc[i], i);
> =20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c b/drivers/n=
et/wireless/mediatek/mt76/mt7921/regd.c
> index f122e418d825..d29b3b0113f2 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
> @@ -10,6 +10,15 @@ static bool mt7921_disable_clc;
>  module_param_named(disable_clc, mt7921_disable_clc, bool, 0644);
>  MODULE_PARM_DESC(disable_clc, "disable CLC support");
> =20
> +static struct ieee80211_regdomain mt7921_regd_ww =3D {
> +	.n_reg_rules =3D 1,
> +	.alpha2 =3D  "00",
> +	.reg_rules =3D {
> +		/* IEEE 802.11b/g, channels 1..11 */
> +		REG_RULE(2412 - 10, 2462 + 10, 40, 6, 20, 0),
> +	}
> +};
> +
>  bool mt7921_regd_clc_supported(struct mt792x_dev *dev)
>  {
>  	if (mt7921_disable_clc ||
> @@ -33,6 +42,9 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct =
mt792x_dev *dev)
>  	np =3D mt76_find_power_limits_node(mdev);
> =20
>  	sband =3D wiphy->bands[NL80211_BAND_5GHZ];
> +	if (!sband)
> +		return;
> +
>  	band_np =3D np ? of_get_child_by_name(np, "txpower-5g") : NULL;
>  	for (i =3D 0; i < sband->n_channels; i++) {
>  		ch =3D &sband->channels[i];
> @@ -71,35 +83,36 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struc=
t mt792x_dev *dev)
>  	}
>  }
> =20
> -int mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
> -			   enum environment_cap country_ie_env)
> +static int mt7921_mcu_apply_regd(struct mt792x_dev *dev, u8 *alpha2,
> +				  enum environment_cap env)
>  {
> -	struct mt76_dev *mdev =3D &dev->mt76;
> -	struct ieee80211_hw *hw =3D mdev->hw;
> +	struct ieee80211_hw *hw =3D mt76_hw(dev);
>  	struct wiphy *wiphy =3D hw->wiphy;
> -	int ret =3D 0;
> -
> -	dev->regd_in_progress =3D true;
> -
> -	mt792x_mutex_acquire(dev);
> -	if (!dev->regd_change)
> -		goto err;
> +	int ret;
> =20
> -	ret =3D mt7921_mcu_set_clc(dev, alpha2, country_ie_env);
> +	ret =3D mt7921_mcu_set_clc(dev, alpha2, env);
>  	if (ret < 0)
> -		goto err;
> +		return ret;
> =20
>  	mt7921_regd_channel_update(wiphy, dev);
> =20
>  	ret =3D mt76_connac_mcu_set_channel_domain(hw->priv);
>  	if (ret < 0)
> -		goto err;
> +		return ret;
> =20
> -	ret =3D mt7921_set_tx_sar_pwr(hw, NULL);
> -	if (ret < 0)
> -		goto err;
> +	return mt7921_set_tx_sar_pwr(hw, NULL);
> +}
> =20
> -err:
> +int mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
> +			   enum environment_cap country_ie_env)
> +{
> +	int ret =3D 0;
> +
> +	dev->regd_in_progress =3D true;
> +
> +	mt792x_mutex_acquire(dev);
> +	if (dev->regd_change)
> +		ret =3D mt7921_mcu_apply_regd(dev, alpha2, country_ie_env);
>  	mt792x_mutex_release(dev);
>  	dev->regd_change =3D false;
>  	dev->regd_in_progress =3D false;
> @@ -142,10 +155,160 @@ void mt7921_regd_notifier(struct wiphy *wiphy,
>  	if (pm->suspended)
>  		return;
> =20
> +	if (MT7921_REGD_SUPPORTED(&dev->phy)) {
> +		mt7921_regd_update(&dev->phy, req->alpha2);
> +
> +		return;
> +	}
> +
>  	mt7921_mcu_regd_update(dev, req->alpha2,
>  			       req->country_ie_env);
>  }
> =20
> +static struct sk_buff *
> +mt7921_regd_query_regdb(struct mt792x_phy *phy, char *alpha2)
> +{
> +	struct wiphy *wiphy =3D phy->mt76->hw->wiphy;
> +	struct ieee80211_hw *hw =3D wiphy_to_ieee80211_hw(wiphy);
> +	struct mt792x_dev *dev =3D mt792x_hw_dev(hw);
> +	struct mt7921_clc *clc =3D phy->clc[MT792x_CLC_REGD];
> +	struct mt7921_regd_query_req *req;
> +	struct mt7921_regd_cc *regd_cc;
> +	struct sk_buff *ret_skb =3D NULL;
> +	u8 *pos, *last_pos;
> +	int ret =3D 0;
> +
> +	if (!clc)
> +		return NULL;
> +
> +	pos =3D clc->data;
> +	last_pos =3D pos + le32_to_cpu(clc->len) - sizeof(struct mt7921_clc);
> +	while (pos < last_pos) {
> +		u32 req_len =3D 0;
> +		u32 rules_len =3D 0;
> +		u32 sign_len =3D 4;
> +
> +		if (pos + sizeof(*regd_cc) > last_pos)
> +			break;
> +
> +		regd_cc =3D (struct mt7921_regd_cc *)pos;
> +		rules_len =3D sizeof(struct mt7921_regd_rule_header) +
> +			    sizeof(struct mt7921_regd_rule) *
> +			    le32_to_cpu(regd_cc->n_reg_rules);
> +
> +		if (pos + sizeof(*regd_cc) + rules_len + sign_len > last_pos)
> +			break;
> +
> +		pos +=3D sizeof(*regd_cc) + rules_len + sign_len;
> +		if (memcmp(regd_cc->alpha2, alpha2, 2))
> +			continue;
> +
> +		req_len =3D sizeof(*req) + rules_len + sign_len;
> +		req =3D devm_kmalloc(dev->mt76.dev, req_len, GFP_KERNEL);
> +
> +		if (!req)
> +			return NULL;
> +
> +		req->ver =3D regd_cc->ver;
> +		req->sign_type =3D regd_cc->sign_type;
> +		req->size =3D cpu_to_le32(rules_len + sign_len);
> +		req->n_reg_rules =3D regd_cc->n_reg_rules;
> +
> +		memcpy(req->alpha2, regd_cc->alpha2, 2);
> +		memcpy(req->data, regd_cc->data, rules_len + sign_len);
> +
> +		ret =3D mt76_mcu_send_and_get_msg(&dev->mt76,
> +						MCU_CE_CMD(SET_REGD_CH),
> +						req, req_len, true, &ret_skb);
> +
> +		devm_kfree(dev->mt76.dev, req);
> +
> +		return ret < 0 ? NULL : ret_skb;
> +	}
> +
> +	return NULL;
> +}
> +
> +int mt7921_regd_update(struct mt792x_phy *phy, char *alpha2)
> +{
> +	struct wiphy *wiphy =3D phy->mt76->hw->wiphy;
> +	struct ieee80211_hw *hw =3D wiphy_to_ieee80211_hw(wiphy);
> +	struct mt792x_dev *dev =3D mt792x_hw_dev(hw);
> +	struct mt7921_regd_rule *mt7921_rule;
> +	struct mt76_dev *mdev =3D &dev->mt76;
> +	struct ieee80211_regdomain *regd;
> +	struct ieee80211_reg_rule *rule;
> +	struct mt7921_regd_rule_ev *ev;
> +	int i, num_of_rules =3D 0;
> +	struct sk_buff *skb;
> +	int ret =3D 0;
> +
> +	if (dev->hw_full_reset)
> +		return 0;
> +
> +	if (!MT7921_REGD_SUPPORTED(phy))
> +		return -EOPNOTSUPP;
> +
> +	mt792x_mutex_acquire(dev);
> +	skb =3D mt7921_regd_query_regdb(phy, alpha2);
> +	mt792x_mutex_release(dev);
> +
> +	if (!skb)
> +		return -EINVAL;
> +
> +	ev =3D (struct mt7921_regd_rule_ev *)(skb->data + 4);
> +	num_of_rules =3D le32_to_cpu(ev->n_reg_rules);
> +
> +	if (!num_of_rules ||
> +		WARN_ON_ONCE(num_of_rules > NL80211_MAX_SUPP_REG_RULES)) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> +	regd =3D kzalloc(struct_size(regd, reg_rules, num_of_rules), GFP_KERNEL=
);
> +	if (!regd) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	for (i =3D 0; i < num_of_rules; i++) {
> +		mt7921_rule =3D &ev->reg_rule[i];
> +		rule =3D &regd->reg_rules[i];
> +
> +		rule->freq_range.start_freq_khz =3D
> +					MHZ_TO_KHZ(mt7921_rule->start_freq);
> +		rule->freq_range.end_freq_khz =3D
> +					MHZ_TO_KHZ(mt7921_rule->end_freq);
> +		rule->freq_range.max_bandwidth_khz =3D
> +					MHZ_TO_KHZ(mt7921_rule->max_bw);
> +		/* not used by fw */
> +		rule->power_rule.max_antenna_gain =3D DBI_TO_MBI(6);
> +		rule->power_rule.max_eirp =3D DBM_TO_MBM(22);
> +		rule->flags =3D mt7921_rule->flags;
> +	}
> +
> +	regd->n_reg_rules =3D num_of_rules;
> +	regd->dfs_region =3D ev->dfs_region;
> +
> +	memcpy(regd->alpha2, alpha2, 2);
> +	memcpy(mdev->alpha2, alpha2, 2);
> +
> +	dev->regd_change =3D true;
> +	mt7921_mcu_regd_update(dev, alpha2, ENVIRON_ANY);
> +
> +	ret =3D regulatory_set_wiphy_regd(wiphy, regd);
> +
> +	kfree(regd);
> +err:
> +	dev_kfree_skb(skb);
> +
> +	if (ret < 0)
> +		return regulatory_set_wiphy_regd(wiphy, &mt7921_regd_ww);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(mt7921_regd_update);
> +
>  static bool
>  mt7921_regd_is_valid_alpha2(const char *alpha2)
>  {
> @@ -183,7 +346,9 @@ int mt7921_regd_change(struct mt792x_phy *phy, char *=
alpha2)
>  	if (!memcmp(alpha2, mdev->alpha2, 2))
>  		return 0;
> =20
> -	if (phy->chip_cap & MT792x_CHIP_CAP_11D_EN)
> +	if (MT7921_REGD_SUPPORTED(phy))
> +		return mt7921_regd_update(phy, alpha2);
> +	else if (phy->chip_cap & MT792x_CHIP_CAP_11D_EN)
>  		return regulatory_hint(wiphy, alpha2);
>  	else
>  		return mt7921_mcu_set_clc(dev, alpha2, ENVIRON_INDOOR);
> @@ -197,7 +362,11 @@ int mt7921_regd_init(struct mt792x_phy *phy)
>  	struct mt792x_dev *dev =3D mt792x_hw_dev(hw);
>  	struct mt76_dev *mdev =3D &dev->mt76;
> =20
> -	if (phy->chip_cap & MT792x_CHIP_CAP_11D_EN)
> +	if (MT7921_REGD_SUPPORTED(phy)) {
> +		wiphy->regulatory_flags |=3D REGULATORY_WIPHY_SELF_MANAGED |
> +					   REGULATORY_DISABLE_BEACON_HINTS;
> +		return mt7921_regd_update(phy, "00");
> +	} else if (phy->chip_cap & MT792x_CHIP_CAP_11D_EN)
>  		wiphy->regulatory_flags |=3D REGULATORY_COUNTRY_IE_IGNORE |
>  					   REGULATORY_DISABLE_BEACON_HINTS;
>  	else
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regd.h b/drivers/n=
et/wireless/mediatek/mt76/mt7921/regd.h
> index 571f31629e9e..c1e94cd4c958 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/regd.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/regd.h
> @@ -4,9 +4,57 @@
>  #ifndef __MT7921_REGD_H
>  #define __MT7921_REGD_H
> =20
> -struct mt792x_dev;
> -struct wiphy;
> -struct regulatory_request;
> +#include "mt7921.h"
> +
> +struct mt7921_regd_rule_header {
> +	u8 alpha2[2];
> +	u8 dfs_region;
> +	u8 rsv[13];
> +};
> +
> +struct mt7921_regd_rule {
> +	u32 start_freq;
> +	u32 end_freq;
> +	u32 max_bw;
> +	u32 eirp;
> +	u32 flags;
> +	u8 rsv[12];
> +};
> +
> +struct mt7921_regd_cc {
> +	u8 alpha2[2];
> +	u8 ver;
> +	u8 rsv;
> +	__le32 n_reg_rules;
> +	u8 sign_type;
> +	u8 rsv1[7];
> +	u8 data[];
> +};
> +
> +struct mt7921_regd_rule_ev {
> +	__le16 tag;
> +	__le16 len;
> +	__le32 n_reg_rules;
> +	u8 dfs_region;
> +	u8 rsv[15];
> +	struct mt7921_regd_rule reg_rule[];
> +};
> +
> +struct mt7921_regd_query_req {
> +	u8 ver;
> +	u8 sign_type;
> +	u8 rsv1[2];
> +	__le32 size;
> +	u8 alpha2[2];
> +	u8 rsv2[2];
> +	__le32 n_reg_rules;
> +	u8 rsv3[64];
> +	u8 data[];
> +};
> +
> +#define MT7921_REGD_SUPPORTED(phy) \
> +	(((phy)->chip_cap & MT792x_CHIP_CAP_REGD_EN) && \
> +	(phy)->clc[MT792x_CLC_REGD])
> =20
>  int mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
>  			   enum environment_cap country_ie_env);
> @@ -15,5 +63,6 @@ void mt7921_regd_notifier(struct wiphy *wiphy,
>  bool mt7921_regd_clc_supported(struct mt792x_dev *dev);
>  int mt7921_regd_change(struct mt792x_phy *phy, char *alpha2);
>  int mt7921_regd_init(struct mt792x_phy *phy);
> +int mt7921_regd_update(struct mt792x_phy *phy, char *alpha2);
> =20
>  #endif
> --=20
> 2.18.0
>=20
