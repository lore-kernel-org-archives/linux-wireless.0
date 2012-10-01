Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41733 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2JAM0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 08:26:53 -0400
Received: by obbuo13 with SMTP id uo13so4849669obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2012 05:26:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5069872D.4050607@broadcom.com>
References: <CAHbMyCZ0YU5Jim9kBaBNxmp946ZJfJyNf6f4HNEm8Eti9gO9QA@mail.gmail.com>
	<CAHbMyCYW3qW8R4VV4jGimaqYQHMRd8aeV8GU6Uu5CYNcWVch5Q@mail.gmail.com>
	<5069872D.4050607@broadcom.com>
Date: Mon, 1 Oct 2012 14:26:52 +0200
Message-ID: <CAHbMyCY=cvF6RLkn8SToRS2heHZpxxmC0TH9Ds-Yqo6SrzO8UA@mail.gmail.com> (sfid-20121001_142657_839076_1ACFD419)
Subject: Re: broadcom-sta-dkms: to version >= 6.20.55.19 (r300276)
From: Jasmine Hassan <jasmine.aura@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: 688823@bugs.debian.org, linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec54b4ac03ca50204cafe8517
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--bcaec54b4ac03ca50204cafe8517
Content-Type: text/plain; charset=ISO-8859-1

Resend. Sorry, forgot to "reply all" on the last 2 emails

because wpa_supplicant 1.0 (at least on LMDE/Debian testing) always
tries nl80211 first
# grep -i wext /etc/wpa_supplicant/*
/etc/wpa_supplicant/functions.sh:# -D   driver backend ('wext' if none given)
/etc/wpa_supplicant/functions.sh:
WPA_SUP_OPTIONS="$WPA_SUP_OPTIONS
-D nl80211,wext"
/etc/wpa_supplicant/functions.sh:
wpa_msg stderr "using
\"nl80211,wext\" wpa-driver instead ..."
/etc/wpa_supplicant/functions.sh:
WPA_SUP_OPTIONS="$WPA_SUP_OPTIONS
-D nl80211,wext"
/etc/wpa_supplicant/functions.sh:               wpa_msg verbose "wpa-driver
nl80211,wext (default)"

--

And to answer your other question, attached the complete snipped part

--
Jasmine

On Mon, Oct 1, 2012 at 2:06 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 09/27/2012 04:24 PM, Jasmine Hassan wrote:
>>
>> Update on 3.6-rc7 problems with wpasupplicant-1.0-2 and broadcom-sta
>> 6.20.55.19 (r300276)
>> 1. Fails to associate to AP (WPA encryption used) when wl.ko built with
>> wext
>> 2. Kernel bug when wl.ko built with nl/cfg80211
>
>
> Commenting on issue 1 only, here.
>
>
>>> Updated deb:
>>> http://jas.gemnetworks.com/debian/wireless-bcm43142-dkms-6.20.55.19_amd64.deb
>>>
>>> Also tested on linux 3.5.0-4.dmz.1-liquorix-amd64, and it works for me
>>>
>>> Now, given a power regression in kernel 3.5, I was eager to test drive
>>> 3.6-rc6, and found rc7 out already!
>>> So yesterday I installed linux 3.6-rc7.towo.1-siduction-amd64, the
>>> "wl" module compiles and installs, and loads okay upon boot to
>>> 3.6-rc7. However, I'm unable to associate to my AP:
>>>
>>> Pointers in syslog
>>> Sep 25 21:34:10 terra wpa_supplicant[2787]: nl80211: 'nl80211' generic
>>> netlink not found
>>> Sep 25 21:34:10 terra wpa_supplicant[2787]: Failed to initialize
>>> driver 'nl80211'
>>> [..snip]
>
>
> Not sure what is snipped here. Your wpa_supplicant seems to try nl80211.
> Maybe it goes and try WEXT instead, but that is missing from the log. Do you
> recall or still have the entire syslog?
>
>
>>> Sep 25 21:34:31 terra wpa_supplicant[2787]: eth2: Trying to associate
>>> with 00:xx:xx:xx:xx:xx (SSID='xxxxxxx' freq=2452 MHz)
>>> Sep 25 21:34:31 terra wpa_supplicant[2787]: eth2: Association request
>>> to the driver failed
>>>
>>> As bcm43142 is fairly new, this proprietary driver is all that's there
>>> to support it. Sad face.
>>>
>>> Cheers,
>>> Jasmine
>
>
> Gr. AvS
>
>

