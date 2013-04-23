Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:42465 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab3DWByj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 21:54:39 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 22 Apr 2013 18:50:42 -0700
Subject: RE: Memory leak in mwifiex_cfg80211_scan
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com> (sfid-20130423_035444_922133_3DEEEFBA)
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
In-Reply-To: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D9E0579DBSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D9E0579DBSCVEXCH1marve_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> Hi,
>=20
> The following test script triggers a memory leak:
>=20
> insmod mwifiex_sdio.ko
> sleep 1
> ifconfig eth0 up
> iwlist eth0 scan &
> sleep 0.5
> rmmod mwifiex_sdio
>=20
> kmemleak says:
> unreferenced object 0xed8bb200 (size 512):
>   comm "iwlist", pid 666, jiffies 4294952762 (age 16.330s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 e8 b8 8b ed 01 01 00  ................
>     01 00 00 00 00 00 02 00 01 00 00 00 00 00 03 00  ................
>   backtrace:
>     [<c00a7f1c>] create_object+0x118/0x2b0
>     [<c03db82c>] kmemleak_alloc+0x80/0xc4
>     [<c00a3444>] kmem_cache_alloc+0xa8/0x110
>     [<c022f8ac>] mwifiex_cfg80211_scan+0xc0/0x300
>     [<c03bfe2c>] cfg80211_wext_siwscan+0x280/0x2f8
>     [<c03d7cf8>] ioctl_standard_call+0x290/0x3b8
>     [<c03d7f14>] wext_handle_ioctl+0xf4/0x1c0
>     [<c0308d70>] dev_ioctl+0x6b4/0x6dc
>     [<c02f3f00>] sock_ioctl+0x254/0x28c
>     [<c00b994c>] vfs_ioctl+0x30/0x44
>     [<c00ba504>] do_vfs_ioctl+0x560/0x5b8
>     [<c00ba59c>] sys_ioctl+0x40/0x68
>     [<c000eb40>] ret_fast_syscall+0x0/0x30
>     [<ffffffff>] 0xffffffff

Thanks for reporting this issue.
Please find attached the patch and try it on your XO4.

I will resend the patch to the list if it works for you.

Thanks,
Bing


--_002_477F20668A386D41ADCC57781B1F70430D9E0579DBSCVEXCH1marve_
Content-Type: application/octet-stream;
	name="0001-mwifiex-fix-memory-leak-in-mwifiex_cfg80211_scan.patch"
Content-Description: 0001-mwifiex-fix-memory-leak-in-mwifiex_cfg80211_scan.patch
Content-Disposition: attachment;
	filename="0001-mwifiex-fix-memory-leak-in-mwifiex_cfg80211_scan.patch";
	size=2088; creation-date="Tue, 23 Apr 2013 01:25:48 GMT";
	modification-date="Tue, 23 Apr 2013 01:25:48 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwYjBmMzA4ODM3Mzg2NThhYmU5YTk5ZDNiYTEyMGJhNDU2MzdhMjBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaW5nIFpoYW8gPGJ6aGFvQG1hcnZlbGwuY29tPgpEYXRlOiBN
b24sIDIyIEFwciAyMDEzIDE3OjM5OjMwIC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gbXdpZmlleDog
Zml4IG1lbW9yeSBsZWFrIGluIG13aWZpZXhfY2ZnODAyMTFfc2NhbgoKVGhlIGZvbGxvd2luZyB0
ZXN0IHNjcmlwdCB0cmlnZ2VycyBhIG1lbW9yeSBsZWFrOgoKaW5zbW9kIG13aWZpZXhfc2Rpby5r
bwpzbGVlcCAxCmlmY29uZmlnIGV0aDAgdXAKaXdsaXN0IGV0aDAgc2NhbiAmCnNsZWVwIDAuNQpy
bW1vZCBtd2lmaWV4X3NkaW8KCmttZW1sZWFrIHNheXM6CnVucmVmZXJlbmNlZCBvYmplY3QgMHhl
ZDhiYjIwMCAoc2l6ZSA1MTIpOgogIGNvbW0gIml3bGlzdCIsIHBpZCA2NjYsIGppZmZpZXMgNDI5
NDk1Mjc2MiAoYWdlIDE2LjMzMHMpCiAgaGV4IGR1bXAgKGZpcnN0IDMyIGJ5dGVzKToKICAgIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIGU4IGI4IDhiIGVkIDAxIDAxIDAwICAuLi4uLi4uLi4u
Li4uLi4uCiAgICAwMSAwMCAwMCAwMCAwMCAwMCAwMiAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMyAw
MCAgLi4uLi4uLi4uLi4uLi4uLgogIGJhY2t0cmFjZToKICAgIFs8YzAwYTdmMWM+XSBjcmVhdGVf
b2JqZWN0KzB4MTE4LzB4MmIwCiAgICBbPGMwM2RiODJjPl0ga21lbWxlYWtfYWxsb2MrMHg4MC8w
eGM0CiAgICBbPGMwMGEzNDQ0Pl0ga21lbV9jYWNoZV9hbGxvYysweGE4LzB4MTEwCiAgICBbPGMw
MjJmOGFjPl0gbXdpZmlleF9jZmc4MDIxMV9zY2FuKzB4YzAvMHgzMDAKICAgIFs8YzAzYmZlMmM+
XSBjZmc4MDIxMV93ZXh0X3Npd3NjYW4rMHgyODAvMHgyZjgKICAgIFs8YzAzZDdjZjg+XSBpb2N0
bF9zdGFuZGFyZF9jYWxsKzB4MjkwLzB4M2I4CiAgICBbPGMwM2Q3ZjE0Pl0gd2V4dF9oYW5kbGVf
aW9jdGwrMHhmNC8weDFjMAogICAgWzxjMDMwOGQ3MD5dIGRldl9pb2N0bCsweDZiNC8weDZkYwog
ICAgWzxjMDJmM2YwMD5dIHNvY2tfaW9jdGwrMHgyNTQvMHgyOGMKICAgIFs8YzAwYjk5NGM+XSB2
ZnNfaW9jdGwrMHgzMC8weDQ0CiAgICBbPGMwMGJhNTA0Pl0gZG9fdmZzX2lvY3RsKzB4NTYwLzB4
NWI4CiAgICBbPGMwMGJhNTljPl0gc3lzX2lvY3RsKzB4NDAvMHg2OAogICAgWzxjMDAwZWI0MD5d
IHJldF9mYXN0X3N5c2NhbGwrMHgwLzB4MzAKICAgIFs8ZmZmZmZmZmY+XSAweGZmZmZmZmZmCgpU
aGlzIGxlYWsgaGFwcGVucyB3aGVuIHNjYW4gcmVxdWVzdCBpcyBjYW5jZWxlZCBkdXJpbmcgc2Nh
bm5pbmcuCkluIGFkZGl0aW9uIHRvIG5vdGlmeWluZyBjZmc4MDIxMSB3aXRoIHNjYW4gYWJvcnRl
ZCwKcHJpdi0+dXNlcl9zY2FuX2NmZyBzaG91bGQgYmUgZnJlZWQuCgpDYzogPHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmc+ClJlcG9ydGVkLWJ5OiBEYW5pZWwgRHJha2UgPGRzZEBsYXB0b3Aub3JnPgpT
aWduZWQtb2ZmLWJ5OiBCaW5nIFpoYW8gPGJ6aGFvQG1hcnZlbGwuY29tPgotLS0KIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL213aWZpZXgvbWFpbi5jIHwgICAgNCArKysrCiAxIGZpbGVzIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9td2lmaWV4L21haW4uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgv
bWFpbi5jCmluZGV4IDEyMTQ0M2EuLjhmNmNiMzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL213aWZpZXgvbWFpbi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgv
bWFpbi5jCkBAIC00MzgsNiArNDM4LDEwIEBAIG13aWZpZXhfY2xvc2Uoc3RydWN0IG5ldF9kZXZp
Y2UgKmRldikKIAkJcHJpdi0+c2Nhbl9yZXF1ZXN0ID0gTlVMTDsKIAl9CiAKKwkvKiBGcmVlIHVz
ZXJfc2Nhbl9jZmcgbWVtb3J5IGluIGNhc2UgdGhhdCBzY2FuIGhhcyBiZWVuIGNhbmNlbGVkICov
CisJa2ZyZWUocHJpdi0+dXNlcl9zY2FuX2NmZyk7CisJcHJpdi0+dXNlcl9zY2FuX2NmZyA9IE5V
TEw7CisKIAlyZXR1cm4gMDsKIH0KIAotLSAKMS43LjAuMgoK

--_002_477F20668A386D41ADCC57781B1F70430D9E0579DBSCVEXCH1marve_--
