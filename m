Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36380 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3CZV6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 17:58:50 -0400
Received: by mail-ob0-f171.google.com with SMTP id x4so7612736obh.30
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 14:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1364323118.8319.13.camel@jlt4.sipsolutions.net>
References: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com>
	<1364323118.8319.13.camel@jlt4.sipsolutions.net>
Date: Tue, 26 Mar 2013 22:58:49 +0100
Message-ID: <CACna6rxpiPp_FR8jF=jKHbd6XrYndfFZC5O4g6=fvioK=e8vEg@mail.gmail.com> (sfid-20130326_225857_005226_F05B1E11)
Subject: Re: Scanning regression since "cfg80211: use DS or HT operation IEs
 to determine BSS channel"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: multipart/mixed; boundary=bcaec54c4e00c7fd6704d8db064c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--bcaec54c4e00c7fd6704d8db064c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2013/3/26 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2013-03-26 at 18:10 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>
>> I've just finished bisecting wireless scanning regression I'm
>> experiencing with my 14e4:432b (BCM4322) and b43 driver.
>
> Hmmm.
>
>> The problem is getting my network visible in scanning results (iw dev
>> wlan0 scan). I've to repeat scanning dozens of time to notice my AP.
>> It's also well visible when using wpa_supplicant. It takes from 20s to
>> 100s before I get the "Trying to authenticate with".
>
> That's strange.
>
>> After going back to the kernel before that commit it takes
>> wpa_supplicant less than 2 seconds to connect to my WiFi network.
>
>> My network is at channel 13, I still have to verify if it matters.
>>
>> Any thought about that?
>>
>>
>> The first bad commit (I've verified manually after bisecting) appears to=
 be:
>
> "verified manually" how? By reverting the commit? But anyway the commit
> is clearly scanning related, so ...

Oh, that was just about
1) git checkout 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
2) test
3) git revert 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
4) test


> Can you check your channel list? (iw list or iw phy0 info)

Sure, attaching iw.list.log.


> Also can you show the full data including beacon data from the AP (iw
> wlan0 scan dump -b) please?

Hm, first of all, above command doesn't seem to perform real scanning.
It returns too quick to actually scan anything. It's result is empty
as long as I don't use standard "iw dev wlan0 scan".  After scanning a
normal way once ("iw dev wlan0 scan"), executing "dump -b" results in
the output at the one produced by "iw dev wlan0 scan" (only TSF and
last seen differ).

Is there anything special about "iw dev wlan0 scan dump -b" I should know o=
f?


> Does reverting just the mac80211 change fix it?

Yes. Reverting just a change in net/mac80211/scan.c fixes the problem
for me. I've tested this with the latest wireless-testing.

--=20
Rafa=C5=82

--bcaec54c4e00c7fd6704d8db064c
Content-Type: application/octet-stream; name="iw.list.log"
Content-Disposition: attachment; filename="iw.list.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_herlns3j0