--bcaec54b4ac03ca50204cafe8517
Content-Type: text/plain; charset=US-ASCII; name="snipped.txt"
Content-Disposition: attachment; filename="snipped.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7rjyrh60

U2VwIDI1IDIxOjM0OjEwIHRlcnJhIGtlcm5lbDogWyAgIDE4LjIyMzAyOF0gTkVUOiBSZWdpc3Rl
cmVkIHByb3RvY29sIGZhbWlseSAxNwpTZXAgMjUgMjE6MzQ6MTAgdGVycmEgTmV0d29ya01hbmFn
ZXJbMjc1MF06IDxpbmZvPiAoZXRoMik6IHN1cHBsaWNhbnQgaW50ZXJmYWNlIHN0YXRlOiBzdGFy
dGluZyAtPiByZWFkeQpTZXAgMjUgMjE6MzQ6MTAgdGVycmEgTmV0d29ya01hbmFnZXJbMjc1MF06
IDxpbmZvPiAoZXRoMik6IGRldmljZSBzdGF0ZSBjaGFuZ2U6IHVuYXZhaWxhYmxlIC0+IGRpc2Nv
bm5lY3RlZCAocmVhc29uICdzdXBwbGljYW50LWF2YWlsYWJsZScpIFsyMCAzMCA0Ml0KU2VwIDI1
IDIxOjM0OjEwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gKGV0aDIpOiBzdXBw
bGljYW50IGludGVyZmFjZSBzdGF0ZTogcmVhZHkgLT4gaW5hY3RpdmUKU2VwIDI1IDIxOjM0OjEw
IHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8d2Fybj4gVHJ5aW5nIHRvIHJlbW92ZSBhIG5v
bi1leGlzdGFudCBjYWxsIGlkLgpTZXAgMjUgMjE6MzQ6MTAgdGVycmEgYWNwaWQ6IGNsaWVudCBj
b25uZWN0ZWQgZnJvbSAyODExWzA6MF0KU2VwIDI1IDIxOjM0OjEwIHRlcnJhIGFjcGlkOiAxIGNs
aWVudCBydWxlIGxvYWRlZApTZXAgMjUgMjE6MzQ6MTEgdGVycmEgbGFwdG9wLW1vZGU6IGVuYWJs
ZWQsIG5vdCBhY3RpdmUKU2VwIDI1IDIxOjM0OjEyIHRlcnJhIGtlcm5lbDogWyAgIDIwLjI3MjMy
MV0gcmFkZW9uOiBzd2l0Y2hlZCBvZmYKU2VwIDI1IDIxOjM0OjEyIHRlcnJhIGtlcm5lbDogWyAg
IDIwLjcxNjI2Nl0gZWxldmF0b3I6IHR5cGUgYmZxIG5vdCBmb3VuZApTZXAgMjUgMjE6MzQ6MTIg
dGVycmEga2VybmVsOiBbICAgMjAuNzE2MjcwXSBlbGV2YXRvcjogc3dpdGNoIHRvIGJmcQpTZXAg
MjUgMjE6MzQ6MTIgdGVycmEga2VybmVsOiBbICAgMjAuNzE2MjcwXSAgZmFpbGVkClNlcCAyNSAy
MTozNDoyMyB0ZXJyYSBkYnVzWzI2MzVdOiBbc3lzdGVtXSBBY3RpdmF0aW5nIHNlcnZpY2UgbmFt
ZT0nb3JnLmZyZWVkZXNrdG9wLkNvbnNvbGVLaXQnICh1c2luZyBzZXJ2aWNlaGVscGVyKQpTZXAg
MjUgMjE6MzQ6MjMgdGVycmEgZGJ1c1syNjM1XTogW3N5c3RlbV0gU3VjY2Vzc2Z1bGx5IGFjdGl2
YXRlZCBzZXJ2aWNlICdvcmcuZnJlZWRlc2t0b3AuQ29uc29sZUtpdCcKU2VwIDI1IDIxOjM0OjI4
IHRlcnJhIGRidXNbMjYzNV06IFtzeXN0ZW1dIEFjdGl2YXRpbmcgc2VydmljZSBuYW1lPSdvcmcu
ZnJlZWRlc2t0b3AuVURpc2tzJyAodXNpbmcgc2VydmljZWhlbHBlcikKU2VwIDI1IDIxOjM0OjI4
IHRlcnJhIGRidXNbMjYzNV06IFtzeXN0ZW1dIFN1Y2Nlc3NmdWxseSBhY3RpdmF0ZWQgc2Vydmlj
ZSAnb3JnLmZyZWVkZXNrdG9wLlVEaXNrcycKU2VwIDI1IDIxOjM0OjI5IHRlcnJhIHB1bHNlYXVk
aW9bMzY4OF06IFtwdWxzZWF1ZGlvXSBwaWQuYzogRGFlbW9uIGFscmVhZHkgcnVubmluZy4KU2Vw
IDI1IDIxOjM0OjMwIHRlcnJhIGRidXNbMjYzNV06IFtzeXN0ZW1dIEFjdGl2YXRpbmcgc2Vydmlj
ZSBuYW1lPSdvcmcuZnJlZWRlc2t0b3AuVVBvd2VyJyAodXNpbmcgc2VydmljZWhlbHBlcikKU2Vw
IDI1IDIxOjM0OjMwIHRlcnJhIGRidXNbMjYzNV06IFtzeXN0ZW1dIFN1Y2Nlc3NmdWxseSBhY3Rp
dmF0ZWQgc2VydmljZSAnb3JnLmZyZWVkZXNrdG9wLlVQb3dlcicKU2VwIDI1IDIxOjM0OjMwIHRl
cnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gQXV0by1hY3RpdmF0aW5nIGNvbm5lY3Rp
b24gJ3h4eHh4eHgnLgpTZXAgMjUgMjE6MzQ6MzAgdGVycmEgTmV0d29ya01hbmFnZXJbMjc1MF06
IDxpbmZvPiBBY3RpdmF0aW9uIChldGgyKSBzdGFydGluZyBjb25uZWN0aW9uICd4eHh4eHh4JwpT
ZXAgMjUgMjE6MzQ6MzAgdGVycmEgTmV0d29ya01hbmFnZXJbMjc1MF06IDxpbmZvPiAoZXRoMik6
IGRldmljZSBzdGF0ZSBjaGFuZ2U6IGRpc2Nvbm5lY3RlZCAtPiBwcmVwYXJlIChyZWFzb24gJ25v
bmUnKSBbMzAgNDAgMF0KU2VwIDI1IDIxOjM0OjMwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBd
OiA8aW5mbz4gQWN0aXZhdGlvbiAoZXRoMikgU3RhZ2UgMSBvZiA1IChEZXZpY2UgUHJlcGFyZSkg
c2NoZWR1bGVkLi4uClNlcCAyNSAyMTozNDozMCB0ZXJyYSBOZXR3b3JrTWFuYWdlclsyNzUwXTog
PGluZm8+IEFjdGl2YXRpb24gKGV0aDIpIFN0YWdlIDEgb2YgNSAoRGV2aWNlIFByZXBhcmUpIHN0
YXJ0ZWQuLi4KU2VwIDI1IDIxOjM0OjMwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5m
bz4gQWN0aXZhdGlvbiAoZXRoMikgU3RhZ2UgMiBvZiA1IChEZXZpY2UgQ29uZmlndXJlKSBzY2hl
ZHVsZWQuLi4KU2VwIDI1IDIxOjM0OjMwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5m
bz4gQWN0aXZhdGlvbiAoZXRoMikgU3RhZ2UgMSBvZiA1IChEZXZpY2UgUHJlcGFyZSkgY29tcGxl
dGUuClNlcCAyNSAyMTozNDozMCB0ZXJyYSBOZXR3b3JrTWFuYWdlclsyNzUwXTogPGluZm8+IEFj
dGl2YXRpb24gKGV0aDIpIFN0YWdlIDIgb2YgNSAoRGV2aWNlIENvbmZpZ3VyZSkgc3RhcnRpbmcu
Li4KU2VwIDI1IDIxOjM0OjMwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gKGV0
aDIpOiBkZXZpY2Ugc3RhdGUgY2hhbmdlOiBwcmVwYXJlIC0+IGNvbmZpZyAocmVhc29uICdub25l
JykgWzQwIDUwIDBdClNlcCAyNSAyMTozNDozMCB0ZXJyYSBOZXR3b3JrTWFuYWdlclsyNzUwXTog
PGluZm8+IEFjdGl2YXRpb24gKGV0aDIvd2lyZWxlc3MpOiBjb25uZWN0aW9uICd4eHh4eHh4JyBo
YXMgc2VjdXJpdHksIGFuZCBzZWNyZXRzIGV4aXN0LiAgTm8gbmV3IHNlY3JldHMgbmVlZGVkLgpT
ZXAgMjUgMjE6MzQ6MzAgdGVycmEgTmV0d29ya01hbmFnZXJbMjc1MF06IDxpbmZvPiBDb25maWc6
IGFkZGVkICdzc2lkJyB2YWx1ZSAneHh4eHh4eCcKU2VwIDI1IDIxOjM0OjMwIHRlcnJhIE5ldHdv
cmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gQ29uZmlnOiBhZGRlZCAnc2Nhbl9zc2lkJyB2YWx1ZSAn
MScKU2VwIDI1IDIxOjM0OjMwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gQ29u
ZmlnOiBhZGRlZCAna2V5X21nbXQnIHZhbHVlICdXUEEtUFNLJwpTZXAgMjUgMjE6MzQ6MzAgdGVy
cmEgTmV0d29ya01hbmFnZXJbMjc1MF06IDxpbmZvPiBDb25maWc6IGFkZGVkICdhdXRoX2FsZycg
dmFsdWUgJ09QRU4nClNlcCAyNSAyMTozNDozMCB0ZXJyYSBOZXR3b3JrTWFuYWdlclsyNzUwXTog
PGluZm8+IENvbmZpZzogYWRkZWQgJ3BzaycgdmFsdWUgJzxvbWl0dGVkPicKU2VwIDI1IDIxOjM0
OjMwIHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gQWN0aXZhdGlvbiAoZXRoMikg
U3RhZ2UgMiBvZiA1IChEZXZpY2UgQ29uZmlndXJlKSBjb21wbGV0ZS4KU2VwIDI1IDIxOjM0OjMw
IHRlcnJhIE5ldHdvcmtNYW5hZ2VyWzI3NTBdOiA8aW5mbz4gQ29uZmlnOiBzZXQgaW50ZXJmYWNl
IGFwX3NjYW4gdG8gMQpTZXAgMjUgMjE6MzQ6MzAgdGVycmEgTmV0d29ya01hbmFnZXJbMjc1MF06
IDxpbmZvPiAoZXRoMik6IHN1cHBsaWNhbnQgaW50ZXJmYWNlIHN0YXRlOiBpbmFjdGl2ZSAtPiBz
Y2FubmluZwoK
--bcaec54b4ac03ca50204cafe8517--
