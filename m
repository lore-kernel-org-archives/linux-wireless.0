Received: from mx.chud.cyou (chud.cyou [194.238.28.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96054F797D
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 11:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.238.28.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791977126; cv=none; b=dxuXK0HW+gUDfI/JY00/S0ECJIJAuBtacqf+ZrEujXtbjvJKT6JdU6bA3L/ByNxJBRq5kuO8eaDkZiH+g6bdWBhzp0UxeZjrxL4d8o5tegTGq1smE4rnJAAklxBH8SNzwRaNB9H6RB8sfkcprUyekW1XCbtrGogpcMJMRyHzkW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791977126; c=relaxed/simple;
	bh=TznufuVC6c0lmybTUTx3BUEhA5N7lC6fjxsQ9RZmeWo=;
	h=Date:Message-Id:From:To:CC:Subject:Content-Type; b=TbdpmBvyqWZJQaX9faH/9wuNVWklIDPlpY39t9UZa4JZjRVKhz8o/g+DXSxmozDGM2O40GrFvZUGHnuygJ51z4VSPmdo945/6HjAqkYKt+ELmgA+l0jOMTv58jL+fm8nwXrYHvQ7rcTB4ph865TPHiGkIsuvxF5ZN/orI7JgFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chud.cyou; spf=none smtp.mailfrom=chud.cyou; dkim=pass (2048-bit key) header.d=chud.cyou header.i=@chud.cyou header.b=oBeWSMO0; dkim=pass (2048-bit key) header.d=chud.cyou header.i=@chud.cyou header.b=O+WaSXO4; arc=none smtp.client-ip=194.238.28.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chud.cyou
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chud.cyou
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chud.cyou header.i=@chud.cyou header.b="oBeWSMO0";
	dkim=pass (2048-bit key) header.d=chud.cyou header.i=@chud.cyou header.b="O+WaSXO4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=chud.cyou; s=mail;
	t=1791977122; bh=TznufuVC6c0lmybTUTx3BUEhA5N7lC6fjxsQ9RZmeWo=;
	h=Date:From:To:CC:Subject:From;
	b=oBeWSMO0O5JtxGplCepXx01CZBb0h8XVDxauwmHneJB4+oLmEigVumqa8kH6QS782
	 kNzxljxdVQvUB8zl7YNUjnQHAGpUQtPxLRG2ziv4wnVn6vfmXgzHTSpX2KvdZpoKic
	 m+ge2k/9+fsw/fTXFWk4Rt6HePf2/wsZBodIGkLiZXVXRx1uaLd6b4YHIh8qi0QRGD
	 ojtv/fXM9T28x8ZtyVlr1H8VBV2Eps9477gdBHxh0md//UTUz5DAemtOPe2CG9PEY2
	 BZdgSp/tgC0tvlfC93wlvDX2QibKxHiiM6DSp76f1uiCHOTgcd6R9lvAxN7NYjkKit
	 AjNdCqq0eEH3Q==
Recieved: hidden
X-Spam-Level: **
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=chud.cyou; s=mail;
	t=1791977118; bh=TznufuVC6c0lmybTUTx3BUEhA5N7lC6fjxsQ9RZmeWo=;
	h=Date:From:To:CC:Subject:From;
	b=O+WaSXO4DXkIvE5MDjKhJRnSMg92RG1zsStrXzmVe0qFGwhAqX+u5DTiU6paczOkI
	 scvI8U2u5oAi3iU9bdAs4pveLbSs1NNPi5uRqNjTdKNayUylcV8AZm8WWRoF3CGXeJ
	 X86W4f7cq9YQKSrLPqfyQbaXdpl2Wl0+oeJdxzR5lp7hyT9LsCdNQQG544RroJe+EX
	 wUZQ34yQnzwd2lMog1OMHVOMFFGnOhxtvmAfsLR7+SLE9iqUWjmk/dys2P6DjZ2XS5
	 RXMNUBhG+hg/NdFRI6CGEadhEdMQyQE5Y4GvphUp3XqmA6stwpZnFrOZOrFpm4pG5W
	 IYygFrA+fzbaw==
Recieved: hidden
Date: Wed, 14 Oct 2026 11:25:17 +0000
Message-Id: <871p9s34o2.fsf@chud.cyou>
From: Emil Williams <emil@chud.cyou>
To: linux-wireless@vger.kernel.org
CC: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: iwlwifi: AX211 (CNVi 8086:7a70) probe fails with -110 after kexec; PCI remove/rescan recovers
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

--=-=-=
Content-Type: text/plain

Summary: after kexec, iwlwifi probe on 0000:00:14.3 fails with -110.
A clean boot works. Echoing 1 to the device's remove then to
/sys/bus/pci/rescan recovers it without reboot. A PCI reset does not.

I have not tested this on a newer BIOS, it may very well fix this issue,
however that is a hard ask for most and the issue is fixable past boot.

I use the Gentoo kexec OpenRC service for setting up kexec,
which just boots the last kernel used by default.

Bluetooth seems to be available, however I don't use Bluetooth to any extent.


Effective Repeatable Solution:

echo 1 > /sys/bus/pci/devices/0000:00:14.3/remove
echo 1 > /sys/bus/pci/rescan

Note that I ran a reset too (to no apparent change) before the
remove/rescan in the below log.


Kernel (standard and untouched USE flag wise):

6.18.54-gentoo-dist-hardened
sys-kernel/linux-firmware-20260916
(note: older kernel versions in the 6.1x group had the same results)


Hardware:

Board Vendor	: MSI
Board Name	: PRO B760-P WIFI (MS-7D98)
Board Version	: 2.0
BIOS Vendor	: American Megatrends International, LLC.
Bios Version	: A.Q3
BIOS date	: 08/29/2023


Truncated Logs (see dmesg.log attachment):

00:14.3 Network controller [0280]: Intel Corporation 700 Series Chipset CNVi WiFi [8086:7a70] (rev 11)

[    6.560889] iwlwifi 0000:00:14.3: CSR_RESET = 0x10
[    6.560892] iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x0
[    6.560915] iwlwifi 0000:00:14.3:     value [iter 0]: 0x3f1d0430
...
[    6.610796] iwlwifi 0000:00:14.3: probe with driver iwlwifi failed with error -110
[  732.520454] iwlwifi 0000:00:14.3: Detected crf-id 0x400410, cnv-id 0x80401 wfpm id 0x80000020
[  732.520490] iwlwifi 0000:00:14.3: PCI dev 7a70/0094, rev=0x430, rfid=0x2010d000
[  732.520499] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6E AX211 160MHz
[  732.520992] Loading firmware: iwlwifi-so-a0-gf-a0-89.ucode
[  732.533758] iwlwifi 0000:00:14.3: loaded firmware version 89.d2579d43.0 so-a0-gf-a0-89.ucode op_mode iwlmvm


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg.log
Content-Description: dmesg iwlwifi log after kexec

[    6.560889] iwlwifi 0000:00:14.3: CSR_RESET = 0x10
[    6.560892] iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x0
[    6.560915] iwlwifi 0000:00:14.3:     value [iter 0]: 0x3f1d0430
[    6.560918] iwlwifi 0000:00:14.3:     value [iter 1]: 0x3f1d0430
[    6.560920] iwlwifi 0000:00:14.3:     value [iter 2]: 0x3f1d0030
[    6.560922] iwlwifi 0000:00:14.3:     value [iter 3]: 0x3f1d0030
[    6.560925] iwlwifi 0000:00:14.3:     value [iter 4]: 0x3f1d0030
[    6.560927] iwlwifi 0000:00:14.3:     value [iter 5]: 0x3f1d0030
[    6.560929] iwlwifi 0000:00:14.3:     value [iter 6]: 0x3f1d0030
[    6.560931] iwlwifi 0000:00:14.3:     value [iter 7]: 0x3f1d0030
[    6.560934] iwlwifi 0000:00:14.3:     value [iter 8]: 0x3f1d0030
[    6.560936] iwlwifi 0000:00:14.3:     value [iter 9]: 0x3f1d0430
[    6.560938] iwlwifi 0000:00:14.3:     value [iter 10]: 0x3f1d0430
[    6.560941] iwlwifi 0000:00:14.3:     value [iter 11]: 0x3f1d0430
[    6.560943] iwlwifi 0000:00:14.3:     value [iter 12]: 0x3f1d0430
[    6.560945] iwlwifi 0000:00:14.3:     value [iter 13]: 0x3f1d0430
[    6.560948] iwlwifi 0000:00:14.3:     value [iter 14]: 0x3f1d0430
[    6.560953] iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x1
[    6.560971] iwlwifi 0000:00:14.3:     value [iter 0]: 0x040066c2
[    6.560974] iwlwifi 0000:00:14.3:     value [iter 1]: 0x040066c2
[    6.560976] iwlwifi 0000:00:14.3:     value [iter 2]: 0x040066c2
[    6.560978] iwlwifi 0000:00:14.3:     value [iter 3]: 0x040066c2
[    6.560981] iwlwifi 0000:00:14.3:     value [iter 4]: 0x040066c2
[    6.560983] iwlwifi 0000:00:14.3:     value [iter 5]: 0x040066c2
[    6.560985] iwlwifi 0000:00:14.3:     value [iter 6]: 0x040066c2
[    6.560988] iwlwifi 0000:00:14.3:     value [iter 7]: 0x040066c2
[    6.560990] iwlwifi 0000:00:14.3:     value [iter 8]: 0x040066c2
[    6.560992] iwlwifi 0000:00:14.3:     value [iter 9]: 0x040066c2
[    6.560994] iwlwifi 0000:00:14.3:     value [iter 10]: 0x040066c2
[    6.560997] iwlwifi 0000:00:14.3:     value [iter 11]: 0x040066c2
[    6.560999] iwlwifi 0000:00:14.3:     value [iter 12]: 0x040066c2
[    6.561001] iwlwifi 0000:00:14.3:     value [iter 13]: 0x040066c2
[    6.561004] iwlwifi 0000:00:14.3:     value [iter 14]: 0x040066c2
[    6.561005] iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x6
[    6.561027] iwlwifi 0000:00:14.3:     value [iter 0]: 0xb00c7c75
[    6.561029] iwlwifi 0000:00:14.3:     value [iter 1]: 0xb00c7c75
[    6.561032] iwlwifi 0000:00:14.3:     value [iter 2]: 0xb00c7c75
[    6.561034] iwlwifi 0000:00:14.3:     value [iter 3]: 0xb00c7c75
[    6.561036] iwlwifi 0000:00:14.3:     value [iter 4]: 0xb00c7c75
[    6.561039] iwlwifi 0000:00:14.3:     value [iter 5]: 0xb00c7c75
[    6.561041] iwlwifi 0000:00:14.3:     value [iter 6]: 0xa00c7c75
[    6.561043] iwlwifi 0000:00:14.3:     value [iter 7]: 0xa00c7c75
[    6.561046] iwlwifi 0000:00:14.3:     value [iter 8]: 0xa00c7c75
[    6.561048] iwlwifi 0000:00:14.3:     value [iter 9]: 0xe00c7c75
[    6.561050] iwlwifi 0000:00:14.3:     value [iter 10]: 0xe00c7c75
[    6.561053] iwlwifi 0000:00:14.3:     value [iter 11]: 0xe00c7c75
[    6.561055] iwlwifi 0000:00:14.3:     value [iter 12]: 0xe00c7c75
[    6.561057] iwlwifi 0000:00:14.3:     value [iter 13]: 0xf00c7c75
[    6.561059] iwlwifi 0000:00:14.3:     value [iter 14]: 0xf00c7c75
[    6.561061] iwlwifi 0000:00:14.3: Host monitor block 0x22 vector 0x0
[    6.561083] iwlwifi 0000:00:14.3:     value [iter 0]: 0xf9cec019
[    6.610796] iwlwifi 0000:00:14.3: probe with driver iwlwifi failed with error -110
[  732.520454] iwlwifi 0000:00:14.3: Detected crf-id 0x400410, cnv-id 0x80401 wfpm id 0x80000020
[  732.520490] iwlwifi 0000:00:14.3: PCI dev 7a70/0094, rev=0x430, rfid=0x2010d000
[  732.520499] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6E AX211 160MHz
[  732.520992] Loading firmware: iwlwifi-so-a0-gf-a0-89.ucode
[  732.533758] iwlwifi 0000:00:14.3: loaded firmware version 89.d2579d43.0 so-a0-gf-a0-89.ucode op_mode iwlmvm
[  732.805125] iwlwifi 0000:00:14.3: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  732.805157] iwlwifi 0000:00:14.3: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  732.805171] iwlwifi 0000:00:14.3: WFPM_AUTH_KEY_0: 0x90
[  732.805202] iwlwifi 0000:00:14.3: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  732.805368] iwlwifi 0000:00:14.3: Detected RF GF, rfid=0x2010d000
[  732.805381] Loading firmware: iwlwifi-so-a0-gf-a0.pnvm
[  732.806218] iwlwifi 0000:00:14.3: RFIm is deactivated, reason = 5
[  732.892495] iwlwifi 0000:00:14.3: base HW address: xx:xx:xx:xx:xx:xx
[  732.924669] iwlwifi 0000:00:14.3 wlo1: renamed from wlan0
[  733.137818] iwlwifi 0000:00:14.3: WFPM_UMAC_PD_NOTIFICATION: 0x20
[  733.137860] iwlwifi 0000:00:14.3: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[  733.137892] iwlwifi 0000:00:14.3: WFPM_AUTH_KEY_0: 0x90
[  733.137904] iwlwifi 0000:00:14.3: CNVI_SCU_SEQ_DATA_DW9: 0x0
[  733.138918] iwlwifi 0000:00:14.3: RFIm is deactivated, reason = 5

--=-=-=--
