Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754273;
	b=XAS3D1AJR2SOzZKwpFxRaTEQb59enDa3eqw477KKxK9JvuriypO5gVhAL/6CQJ0AHYBi
	 DNO8/wRdlImrZzOikM48QwBfmgOJkc9LXRv76WWo9oz7TQ6Br1Sy6uZU2nhItNTVqdN1i
	 DgKtYBTrwhDmq5AzSJUvKqvgTwMPdiWAfaVe8KMV734nghhbFueAT4NmM0fWcNRQ174oQ
	 fzg7NZDwOiOGyhRvl6wrhyE9NVu3jJBt8kduXg5jxnzzKW01bXFlx3U0rRG5e8lTbCyAo
	 ud3G/LJiCSYKsFzqLu9fZgy+iCBo0wMjUXDvk/tX4oyxsDTX1tZs/lhgxUEDxuFUpYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754273;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=c45SArBd5DoZfdDUNNo57bk1/aYynoTINzHZ1iwXs50=;
	b=iM0tRT4Q/SdNcaxyEnge2nzkXGq6B3FoTGq2y85dRA+jiZ+HH4mGwkom3RPsv893oeDq
	 diaNxo/63xPBgB4WrrPMV2vA56fI4GgXjxpAtuuDKEWmgNYrWNoB5B0WVztJ6tPzLOtXE
	 T9t8NF46up9Hh6tqxiEP+CnH4CFThBeg3SVxV8L/TrtrFW8B2TYDbxUDni9TM2Jt2GNeo
	 jCPTwH5Jd1tySS2VMwuo4r9twldkCxJ3CuvdLtaIPkoK+jUWyA62O5Kzmj2bCYantM1cZ
	 6vfoei6iQIEnNFGjb+H3w2xff/0DiR8HFr321Qax9UERxUCH1x6aNXl3C8BvfJylD4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Pu1wcneK;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1D5606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:17:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E1D5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Pu1wcneK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792754271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c45SArBd5DoZfdDUNNo57bk1/aYynoTINzHZ1iwXs50=;
	b=Pu1wcneK+IdYEzQzzz4CHY0JHaZdyMu/yKj36MwwucbQf2LKIy9F0gsBJspimtcRD4L3aR
	L3z+9Vlx9XOpOtXjbqIpAom60kr0ZQccSB1LL/r3IgrMbJaVJFJ5QHwdCcz2vlvoca+DNI
	XokDcb+XNdV7kSto5R/e9Knkw0OS6Ow=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-A8lNw8V1NkCYnH1MqKwcgg-1; Fri,
 23 Oct 2026 07:17:41 -0400
X-MC-Unique: A8lNw8V1NkCYnH1MqKwcgg-1
X-Mimecast-MFC-AGG-ID: A8lNw8V1NkCYnH1MqKwcgg_1792754260
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58F2D19540CF;
	Fri, 23 Oct 2026 11:17:40 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF6C31800495;
	Fri, 23 Oct 2026 11:17:38 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: miri.korenblit@intel.com,
	johannes@sipsolutions.net,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: iwlwifi: AX210 firmware ADVANCED_SYSASSERT 0x2010120E on MAC_CONFIG_CMD with ty-a0-gf-a0-89
Date: Fri, 23 Oct 2026 13:17:30 +0200
Message-ID: <20261023111730.481392-1-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi,

I am experiencing a reproducible firmware crash on Intel AX210 with the
latest available firmware (89.b20dcd1f.0 ty-a0-gf-a0-89.ucode). The same
kernel and firmware API version works fine with AX211.

Hardware/Software:
- Device: Intel Wi-Fi 6E AX210 160MHz (PCI dev 2725/0020, rev=0x420,
  rfid=0x10d000)
- Firmware: 89.b20dcd1f.0 ty-a0-gf-a0-89.ucode (latest from
  linux-firmware)
- Kernel: 7.2.11-200.fc44.x86_64 (Fedora 44)

Last known working configuration:
- Fedora 38, kernel 6.8.9-100.fc38.x86_64
- Firmware: 86.fb5c9aeb.0 ty-a0-gf-a0-86.ucode

Problem description:

The AX210 successfully loads firmware 89 and boots. Association with an
AP completes normally. However, when NetworkManager assigns an IPv4
address, the ieee80211_ifa_changed notifier triggers a MAC_CONFIG_CMD
(action:2) update, and the firmware hits ADVANCED_SYSASSERT.

