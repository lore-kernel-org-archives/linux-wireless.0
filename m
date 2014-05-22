Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27523 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbaEVDu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 23:50:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: James Cameron <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 May 2014 20:50:02 -0700
Subject: RE: [RFC] mwifiex: block work queue while suspended
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com> (sfid-20140522_055031_867739_0284CD3D)
References: <20140516012439.GI15430@us.netrek.org>
In-Reply-To: <20140516012439.GI15430@us.netrek.org>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430F70F5D8EDSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430F70F5D8EDSCVEXCH1marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi James,

> The work queue may execute after the device is suspended, leading to
> SDIO register I/O over a suspend and resume of the system.  With a
> WARN_ON in mwifiex_write_data_to_card we see:
>=20
> [ 2115.351137] PM: suspend of devices complete after 15.989 msecs
> [ 2115.366047] mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not all=
owed while suspended
> [ 2115.366067] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1) fa=
iled: -1
> [ 2115.386023] PM: late suspend of devices complete after 34.845 msecs
> [ 2115.386303] PM: noirq suspend of devices complete after 0.272 msecs
> [ 2115.386388] before suspend
> [ 2115.387824] after resume
> [ 2115.388618] PM: noirq resume of devices complete after 0.745 msecs
> [ 2115.407641] PM: early resume of devices complete after 18.849 msecs
> [ 2125.397532] mmc0: Timeout waiting for hardware interrupt.
> [ 2125.397559] mwifiex_sdio mmc0:0001:1: write CFG reg failed
> [ 2125.397575] ------------[ cut here ]------------
> [ 2125.397575] WARNING: at drivers/net/wireless/mwifiex/sdio.c:485
> mwifiex_write_data_to_card+0x98/0xc4 [mwifiex_sdio]()
> [ 2125.397746] [<bf0eb34c>] (mwifiex_host_to_card_mp_aggr+0x354/0x46c [mw=
ifiex_sdio])
> [ 2125.397746] [<bf0eb5f4>] (mwifiex_sdio_host_to_card+0x190/0x234 [mwifi=
ex_sdio])
> [ 2125.397788] [<bf0bed00>] (mwifiex_process_tx+0x90/0x1a0 [mwifiex])
> [ 2125.397823] [<bf0bf8a0>] (mwifiex_send_single_packet+0x134/0x2b0 [mwif=
iex])
> [ 2125.397857] [<bf0c074c>] (mwifiex_wmm_process_tx+0x76c/0x800 [mwifiex]=
)
> [ 2125.397887] [<bf0ba3f8>] (mwifiex_main_process+0x344/0x504 [mwifiex])
> [ 2125.397913] [<bf0ba5e0>] (mwifiex_main_work_queue+0x28/0x2c [mwifiex])
> [ 2125.397949] [<c00409fc>] (process_one_work+0x260/0x488)
> [ 2125.397949] [<c0040e40>] (worker_thread+0x1e0/0x32c)
> [ 2125.397979] [<c00464d0>] (kthread+0x9c/0xac)
> [ 2125.397979] ---[ end trace 86d7b628a6c8ddd0 ]---
> ---
>=20
> Test environment is an OLPC XO-4 doing one sleep every few seconds,
> with the device configured to wake the system, with constant ping by
> another host.  Kernel is 3.5 with many backported mwifiex patches.
>=20
> We also see that an SDIO interrupt from the device may occur after all
> devices are suspended, leading to a similar symptom:

To understand what is happening here could you apply attached debug patch t=
o generate logs, or enable dynamic_debug for that?

>=20
> [ 1292.887221] PM: suspend of devices complete after 21.990 msecs
> [ 1292.922632] PM: late suspend of devices complete after 35.403 msecs
> [ 1292.922901] PM: noirq suspend of devices complete after 0.001 msecs
>                <-- here an mmc register read begins in sdio_irq_thread
> [ 1292.923020] before suspend
> [ 1292.953311] after resume
> [ 1292.954106] PM: noirq resume of devices complete after 0.099 msecs
> [ 1292.973124] PM: early resume of devices complete after 18.814 msecs
> [ 1302.923009] mmc0: Timeout waiting for hardware interrupt.
> [ 1302.923050] ------------[ cut here ]------------
> [ 1302.923075] WARNING: at drivers/net/wireless/mwifiex/sdio.c:688 mwifie=
x_sdio_interrupt+0xcc/0x21c
> [mwifiex_sdio]()
> [ 1302.923204] [<bf0c089c>] (mwifiex_sdio_interrupt+0xcc/0x21c [mwifiex_s=
dio])
> [ 1302.923218] [<c0302be4>] (sdio_irq_thread+0x178/0x2f0)
> [ 1302.923218] [<c00464d0>] (kthread+0x9c/0xac)
> [ 1302.923235] ---[ end trace 7e9f40af36cc200c ]---
> [ 1302.923240] mwifiex_sdio mmc0:0001:1: read mp_regs failed, will retry =
...
> [ 1302.923291] mwifiex_sdio mmc0:0001:1: read mp_regs worked on retry

