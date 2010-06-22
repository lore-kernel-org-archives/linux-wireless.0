Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0FVKo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 06:44:28 -0400
Received: by wyb33 with SMTP id 33so3012477wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 03:44:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 22 Jun 2010 12:44:26 +0200
Message-ID: <AANLkTilpqUnWG2CnMNZR7a45rY9cbqks3W-gkjsMbYOQ@mail.gmail.com>
Subject: ASPM status for iwlwifi and power-management (in general)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: multipart/mixed; boundary=0016e65b5c50e7546904899c1a42
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016e65b5c50e7546904899c1a42
Content-Type: text/plain; charset=UTF-8

Hi,

yesterday, I was playing with PowerTop and my iwl3945 still is in the
TOP 3 of energy user.

Inspired by the recently published ASPM doc from Luis [2] I played a
bit with ASPM.

Currently, I am using a 2.6.35-rc3 Linux-kernel with latest
acpi-2.6/release fixes.

# dmesg | grep -i aspm
[    0.226963] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.227629] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.228205] pci 0000:10:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'

# for i in 01:00.0 08:00.0 10:00.0 ; do lspci -v | grep $i ; done
01:00.0 VGA compatible controller: ATI Technologies Inc M52 [Mobility
Radeon X1300] (prog-if 00 [VGA controller])
08:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5753M
Gigabit Ethernet PCI Express (rev 21)
10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

# lspci -vvvv -s 10:00.0 | grep -i aspm
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<128ns, L1 <64us
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+

Before I will try 'pcie_aspm=force' cheat-code I wanted to ask about
the status of iwlwifi and ASPM.
Is there code available. yet? Which kernel has it - linux-next,
wireless-testing GIT, iwlwifi GIT?
Which user-space apps are required?
IIRC iw [3] from GIT has already "iw: add set/get power_save commands" [4].
Anyone tested ASPM with iwlwifi hardware? Experiences?

Beyond ASPM code, what is the actual status on power-mangement for
wifi-hardware in general?
IIRC it was turned off by default (with 2.6.33?)?

Thanks for any help in advance.


Kind Regards,
- Sedat -


[1] http://wireless.kernel.org/en/users/Documentation/ASPM
[2] http://marc.info/?l=linux-wireless&m=127716115227206&w=2
[3] http://git.sipsolutions.net/?p=iw.git
[4] http://git.sipsolutions.net/?p=iw.git;a=commit;h=cf40ef379fd6c74a01092d1dfdd936385ea402b0

--0016e65b5c50e7546904899c1a42
Content-Type: text/plain; charset=US-ASCII; name="iwl3945_ASPM.txt"
Content-Disposition: attachment; filename="iwl3945_ASPM.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gaqle5fc0

MTA6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFBSTy9XaXJlbGVz
cyAzOTQ1QUJHIFtHb2xhbl0gTmV0d29yayBDb25uZWN0aW9uIChyZXYgMDIpCglTdWJzeXN0ZW06
IEhld2xldHQtUGFja2FyZCBDb21wYW55IENvbXBhcSA2NzEwYiBvciBueDk0MjAgTm90ZWJvb2sK
CUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25v
b3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENh
cCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFi
b3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5l
IFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgNDUKCVJlZ2lv
biAwOiBNZW1vcnkgYXQgZTAwMDAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9
NEtdCglDYXBhYmlsaXRpZXM6IFtjOF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFn
czogUE1FQ2xrLSBEU0krIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQz
aG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAg
RFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbZDBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEg
TWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMgIERhdGE6IDQxYTEK
CUNhcGFiaWxpdGllczogW2UwXSBFeHByZXNzICh2MSkgTGVnYWN5IEVuZHBvaW50LCBNU0kgMDAK
CQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMg
PDUxMm5zLCBMMSB1bmxpbWl0ZWQKCQkJRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQt
IFJCRS0gRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24t
RmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZCsgRXh0VGFnLSBQaGFudEZ1bmMt
IEF1eFB3ci0gTm9Tbm9vcCsKCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4
IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEt
IEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQgMi41R1QvcywgV2lk
dGggeDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDwxMjhucywgTDEgPDY0dXMKCQkJQ2xvY2tQ
TSsgU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlMbmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJD
QiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENsb2Nr
UE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1Qvcywg
V2lkdGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdt
dC0KCUNhcGFiaWxpdGllczogWzEwMCB2MV0gQWR2YW5jZWQgRXJyb3IgUmVwb3J0aW5nCgkJVUVT
dGE6CURMUC0gU0RFUy0gVExQLSBGQ1AtIENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4
T0YtIE1hbGZUTFAtIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9sLQoJCVVFTXNrOglETFAtIFNERVMt
IFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBF
Q1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlVRVN2cnQ6CURMUCsgU0RFUy0gVExQLSBGQ1ArIENt
cGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YrIE1hbGZUTFArIEVDUkMtIFVuc3VwUmVx
LSBBQ1NWaW9sLQoJCUNFU3RhOglSeEVyci0gQmFkVExQLSBCYWRETExQKyBSb2xsb3Zlci0gVGlt
ZW91dC0gTm9uRmF0YWxFcnItCgkJQ0VNc2s6CVJ4RXJyLSBCYWRUTFAtIEJhZERMTFAtIFJvbGxv
dmVyLSBUaW1lb3V0LSBOb25GYXRhbEVyci0KCQlBRVJDYXA6CUZpcnN0IEVycm9yIFBvaW50ZXI6
IDAwLCBHZW5DYXAtIENHZW5Fbi0gQ2hrQ2FwLSBDaGtFbi0KCUNhcGFiaWxpdGllczogWzE0MCB2
MV0gRGV2aWNlIFNlcmlhbCBOdW1iZXIgMDAtMTktZDItZmYtZmYtNjItZTQtYmIKCUtlcm5lbCBk
cml2ZXIgaW4gdXNlOiBpd2wzOTQ1Cgo=
--0016e65b5c50e7546904899c1a42--
