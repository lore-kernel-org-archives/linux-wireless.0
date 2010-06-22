Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45114 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0FVLLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 07:11:18 -0400
Received: by wwb13 with SMTP id 13so1232075wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 04:11:16 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTilr1jzS2-q3Je_QEKE-eZyHSwIIbbd07tZFJgJQ@mail.gmail.com>
References: <AANLkTilpqUnWG2CnMNZR7a45rY9cbqks3W-gkjsMbYOQ@mail.gmail.com>
	<AANLkTilr1jzS2-q3Je_QEKE-eZyHSwIIbbd07tZFJgJQ@mail.gmail.com>
Date: Tue, 22 Jun 2010 13:11:15 +0200
Message-ID: <AANLkTimKDOpeH8zLik3QD-EyO9rvMQAl0SEipIfCA-42@mail.gmail.com>
Subject: Re: ASPM status for iwlwifi and power-management (in general)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: multipart/mixed; boundary=0016e6d77f11d9c28904899c7ac1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016e6d77f11d9c28904899c7ac1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Attached iwl3945_ASPM-enabled_full.txt

- Sedat -

On Tue, Jun 22, 2010 at 1:09 PM, Sedat Dilek <sedat.dilek@googlemail.com> w=
rote:
> I booted now with 'pcie_aspm=3Dforce':
>
> # dmesg | grep -i aspm
> [ =C2=A0 =C2=A00.000000] Kernel command line:
> BOOT_IMAGE=3D/boot/vmlinuz-2.6.35-rc3-iniza-686-kms
> root=3DUUID=3Db1333729-42ce-4a1b-9669-41c14c42bb81 ro nomodeset 3
> pcie_aspm=3Dforce
> [ =C2=A0 =C2=A00.000000] PCIe ASPM is forcedly enabled
>
> # lspci -vvvv -s 10:00.0 | grep -i aspm
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #0, S=
peed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
> <128ns, L1 <64us
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM L1 En=
abled; RCB 64 bytes Disabled- Retrain- CommClk+
>
> Full dmesg and lspci for iwl3945 outputs are attached.
>
> - Sedat -
>
> On Tue, Jun 22, 2010 at 12:44 PM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> Hi,
>>
>> yesterday, I was playing with PowerTop and my iwl3945 still is in the
>> TOP 3 of energy user.
>>
>> Inspired by the recently published ASPM doc from Luis [2] I played a
>> bit with ASPM.
>>
>> Currently, I am using a 2.6.35-rc3 Linux-kernel with latest
>> acpi-2.6/release fixes.
>>
>> # dmesg | grep -i aspm
>> [ =C2=A0 =C2=A00.226963] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCI=
e
>> device. =C2=A0You can enable it with 'pcie_aspm=3Dforce'
>> [ =C2=A0 =C2=A00.227629] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCI=
e
>> device. =C2=A0You can enable it with 'pcie_aspm=3Dforce'
>> [ =C2=A0 =C2=A00.228205] pci 0000:10:00.0: disabling ASPM on pre-1.1 PCI=
e
>> device. =C2=A0You can enable it with 'pcie_aspm=3Dforce'
>>
>> # for i in 01:00.0 08:00.0 10:00.0 ; do lspci -v | grep $i ; done
>> 01:00.0 VGA compatible controller: ATI Technologies Inc M52 [Mobility
>> Radeon X1300] (prog-if 00 [VGA controller])
>> 08:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5753M
>> Gigabit Ethernet PCI Express (rev 21)
>> 10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
>> [Golan] Network Connection (rev 02)
>>
>> # lspci -vvvv -s 10:00.0 | grep -i aspm
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #0, =
Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
>> <128ns, L1 <64us
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain- CommClk+
>>
>> Before I will try 'pcie_aspm=3Dforce' cheat-code I wanted to ask about
>> the status of iwlwifi and ASPM.
>> Is there code available. yet? Which kernel has it - linux-next,
>> wireless-testing GIT, iwlwifi GIT?
>> Which user-space apps are required?
>> IIRC iw [3] from GIT has already "iw: add set/get power_save commands" [=
4].
>> Anyone tested ASPM with iwlwifi hardware? Experiences?
>>
>> Beyond ASPM code, what is the actual status on power-mangement for
>> wifi-hardware in general?
>> IIRC it was turned off by default (with 2.6.33?)?
>>
>> Thanks for any help in advance.
>>
>>
>> Kind Regards,
>> - Sedat -
>>
>>
>> [1] http://wireless.kernel.org/en/users/Documentation/ASPM
>> [2] http://marc.info/?l=3Dlinux-wireless&m=3D127716115227206&w=3D2
>> [3] http://git.sipsolutions.net/?p=3Diw.git
>> [4] http://git.sipsolutions.net/?p=3Diw.git;a=3Dcommit;h=3Dcf40ef379fd6c=
74a01092d1dfdd936385ea402b0
>>
>

--0016e6d77f11d9c28904899c7ac1
Content-Type: text/plain; charset=US-ASCII; name="iwl3945_ASPM-enabled_full.txt"
Content-Disposition: attachment; filename="iwl3945_ASPM-enabled_full.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gaqmwrxi2

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
TSsgU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlMbmtDdGw6CUFTUE0gTDEgRW5hYmxlZDsg
UkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xv
Y2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9z
LCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210LSBBQldN
Z210LQoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRpbmcKCQlV
RVN0YToJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0g
UnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wtCgkJVUVNc2s6CURMUC0gU0RF
Uy0gVExQLSBGQ1AtIENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1hbGZUTFAt
IEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9sLQoJCVVFU3ZydDoJRExQKyBTREVTLSBUTFAtIEZDUCsg
Q21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0gUnhPRisgTWFsZlRMUCsgRUNSQy0gVW5zdXBS
ZXEtIEFDU1Zpb2wtCgkJQ0VTdGE6CVJ4RXJyLSBCYWRUTFArIEJhZERMTFArIFJvbGxvdmVyLSBU
aW1lb3V0LSBOb25GYXRhbEVyci0KCQlDRU1zazoJUnhFcnItIEJhZFRMUC0gQmFkRExMUC0gUm9s
bG92ZXItIFRpbWVvdXQtIE5vbkZhdGFsRXJyLQoJCUFFUkNhcDoJRmlyc3QgRXJyb3IgUG9pbnRl
cjogMDAsIEdlbkNhcC0gQ0dlbkVuLSBDaGtDYXAtIENoa0VuLQoJQ2FwYWJpbGl0aWVzOiBbMTQw
IHYxXSBEZXZpY2UgU2VyaWFsIE51bWJlciAwMC0xOS1kMi1mZi1mZi02Mi1lNC1iYgoJS2VybmVs
IGRyaXZlciBpbiB1c2U6IGl3bDM5NDUKCg==
--0016e6d77f11d9c28904899c7ac1--
