Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653D2399342;
	Sun, 13 Sep 2026 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789288543; cv=none; b=Y428uj/poxdXBDHqHgMuuMrXQ5yrPlvqpfu5DSWk0snNP/0q6zqGenTsVSxv914kocMfoYhQdRgD0hr79MN2avH+EVi+wYUKc7EeeC+qomX1wlKWD47hoqVX57DGRnhKzRWkzWx2X5U4EOV8veBq/LK3W6o4mIBKhrvglLW5UDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789288543; c=relaxed/simple;
	bh=SXaQoDkoAX1LD/TuLgAl7Pco0PKvCaIn0RvsB2+GLiY=;
	h=Date:Message-ID:From:To:Cc:Subject:MIME-Version:Content-Type; b=Docl1x59rruQayTEtxakAEDiN6bv1pPE29IMjCm8ZVzDt1K6kYRV6iosQ3b6oTUyekzhqOUJKZ/swnW1on+5A0qJWzcnaRmkSEGYB9+2WHiXtfVN6JuN4Gr/j4GYzb53Vg89uTIsK1dSlUc7eZoYRKwVMR0srm9XxtJgSKjKYNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VkxX4IKi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hN4nobvc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rotyr64i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CIgm273t; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VkxX4IKi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hN4nobvc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rotyr64i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CIgm273t"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3BDE321D80;
	Sun, 13 Sep 2026 08:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789288532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=UJfrU1s6y9kniljNgkDsZApuFldQn/hOSpGIzKMxMQ8=;
	b=VkxX4IKiMY/kkuTlJGOzUDHeJo4AybQgqM4WZM6H08CQJDhax6d1D4OdpzQWJwpul6puau
	B4xDHbq7xWzlEUqcBGNLeqzf3CeWEQM/d16Nnyio0iNBdHSOkUi79LUZI+AgQ4W7zwgoBg
	dHnQxX4LDkaGxriFB7im6jhwXVpR3SY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789288532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=UJfrU1s6y9kniljNgkDsZApuFldQn/hOSpGIzKMxMQ8=;
	b=hN4nobvcqFfMupJ7uBg/6BS0/P5WHyVoBuiFQdCsGsi69H85CTt4wJjHTZTy4D9vJFlHrX
	czOfKEDqQG5kqLDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rotyr64i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CIgm273t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789288528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=UJfrU1s6y9kniljNgkDsZApuFldQn/hOSpGIzKMxMQ8=;
	b=rotyr64i1a3eX117TXczc9TXtoPAn3zY0hnT78ImsFlR3dJh6TtvzccgEdl7WnFk81GBz3
	Z7qIpg8c32rXBAug8300KogMptyPN+qNmI8ZDYyCriFOBervYka0J6Fykq+Y/Q1zmjOezv
	8MlasbatJJSv67ukn3u5Q/NUw6X8+EE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789288528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=UJfrU1s6y9kniljNgkDsZApuFldQn/hOSpGIzKMxMQ8=;
	b=CIgm273tDWWLTUsE2pcxfg1vsPAWeCl7swV4pMo5GCovKU/AGiESJIfNG8wYbFrurmtabK
	62/WoYfGvdX9O7CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D67DC1368C;
	Sun, 13 Sep 2026 08:35:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dLf7Mk9gpmryDgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Sun, 13 Sep 2026 08:35:27 +0000
Date: Sun, 13 Sep 2026 10:35:27 +0200
Message-ID: <87a4plsg4w.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Chris Lew <christopher.lew@oss.qualcomm.com>
Cc: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
    Pranav Mahesh Phansalkar <pranav.phansalkar@oss.qualcomm.com>,
    netdev@vger.kernel.org,
    linux-wireless@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    regressions@lists.linux.dev
Subject: [REGRESSION] ath12k suspend/resume breakage on 7.3-rc2
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: multipart/mixed;
 boundary="Multipart_Sun_Sep_13_10:35:27_2026-1"
X-Spam-Score: -3.51
X-Rspamd-Queue-Id: 3BDE321D80
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

--Multipart_Sun_Sep_13_10:35:27_2026-1
Content-Type: text/plain; charset=US-ASCII

Hi,

on 7.3-rc2, the suspend/resume of ath12k WiFi on Lenovo Thinkpad T14s
Gen6 AMD model is broken.  Upon suspend, the network isn't recovered,
and the desktop got eventually frozen.

The git bisect pointed to the commit
544d85de4dc22c01badfd8cefa59829ce35c4858
    net: qrtr: Send HELLO message on endpoint register

and reverting this fixed the problem.

Below is the (stripped) dmesg output after the resume showing the
problem.

