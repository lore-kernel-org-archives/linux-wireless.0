Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:37111 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760188Ab3DBSQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 14:16:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Mack <daniel@zonque.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 2 Apr 2013 11:16:26 -0700
Subject: RE: mwifiex: infinite loop in mwifiex_main_process
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAAFDA@SC-VEXCH1.marvell.com> (sfid-20130402_201655_905947_7F2BA16E)
References: <20130319095235.GA22962@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DBCE43F@SC-VEXCH1.marvell.com>
 <20130402000511.GA31921@blumentopf>
In-Reply-To: <20130402000511.GA31921@blumentopf>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D9DDAAFDASCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D9DDAAFDASCVEXCH1marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Andi,

[...]

> +			spin_lock_irqsave(&priv_tmp->wmm.ra_list_spinlock, flags);
> +			BUG_ON(atomic_read(&priv_tmp->wmm.tx_pkts_queued));
> +			spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags);
> +
>                         /* No packet at any TID for this priv. Mark as su=
ch
>                          * to skip checking TIDs for this priv (until pkt=
 is
>                          * added).
> 			atomic_set(hqp, NO_PKT_PRIO_TID);
>=20
>=20
> Which crashed. Hence searching for queued packets and adding new ones is
> not synchronized, new packets can be added while searching the WMM
> queues. If a packet is added right before setting max prio to NO_PKT,
> that packet is trapped and creates an infinite loop.
>=20
> Because of the new packet tx_pkts_queued is at least 1, indicating wmm
> lists are not empty. Opposing that max prio is NO_PKT, which means "skip
> this wmm queue, it has no packets".
> The infinite loop results, because the main loop checks the wmm lists
> for not empty (tx_pkts_queued !=3D 0), but then finds no packet since it
> skips the wmm queue where it is located on. This will never end, unless
> a new packet is added which will restore max prio.

Thanks for your analysis.

> One possible solution is is to rely on tx_pkts_queued solely for
> checking wmm queue to be empty, and drop the NO_PKT define.

FYI, Yogesh suggested another fix (attached).

[...]

> seems to be intruduced with this patch:
> 17e8cec  05-16-2011 mwifiex: CPU mips optimization with NO_PKT_PRIO_TID
>=20
> I was wondering why hasn't happened more frequently. Evtl. if the
> interface is working in bridge mode, new packets might be added to the
> WMM queue with the trapped packet. 2c
>=20
> I prepared a few patches, fixing above bug as suggested and plus some
> cleanup patches I did while trying to get an understanding. Pls review.

Thanks for the patches. We will review them and run some WMM tests.

Thanks,
Bing

--_002_477F20668A386D41ADCC57781B1F70430D9DDAAFDASCVEXCH1marve_
Content-Type: application/octet-stream; name="hqp.diff"
Content-Description: hqp.diff
Content-Disposition: attachment; filename="hqp.diff"; size=1619;
	creation-date="Tue, 02 Apr 2013 18:10:38 GMT";
	modification-date="Tue, 02 Apr 2013 18:10:38 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvd21tLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9td2lmaWV4L3dtbS5jCmluZGV4IDNkZGFlNTIuLmQ4YWIwOTUgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvd21tLmMKKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbXdpZmlleC93bW0uYwpAQCAtODg4LDcgKzg4OCw3IEBAIG13aWZpZXhfd21t
X2dldF9oaWdoZXN0X3ByaW9saXN0X3B0cihzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVy
LAogCXN0cnVjdCBtd2lmaWV4X3RpZF90YmwgKnRpZF9wdHI7CiAJYXRvbWljX3QgKmhxcDsKIAlp
bnQgaXNfbGlzdF9lbXB0eTsKLQl1bnNpZ25lZCBsb25nIGZsYWdzOworCXVuc2lnbmVkIGxvbmcg
ZmxhZ3MsIHJhX2ZsYWdzOwogCWludCBpLCBqOwogCiAJZm9yIChqID0gYWRhcHRlci0+cHJpdl9u
dW0gLSAxOyBqID49IDA7IC0taikgewpAQCAtOTE4LDYgKzkxOCw5IEBAIG13aWZpZXhfd21tX2dl
dF9oaWdoZXN0X3ByaW9saXN0X3B0cihzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyLAog
CQkJcHJpdl90bXAgPSBic3NwcmlvX25vZGUtPnByaXY7CiAJCQlocXAgPSAmcHJpdl90bXAtPndt
bS5oaWdoZXN0X3F1ZXVlZF9wcmlvOwogCisJCQlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdl90bXAt
PndtbS5yYV9saXN0X3NwaW5sb2NrLAorCQkJCQkgIHJhX2ZsYWdzKTsKKwogCQkJZm9yIChpID0g
YXRvbWljX3JlYWQoaHFwKTsgaSA+PSBMT1dfUFJJT19USUQ7IC0taSkgewogCiAJCQkJdGlkX3B0
ciA9ICYocHJpdl90bXApLT53bW0uCkBAIC05ODMsNiArOTg2LDkgQEAgbXdpZmlleF93bW1fZ2V0
X2hpZ2hlc3RfcHJpb2xpc3RfcHRyKHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIsCiAJ
CQkgKi8KIAkJCWF0b21pY19zZXQoaHFwLCBOT19QS1RfUFJJT19USUQpOwogCisJCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZwcml2X3RtcC0+d21tLnJhX2xpc3Rfc3BpbmxvY2ssCisJCQkJCSAg
ICAgICByYV9mbGFncyk7CisKIAkJCS8qIEdldCBuZXh0IGJzcyBwcmlvcml0eSBub2RlICovCiAJ
CQlic3NwcmlvX25vZGUgPSBsaXN0X2ZpcnN0X2VudHJ5KCZic3NwcmlvX25vZGUtPmxpc3QsCiAJ
CQkJCQlzdHJ1Y3QgbXdpZmlleF9ic3NfcHJpb19ub2RlLApAQCAtMTAwMSwxMCArMTAwNywxMCBA
QCBtd2lmaWV4X3dtbV9nZXRfaGlnaGVzdF9wcmlvbGlzdF9wdHIoc3RydWN0IG13aWZpZXhfYWRh
cHRlciAqYWRhcHRlciwKIAlyZXR1cm4gTlVMTDsKIAogZm91bmQ6Ci0Jc3Bpbl9sb2NrX2lycXNh
dmUoJnByaXZfdG1wLT53bW0ucmFfbGlzdF9zcGlubG9jaywgZmxhZ3MpOworCS8qIGxvY2sgaXMg
c3RpbGwgaGVsZCBoZXJlICovCiAJaWYgKGF0b21pY19yZWFkKGhxcCkgPiBpKQogCQlhdG9taWNf
c2V0KGhxcCwgaSk7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdl90bXAtPndtbS5yYV9s
aXN0X3NwaW5sb2NrLCBmbGFncyk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdl90bXAt
PndtbS5yYV9saXN0X3NwaW5sb2NrLCByYV9mbGFncyk7CiAKIAkqcHJpdiA9IHByaXZfdG1wOwog
CSp0aWQgPSB0b3NfdG9fdGlkW2ldOwo=

--_002_477F20668A386D41ADCC57781B1F70430D9DDAAFDASCVEXCH1marve_--
