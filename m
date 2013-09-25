Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65370 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab3IYQUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 12:20:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Mack <zonque@gmail.com>, Paul Stewart <pstew@google.com>,
	Dylan Reid <dgreid@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Wed, 25 Sep 2013 09:19:42 -0700
Subject: RE: [PATCH 3.12] mwifiex: queue main work from main process when
 bailing on races
Message-ID: <477F20668A386D41ADCC57781B1F70430F45077CCF@SC-VEXCH1.marvell.com> (sfid-20130925_221644_339414_6BDC0FD6)
References: <1379442330-18249-1-git-send-email-zonque@gmail.com>
 <477F20668A386D41ADCC57781B1F70430F44C5880A@SC-VEXCH1.marvell.com>
 <5242F1D7.4040404@gmail.com>
In-Reply-To: <5242F1D7.4040404@gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430F45077CCFSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430F45077CCFSCVEXCH1marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> > Acked-by: Bing Zhao <bzhao@marvell.com>
>=20
> John, could you pick this one?

We found that this patch causes CPU utilization issue on Chromebooks.
Could you please try attached patch on your platform? Basically this patch =
reverts your change and add main_proc_lock protection for int_status and IS=
_CARD_RX_RCVD access to avoid the missing interrupt handling.

Thanks,
Bing
=20

--_002_477F20668A386D41ADCC57781B1F70430F45077CCFSCVEXCH1marve_
Content-Type: application/octet-stream;
	name="0001-mwifiex-avoid-redundant-main-process-queueing.patch"
Content-Description: 0001-mwifiex-avoid-redundant-main-process-queueing.patch
Content-Disposition: attachment;
	filename="0001-mwifiex-avoid-redundant-main-process-queueing.patch";
	size=1965; creation-date="Wed, 25 Sep 2013 16:19:23 GMT";
	modification-date="Wed, 25 Sep 2013 16:19:23 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0M2IzZmNiM2U1OGI2ZDEwYjcwYzA4ZjViMjI1OWE2NGExOTVmMWE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2FyQG1hcnZlbGwuY29t
PgpEYXRlOiBXZWQsIDI1IFNlcCAyMDEzIDIxOjIxOjI5ICswNTMwClN1YmplY3Q6IFtQQVRDSF0g
bXdpZmlleDogYXZvaWQgcmVkdW5kYW50IG1haW4gcHJvY2VzcyBxdWV1ZWluZwoKQXMgd2UgdXNl
IHNpbmdsZSB0aHJlYWRlZCB3b3JrcXVldWUsIHRoZSBvbmx5IHBvc3NpYmxpdHkKZm9yIGNvbmN1
cnJlbnQgbXdpZmlleF9tYWluX3Byb2Nlc3MoKSBjYWxscyBpcyBkdXJpbmcgU0RJTwppbnRlcnJ1
cHRzIHdoZXJlIHRoZSByb3V0aW5lIGlzIGRpcmVjdGx5IGNhbGxlZC4KClJlY2VudGx5IHF1ZXVl
X3dvcmsoKSBjYWxsIGlzIGFkZGVkIHRvIGZpeCBjb3JuZXIgY2FzZQpTRElPIGludGVycnVwdCBs
b3N0IGlzc3VlLiBXaXRoIHRoaXMgY2hhbmdlIG1haW4gcHJvY2VzcwppcyBzb21ldGltZXMgdW5u
ZWNlc3NhcmlseSBxdWV1ZWQgbXVsdGlwbGUgdGltZXMgd2hpY2ggcmVzdWx0cwppbiBpbmNyZWFz
ZWQgQ1BVIHV0aWxpemF0aW9uLgoKVGhpcyBwYXRjaCBtYWtlcyBzdXJlIHRoYXQgY3VycmVudGx5
IHJ1bm5pbmcgbWFpbiBwcm9jZXNzCndpbGwgYWx3YXlzIHRha2UgY2FyZSBvZiBwZW5kaW5nIGlu
dGVycnVwdHMuIFdlIGRvbid0IG5lZWQgdG8KcXVldWUgYW4gZXh0cmEgbWFpbiBwcm9jZXNzLiBU
aGlzIGZpeGVzIGludGVycnVwdCBsb3N0IGlzc3VlLgoKU2lnbmVkLW9mZi1ieTogQW1pdGt1bWFy
IEthcndhciA8YWthcndhckBtYXJ2ZWxsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9t
d2lmaWV4L21haW4uYyB8ICAgIDcgKysrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bXdpZmlleC9tYWluLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L21haW4uYwppbmRl
eCA1MTZiODBlLi5kZDY1NDhlIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lm
aWV4L21haW4uYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L21haW4uYwpAQCAt
MjM1LDcgKzIzNSw2IEBAIGludCBtd2lmaWV4X21haW5fcHJvY2VzcyhzdHJ1Y3QgbXdpZmlleF9h
ZGFwdGVyICphZGFwdGVyKQogCS8qIENoZWNrIGlmIGFscmVhZHkgcHJvY2Vzc2luZyAqLwogCWlm
IChhZGFwdGVyLT5td2lmaWV4X3Byb2Nlc3NpbmcpIHsKIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmYWRhcHRlci0+bWFpbl9wcm9jX2xvY2ssIGZsYWdzKTsKLQkJcXVldWVfd29yayhhZGFwdGVy
LT53b3JrcXVldWUsICZhZGFwdGVyLT5tYWluX3dvcmspOwogCQlnb3RvIGV4aXRfbWFpbl9wcm9j
OwogCX0gZWxzZSB7CiAJCWFkYXB0ZXItPm13aWZpZXhfcHJvY2Vzc2luZyA9IHRydWU7CkBAIC0z
NTksMTAgKzM1OCwxMiBAQCBwcm9jZXNzX3N0YXJ0OgogCQl9CiAJfSB3aGlsZSAodHJ1ZSk7CiAK
LQlpZiAoKGFkYXB0ZXItPmludF9zdGF0dXMpIHx8IElTX0NBUkRfUlhfUkNWRChhZGFwdGVyKSkK
KwlzcGluX2xvY2tfaXJxc2F2ZSgmYWRhcHRlci0+bWFpbl9wcm9jX2xvY2ssIGZsYWdzKTsKKwlp
ZiAoKGFkYXB0ZXItPmludF9zdGF0dXMpIHx8IElTX0NBUkRfUlhfUkNWRChhZGFwdGVyKSkgewor
CQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZhZGFwdGVyLT5tYWluX3Byb2NfbG9jaywgZmxhZ3Mp
OwogCQlnb3RvIHByb2Nlc3Nfc3RhcnQ7CisJfQogCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJmFkYXB0
ZXItPm1haW5fcHJvY19sb2NrLCBmbGFncyk7CiAJYWRhcHRlci0+bXdpZmlleF9wcm9jZXNzaW5n
ID0gZmFsc2U7CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWRhcHRlci0+bWFpbl9wcm9jX2xv
Y2ssIGZsYWdzKTsKIAotLSAKMS43LjMuNAoK

--_002_477F20668A386D41ADCC57781B1F70430F45077CCFSCVEXCH1marve_--
