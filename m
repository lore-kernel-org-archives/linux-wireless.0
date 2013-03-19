Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:57085 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416Ab3CSWiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 18:38:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Daniel Mack <daniel@zonque.org>
Date: Tue, 19 Mar 2013 15:37:52 -0700
Subject: RE: mwifiex: infinite loop in mwifiex_main_process
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DBCE43F@SC-VEXCH1.marvell.com> (sfid-20130319_233814_451338_0D5A2F1A)
References: <20130319095235.GA22962@blumentopf>
In-Reply-To: <20130319095235.GA22962@blumentopf>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D9DBCE43FSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D9DBCE43FSCVEXCH1marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Andi,

> Hi,
>=20
> I'm working on this, currently testing it
> http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg17726.html
>=20
> Within less than 3 days, the module always crashes. I observe
> that mwifiex is looping in mwifiex_main_process, not exiting. The
> loop is always entered from the sdio_irq_thread.
>=20
> I put printk statement to find cause for why it's not exiting:
>=20
> [18017.211513] scan processing 0
> [18017.214686] data sent 0
> [18017.217269] ps state 0
> [18017.219765] cmd sent 0 / curr cmd   (null)
> [18017.224134] is_command_pending 0
> [18017.227548] wmm list empty 0
> [18017.230592] tx_lock_flag 0
>=20
> So it seems the wmm list has packets queued, but they are never
> sent out. Adding a few more statements, it seems the problem is
> in mwifiex_wmm_get_highest_priolist_ptr:
>=20
> 	for (j =3D adapter->priv_num - 1; j >=3D 0; --j) {
>=20
> 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
> 				flags);
> 		is_list_empty =3D list_empty(&adapter->bss_prio_tbl[j]
> 				.bss_prio_head);
> 		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
> 				flags);
> 		if (is_list_empty)
> 			continue;
>=20
> 		.... <snip> ...
>=20
> 		do {
> 			priv_tmp =3D bssprio_node->priv;
> 			hqp =3D &priv_tmp->wmm.highest_queued_prio;
>=20
> 			for (i =3D atomic_read(hqp); i >=3D LOW_PRIO_TID;
> 					--i) {
> 			...
> 			... NEVER REACHED ...
> 			...
>=20
>=20
> So there are packets queued, but the highest_queued_prio is too
> low, so they are never sent out.

Could you apply the debug patch attached to print out hqp number?

>=20
> I was never able to crash it without my patches, though trying
> harder now. But maybe my patches only trigger the issue more
> often.
>=20
> Is there a known issue, with highest_queued_prio getting out of
> sync with the number of packets queued?

I'm not aware of any known issue related to highest_queued_prio.

Regards,
Bing




--_002_477F20668A386D41ADCC57781B1F70430D9DBCE43FSCVEXCH1marve_
Content-Type: application/octet-stream; name="wmm_hqp_debug.diff"
Content-Description: wmm_hqp_debug.diff
Content-Disposition: attachment; filename="wmm_hqp_debug.diff"; size=1435;
	creation-date="Tue, 19 Mar 2013 22:12:16 GMT";
	modification-date="Tue, 19 Mar 2013 22:12:16 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvd21tLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9td2lmaWV4L3dtbS5jCmluZGV4IDMyYWRjODcuLmQ5M2QwZDcgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvd21tLmMKKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbXdpZmlleC93bW0uYwpAQCAtOTIxLDYgKzkyMSw3IEBAIG13aWZpZXhfd21t
X2dldF9oaWdoZXN0X3ByaW9saXN0X3B0cihzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVy
LAogCQkJcHJpdl90bXAgPSBic3NwcmlvX25vZGUtPnByaXY7CiAJCQlocXAgPSAmcHJpdl90bXAt
PndtbS5oaWdoZXN0X3F1ZXVlZF9wcmlvOwogCisJCQlwcl9pbmZvKCIlczogbG9vcCBocXA9JWRc
biIsIF9fZnVuY19fLCBhdG9taWNfcmVhZChocXApKTsKIAkJCWZvciAoaSA9IGF0b21pY19yZWFk
KGhxcCk7IGkgPj0gTE9XX1BSSU9fVElEOyAtLWkpIHsKIAogCQkJCXRpZF9wdHIgPSAmKHByaXZf
dG1wKS0+d21tLgpAQCAtOTg0LDcgKzk4NSw5IEBAIG13aWZpZXhfd21tX2dldF9oaWdoZXN0X3By
aW9saXN0X3B0cihzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyLAogCQkJICogdG8gc2tp
cCBjaGVja2luZyBUSURzIGZvciB0aGlzIHByaXYgKHVudGlsIHBrdCBpcwogCQkJICogYWRkZWQp
LgogCQkJICovCisJCQlwcl9pbmZvKCIlczogb2xkIGhxcD0lZFxuIiwgX19mdW5jX18sIGF0b21p
Y19yZWFkKGhxcCkpOwogCQkJYXRvbWljX3NldChocXAsIE5PX1BLVF9QUklPX1RJRCk7CisJCQlw
cl9pbmZvKCIlczogbm8gcGt0IGhxcD0lZFxuIiwgX19mdW5jX18sIGF0b21pY19yZWFkKGhxcCkp
OwogCiAJCQkvKiBHZXQgbmV4dCBic3MgcHJpb3JpdHkgbm9kZSAqLwogCQkJYnNzcHJpb19ub2Rl
ID0gbGlzdF9maXJzdF9lbnRyeSgmYnNzcHJpb19ub2RlLT5saXN0LApAQCAtMTAwNCwxMCArMTAw
NywxMiBAQCBtd2lmaWV4X3dtbV9nZXRfaGlnaGVzdF9wcmlvbGlzdF9wdHIoc3RydWN0IG13aWZp
ZXhfYWRhcHRlciAqYWRhcHRlciwKIAlyZXR1cm4gTlVMTDsKIAogZm91bmQ6CisJcHJfaW5mbygi
JXM6IGZvdW5kIGhxcD0lZCBpPSVkXG4iLCBfX2Z1bmNfXywgYXRvbWljX3JlYWQoaHFwKSwgaSk7
CiAJc3Bpbl9sb2NrX2lycXNhdmUoJnByaXZfdG1wLT53bW0ucmFfbGlzdF9zcGlubG9jaywgZmxh
Z3MpOwogCWlmIChhdG9taWNfcmVhZChocXApID4gaSkKIAkJYXRvbWljX3NldChocXAsIGkpOwog
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXZfdG1wLT53bW0ucmFfbGlzdF9zcGlubG9jaywg
ZmxhZ3MpOworCXByX2luZm8oIiVzOiByZXR1cm4gaHFwPSVkIGk9JWRcbiIsIF9fZnVuY19fLCBh
dG9taWNfcmVhZChocXApLCBpKTsKIAogCSpwcml2ID0gcHJpdl90bXA7CiAJKnRpZCA9IHRvc190
b190aWRbaV07Cg==

--_002_477F20668A386D41ADCC57781B1F70430D9DBCE43FSCVEXCH1marve_--
