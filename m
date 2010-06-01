Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:44084 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0FAT7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 15:59:17 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Date: Tue, 01 Jun 2010 21:29:38 +0200
MIME-Version: 1.0
Content-type: Multipart/Mixed; boundary=Message-Boundary-18013
Subject: Re: Association problems - again - comment
CC: johannes.berg@intel.com
Message-ID: <4C055FA2.23990.223BFA@jafojtik.seznam.cz>
In-reply-to: <AANLkTimRxjfvS_6cR7ZN3yim3TO9GcPwJ59L3HZzpVmy@mail.gmail.com>
References: <4C02E1CA.10757.239262@jafojtik.seznam.cz>, <AANLkTimRxjfvS_6cR7ZN3yim3TO9GcPwJ59L3HZzpVmy@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Message-Boundary-18013
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Content-description: Mail message body

Dear Bob,

I have found a solution for my problem.

Patch from "Johannes Berg <johannes.berg@intel.com>" fixes a problem.

#Processing an association response could take a bit
#of time while we set up the hardware etc. During that
#time, the AP might already send a blockack request.
#If this happens very quickly on a fairly slow machine,
#we can end up processing the blockack request before
#the association processing has finished. Since the
#blockack processing cannot sleep right now, we also
#cannot make it wait in the driver.


> > I have found that ATH5k has severe problems during association to AP.
> > Sometimes it needs more than 100 attempts to association, before it connects
> > to AP.
> Did it work in previous kernels?
     The association has beed bad - 2 to 5 attempts needed, 
but not 150. So previous kernels did not behave so wrong.
 
> You said you reverted 6b5d117eddc09cd976ad8030d715f4 and still have the
> problem, right?  Are you sure you booted the kernel with the revert?
Yes, because I have ATH5k inside modules. And when I type:

make KLIB=/usr/src/linux-2.6.32.11 KLIB_BUILD=/usr/src/linux-2.6.32.11
make KLIB=/usr/src/linux-2.6.32.11 KLIB_BUILD=/usr/src/linux-2.6.32.11 KMODPATH_ARG='INSTALL_MOD_PATH=' install

Modules in /lib/modules are updated.

 
> > [  149.926717] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 1)
> > [  150.013353] eth3: no IPv6 routers present
> > [  150.126699] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 2)
> > [  150.326707] wlan1: direct probe to 00:15:6d:d6:2a:9d (try 3)
> > [  150.526696] wlan1: direct probe to 00:15:6d:d6:2a:9d timed out
> 
> Probably traffic is not being sent or received from one side.
But when association is done (after 150 attempts), the client runs without any packetloss
without any problems.

regards
   Jara


> -- 
> Bob Copeland %% www.bobcopeland.com



--Message-Boundary-18013
Content-type: Application/Octet-stream; name="patch_wireless.txt"; type=Text
Content-disposition: attachment; filename="patch_wireless.txt"
Content-transfer-encoding: BASE64

