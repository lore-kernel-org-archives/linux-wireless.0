Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42881 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2H1N6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 09:58:03 -0400
Received: by obbuo13 with SMTP id uo13so10434286obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 06:58:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346161526.3808.5.camel@inferno>
References: <1346146736.3087.12.camel@inferno>
	<CAD2nsn0uis8_GnNnR2p84TkDmphPoHe9LGTn2TNNZ18tCBxkog@mail.gmail.com>
	<1346161526.3808.5.camel@inferno>
Date: Tue, 28 Aug 2012 19:28:02 +0530
Message-ID: <CAD2nsn0cyiFj-obgtZt1JDt7f9o_+Yk0i3uZAt8DweLKKPxeRQ@mail.gmail.com> (sfid-20120828_155808_459696_D181D7C4)
Subject: Re: ath9k AR9287 freeze linux system
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-1?B?THXtcyBE7WF6IEdvbnrhbGV6?= <luis.hlodwig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d0447f2ceb17ae004c853d4dd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d0447f2ceb17ae004c853d4dd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2012 at 7:15 PM, Lu=EDs D=EDaz Gonz=E1lez
<luis.hlodwig@gmail.com> wrote:
> El mar, 28-08-2012 a las 19:08 +0530, Mohammed Shafi escribi=F3:
>> Hi,
>>
>> On Tue, Aug 28, 2012 at 3:08 PM, Lu=EDs D=EDaz Gonz=E1lez
>> <luis.hlodwig@gmail.com> wrote:
>> > The last two releases compat-wireless (2012-08-26 and 2012-08-27) free=
ze
>> > my linux system.
>>
>> thanks for reporting.
>> *Please provide some information/call trace if you can get(you can
>> attach a photograph of the trace :) )
>> *like what did you do(sending traffic, suspend resume, keep the
>> station idle?) to see the freeze.
>> *I would try to recreate in my ubuntu 2.6.32.. kernel.
>> *are you using btcoex in the driver sudo modprobe ath9k btcoex_enable=3D=
1  ?
>
> Yes, I'm using btcoex, when I disabled it, all works again.

please try the attached patch sent today,
http://comments.gmane.org/gmane.linux.kernel.wireless.general/96629
you have go to your compat-wireless folder
cd compat-wireless...
then do patch -p1 <  /home/myname/fix-bt.patch

assuming the patch is in /home/myname/fix-bt.patch

do
make clean && make && sudo make install

sudo make unload
sudo modprobe -v ath9k btcoex_enable=3D1



>
>>
>>
>> >
>> > I'm not a developer, I'm a simple user
>> >
>> > Debian Squeeze 2.6.32
>> > wireless card  AR9287
>> >
>> >
>> > thanks,
>> > luis
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wirele=
ss" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>



--=20
thanks,
shafi

--f46d0447f2ceb17ae004c853d4dd
Content-Type: application/octet-stream;
	name="0001-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch"
Content-Disposition: attachment;
	filename="0001-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h6f2959u0

