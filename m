Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52922 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0HPTQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:16:54 -0400
Received: by qwh6 with SMTP id 6so5282584qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 12:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C698C19.5010902@lwfinger.net>
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com> <4C698C19.5010902@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 16 Aug 2010 21:16:33 +0200
Message-ID: <AANLkTi=eFz5fabN74xbndCvD-XBS-KA9EBiOKAZvcbRb@mail.gmail.com>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015175cb580d9f698048df5ac17
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0015175cb580d9f698048df5ac17
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

2010/8/16 Larry Finger <Larry.Finger@lwfinger.net>:
> On 08/16/2010 12:59 PM, G=E1bor Stefanik wrote:
>> Hello Everyone!
>>
>> If you are experiencing DMA errors on a BCM4312, please test the
>> attached patch. It implements the PCI-E SERDES workaround, which the
>> hybrid driver is applying during early init to LP-PHY cards, and which
>> is a good candidate for the cause of the DMA error.
>> Note that this is not a final patch & it may cause collateral damage
>> for non-4312 cards; if it helps the 4312 problem, I will submit a
>> cleaned-up version.
>
> The patch that you distributed had a couple of errors in compiling, namel=
y:
>
> =A0CC [M] =A0drivers/ssb/driver_pcicore.o
> drivers/ssb/driver_pcicore.c: In function =91ssb_pcie_mdio_set_block=92:
> drivers/ssb/driver_pcicore.c:457:7: error: =91i=92 undeclared (first use =
in this
> function)
> drivers/ssb/driver_pcicore.c:457:7: note: each undeclared identifier is r=
eported
> only once for each function it appears in
> drivers/ssb/driver_pcicore.c: In function =91ssb_pcie_mdio_read=92:
> drivers/ssb/driver_pcicore.c:503:2: error: expected =91;=92 before =91pci=
core_write32=92
> make[2]: *** [drivers/ssb/driver_pcicore.o] Error 1
> make[1]: *** [drivers/ssb] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> Did you forget a quilt refresh?
>
> My machine does not have the DMA error, but I will be testing.
>
> Larry
>

Oops... yes, two nasty typos. I have no idea why it compiled for me...
Schr=F6dinbug?

With that said, here is the corrected version.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