I guess the driver and firmware are out of sync here. If firmware is sleepi=
ng we will get this failure.

> [ 1303.554228] PM: resume of devices complete after 10581.100 msecs
>                ^-- note how resume was delayed by mmc0 timeout
> [ 1303.745395] Restarting tasks ... done.
> [ 1312.943035] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeou=
t cmd id (1400141716.779991)
> =3D 0xe5, act =3D 0x1
>=20
> I don't know how to fix this one yet; I don't know why the SDHCI
> transaction fails, given the clocks remain running.

Are you able to get an SDIO Bus Analyzer capture?

>=20
>  drivers/net/wireless/mwifiex/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/m=
wifiex/main.c
> index 9c771b3..512ccd6 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -833,6 +833,8 @@ static void mwifiex_main_work_queue(struct work_struc=
t *work)
>=20
>  	if (adapter->surprise_removed)
>  		return;
> +	if (adapter->is_suspended)
> +		return;

If we can find the root cause and fix it, this change won't be necessary.

Thanks,
Bing

>  	mwifiex_main_process(adapter);
>  }
>=20


--_002_477F20668A386D41ADCC57781B1F70430F70F5D8EDSCVEXCH1marve_
Content-Type: application/octet-stream;
	name="mwifiex_debug_cmd_sequence_in_suspend.patch"
Content-Description: mwifiex_debug_cmd_sequence_in_suspend.patch
Content-Disposition: attachment;
	filename="mwifiex_debug_cmd_sequence_in_suspend.patch"; size=4190;
	creation-date="Thu, 22 May 2014 03:39:47 GMT";
	modification-date="Thu, 22 May 2014 03:39:47 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvY21kZXZ0LmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NtZGV2dC5jCmluZGV4IDhkZWU2YzguLmVlNTE4NWQg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvY21kZXZ0LmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9jbWRldnQuYwpAQCAtMTk5LDcgKzE5OSw3IEBA