As far as I understand, the problem seems to be the change of the code
flow: ath12k uses mhi_power_down_keep_dev() during suspend, so the
qcom_mhi_qrtr_remove() and *_probe() won't be called.  This makes the
driver endlessly waiting for the HELLO handshake upon resume with the
commit above.


thanks,

Takashi

#regzbot introduced: 544d85de4dc22c01badfd8cefa59829ce35c4858


--Multipart_Sun_Sep_13_10:35:27_2026-1
Content-Type: text/plain; name="ath12-crash.txt"; charset=US-ASCII
Content-Disposition: inline; filename="ath12-crash.txt"
Content-Transfer-Encoding: 7bit

ath12k_wifi7_pci 0000:c2:00.0: BAR 0 [mem 0xb0600000-0xb07fffff 64bit]: assigned
ath12k_wifi7_pci 0000:c2:00.0: enabling device (0000 -> 0002)
ath12k_wifi7_pci 0000:c2:00.0: Wi-Fi 7 Hardware name: wcn7850 hw2.0
ath12k_wifi7_pci 0000:c2:00.0: MSI vectors: 16
(snip)
ath12k_wifi7_pci 0000:c2:00.0: qmi dma allocation failed (7274496 B type 1), will try later with small size
ath12k_wifi7_pci 0000:c2:00.0: chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
ath12k_wifi7_pci 0000:c2:00.0: fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10 fw_build_id QC_IMAGE_VERSION_STRING=WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
ath12k_wifi7_pci 0000:c2:00.0: invalid ACPI DSM TAS config size: 1
ath12k_wifi7_pci 0000:c2:00.0: failed to get ACPI TAS config table: -22
(snip)
ath12k_wifi7_pci 0000:c2:00.0 wlp194s0: renamed from wlan0
....

PM: suspend entry (s2idle)
Filesystems sync: 0.029 seconds
Freezing user space processes
Freezing user space processes completed (elapsed 0.002 seconds)
OOM killer disabled.
Freezing remaining freezable tasks
Freezing remaining freezable tasks completed (elapsed 0.000 seconds)
printk: Suspending console(s) (use no_console_suspend to debug)
....