--0015175cb580d9f698048df5ac17
Content-Type: application/octet-stream; name="pcie_serdes_workaround.diff"
Content-Disposition: attachment; filename="pcie_serdes_workaround.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcxphgfy0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3NiL2RyaXZlcl9wY2ljb3JlLmMgYi9kcml2ZXJzL3NzYi9k
cml2ZXJfcGNpY29yZS5jDQppbmRleCAwZThkMzUyLi45ZjVjNWUyIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zc2IvZHJpdmVyX3BjaWNvcmUuYw0KKysrIGIvZHJpdmVycy9zc2IvZHJpdmVyX3BjaWNv
cmUuYw0KQEAgLTQ0NiwxMyArNDQ2LDcxIEBAIHN0YXRpYyB2b2lkIHNzYl9wY2llX3dyaXRlKHN0
cnVjdCBzc2JfcGNpY29yZSAqcGMsIHUzMiBhZGRyZXNzLCB1MzIgZGF0YSkNCiAJcGNpY29yZV93
cml0ZTMyKHBjLCAweDEzNCwgZGF0YSk7DQogfQ0KIA0KK3N0YXRpYyBib29sIHNzYl9wY2llX21k
aW9fc2V0X2Jsb2NrKHN0cnVjdCBzc2JfcGNpY29yZSAqcGMsIHU4IGRldmljZSkNCit7DQorCWNv
bnN0IHUxNiBtZGlvX2NvbnRyb2wgPSAweDEyODsNCisJY29uc3QgdTE2IG1kaW9fZGF0YSA9IDB4
MTJDOw0KKw0KKwlwY2ljb3JlX3dyaXRlMzIocGMsIG1kaW9fZGF0YSwgMHg1N0MyMDAwMCB8IChk
ZXZpY2UgPDwgNCkpOw0KKwl1ZGVsYXkoMTApOw0KKwlpbnQgaTsNCisJZm9yIChpID0gMDsgaSA8
IDIwMDsgaSsrKSB7DQorCQlpZiAocGNpY29yZV9yZWFkMzIocGMsIG1kaW9fY29udHJvbCkgJiAw
eDEwMCkNCisJCQlyZXR1cm4gdHJ1ZTsNCisJCW1zbGVlcCgxKTsNCisJfQ0KKw0KKwlyZXR1cm4g
ZmFsc2U7DQorfQ0KKw0KK3N0YXRpYyB1MTYgc3NiX3BjaWVfbWRpb19yZWFkKHN0cnVjdCBzc2Jf
cGNpY29yZSAqcGMsIHU4IGRldmljZSwNCisJCQkJdTggYWRkcmVzcykNCit7DQorCWNvbnN0IHUx
NiBtZGlvX2NvbnRyb2wgPSAweDEyODsNCisJY29uc3QgdTE2IG1kaW9fZGF0YSA9IDB4MTJDOw0K
Kwl1MzIgdjsNCisJaW50IGksIGltYXg7DQorCXUxNiBkYXRhOw0KKw0KKwl2ID0gMHg4MDsgLyog
RW5hYmxlIFByZWFtYmxlIFNlcXVlbmNlICovDQorCXYgfD0gMHgyOyAvKiBNRElPIENsb2NrIERp
dmlzb3IgKi8NCisJcGNpY29yZV93cml0ZTMyKHBjLCBtZGlvX2NvbnRyb2wsIHYpOw0KKw0KKwl2
ID0gKDEgPDwgMzApOyAvKiBTdGFydCBvZiBUcmFuc2FjdGlvbiAqLw0KKwl2IHw9ICgxIDw8IDI5
KTsgLyogUmVhZCBUcmFuc2FjdGlvbiAqLw0KKwl2IHw9ICgxIDw8IDE3KTsgLyogVHVybmFyb3Vu
ZCAqLw0KKw0KKwlpZiAocGMtPmRldi0+aWQucmV2aXNpb24gPj0gMTApIHsNCisJCWlmICghc3Ni
X3BjaWVfbWRpb19zZXRfYmxvY2socGMsIGRldmljZSkpDQorCQkJcmV0dXJuIDA7DQorCQlpbWF4
ID0gMjAwOw0KKwl9IGVsc2Ugew0KKwkJdiB8PSAodTMyKWRldmljZSA8PCAyMjsNCisJCWltYXgg
PSAxMDsNCisJfQ0KKwl2IHw9ICh1MzIpYWRkcmVzcyA8PCAxODsNCisJcGNpY29yZV93cml0ZTMy
KHBjLCBtZGlvX2RhdGEsIHYpOw0KKwkvKiBXYWl0IGZvciB0aGUgZGV2aWNlIHRvIGNvbXBsZXRl
IHRoZSB0cmFuc2FjdGlvbiAqLw0KKwl1ZGVsYXkoMTApOw0KKwlmb3IgKGkgPSAwOyBpIDwgaW1h
eDsgaSsrKSB7DQorCQl2ID0gcGNpY29yZV9yZWFkMzIocGMsIG1kaW9fY29udHJvbCk7DQorCQlp
ZiAodiAmIDB4MTAwIC8qIFRyYW5zIGNvbXBsZXRlICovKQ0KKwkJCWJyZWFrOw0KKwkJbXNsZWVw
KDEpOw0KKwl9DQorCXVkZWxheSgxMCk7DQorCWRhdGEgPSBwY2ljb3JlX3JlYWQzMihwYywgbWRp
b19kYXRhKSAmIDB4RkZGRjsNCisJcGNpY29yZV93cml0ZTMyKHBjLCBtZGlvX2NvbnRyb2wsIDAp
Ow0KKwlyZXR1cm4gZGF0YTsNCit9DQorDQogc3RhdGljIHZvaWQgc3NiX3BjaWVfbWRpb193cml0
ZShzdHJ1Y3Qgc3NiX3BjaWNvcmUgKnBjLCB1OCBkZXZpY2UsDQogCQkJCXU4IGFkZHJlc3MsIHUx
NiBkYXRhKQ0KIHsNCiAJY29uc3QgdTE2IG1kaW9fY29udHJvbCA9IDB4MTI4Ow0KIAljb25zdCB1
MTYgbWRpb19kYXRhID0gMHgxMkM7DQogCXUzMiB2Ow0KLQlpbnQgaTsNCisJaW50IGksIGltYXg7
DQogDQogCXYgPSAweDgwOyAvKiBFbmFibGUgUHJlYW1ibGUgU2VxdWVuY2UgKi8NCiAJdiB8PSAw
eDI7IC8qIE1ESU8gQ2xvY2sgRGl2aXNvciAqLw0KQEAgLTQ2MSwxMyArNTE5LDIxIEBAIHN0YXRp
YyB2b2lkIHNzYl9wY2llX21kaW9fd3JpdGUoc3RydWN0IHNzYl9wY2ljb3JlICpwYywgdTggZGV2
aWNlLA0KIAl2ID0gKDEgPDwgMzApOyAvKiBTdGFydCBvZiBUcmFuc2FjdGlvbiAqLw0KIAl2IHw9
ICgxIDw8IDI4KTsgLyogV3JpdGUgVHJhbnNhY3Rpb24gKi8NCiAJdiB8PSAoMSA8PCAxNyk7IC8q
IFR1cm5hcm91bmQgKi8NCi0JdiB8PSAodTMyKWRldmljZSA8PCAyMjsNCisJDQorCWlmIChwYy0+
ZGV2LT5pZC5yZXZpc2lvbiA+PSAxMCkgew0KKwkJaWYgKCFzc2JfcGNpZV9tZGlvX3NldF9ibG9j
ayhwYywgZGV2aWNlKSkNCisJCQlyZXR1cm47DQorCQlpbWF4ID0gMjAwOw0KKwl9IGVsc2Ugew0K
KwkJdiB8PSAodTMyKWRldmljZSA8PCAyMjsNCisJCWltYXggPSAxMDsNCisJfQ0KIAl2IHw9ICh1
MzIpYWRkcmVzcyA8PCAxODsNCiAJdiB8PSBkYXRhOw0KIAlwY2ljb3JlX3dyaXRlMzIocGMsIG1k
aW9fZGF0YSwgdik7DQogCS8qIFdhaXQgZm9yIHRoZSBkZXZpY2UgdG8gY29tcGxldGUgdGhlIHRy
YW5zYWN0aW9uICovDQogCXVkZWxheSgxMCk7DQotCWZvciAoaSA9IDA7IGkgPCAxMDsgaSsrKSB7
DQorCWZvciAoaSA9IDA7IGkgPCBpbWF4OyBpKyspIHsNCiAJCXYgPSBwY2ljb3JlX3JlYWQzMihw
YywgbWRpb19jb250cm9sKTsNCiAJCWlmICh2ICYgMHgxMDAgLyogVHJhbnMgY29tcGxldGUgKi8p
DQogCQkJYnJlYWs7DQpAQCAtNTkxLDYgKzY1NywyMCBAQCBpbnQgc3NiX3BjaWNvcmVfZGV2X2ly
cXZlY3NfZW5hYmxlKHN0cnVjdCBzc2JfcGNpY29yZSAqcGMsDQogCQkJdG1wID0gc3NiX3BjaWVf
cmVhZChwYywgMHgxMDApOw0KIAkJCXRtcCB8PSAweDQwOw0KIAkJCXNzYl9wY2llX3dyaXRlKHBj
LCAweDEwMCwgdG1wKTsNCisJCX0gZWxzZSB7DQorCQkJY29uc3QgdTggc2VyZGVzX3BsbF9kZXZp
Y2UgPSAweDFEOw0KKwkJCWNvbnN0IHU4IHNlcmRlc19yeF9kZXZpY2UgPSAweDFGOw0KKw0KKwkJ
CS8qIFBDSS1FIFBIWSBTdGF0dXMgcmVnaXN0ZXIgKi8NCisJCQlpZiAoc3NiX3BjaWVfcmVhZChw
YywgMHgyMDQpICYgMHgxMCkNCisJCQkJc3NiX3BjaWVfbWRpb193cml0ZShwYywgc2VyZGVzX3J4
X2RldmljZSwNCisJCQkJCQkgICAgMSAvKiBDb250cm9sICovLCAweEMwKTsNCisJCQllbHNlDQor
CQkJCXNzYl9wY2llX21kaW9fd3JpdGUocGMsIHNlcmRlc19yeF9kZXZpY2UsDQorCQkJCQkJICAg
IDEgLyogQ29udHJvbCAqLywgMHg4MCk7DQorCQkJc3NiX3BjaWVfbWRpb193cml0ZShwYywgc2Vy
ZGVzX3BsbF9kZXZpY2UsIDEsDQorCQkJCXNzYl9wY2llX21kaW9fcmVhZChwYywgc2VyZGVzX3Bs
bF9kZXZpY2UsIDEpICYNCisJCQkJfjB4NDAwMCk7DQogCQl9DQogCX0NCiAJcGMtPnNldHVwX2Rv
bmUgPSAxOw0K
--0015175cb580d9f698048df5ac17--