V2lwaHkgcGh5MwoJQmFuZCAxOgoJCUZyZXF1ZW5jaWVzOgoJCQkqIDI0MTIgTUh6IFsxXSAoMjAu
MCBkQm0pCgkJCSogMjQxNyBNSHogWzJdICgyMC4wIGRCbSkKCQkJKiAyNDIyIE1IeiBbM10gKDIw
LjAgZEJtKQoJCQkqIDI0MjcgTUh6IFs0XSAoMjAuMCBkQm0pCgkJCSogMjQzMiBNSHogWzVdICgy
MC4wIGRCbSkKCQkJKiAyNDM3IE1IeiBbNl0gKDIwLjAgZEJtKQoJCQkqIDI0NDIgTUh6IFs3XSAo
MjAuMCBkQm0pCgkJCSogMjQ0NyBNSHogWzhdICgyMC4wIGRCbSkKCQkJKiAyNDUyIE1IeiBbOV0g
KDIwLjAgZEJtKQoJCQkqIDI0NTcgTUh6IFsxMF0gKDIwLjAgZEJtKQoJCQkqIDI0NjIgTUh6IFsx
MV0gKDIwLjAgZEJtKQoJCQkqIDI0NjcgTUh6IFsxMl0gKDIwLjAgZEJtKSAocGFzc2l2ZSBzY2Fu
bmluZywgbm8gSUJTUykKCQkJKiAyNDcyIE1IeiBbMTNdICgyMC4wIGRCbSkKCQkJKiAyNDg0IE1I
eiBbMTRdICgyMC4wIGRCbSkgKHBhc3NpdmUgc2Nhbm5pbmcsIG5vIElCU1MpCgkJQml0cmF0ZXMg
KG5vbi1IVCk6CgkJCSogMS4wIE1icHMKCQkJKiAyLjAgTWJwcyAoc2hvcnQgcHJlYW1ibGUgc3Vw
cG9ydGVkKQoJCQkqIDUuNSBNYnBzIChzaG9ydCBwcmVhbWJsZSBzdXBwb3J0ZWQpCgkJCSogMTEu
MCBNYnBzIChzaG9ydCBwcmVhbWJsZSBzdXBwb3J0ZWQpCgkJCSogNi4wIE1icHMKCQkJKiA5LjAg
TWJwcwoJCQkqIDEyLjAgTWJwcwoJCQkqIDE4LjAgTWJwcwoJCQkqIDI0LjAgTWJwcwoJCQkqIDM2
LjAgTWJwcwoJCQkqIDQ4LjAgTWJwcwoJCQkqIDU0LjAgTWJwcwoJbWF4ICMgc2NhbiBTU0lEczog
NAoJbWF4IHNjYW4gSUVzIGxlbmd0aDogMjI4NSBieXRlcwoJQ292ZXJhZ2UgY2xhc3M6IDAgKHVw
IHRvIDBtKQoJQXZhaWxhYmxlIEFudGVubmFzOiBUWCAwIFJYIDAKCVN1cHBvcnRlZCBpbnRlcmZh
Y2UgbW9kZXM6CgkJICogSUJTUwoJCSAqIG1hbmFnZWQKCQkgKiBBUAoJCSAqIEFQL1ZMQU4KCQkg
KiBXRFMKCQkgKiBtb25pdG9yCglTdXBwb3J0ZWQgY29tbWFuZHM6CgkJICogbmV3X2ludGVyZmFj
ZQoJCSAqIHNldF9pbnRlcmZhY2UKCQkgKiBuZXdfa2V5CgkJICogbmV3X2JlYWNvbgoJCSAqIG5l
d19zdGF0aW9uCgkJICogc2V0X2JzcwoJCSAqIGF1dGhlbnRpY2F0ZQoJCSAqIGFzc29jaWF0ZQoJ
CSAqIGRlYXV0aGVudGljYXRlCgkJICogZGlzYXNzb2NpYXRlCgkJICogam9pbl9pYnNzCgkJICog
c2V0X3R4X2JpdHJhdGVfbWFzawoJCSAqIGFjdGlvbgoJCSAqIGZyYW1lX3dhaXRfY2FuY2VsCgkJ
ICogc2V0X3dpcGh5X25ldG5zCgkJICogc2V0X2NoYW5uZWwKCQkgKiBzZXRfd2RzX3BlZXIKCQkg
KiBVbmtub3duIGNvbW1hbmQgKDg0KQoJCSAqIFVua25vd24gY29tbWFuZCAoODcpCgkJICogVW5r
bm93biBjb21tYW5kICg4NSkKCQkgKiBVbmtub3duIGNvbW1hbmQgKDg5KQoJCSAqIFVua25vd24g
Y29tbWFuZCAoOTIpCgkJICogY29ubmVjdAoJCSAqIGRpc2Nvbm5lY3QKCVN1cHBvcnRlZCBUWCBm
cmFtZSB0eXBlczoKCQkgKiBJQlNTOiAweDAwMDAgMHgwMDEwIDB4MDAyMCAweDAwMzAgMHgwMDQw
IDB4MDA1MCAweDAwNjAgMHgwMDcwIDB4MDA4MCAweDAwOTAgMHgwMGEwIDB4MDBiMCAweDAwYzAg
MHgwMGQwIDB4MDBlMCAweDAwZjAKCQkgKiBtYW5hZ2VkOiAweDAwMDAgMHgwMDEwIDB4MDAyMCAw
eDAwMzAgMHgwMDQwIDB4MDA1MCAweDAwNjAgMHgwMDcwIDB4MDA4MCAweDAwOTAgMHgwMGEwIDB4
MDBiMCAweDAwYzAgMHgwMGQwIDB4MDBlMCAweDAwZjAKCQkgKiBBUDogMHgwMDAwIDB4MDAxMCAw
eDAwMjAgMHgwMDMwIDB4MDA0MCAweDAwNTAgMHgwMDYwIDB4MDA3MCAweDAwODAgMHgwMDkwIDB4
MDBhMCAweDAwYjAgMHgwMGMwIDB4MDBkMCAweDAwZTAgMHgwMGYwCgkJICogQVAvVkxBTjogMHgw
MDAwIDB4MDAxMCAweDAwMjAgMHgwMDMwIDB4MDA0MCAweDAwNTAgMHgwMDYwIDB4MDA3MCAweDAw
ODAgMHgwMDkwIDB4MDBhMCAweDAwYjAgMHgwMGMwIDB4MDBkMCAweDAwZTAgMHgwMGYwCgkJICog
bWVzaCBwb2ludDogMHgwMDAwIDB4MDAxMCAweDAwMjAgMHgwMDMwIDB4MDA0MCAweDAwNTAgMHgw
MDYwIDB4MDA3MCAweDAwODAgMHgwMDkwIDB4MDBhMCAweDAwYjAgMHgwMGMwIDB4MDBkMCAweDAw
ZTAgMHgwMGYwCgkJICogUDJQLWNsaWVudDogMHgwMDAwIDB4MDAxMCAweDAwMjAgMHgwMDMwIDB4
MDA0MCAweDAwNTAgMHgwMDYwIDB4MDA3MCAweDAwODAgMHgwMDkwIDB4MDBhMCAweDAwYjAgMHgw
MGMwIDB4MDBkMCAweDAwZTAgMHgwMGYwCgkJICogUDJQLUdPOiAweDAwMDAgMHgwMDEwIDB4MDAy
MCAweDAwMzAgMHgwMDQwIDB4MDA1MCAweDAwNjAgMHgwMDcwIDB4MDA4MCAweDAwOTAgMHgwMGEw
IDB4MDBiMCAweDAwYzAgMHgwMGQwIDB4MDBlMCAweDAwZjAKCQkgKiBVbmtub3duIG1vZGUgKDEw
KTogMHgwMDAwIDB4MDAxMCAweDAwMjAgMHgwMDMwIDB4MDA0MCAweDAwNTAgMHgwMDYwIDB4MDA3
MCAweDAwODAgMHgwMDkwIDB4MDBhMCAweDAwYjAgMHgwMGMwIDB4MDBkMCAweDAwZTAgMHgwMGYw
CglTdXBwb3J0ZWQgUlggZnJhbWUgdHlwZXM6CgkJICogSUJTUzogMHgwMDQwIDB4MDBiMCAweDAw
YzAgMHgwMGQwCgkJICogbWFuYWdlZDogMHgwMDQwIDB4MDBkMAoJCSAqIEFQOiAweDAwMDAgMHgw
MDIwIDB4MDA0MCAweDAwYTAgMHgwMGIwIDB4MDBjMCAweDAwZDAKCQkgKiBBUC9WTEFOOiAweDAw
MDAgMHgwMDIwIDB4MDA0MCAweDAwYTAgMHgwMGIwIDB4MDBjMCAweDAwZDAKCQkgKiBtZXNoIHBv
aW50OiAweDAwYjAgMHgwMGMwIDB4MDBkMAoJCSAqIFAyUC1jbGllbnQ6IDB4MDA0MCAweDAwZDAK
CQkgKiBQMlAtR086IDB4MDAwMCAweDAwMjAgMHgwMDQwIDB4MDBhMCAweDAwYjAgMHgwMGMwIDB4
MDBkMAoJCSAqIFVua25vd24gbW9kZSAoMTApOiAweDAwNDAgMHgwMGQwCg==
--bcaec54c4e00c7fd6704d8db064c--