ath12k_wifi7_pci 0000:c2:00.0: timeout while waiting for restart complete
ath12k_wifi7_pci 0000:c2:00.0: failed to resume core: -110
ath12k_wifi7_pci 0000:c2:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110
ath12k_wifi7_pci 0000:c2:00.0: PM: failed to resume async: error -110
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable dynamic bw: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
------------[ cut here ]------------
Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.
WARNING: net/mac80211/util.c:1957 at ieee80211_reconfig+0x9e/0x1f40 [mac80211], CPU#2: kworker/u65:27/116237
Modules linked in: uas(E) usb_storage(E) sd_mod(E) scsi_dh_emc(E) scsi_dh_rdac(E) scsi_dh_alua(E) sg(E) scsi_mod(E) scsi_common(E) cuse(E) tun(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) rfcomm(E) hid_plantronics(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) af_packet(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ip_set(E) algif_hash(E) algif_skcipher(E) af_alg(E) bnep(E) dm_mod(E) binfmt_misc(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) qrtr_mhi(E) r8153_ecm(E) cdc_ether(E) usbnet(E) snd_acp_legacy_mach(E) snd_acp_mach(E) snd_soc_nau8821(E) snd_acp3x_rn(E) snd_acp70(E) snd_acp_i2s(E) snd_acp_pdm(E) snd_soc_dmic(E) snd_acp_pcm(E) btusb(E) snd_sof_amd_acp70(E) snd_usb_audio(E) snd_sof_amd_acp63(E) btrtl(E) snd_sof_amd_vangogh(E) btintel(E) snd_usbmidi_lib(E) snd_sof_amd_rembrandt(E) snd_ump(E) btbcm(E) r8152(E) snd_sof_amd_renoir(E) btmtk(E) snd_rawmi
 di(E) qrtr(E) mii(E)
 snd_sof_amd_acp(E) snd_seq_device(E) ath12k_wifi7(E) snd_sof_pci(E) bluetooth(E) snd_sof_xtensa_dsp(E) ath12k(E) snd_ctl_led(E) snd_sof(E) intel_rapl_msr(E) intel_rapl_common(E) snd_sof_utils(E) snd_hda_codec_alc269(E) mhi(E) snd_pci_ps(E) snd_hda_scodec_component(E) uvcvideo(E) snd_soc_acpi_amd_match(E) qmi_helpers(E) snd_hda_codec_atihdmi(E) snd_hda_codec_realtek_lib(E) snd_soc_sdca(E) kvm_amd(E) videobuf2_vmalloc(E) snd_hda_codec_generic(E) snd_hda_codec_hdmi(E) snd_soc_core(E) mac80211(E) videobuf2_memops(E) uvc(E) snd_hda_intel(E) videobuf2_v4l2(E) snd_compress(E) kvm(E) snd_hda_codec(E) snd_acp_pci(E) videodev(E) thinkpad_acpi(E) snd_amd_acpi_mach(E) snd_intel_dspcfg(E) spd5118(E) gpio_keys(E) think_lmi(E) irqbypass(E) snd_acp_legacy_common(E) libarc4(E) videobuf2_common(E) snd_hda_core(E) pcspkr(E) mc(E) firmware_attributes_class(E) wmi_bmof(E) battery(E) snd_pci_acp6x(E) sparse_keymap(E) ac(E) snd_hwdep(E) cfg80211(E) snd_pcm(E) snd_pci_acp5x(E) snd_timer(E) snd_rn_pci_acp3x
 (E) fan(E)
 snd_acp_config(E) amd_pmc(E) snd(E) soc_button_array(E) snd_soc_acpi(E) i2c_piix4(E) rfkill(E) joydev(E) k10temp(E) thermal(E) i2c_smbus(E) snd_pci_acp3x(E) soundcore(E) fuse(E) efi_pstore(E) dmi_sysfs(E) ip_tables(E) x_tables(E) ext4(E) mbcache(E) jbd2(E) usbhid(E) amdxdna(E) amdgpu(E) drm_buddy(E) amdxcp(E) i2c_algo_bit(E) drm_ttm_helper(E) ttm(E) drm_exec(E) drm_panel_backlight_quirks(E) drm_suballoc_helper(E) hid_multitouch(E) hid_generic(E) nvme(E) drm_display_helper(E) ucsi_acpi(E) xhci_pci(E) typec_ucsi(E) cec(E) roles(E) nvme_core(E) amd_pmf(E) video(E) xhci_hcd(E) rc_core(E) nvme_keyring(E) amdtee(E) typec(E) aesni_intel(E) gf128mul(E) amd_sfh(E) ccp(E) sp5100_tco(E) usbcore(E) gpu_sched(E) nvme_auth(E) crc16(E) thunderbolt(E) wmi(E) button(E) i2c_hid_acpi(E) tee(E) i2c_hid(E) serio_raw(E) br_netfilter(E) bridge(E) stp(E) llc(E) nf_tables(E) msr(E) i2c_dev(E) efivarfs(E)
Unloaded tainted modules: snd_seq_midi_event(E):1 snd_seq_oss(E):1 [last unloaded: snd_seq_midi_event(E)]
CPU: 2 UID: 0 PID: 116237 Comm: kworker/u65:27 Tainted: G            E       7.3.0-rc2-test2+ #729 PREEMPT(full)  245c2cda426ab8fbe50e1a5e242c600fed149e78
Tainted: [E]=UNSIGNED_MODULE
Hardware name: LENOVO 21M2S03K00/21M2S03K00, BIOS R2NET44W (1.18 ) 01/28/2026
Workqueue: async async_run_entry_fn
RIP: 0010:ieee80211_reconfig+0x9e/0x1f40 [mac80211]
Code: d5 05 00 00 00 4c 89 df 4c 89 1c 24 e8 fb 35 fb ff 4c 8b 1c 24 85 c0 89 c3 0f 84 82 03 00 00 4c 89 1c 24 48 8d 3d 32 8b 1e 00 <67> 48 0f b9 3a 4c 8b 1c 24 eb 3e 84 c0 0f 85 f4 01 00 00 41 c6 83
RSP: 0018:ffffd0ae25a73c58 EFLAGS: 00010286
RAX: 00000000fffffff5 RBX: 00000000fffffff5 RCX: 0000000000000086
RDX: 00000000fffffff5 RSI: 0000000000000086 RDI: ffffffffc26ba360
RBP: ffff8b3604f403e0 R08: 0000000000000000 R09: 3fffffffffff7fff
R10: ffffffff89ade780 R11: ffff8b3604f409c0 R12: ffffffff88b73088
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8b44148c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561dcde865d0 CR3: 0000000f2583a000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? queue_work_node+0xf9/0x110
 ? __async_schedule_node_domain+0xdd/0x140
 ? __pfx_dpm_async_with_cleanup+0x10/0x10
 ? __pfx_async_resume+0x10/0x10
 ? __mutex_lock.constprop.0+0xe1/0x910
 ? async_schedule_dev_nocall+0x8c/0xb0
 wiphy_resume+0x89/0x1a0 [cfg80211 2570b52396ed1f7136cfda569804f3ee76261a22]
 ? __pfx_wiphy_resume+0x10/0x10 [cfg80211 2570b52396ed1f7136cfda569804f3ee76261a22]
 dpm_run_callback+0x4e/0x160
 device_resume+0x1a0/0x2c0
 ? __pfx_dpm_watchdog_handler+0x10/0x10
 ? select_fallback_rq+0x181/0x1e0
 async_resume+0x21/0x30
 async_run_entry_fn+0x36/0x160
 process_one_work+0x1d2/0x3d0
 worker_thread+0x1b7/0x330
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe5/0x120
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2aa/0x340
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
!local->started
WARNING: net/mac80211/driver-ops.c:41 at drv_stop+0xff/0x110 [mac80211], CPU#10: kworker/u65:27/116237
Modules linked in: uas(E) usb_storage(E) sd_mod(E) scsi_dh_emc(E) scsi_dh_rdac(E) scsi_dh_alua(E) sg(E) scsi_mod(E) scsi_common(E) cuse(E) tun(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) rfcomm(E) hid_plantronics(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) af_packet(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ip_set(E) algif_hash(E) algif_skcipher(E) af_alg(E) bnep(E) dm_mod(E) binfmt_misc(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) qrtr_mhi(E) r8153_ecm(E) cdc_ether(E) usbnet(E) snd_acp_legacy_mach(E) snd_acp_mach(E) snd_soc_nau8821(E) snd_acp3x_rn(E) snd_acp70(E) snd_acp_i2s(E) snd_acp_pdm(E) snd_soc_dmic(E) snd_acp_pcm(E) btusb(E) snd_sof_amd_acp70(E) snd_usb_audio(E) snd_sof_amd_acp63(E) btrtl(E) snd_sof_amd_vangogh(E) btintel(E) snd_usbmidi_lib(E) snd_sof_amd_rembrandt(E) snd_ump(E) btbcm(E) r8152(E) snd_sof_amd_renoir(E) btmtk(E) snd_rawmi
 di(E) qrtr(E) mii(E)
 snd_sof_amd_acp(E) snd_seq_device(E) ath12k_wifi7(E) snd_sof_pci(E) bluetooth(E) snd_sof_xtensa_dsp(E) ath12k(E) snd_ctl_led(E) snd_sof(E) intel_rapl_msr(E) intel_rapl_common(E) snd_sof_utils(E) snd_hda_codec_alc269(E) mhi(E) snd_pci_ps(E) snd_hda_scodec_component(E) uvcvideo(E) snd_soc_acpi_amd_match(E) qmi_helpers(E) snd_hda_codec_atihdmi(E) snd_hda_codec_realtek_lib(E) snd_soc_sdca(E) kvm_amd(E) videobuf2_vmalloc(E) snd_hda_codec_generic(E) snd_hda_codec_hdmi(E) snd_soc_core(E) mac80211(E) videobuf2_memops(E) uvc(E) snd_hda_intel(E) videobuf2_v4l2(E) snd_compress(E) kvm(E) snd_hda_codec(E) snd_acp_pci(E) videodev(E) thinkpad_acpi(E) snd_amd_acpi_mach(E) snd_intel_dspcfg(E) spd5118(E) gpio_keys(E) think_lmi(E) irqbypass(E) snd_acp_legacy_common(E) libarc4(E) videobuf2_common(E) snd_hda_core(E) pcspkr(E) mc(E) firmware_attributes_class(E) wmi_bmof(E) battery(E) snd_pci_acp6x(E) sparse_keymap(E) ac(E) snd_hwdep(E) cfg80211(E) snd_pcm(E) snd_pci_acp5x(E) snd_timer(E) snd_rn_pci_acp3x
 (E) fan(E)
 snd_acp_config(E) amd_pmc(E) snd(E) soc_button_array(E) snd_soc_acpi(E) i2c_piix4(E) rfkill(E) joydev(E) k10temp(E) thermal(E) i2c_smbus(E) snd_pci_acp3x(E) soundcore(E) fuse(E) efi_pstore(E) dmi_sysfs(E) ip_tables(E) x_tables(E) ext4(E) mbcache(E) jbd2(E) usbhid(E) amdxdna(E) amdgpu(E) drm_buddy(E) amdxcp(E) i2c_algo_bit(E) drm_ttm_helper(E) ttm(E) drm_exec(E) drm_panel_backlight_quirks(E) drm_suballoc_helper(E) hid_multitouch(E) hid_generic(E) nvme(E) drm_display_helper(E) ucsi_acpi(E) xhci_pci(E) typec_ucsi(E) cec(E) roles(E) nvme_core(E) amd_pmf(E) video(E) xhci_hcd(E) rc_core(E) nvme_keyring(E) amdtee(E) typec(E) aesni_intel(E) gf128mul(E) amd_sfh(E) ccp(E) sp5100_tco(E) usbcore(E) gpu_sched(E) nvme_auth(E) crc16(E) thunderbolt(E) wmi(E) button(E) i2c_hid_acpi(E) tee(E) i2c_hid(E) serio_raw(E) br_netfilter(E) bridge(E) stp(E) llc(E) nf_tables(E) msr(E) i2c_dev(E) efivarfs(E)
Unloaded tainted modules: snd_seq_midi_event(E):1 snd_seq_oss(E):1 [last unloaded: snd_seq_midi_event(E)]
CPU: 10 UID: 0 PID: 116237 Comm: kworker/u65:27 Tainted: G        W   E       7.3.0-rc2-test2+ #729 PREEMPT(full)  245c2cda426ab8fbe50e1a5e242c600fed149e78
Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
Hardware name: LENOVO 21M2S03K00/21M2S03K00, BIOS R2NET44W (1.18 ) 01/28/2026
Workqueue: async async_run_entry_fn
RIP: 0010:drv_stop+0xff/0x110 [mac80211]
Code: 48 8b 05 ac 56 25 00 48 85 c0 74 14 48 8b 78 08 48 89 de 89 54 24 04 e8 af a7 05 00 8b 54 24 04 65 48 ff 45 08 e9 30 ff ff ff <0f> 0b 48 83 c4 08 5b 5d c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 90
RSP: 0018:ffffd0ae25a73b90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8b3604f409c0 RCX: 0000000000000282
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8b3604f409c0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8b35023ce958
R10: ffff8b3604f41328 R11: 0000000000000286 R12: ffff8b3604f409c0
R13: 0000000000000000 R14: 0000000000000001 R15: ffffd0ae25a73bd0
FS:  0000000000000000(0000) GS:ffff8b4414cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d1e3644258 CR3: 0000000f2583a000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? ieee80211_stop_device+0x72/0x80 [mac80211 e18f41d534f84d432ebf007925056aa3424b1586]
 ieee80211_do_stop+0x655/0xa60 [mac80211 e18f41d534f84d432ebf007925056aa3424b1586]
 ? __pfx_wait_rcu_exp_gp+0x10/0x10
 ieee80211_stop+0x62/0xe0 [mac80211 e18f41d534f84d432ebf007925056aa3424b1586]
 __dev_close_many+0xa8/0x1e0
 netif_close_many+0xbc/0x1f0
 netif_close+0x68/0xa0
 dev_close+0x2a/0x80
 cfg80211_shutdown_all_interfaces+0x4f/0x110 [cfg80211 2570b52396ed1f7136cfda569804f3ee76261a22]
 wiphy_resume+0xc2/0x1a0 [cfg80211 2570b52396ed1f7136cfda569804f3ee76261a22]
 ? __pfx_wiphy_resume+0x10/0x10 [cfg80211 2570b52396ed1f7136cfda569804f3ee76261a22]
 dpm_run_callback+0x4e/0x160
 device_resume+0x1a0/0x2c0
 ? __pfx_dpm_watchdog_handler+0x10/0x10
 ? select_fallback_rq+0x181/0x1e0
 async_resume+0x21/0x30
 async_run_entry_fn+0x36/0x160
 process_one_work+0x1d2/0x3d0
 worker_thread+0x1b7/0x330
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe5/0x120
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2aa/0x340
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
---[ end trace 0000000000000000 ]---
ieee80211 phy0: PM: dpm_run_callback(): wiphy_resume [cfg80211] returns -11
ieee80211 phy0: PM: failed to resume async: error -11
OOM killer enabled.
Restarting tasks: Starting
Restarting tasks: Done
efivarfs: resyncing variable state
efivarfs: finished resyncing variable state
random: crng reseeded on system resumption
PM: suspend exit
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11
fbcon: Taking over console
Console: switching to colour frame buffer device 240x75
ath12k_wifi7_pci 0000:c2:00.0: wmi command 16387 timeout
ath12k_wifi7_pci 0000:c2:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath12k_wifi7_pci 0000:c2:00.0: failed to enable PMF QOS: -11
ath12k_wifi7_pci 0000:c2:00.0: fail to start mac operations in pdev idx 0 ret -11

--Multipart_Sun_Sep_13_10:35:27_2026-1--