RnJvbSA5NzI0NGEwNWNhYjNiZjdjYzkwZGIyOWNkZWYwZmRmNmE5YTM0ZjNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBTaGFmaSBTaGFqYWtoYW4gPG1vaGFtbWVkQHFj
YS5xdWFsY29tbS5jb20+CkRhdGU6IFR1ZSwgMjggQXVnIDIwMTIgMTE6NTg6MDQgKzA1MzAKU3Vi
amVjdDogW1BBVENIXSBhdGg5azogRml4IGEgY3Jhc2ggaW4gMiBXSVJFIGJ0Y29leCBjaGlwc2V0
cwoKR2VuZXJpYyB0aW1lcnMgZm9yIEJUQ09FWCBmdW5jdGlvbmFsaXR5IGlzIGFwcGxpY2FibGUK
b25seSBmb3IgMyBXSVJFIEJUQ09FWCAoYW5kIE1DSSkgY2hpcHNldHMuCkhlbmNlIGJ0Y29leC0+
bm9fc3RvbXBfdGltZXIgaXMgYWxsb2NhdGVkIG9ubHkgMyBXSVJFCmJ0Y29leCBjaGlwc2V0cyBh
bmQgaW4gYWxsIHRoZSBvdGhlciBjYXNlcyBpdHMgTlVMTC4KTWFrZSBzdXJlIHdlIHN0b3AgdGhl
IGdlbmVyaWMgdGltZXIgb25seSBpZgonYnRjb2V4LT5od190aW1lcl9lbmFibGVkJyBpcyB0cnVl
KG9ubHkgaWYgaXRzIHVwIGFuZApydW5uaW5nKQoKRml4ZXMgdGhlIGZvbGxvd2luZyBjcmFzaAoK
CVs2ODc1Ny4wMjA0NTRdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVy
IGRlcmVmZXJlbmNlIGF0IDAwMDAwMDBjCglbNjg3NTcuMDIwOTE2XSBJUDogWzxmOWIwNTVjMz5d
IGF0aDlrX2h3X2dlbl90aW1lcl9zdG9wKzB4MTMvMHg4MCBbYXRoOWtfaHddCglbNjg3NTcuMDIx
MjUxXSAqcGRlID0gMDAwMDAwMDAKCVs2ODc1Ny4wMjQzODRdIEVJUDogMDA2MDpbPGY5YjA1NWMz
Pl0gRUZMQUdTOiAwMDAxMDA4MiBDUFU6IDAKCVs2ODc1Ny4wMjQzODRdIEVJUCBpcyBhdCBhdGg5
a19od19nZW5fdGltZXJfc3RvcCsweDEzLzB4ODAgW2F0aDlrX2h3XQoJWzY4NzU3LjAyNDM4NF0g
RUFYOiBkMzJkMDAwMCBFQlg6IGQzMmQwMDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMAoJ
WzY4NzU3LjAyNDM4NF0gRVNJOiBlNjdjMjRjMCBFREk6IDAwMDAwMjk2IEVCUDogZTEzN2JlMmMg
RVNQOiBlMTM3YmUyMAoJWzY4NzU3LjAyNDM4NF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4
IEdTOiAwMGUwIFNTOiAwMDY4CglbNjg3NTcuMDI0Mzg0XSBDUjA6IDgwMDUwMDNiIENSMjogMDAw
MDAwMGMgQ1IzOiAwMGI5OTAwMCBDUjQ6IDAwMDQwN2QwCglbNjg3NTcuMDI0Mzg0XSBEUjA6IDAw
MDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwCglbNjg3NTcu
MDI0Mzg0XSBEUjY6IGZmZmYwZmYwIERSNzogMDAwMDA0MDAKCVs2ODc1Ny4wMjQzODRdIFByb2Nl
c3Mga3dvcmtlci91OjIgKHBpZDogODkxNywgdGk9ZTEzN2EwMDAgdGFzaz1lYTdhNjg2MCB0YXNr
LnRpPWUxMzdhMDAwKQoJWzY4NzU3LjAyNDM4NF0gU3RhY2s6CglbNjg3NTcuMDI0Mzg0XSAgYzA2
YzQ2NzYgZDMyZDAwMDAgZTY3YzI0YzAgZTEzN2JlMzggZjgxYzk1OTAgZTY3YzFjYTAgZTEzN2Jl
NDAgZjgxYzk1ZDkKCVs2ODc1Ny4wMjQzODRdICBlMTM3YmU2NCBmODFjZDFjNSAwMDAwMDI0NiAw
MDAwMDAwMiBkMzJkMDAwMCBlNjdjMDVlMCBlNjdjMWNhMCBlNjdjMDVlMAoJWzY4NzU3LjAyNDM4
NF0gIDAwMDAwMDAwIGUxMzdiZWFjIGY4MWNkZmEwIGUxMzdiZTg0IDAwMDAwMjQ2IDAwMDAwMjQ2
IGU2N2MxY2EwIGU2N2MxY2EwCglbNjg3NTcuMDI0Mzg0XSBDYWxsIFRyYWNlOgoJWzY4NzU3LjAy
NDM4NF0gIFs8YzA2YzQ2NzY+XSA/IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHg4Ni8weGEwCglb
Njg3NTcuMDI0Mzg0XSAgWzxmODFjOTU5MD5dIGF0aDlrX2dlbl90aW1lcl9zdG9wKzB4MTAvMHg0
MCBbYXRoOWtdCglbNjg3NTcuMDI0Mzg0XSAgWzxmODFjOTVkOT5dIGF0aDlrX2J0Y29leF9zdG9w
X2dlbl90aW1lcisweDE5LzB4MjAgW2F0aDlrXQoJWzY4NzU3LjAyNDM4NF0gIFs8ZjgxY2QxYzU+
XSBhdGg5a19wc19yZXN0b3JlKzB4ODUvMHgxMTAgW2F0aDlrXQoJWzY4NzU3LjAyNDM4NF0gIFs8
ZjgxY2RmYTA+XSBhdGg5a19jb25maWcrMHgyMjAvMHg1MjAgW2F0aDlrXQoJWzY4NzU3LjAyNDM4
NF0gIFs8ZjgxY2Q0N2Q+XSA/IGF0aDlrX2ZsdXNoKzB4MTVkLzB4MWIwIFthdGg5a10KCVs2ODc1
Ny4wMjQzODRdICBbPGY4NWM3Y2E1Pl0gaWVlZTgwMjExX2h3X2NvbmZpZysweDEzNS8weDJjMCBb
bWFjODAyMTFdCglbNjg3NTcuMDI0Mzg0XSAgWzxmODYwZTNjOD5dIGllZWU4MDIxMV9keW5hbWlj
X3BzX2VuYWJsZV93b3JrKzB4MTk4LzB4NWYwIFttYWM4MDIxMV0KCkNjOiBSYWprdW1hciBNYW5v
aGFyYW4gPHJtYW5vaGFyQHFjYS5xdWFsY29tbS5jb20+CkNjOiBCYWxhIFNoYW5tdWdhbSA8Ymth
bWF0Y2hAcWNhLnF1YWxjb21tLmNvbT4KU2lnbmVkLW9mZi1ieTogTW9oYW1tZWQgU2hhZmkgU2hh
amFraGFuIDxtb2hhbW1lZEBxY2EucXVhbGNvbW0uY29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay9ncGlvLmMgfCAgICAzICsrLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL2dwaW8uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9ncGlv
LmMKaW5kZXggYmFjZGI4Zi4uOWY4M2Y3MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL2dwaW8uYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
Z3Bpby5jCkBAIC0zNDEsNyArMzQxLDggQEAgdm9pZCBhdGg5a19idGNvZXhfc3RvcF9nZW5fdGlt
ZXIoc3RydWN0IGF0aF9zb2Z0YyAqc2MpCiB7CiAJc3RydWN0IGF0aF9idGNvZXggKmJ0Y29leCA9
ICZzYy0+YnRjb2V4OwogCi0JYXRoOWtfZ2VuX3RpbWVyX3N0b3Aoc2MtPnNjX2FoLCBidGNvZXgt
Pm5vX3N0b21wX3RpbWVyKTsKKwlpZiAoYnRjb2V4LT5od190aW1lcl9lbmFibGVkKQorCQlhdGg5
a19nZW5fdGltZXJfc3RvcChzYy0+c2NfYWgsIGJ0Y29leC0+bm9fc3RvbXBfdGltZXIpOwogfQog
CiB1MTYgYXRoOWtfYnRjb2V4X2FnZ3JfbGltaXQoc3RydWN0IGF0aF9zb2Z0YyAqc2MsIHUzMiBt
YXhfNG1zX2ZyYW1lbGVuKQotLSAKMS43LjAuNAoK
--f46d0447f2ceb17ae004c853d4dd--
