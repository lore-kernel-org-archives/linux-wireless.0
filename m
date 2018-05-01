Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:56414 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbeEAPvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 11:51:52 -0400
Received: from homiemail-a108.g.dreamhost.com (sub4.mail.dreamhost.com [69.163.253.135])
        by hapkido.dreamhost.com (Postfix) with ESMTP id DA4638F21D
        for <linux-wireless@vger.kernel.org>; Tue,  1 May 2018 08:51:51 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Stephen Wille Padnos <steve@thothsystems.com>
Subject: Patch: Support Killer 1550 in MSI laptop
Cc: Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Message-ID: <3e72561c-c531-95c3-5fc8-b195ce8dae4b@thothsystems.com> (sfid-20180501_175156_151182_EECA75E1)
Date: Tue, 1 May 2018 11:51:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, all

I have an MSI 8th-gen notebook with a Killer 1550 wifi card.=C2=A0 This c=
ard=20
has a different subsystem ID than I have seen in prior patches:

Output of lspci -nnvvv:
00:14.3 Network controller [0280]: Intel Corporation Wireless-AC 9560=20
[Jefferson Peak] [8086:a370] (rev 10)
 =C2=A0=C2=A0 =C2=A0Subsystem: Bigfoot Networks, Inc. Device [1a56:1552]
 =C2=A0=C2=A0 =C2=A0Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGA=
Snoop- ParErr-=20
Stepping- SERR- FastB2B- DisINTx+
 =C2=A0=C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfa=
st >TAbort-=20
<TAbort- <MAbort- >SERR- <PERR- INTx-
 =C2=A0=C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
 =C2=A0=C2=A0 =C2=A0Interrupt: pin A routed to IRQ 16
 =C2=A0=C2=A0 =C2=A0Region 0: Memory at ad414000 (64-bit, non-prefetchabl=
e) [size=3D16K]
 =C2=A0=C2=A0 =C2=A0Capabilities: <access denied>
 =C2=A0=C2=A0 =C2=A0Kernel driver in use: iwlwifi
 =C2=A0=C2=A0 =C2=A0Kernel modules: iwlwifi

Without this patch no driver is shown, not even pci_stub. This has been=20
tested on my laptop, and only on my home wifi which is wireless-N, not=20
-AC (no 5GHz).=C2=A0 The speed seems to be slower than the Windows driver=
,=20
but at least this gets the device recognized and working.

Signed-off-by: Stephen Wille Padnos

---

diff --git a/drv.c.orig b/drv.c
index ccd7c33..8920169 100644
--- a/drv.c.orig
+++ b/drv.c
@@ -648,6 +648,7 @@ static const struct pci_device_id iwl_hw_card_ids[] =3D=
 {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x02A=
0, iwl9462_2ac_cfg_soc)},
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x02A=
4, iwl9462_2ac_cfg_soc)},
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x103=
0, iwl9560_2ac_cfg_soc)},
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x1552, iwl=
9560_2ac_cfg_soc)},
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x403=
0, iwl9560_2ac_cfg_soc)},
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x403=
4, iwl9560_2ac_cfg_soc)},
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {IWL_PCI_DEVICE(0xA370, 0x40A=
4, iwl9462_2ac_cfg_soc)},