IHN0YXRpYyBpbnQgbXdpZmlleF9kbmxkX2NtZF90b19mdyhzdHJ1Y3QgbXdpZmlleF9wcml2YXRl
ICpwcml2LAogCQlza2JfcHV0KGNtZF9ub2RlLT5jbWRfc2tiLCBjbWRfc2l6ZSAtIGNtZF9ub2Rl
LT5jbWRfc2tiLT5sZW4pOwogCiAJZG9fZ2V0dGltZW9mZGF5KCZ0c3RhbXApOwotCWRldl9kYmco
YWRhcHRlci0+ZGV2LCAiY21kOiBETkxEX0NNRDogKCVsdS4lbHUpOiAlI3gsIGFjdCAlI3gsIGxl
biAlZCwiCisJZGV2X2VycihhZGFwdGVyLT5kZXYsICJjbWQ6IEROTERfQ01EOiAoJWx1LiVsdSk6
ICUjeCwgYWN0ICUjeCwgbGVuICVkLCIKIAkJIiBzZXFubyAlI3hcbiIsCiAJCXRzdGFtcC50dl9z
ZWMsIHRzdGFtcC50dl91c2VjLCBjbWRfY29kZSwKIAkJbGUxNl90b19jcHUoKihfX2xlMTYgKikg
KCh1OCAqKSBob3N0X2NtZCArIFNfRFNfR0VOKSksIGNtZF9zaXplLApAQCAtNDU3LDYgKzQ1Nyw5
IEBAIGludCBtd2lmaWV4X3Byb2Nlc3NfZXZlbnQoc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRh
cHRlcikKIAkJcnhfaW5mby0+YnNzX3R5cGUgPSBwcml2LT5ic3NfdHlwZTsKIAl9CiAKKwlkb19n
ZXR0aW1lb2ZkYXkoJnRzdGFtcCk7CisJZGV2X2VycihhZGFwdGVyLT5kZXYsICJldmVudDogJWx1
LiVsdTogY2F1c2U6ICUjeFxuIiwKKwkJdHN0YW1wLnR2X3NlYywgdHN0YW1wLnR2X3VzZWMsIGV2
ZW50Y2F1c2UpOwogCWlmIChldmVudGNhdXNlICE9IEVWRU5UX1BTX1NMRUVQICYmIGV2ZW50Y2F1
c2UgIT0gRVZFTlRfUFNfQVdBS0UpIHsKIAkJZG9fZ2V0dGltZW9mZGF5KCZ0c3RhbXApOwogCQlk
ZXZfZGJnKGFkYXB0ZXItPmRldiwgImV2ZW50OiAlbHUuJWx1OiBjYXVzZTogJSN4XG4iLApAQCAt
NjMzLDcgKzYzNiw3IEBAIHZvaWQgbXdpZmlleF9yZWN5Y2xlX2NtZF9ub2RlKHN0cnVjdCBtd2lm
aWV4X2FkYXB0ZXIgKmFkYXB0ZXIsCiAJbXdpZmlleF9pbnNlcnRfY21kX3RvX2ZyZWVfcShhZGFw
dGVyLCBjbWRfbm9kZSk7CiAKIAlhdG9taWNfZGVjKCZhZGFwdGVyLT5jbWRfcGVuZGluZyk7Ci0J
ZGV2X2RiZyhhZGFwdGVyLT5kZXYsICJjbWQ6IEZSRUVfQ01EOiBjbWQ9JSN4LCBjbWRfcGVuZGlu
Zz0lZFxuIiwKKwlkZXZfZXJyKGFkYXB0ZXItPmRldiwgImNtZDogRlJFRV9DTUQ6IGNtZD0lI3gs
IGNtZF9wZW5kaW5nPSVkXG4iLAogCQlsZTE2X3RvX2NwdShob3N0X2NtZC0+Y29tbWFuZCksCiAJ
CWF0b21pY19yZWFkKCZhZGFwdGVyLT5jbWRfcGVuZGluZykpOwogfQpAQCAtNjgwLDcgKzY4Myw3
IEBAIG13aWZpZXhfaW5zZXJ0X2NtZF90b19wZW5kaW5nX3Eoc3RydWN0IG13aWZpZXhfYWRhcHRl
ciAqYWRhcHRlciwKIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZhZGFwdGVyLT5jbWRfcGVuZGlu
Z19xX2xvY2ssIGZsYWdzKTsKIAogCWF0b21pY19pbmMoJmFkYXB0ZXItPmNtZF9wZW5kaW5nKTsK
LQlkZXZfZGJnKGFkYXB0ZXItPmRldiwgImNtZDogUVVFVUVfQ01EOiBjbWQ9JSN4LCBjbWRfcGVu
ZGluZz0lZFxuIiwKKwlkZXZfZXJyKGFkYXB0ZXItPmRldiwgImNtZDogUVVFVUVfQ01EOiBjbWQ9
JSN4LCBjbWRfcGVuZGluZz0lZFxuIiwKIAkJY29tbWFuZCwgYXRvbWljX3JlYWQoJmFkYXB0ZXIt
PmNtZF9wZW5kaW5nKSk7CiB9CiAKQEAgLTgzMSw3ICs4MzQsNyBAQCBpbnQgbXdpZmlleF9wcm9j
ZXNzX2NtZHJlc3Aoc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlcikKIAkJCQkJCQkJb3Jp
Z19jbWRyZXNwX25vOwogCiAJZG9fZ2V0dGltZW9mZGF5KCZ0c3RhbXApOwotCWRldl9kYmcoYWRh
cHRlci0+ZGV2LCAiY21kOiBDTURfUkVTUDogKCVsdS4lbHUpOiAweCV4LCByZXN1bHQgJWQsIgor
CWRldl9lcnIoYWRhcHRlci0+ZGV2LCAiY21kOiBDTURfUkVTUDogKCVsdS4lbHUpOiAweCV4LCBy
ZXN1bHQgJWQsIgogCQkiIGxlbiAlZCwgc2Vxbm8gMHgleFxuIiwKIAkgICAgICAgdHN0YW1wLnR2
X3NlYywgdHN0YW1wLnR2X3VzZWMsIG9yaWdfY21kcmVzcF9ubywgY21kcmVzcF9yZXN1bHQsCiAJ
ICAgICAgIGxlMTZfdG9fY3B1KHJlc3AtPnNpemUpLCBsZTE2X3RvX2NwdShyZXNwLT5zZXFfbnVt
KSk7CkBAIC0xMTM1LDE1ICsxMTM4LDE1IEBAIG13aWZpZXhfaHNfYWN0aXZhdGVkX2V2ZW50KHN0
cnVjdCBtd2lmaWV4X3ByaXZhdGUgKnByaXYsIHU4IGFjdGl2YXRlZCkKIAkJCXByaXYtPmFkYXB0
ZXItPmhzX2FjdGl2YXRlZCA9IHRydWU7CiAJCQltd2lmaWV4X3VwZGF0ZV9yeHJlb3JfZmxhZ3Mo
cHJpdi0+YWRhcHRlciwKIAkJCQkJCSAgICBSWFJFT1JfRk9SQ0VfTk9fRFJPUCk7Ci0JCQlkZXZf
ZGJnKHByaXYtPmFkYXB0ZXItPmRldiwgImV2ZW50OiBoc19hY3RpdmF0ZWRcbiIpOworCQkJZGV2
X2Vycihwcml2LT5hZGFwdGVyLT5kZXYsICJldmVudDogaHNfYWN0aXZhdGVkXG4iKTsKIAkJCXBy
aXYtPmFkYXB0ZXItPmhzX2FjdGl2YXRlX3dhaXRfcV93b2tlbiA9IHRydWU7CiAJCQl3YWtlX3Vw
X2ludGVycnVwdGlibGUoCiAJCQkJJnByaXYtPmFkYXB0ZXItPmhzX2FjdGl2YXRlX3dhaXRfcSk7
CiAJCX0gZWxzZSB7Ci0JCQlkZXZfZGJnKHByaXYtPmFkYXB0ZXItPmRldiwgImV2ZW50OiBIUyBu
b3QgY29uZmlndXJlZFxuIik7CisJCQlkZXZfZXJyKHByaXYtPmFkYXB0ZXItPmRldiwgImV2ZW50
OiBIUyBub3QgY29uZmlndXJlZFxuIik7CiAJCX0KIAl9IGVsc2UgewotCQlkZXZfZGJnKHByaXYt
PmFkYXB0ZXItPmRldiwgImV2ZW50OiBoc19kZWFjdGl2YXRlZFxuIik7CisJCWRldl9lcnIocHJp
di0+YWRhcHRlci0+ZGV2LCAiZXZlbnQ6IGhzX2RlYWN0aXZhdGVkXG4iKTsKIAkJcHJpdi0+YWRh
cHRlci0+aHNfYWN0aXZhdGVkID0gZmFsc2U7CiAJfQogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4
L3NkaW8uYwppbmRleCA0Y2UzZDdiLi5kN2Q4YTk2IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9td2lmaWV4L3NkaW8uYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4
L3NkaW8uYwpAQCAtMTAzMywxMiArMTAzMywxMiBAQCBzdGF0aWMgaW50IG13aWZpZXhfZGVjb2Rl
X3J4X3BhY2tldChzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyLAogCiAJc3dpdGNoICh1
cGxkX3R5cCkgewogCWNhc2UgTVdJRklFWF9UWVBFX0RBVEE6Ci0JCWRldl9kYmcoYWRhcHRlci0+
ZGV2LCAiaW5mbzogLS0tIFJ4OiBEYXRhIHBhY2tldCAtLS1cbiIpOworCQlkZXZfZXJyKGFkYXB0
ZXItPmRldiwgImluZm86IC0tLSBSeDogRGF0YSBwYWNrZXQgLS0tXG4iKTsKIAkJbXdpZmlleF9o
YW5kbGVfcnhfcGFja2V0KGFkYXB0ZXIsIHNrYik7CiAJCWJyZWFrOwogCiAJY2FzZSBNV0lGSUVY
X1RZUEVfQ01EOgotCQlkZXZfZGJnKGFkYXB0ZXItPmRldiwgImluZm86IC0tLSBSeDogQ21kIFJl
c3BvbnNlIC0tLVxuIik7CisJCWRldl9lcnIoYWRhcHRlci0+ZGV2LCAiaW5mbzogLS0tIFJ4OiBD
bWQgUmVzcG9uc2UgLS0tXG4iKTsKIAkJLyogdGFrZSBjYXJlIG9mIGN1cnJfY21kID0gTlVMTCBj
YXNlICovCiAJCWlmICghYWRhcHRlci0+Y3Vycl9jbWQpIHsKIAkJCWNtZF9idWYgPSBhZGFwdGVy
LT51cGxkX2J1ZjsKQEAgLTEwNjAsNyArMTA2MCw3IEBAIHN0YXRpYyBpbnQgbXdpZmlleF9kZWNv
ZGVfcnhfcGFja2V0KHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIsCiAJCWJyZWFrOwog
CiAJY2FzZSBNV0lGSUVYX1RZUEVfRVZFTlQ6Ci0JCWRldl9kYmcoYWRhcHRlci0+ZGV2LCAiaW5m
bzogLS0tIFJ4OiBFdmVudCAtLS1cbiIpOworCQlkZXZfZXJyKGFkYXB0ZXItPmRldiwgImluZm86
IC0tLSBSeDogRXZlbnQgLS0tXG4iKTsKIAkJYWRhcHRlci0+ZXZlbnRfY2F1c2UgPSBsZTMyX3Rv
X2NwdSgqKF9fbGUzMiAqKSBza2ItPmRhdGEpOwogCiAJCWlmICgoc2tiLT5sZW4gPiAwKSAmJiAo
c2tiLT5sZW4gIDwgTUFYX0VWRU5UX1NJWkUpKQo=

--_002_477F20668A386D41ADCC57781B1F70430F70F5D8EDSCVEXCH1marve_--