LS0tDQogbmV0L21hYzgwMjExL21sbWUuYyB8ICAgNTIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQ0KIG5ldC9tYWM4MDIxMS9yeC5jICAg
fCAgICAzICsrKw0KIDIgZmlsZXMgY2hhbmdlZCwgNDggaW5zZXJ0aW9ucygrKSwgNyBkZWxl
dGlvbnMoLSkNCg0KLS0tIHdpcmVsZXNzLXRlc3Rpbmcub3JpZy9uZXQvbWFjODAyMTEvbWxt
ZS5jCTIwMTAtMDUtMjggMTU6MTA6MjkuMDAwMDAwMDAwICswMjAwDQorKysgd2lyZWxlc3Mt
dGVzdGluZy9uZXQvbWFjODAyMTEvbWxtZS5jCTIwMTAtMDUtMjggMTU6MTI6MDQuMDAwMDAw
MDAwICswMjAwDQpAQCAtMTY5MiwxNCArMTY5Miw1MiBAQCBzdGF0aWMgdm9pZCBpZWVlODAy
MTFfc3RhX3J4X3F1ZXVlZF9tZ210DQogICAgcm1hID0gaWVlZTgwMjExX3J4X21nbXRfZGlz
YXNzb2Moc2RhdGEsIG1nbXQsIHNrYi0+bGVuKTsNCiAgICBicmVhazsNCiAgIGNhc2UgSUVF
RTgwMjExX1NUWVBFX0FDVElPTjoNCi0JCQlpZiAobWdtdC0+dS5hY3Rpb24uY2F0ZWdvcnkg
IT0gV0xBTl9DQVRFR09SWV9TUEVDVFJVTV9NR01UKQ0KLQkJCQlicmVhazsNCisJCQlzd2l0
Y2ggKG1nbXQtPnUuYWN0aW9uLmNhdGVnb3J5KSB7DQorCQkJY2FzZSBXTEFOX0NBVEVHT1JZ
X0JBQ0s6IHsNCisJCQkJc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwgPSBzZGF0YS0+
bG9jYWw7DQorCQkJCWludCBsZW4gPSBza2ItPmxlbjsNCisJCQkJc3RydWN0IHN0YV9pbmZv
ICpzdGE7DQoNCi0JCQlpZWVlODAyMTFfc3RhX3Byb2Nlc3NfY2hhbnN3aXRjaChzZGF0YSwN
Ci0JCQkJCSZtZ210LT51LmFjdGlvbi51LmNoYW5fc3dpdGNoLnN3X2VsZW0sDQotCQkJCQko
dm9pZCAqKWlmbWdkLT5hc3NvY2lhdGVkLT5wcml2LA0KLQkJCQkJcnhfc3RhdHVzLT5tYWN0
aW1lKTsNCi0JCQlicmVhazsNCisJCQkJcmN1X3JlYWRfbG9jaygpOw0KKwkJCQlzdGEgPSBz
dGFfaW5mb19nZXQoc2RhdGEsIG1nbXQtPnNhKTsNCisJCQkJaWYgKCFzdGEpIHsNCisJCQkJ
CXJjdV9yZWFkX3VubG9jaygpOw0KKwkJCQkJYnJlYWs7DQorCQkJCX0NCisNCisJCQkJbG9j
YWxfYmhfZGlzYWJsZSgpOw0KKw0KKwkJCQlzd2l0Y2ggKG1nbXQtPnUuYWN0aW9uLnUuYWRk
YmFfcmVxLmFjdGlvbl9jb2RlKSB7DQorCQkJCWNhc2UgV0xBTl9BQ1RJT05fQUREQkFfUkVR
Og0KKwkJCQkJaWYgKGxlbiA8IChJRUVFODAyMTFfTUlOX0FDVElPTl9TSVpFICsNCisJCQkJ
CQkgICBzaXplb2YobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEpKSkNCisJCQkJCQlicmVh
azsNCisJCQkJCWllZWU4MDIxMV9wcm9jZXNzX2FkZGJhX3JlcXVlc3QobG9jYWwsIHN0YSwg
bWdtdCwgbGVuKTsNCisJCQkJCWJyZWFrOw0KKwkJCQljYXNlIFdMQU5fQUNUSU9OX0FEREJB
X1JFU1A6DQorCQkJCQlpZiAobGVuIDwgKElFRUU4MDIxMV9NSU5fQUNUSU9OX1NJWkUgKw0K
KwkJCQkJCSAgIHNpemVvZihtZ210LT51LmFjdGlvbi51LmFkZGJhX3Jlc3ApKSkNCisJCQkJ
CQlicmVhazsNCisJCQkJCWllZWU4MDIxMV9wcm9jZXNzX2FkZGJhX3Jlc3AobG9jYWwsIHN0
YSwgbWdtdCwgbGVuKTsNCisJCQkJCWJyZWFrOw0KKwkJCQljYXNlIFdMQU5fQUNUSU9OX0RF
TEJBOg0KKwkJCQkJaWYgKGxlbiA8IChJRUVFODAyMTFfTUlOX0FDVElPTl9TSVpFICsNCisJ
CQkJCQkgICBzaXplb2YobWdtdC0+dS5hY3Rpb24udS5kZWxiYSkpKQ0KKwkJCQkJCWJyZWFr
Ow0KKwkJCQkJaWVlZTgwMjExX3Byb2Nlc3NfZGVsYmEoc2RhdGEsIHN0YSwgbWdtdCwgbGVu
KTsNCisJCQkJCWJyZWFrOw0KKwkJCQl9DQorCQkJCWxvY2FsX2JoX2VuYWJsZSgpOw0KKwkJ
CQlyY3VfcmVhZF91bmxvY2soKTsNCisJCQkJYnJlYWs7DQorCQkJCX0NCisJCQljYXNlIFdM
QU5fQ0FURUdPUllfU1BFQ1RSVU1fTUdNVDoNCisJCQkJaWVlZTgwMjExX3N0YV9wcm9jZXNz
X2NoYW5zd2l0Y2goc2RhdGEsDQorCQkJCQkJJm1nbXQtPnUuYWN0aW9uLnUuY2hhbl9zd2l0
Y2guc3dfZWxlbSwNCisJCQkJCQkodm9pZCAqKWlmbWdkLT5hc3NvY2lhdGVkLT5wcml2LA0K
KwkJCQkJCXJ4X3N0YXR1cy0+bWFjdGltZSk7DQorCQkJCWJyZWFrOw0KKwkJCX0NCiAgIH0N
CiAgIG11dGV4X3VubG9jaygmaWZtZ2QtPm10eCk7DQoNCi0tLSB3aXJlbGVzcy10ZXN0aW5n
Lm9yaWcvbmV0L21hYzgwMjExL3J4LmMJMjAxMC0wNS0yOCAxNDoyMjo1OS4wMDAwMDAwMDAg
KzAyMDANCisrKyB3aXJlbGVzcy10ZXN0aW5nL25ldC9tYWM4MDIxMS9yeC5jCTIwMTAtMDUt
MjggMTU6MTE6NDcuMDAwMDAwMDAwICswMjAwDQpAQCAtMTkzNiw2ICsxOTM2LDkgQEAgaWVl
ZTgwMjExX3J4X2hfYWN0aW9uKHN0cnVjdCBpZWVlODAyMTFfcg0KICAgaWYgKGxlbiA8IElF
RUU4MDIxMV9NSU5fQUNUSU9OX1NJWkUgKyAxKQ0KICAgIGJyZWFrOw0KDQorCQlpZiAoc2Rh
dGEtPnZpZi50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pDQorCQkJcmV0dXJuIGll
ZWU4MDIxMV9zdGFfcnhfbWdtdChzZGF0YSwgcngtPnNrYik7DQorDQogICBzd2l0Y2ggKG1n
bXQtPnUuYWN0aW9uLnUuYWRkYmFfcmVxLmFjdGlvbl9jb2RlKSB7DQogICBjYXNlIFdMQU5f
QUNUSU9OX0FEREJBX1JFUToNCiAgICBpZiAobGVuIDwgKElFRUU4MDIxMV9NSU5fQUNUSU9O
X1NJWkUgKw0K

--Message-Boundary-18013--