The firmware crash also occurs during authentication in some connection
attempts.

AX211 with the same kernel and firmware API 89 works without any issues,
which points to a bug specific to the ty-a0-gf-a0-89 firmware image.

I have tried to set IWL_AX210_UCODE_API_MAX and IWL_AX210_UCODE_API_MIN to
86 to test with the old firmware, but firmware 86 (used by Fedora 38) does
not work with the new kernel (API incompatibility, expected), confirming
the driver requires API 89 features.

Firmware assert details (Fedora 44):
[   10.188120] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   10.188201] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
[   10.240973] iwlwifi 0000:07:00.0: Detected crf-id 0x400410, cnv-id 0x400410 wfpm id 0x80000000
[   10.240982] iwlwifi 0000:07:00.0: PCI dev 2725/0020, rev=0x420, rfid=0x10d000
[   10.240984] iwlwifi 0000:07:00.0: Detected Intel(R) Wi-Fi 6E AX210 160MHz
[   10.274560] iwlwifi 0000:07:00.0: loaded firmware version 89.b20dcd1f.0 ty-a0-gf-a0-89.ucode op_mode iwlmvm
[   10.364043] lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
[   10.367776] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   10.367976] i2c i2c-0: Memory type 0x07 not supported yet, not instantiating SPD
[   10.412996] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
[   10.419047] iTCO_wdt iTCO_wdt.1.auto: Found a ICH9 TCO device (Version=2, TCOBASE=0x0660)
[   10.419602] iTCO_wdt iTCO_wdt.1.auto: initialized. heartbeat=30 sec (nowayout=0)
[   10.559190] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[   10.559204] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[   10.559262] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[   10.559273] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[   10.559294] iwlwifi 0000:07:00.0: Detected RF GF, rfid=0x10d000
[   10.644173] iwlwifi 0000:07:00.0: base HW address: 98:8d:46:ee:77:f3
[   10.670920] iwlwifi 0000:07:00.0 wlp7s0: renamed from wlan0
[   10.783488] EXT4-fs (vda2): mounted filesystem c74cc6c8-0b85-45dc-b3f6-bdf439e6c8c5 r/w with ordered data mode. Quota mode: none.
[   11.001051] NET: Registered PF_QIPCRTR protocol family
[   11.146407] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[   11.146419] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[   11.146434] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[   11.146466] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[   11.416100] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[   11.416115] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[   11.416124] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[   11.416132] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  225.714141] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  225.714155] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  225.714164] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[  225.714177] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  228.971637] wlp7s0: authenticate with 00:0c:43:26:60:20 (local address=98:8d:46:ee:77:f3)
[  228.972537] wlp7s0: send auth to 00:0c:43:26:60:20 (try 1/3)
[  229.007657] wlp7s0: authenticate with 00:0c:43:26:60:20 (local address=98:8d:46:ee:77:f3)
[  229.007663] wlp7s0: send auth to 00:0c:43:26:60:20 (try 1/3)
[  229.009167] wlp7s0: authenticated
[  229.009398] wlp7s0: associate with 00:0c:43:26:60:20 (try 1/3)
[  229.013648] wlp7s0: RX AssocResp from 00:0c:43:26:60:20 (capab=0x11 status=0 aid=1)
[  229.017486] wlp7s0: associated
[  229.212442] iwlwifi 0000:07:00.0: Microcode SW error detected. Restarting 0x0.
[  229.212507] iwlwifi 0000:07:00.0: Start IWL Error Log Dump:
[  229.212508] iwlwifi 0000:07:00.0: Transport status: 0x0000004B, valid: 6
[  229.212509] iwlwifi 0000:07:00.0: Loaded firmware version: 89.b20dcd1f.0 ty-a0-gf-a0-89.ucode
[  229.212510] iwlwifi 0000:07:00.0: 0x00000071 | NMI_INTERRUPT_UMAC_FATAL    
[  229.212511] iwlwifi 0000:07:00.0: 0x004D0902 | interruptlink2
[  229.212511] iwlwifi 0000:07:00.0: 0x0000C228 | data1
[  229.212512] iwlwifi 0000:07:00.0: 0x00000010 | data2
[  229.212513] iwlwifi 0000:07:00.0: 0x00000000 | data3
[  229.212537] iwlwifi 0000:07:00.0: Start IWL Error Log Dump:
[  229.212537] iwlwifi 0000:07:00.0: Transport status: 0x0000004B, valid: 7
[  229.212538] iwlwifi 0000:07:00.0: 0x2010120E | ADVANCED_SYSASSERT
[  229.212539] iwlwifi 0000:07:00.0: 0x00000000 | umac interruptlink2
[  229.212539] iwlwifi 0000:07:00.0: 0x00000400 | umac data1
[  229.212540] iwlwifi 0000:07:00.0: 0x00000004 | umac data2
[  229.212541] iwlwifi 0000:07:00.0: 0x00000001 | umac data3
[  229.212541] iwlwifi 0000:07:00.0: 0x00610517 | last host cmd
[  229.212549] iwlwifi 0000:07:00.0: IML/ROM dump:
[  229.212549] iwlwifi 0000:07:00.0: 0x00000B03 | IML/ROM error/state
[  229.212557] iwlwifi 0000:07:00.0: 0x00007EF6 | IML/ROM data1
[  229.212565] iwlwifi 0000:07:00.0: 0x00000090 | IML/ROM WFPM_AUTH_KEY_0
[  229.212569] iwlwifi 0000:07:00.0: Fseq Registers:
[  229.212572] iwlwifi 0000:07:00.0: 0x60000000 | FSEQ_ERROR_CODE
[  229.212574] iwlwifi 0000:07:00.0: 0x80440007 | FSEQ_TOP_INIT_VERSION
[  229.212577] iwlwifi 0000:07:00.0: 0x00080009 | FSEQ_CNVIO_INIT_VERSION
[  229.212579] iwlwifi 0000:07:00.0: 0x0000A652 | FSEQ_OTP_VERSION
[  229.212581] iwlwifi 0000:07:00.0: 0x00000002 | FSEQ_TOP_CONTENT_VERSION
[  229.212584] iwlwifi 0000:07:00.0: 0x4552414E | FSEQ_ALIVE_TOKEN
[  229.212586] iwlwifi 0000:07:00.0: 0x00400410 | FSEQ_CNVI_ID
[  229.212589] iwlwifi 0000:07:00.0: 0x00400410 | FSEQ_CNVR_ID
[  229.212591] iwlwifi 0000:07:00.0: 0x00400410 | CNVI_AUX_MISC_CHIP
[  229.212596] iwlwifi 0000:07:00.0: 0x00400410 | CNVR_AUX_MISC_CHIP
[  229.212600] iwlwifi 0000:07:00.0: 0x00009061 | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
[  229.212605] iwlwifi 0000:07:00.0: 0x00000061 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
[  229.212607] iwlwifi 0000:07:00.0: 0x00080009 | FSEQ_PREV_CNVIO_INIT_VERSION
[  229.212613] iwlwifi 0000:07:00.0: 0x00440007 | FSEQ_WIFI_FSEQ_VERSION
[  229.212616] iwlwifi 0000:07:00.0: 0x7AF0825B | FSEQ_BT_FSEQ_VERSION
[  229.212618] iwlwifi 0000:07:00.0: 0x0000006E | FSEQ_CLASS_TP_VERSION
[  229.212626] iwlwifi 0000:07:00.0: UMAC CURRENT PC: 0x804a5bf0
[  229.212629] iwlwifi 0000:07:00.0: LMAC1 CURRENT PC: 0xd0
[  229.212644] iwlwifi 0000:07:00.0: FW error in SYNC CMD MAC_CONFIG_CMD
[  229.212652] CPU: 1 UID: 0 PID: 878 Comm: NetworkManager Not tainted 7.2.11-200.fc44.x86_64 #1 PREEMPT(lazy) 
[  229.212654] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.3-6.el9 11/05/2023
[  229.212657] Call Trace:
[  229.212662]  <TASK>
[  229.212663]  dump_stack_lvl+0x5d/0x80
[  229.212677]  iwl_trans_pcie_send_hcmd_sync+0x3ae/0x3c0 [iwlwifi]
[  229.212691]  ? __pfx_autoremove_wake_function+0x10/0x10
[  229.212695]  iwl_trans_send_cmd+0x40/0xa0 [iwlwifi]
[  229.212708]  iwl_mvm_send_cmd_pdu+0x77/0xc0 [iwlmvm]
[  229.212723]  iwl_mvm_mld_mac_ctxt_cmd_sta+0xee/0x1b0 [iwlmvm]
[  229.212735]  ? fib_magic+0x14f/0x180
[  229.212738]  iwl_mvm_mld_vif_cfg_changed_station+0x35/0x370 [iwlmvm]
[  229.212747]  ? neigh_lookup+0xdc/0x110
[  229.212753]  iwl_mvm_mld_vif_cfg_changed+0x5a/0x80 [iwlmvm]
[  229.212761]  ieee80211_vif_cfg_change_notify+0xda/0x1c0 [mac80211]
[  229.212801]  ieee80211_ifa_changed+0xe3/0x120 [mac80211]
[  229.212829]  notifier_call_chain+0x70/0x110
[  229.212834]  blocking_notifier_call_chain+0x40/0x60
[  229.212836]  __inet_insert_ifa+0x21b/0x2c0
[  229.212841]  inet_rtm_newaddr+0x3f3/0x490
[  229.212842]  ? __pfx_inet_rtm_newaddr+0x10/0x10
[  229.212844]  ? ns_capable+0x2e/0x50
[  229.212847]  rtnetlink_rcv_msg+0x3d5/0x4d0
[  229.212849]  ? avc_has_perm+0x59/0xf0
[  229.212855]  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
[  229.212856]  netlink_rcv_skb+0xcd/0x150
[  229.212858]  netlink_unicast+0x29e/0x3d0
[  229.212859]  netlink_sendmsg+0x21f/0x470
[  229.212861]  ____sys_sendmsg+0x39c/0x3d0
[  229.212865]  ? import_iovec+0x1b/0x30
[  229.212869]  ___sys_sendmsg+0xe1/0x130
[  229.212872]  __sys_sendmsg+0xa4/0x100
[  229.212874]  do_syscall_64+0xe2/0x570
[  229.212880]  ? __sys_recvmsg+0xe2/0x100
[  229.212881]  ? do_syscall_64+0x11f/0x570
[  229.212883]  ? __x64_sys_close+0x47/0xa0
[  229.212889]  ? ksys_write+0xdd/0x110
[  229.212891]  ? do_syscall_64+0x11f/0x570
[  229.212891]  ? do_syscall_64+0x11f/0x570
[  229.212892]  ? do_syscall_64+0x11f/0x570
[  229.212893]  ? do_syscall_64+0x99/0x570
[  229.212894]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  229.212898] RIP: 0033:0x7fba44882352
[  229.212902] Code: 08 0f 85 51 41 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 55 bf 01 00
[  229.212903] RSP: 002b:00007ffc955cd798 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  229.212906] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fba44882352
[  229.212906] RDX: 0000000000000000 RSI: 00007ffc955cd820 RDI: 000000000000000d
[  229.212907] RBP: 00007ffc955cd7c0 R08: 0000000000000000 R09: 0000000000000000
[  229.212907] R10: 0000000000000000 R11: 0000000000000246 R12: 00005592ae27a820
[  229.212908] R13: 0000000000000000 R14: 000000000000006f R15: 00007ffc955cd9a4
[  229.212909]  </TASK>
[  229.212910] iwlwifi 0000:07:00.0: Failed to send MAC_CONFIG_CMD (action:2): -5
[  229.212913] iwlwifi 0000:07:00.0: failed to update MAC 98:8d:46:ee:77:f3
[  229.212925] iwlwifi 0000:07:00.0: WRT: Collecting data: ini trigger 4 fired (delay=0ms).
[  229.614806] iwlwifi 0000:07:00.0: Device error - SW reset
[  229.614811] iwlwifi 0000:07:00.0: mcast filter cmd error. ret=-5
[  229.614815] iwlwifi 0000:07:00.0: Failed to synchronize multicast groups update
[  229.614820] iwlwifi 0000:07:00.0: mcast filter cmd error. ret=-5
[  229.614821] iwlwifi 0000:07:00.0: Failed to synchronize multicast groups update
[  229.614901] ieee80211 phy0: Hardware restart was requested
[  229.790426] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  229.790438] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  229.790446] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[  229.790455] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  229.886173] iwlwifi 0000:07:00.0: restart completed
[  230.101199] iwlwifi 0000:07:00.0: Microcode SW error detected. Restarting 0x0.
[  230.101282] iwlwifi 0000:07:00.0: Start IWL Error Log Dump:
[  230.101306] iwlwifi 0000:07:00.0: Transport status: 0x0000004A, valid: 6
[  230.101308] iwlwifi 0000:07:00.0: Loaded firmware version: 89.b20dcd1f.0 ty-a0-gf-a0-89.ucode
[  230.101310] iwlwifi 0000:07:00.0: 0x00000071 | NMI_INTERRUPT_UMAC_FATAL    
[  230.101311] iwlwifi 0000:07:00.0: 0x004D0902 | interruptlink2
[  230.101312] iwlwifi 0000:07:00.0: 0x0000C228 | data1
[  230.101313] iwlwifi 0000:07:00.0: 0x00000010 | data2
[  230.101314] iwlwifi 0000:07:00.0: 0x00000000 | data3
[  230.101480] iwlwifi 0000:07:00.0: Start IWL Error Log Dump:
[  230.101485] iwlwifi 0000:07:00.0: Transport status: 0x0000004A, valid: 7
[  230.101487] iwlwifi 0000:07:00.0: 0x2010120E | ADVANCED_SYSASSERT
[  230.101488] iwlwifi 0000:07:00.0: 0x00000000 | umac interruptlink2
[  230.101489] iwlwifi 0000:07:00.0: 0x00000400 | umac data1
[  230.101489] iwlwifi 0000:07:00.0: 0x00000004 | umac data2
[  230.101490] iwlwifi 0000:07:00.0: 0x00000001 | umac data3
[  230.101490] iwlwifi 0000:07:00.0: 0x0045020F | last host cmd
[  230.101498] iwlwifi 0000:07:00.0: IML/ROM dump:
[  230.101499] iwlwifi 0000:07:00.0: 0x00000B03 | IML/ROM error/state
[  230.101509] iwlwifi 0000:07:00.0: 0x00007EF5 | IML/ROM data1
[  230.101517] iwlwifi 0000:07:00.0: 0x00000090 | IML/ROM WFPM_AUTH_KEY_0
[  230.101521] iwlwifi 0000:07:00.0: Fseq Registers:
[  230.101524] iwlwifi 0000:07:00.0: 0x60000000 | FSEQ_ERROR_CODE
[  230.101526] iwlwifi 0000:07:00.0: 0x80440007 | FSEQ_TOP_INIT_VERSION
[  230.101529] iwlwifi 0000:07:00.0: 0x00080009 | FSEQ_CNVIO_INIT_VERSION
[  230.101531] iwlwifi 0000:07:00.0: 0x0000A652 | FSEQ_OTP_VERSION
[  230.101534] iwlwifi 0000:07:00.0: 0x00000002 | FSEQ_TOP_CONTENT_VERSION
[  230.101536] iwlwifi 0000:07:00.0: 0x4552414E | FSEQ_ALIVE_TOKEN
[  230.101539] iwlwifi 0000:07:00.0: 0x00400410 | FSEQ_CNVI_ID
[  230.101541] iwlwifi 0000:07:00.0: 0x00400410 | FSEQ_CNVR_ID
[  230.101544] iwlwifi 0000:07:00.0: 0x00400410 | CNVI_AUX_MISC_CHIP
[  230.101548] iwlwifi 0000:07:00.0: 0x00400410 | CNVR_AUX_MISC_CHIP
[  230.101553] iwlwifi 0000:07:00.0: 0x00009061 | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
[  230.101557] iwlwifi 0000:07:00.0: 0x00000061 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
[  230.101560] iwlwifi 0000:07:00.0: 0x00080009 | FSEQ_PREV_CNVIO_INIT_VERSION
[  230.101562] iwlwifi 0000:07:00.0: 0x00440007 | FSEQ_WIFI_FSEQ_VERSION
[  230.101565] iwlwifi 0000:07:00.0: 0x7AF0825B | FSEQ_BT_FSEQ_VERSION
[  230.101567] iwlwifi 0000:07:00.0: 0x0000006E | FSEQ_CLASS_TP_VERSION
[  230.101577] iwlwifi 0000:07:00.0: UMAC CURRENT PC: 0x804a5bf0
[  230.101587] iwlwifi 0000:07:00.0: LMAC1 CURRENT PC: 0xd0
[  230.101622] iwlwifi 0000:07:00.0: WRT: Collecting data: ini trigger 4 fired (delay=0ms).
[  230.499195] iwlwifi 0000:07:00.0: Device error - reprobe!
[  230.502471] iwlwifi 0000:07:00.0: LED command failed: -5
[  230.502487] iwlwifi 0000:07:00.0: LED command failed: -5
[  230.508407] wlp7s0: deauthenticating from 00:0c:43:26:60:20 by local choice (Reason: 3=DEAUTH_LEAVING)
[  230.508429] iwlwifi 0000:07:00.0: Failed to send flush command (-5)
[  230.508434] iwlwifi 0000:07:00.0: flush request fail
[  230.508445] iwlwifi 0000:07:00.0: Failed to send MAC_CONFIG_CMD (action:2): -5
[  230.508446] iwlwifi 0000:07:00.0: failed to update MAC 98:8d:46:ee:77:f3
[  230.508447] iwlwifi 0000:07:00.0: Failed to synchronize multicast groups update
[  230.508450] iwlwifi 0000:07:00.0: Failed to send LINK_CONFIG_CMD (action:2): -5
[  230.508450] iwlwifi 0000:07:00.0: failed to update link
[  230.508451] iwlwifi 0000:07:00.0: Failed to send MAC_CONFIG_CMD (action:2): -5
[  230.508452] iwlwifi 0000:07:00.0: failed to update MAC 98:8d:46:ee:77:f3
[  230.508453] iwlwifi 0000:07:00.0: failed to update power mode
[  230.508455] iwlwifi 0000:07:00.0: Failed to trigger RX queues sync (-5)
[  230.508468] iwlwifi 0000:07:00.0: Failed to send flush command (-5)
[  230.508469] iwlwifi 0000:07:00.0: flush request fail
[  230.508471] iwlwifi 0000:07:00.0: Failed to send rate scale config (-5)
[  230.508478] wlp7s0: failed to remove key (0, 00:0c:43:26:60:20) from hardware (-5)
[  230.508497] iwlwifi 0000:07:00.0: Failed to send flush command (-5)
[  230.508521] iwlwifi 0000:07:00.0: Failed to send LINK_CONFIG_CMD (action:2): -5
[  230.508522] iwlwifi 0000:07:00.0: Failed to send LINK_CONFIG_CMD (action:3): -5
[  230.508523] iwlwifi 0000:07:00.0: Failed to send LINK_CONFIG_CMD (action:1): -5
[  230.508525] iwlwifi 0000:07:00.0: PHY ctxt cmd error. ret=-5
[  230.508531] wlp7s0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-5)
[  230.508651] wlp7s0: failed to remove key (5, ff:ff:ff:ff:ff:ff) from hardware (-5)
[  230.510973] iwlwifi 0000:07:00.0: Failed to send LINK_CONFIG_CMD (action:3): -5
[  230.510976] iwlwifi 0000:07:00.0: Failed to send MAC_CONFIG_CMD (action:3): -5
[  230.510977] iwlwifi 0000:07:00.0: Failed to synchronize multicast groups update
[  230.518440] iwlwifi 0000:07:00.0: Failed to send LINK_CONFIG_CMD (action:3): -5
[  230.518442] iwlwifi 0000:07:00.0: Failed to send MAC_CONFIG_CMD (action:3): -5
[  230.606339] iwlwifi 0000:07:00.0: Detected crf-id 0x400410, cnv-id 0x400410 wfpm id 0x80000000
[  230.606346] iwlwifi 0000:07:00.0: PCI dev 2725/0020, rev=0x420, rfid=0x10d000
[  230.606348] iwlwifi 0000:07:00.0: Detected Intel(R) Wi-Fi 6E AX210 160MHz
[  230.633852] iwlwifi 0000:07:00.0: loaded firmware version 89.b20dcd1f.0 ty-a0-gf-a0-89.ucode op_mode iwlmvm
[  230.796050] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  230.796063] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  230.796073] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[  230.796081] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  230.796110] iwlwifi 0000:07:00.0: Detected RF GF, rfid=0x10d000
[  230.881173] iwlwifi 0000:07:00.0: base HW address: 98:8d:46:ee:77:f3
[  230.902736] iwlwifi 0000:07:00.0 wlp7s0: renamed from wlan0
[  231.067475] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  231.067487] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  231.067496] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[  231.067506] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  231.337245] iwlwifi 0000:07:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  231.337273] iwlwifi 0000:07:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  231.337281] iwlwifi 0000:07:00.0: WFPM_AUTH_KEY_0: 0x90
[  231.337295] iwlwifi 0000:07:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0

After the first crash, the driver attempts HW restart. The restart
itself also hits ADVANCED_SYSASSERT, leading to a reprobe.

Please, is there any solution or could the ty-a0-gf-a0-89 firmware image
be fixed?

Thanks

Best regards
Jose Ignacio

