Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63489 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2IZOCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 10:02:44 -0400
Received: by vcbfo13 with SMTP id fo13so656590vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 07:02:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5062F6A6.8000207@gmail.com>
References: <5062E0CB.6040308@gmail.com>
	<5062EBCE.70700@lenbrook.com>
	<CAD2nsn3Tkkk92WRhBhBtj8oU5edWZf4tgS2ex8doSAnGDGpcnA@mail.gmail.com>
	<5062F6A6.8000207@gmail.com>
Date: Wed, 26 Sep 2012 19:32:43 +0530
Message-ID: <CAD2nsn3u09ywKek2DT+R__eezq68tTzC43OuQCZCGf3_QKa8cg@mail.gmail.com> (sfid-20120926_160248_144761_528AD143)
Subject: Re: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Gray <ben.r.gray@gmail.com>
Cc: Jonathan Bagg <jbagg@lenbrook.com>, linux-wireless@vger.kernel.org,
	jouni@qca.qualcomm.com
Content-Type: multipart/mixed; boundary=20cf3071cc68cddb0704ca9b465c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--20cf3071cc68cddb0704ca9b465c
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Sep 26, 2012 at 6:05 PM, Ben Gray <ben.r.gray@gmail.com> wrote:
> Wow that was quick, thanks very much.  Any idea when it will make it
> upstream ?

can you please try the attached patch. I will just put tested-by if it
works for you too.
It works for me.

>
> I've attached the wpa_supplicant (v0.7.3) log in case anyone is still
> interested.
>
> Thanks everyone for your replies,
>
> Ben.
>
>
>
> On 26/09/2012 13:19, Mohammed Shafi wrote:
>>
>> On Wed, Sep 26, 2012 at 5:19 PM, Jonathan Bagg <jbagg@lenbrook.com> wrote:
>>>
>>> I've had the same experience, I can connect with iw, but not with
>>> wpa_supplicant with wpa.  I also couldn't get higher than 65Mbps, MCS7
>>> (other devices on the same router will go faster).  I'm probably the
>>> other
>>> post you mentioned.
>>
>>
>> We have a fix, I shall validate it and send it upstream.
>>>
>>>
>>> Jon
>>>
>>>
>>> On 12-09-26 07:02 AM, Ben Gray wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>>      I have a bunch of UB134 USB dongles which have a ath6kl chip with
>>>> H/W
>>>> version 0x31c8088a, I'm trying to get them to work with the ath6kl
>>>> driver
>>>> from the compat-wireless-3.6-rc5-1 package. I've applied this
>>>> (https://patchwork.kernel.org/patch/1203191/) patch to the source and
>>>> pulled
>>>> the hw1.3 firmware from the linux-firmware git.
>>>>
>>>>      The driver works as far as it can scan AP's and connect to
>>>> unencrypted
>>>> networks, however WPA/WPA2 doesn't work when I run wpa_supplicant. I
>>>> realise
>>>> "WPA doesn't work" is a bit vague, and I can post the wpa_supplicant and
>>>> driver logs if that helps, but I've seen another post which says they
>>>> couldn't get WPA to work either, so I'd like to know if this is a known
>>>> issue with the driver and/or firmware? Has anyone had any luck getting
>>>> WPA/WPA2 working with ath6kl hw1.3 ?
>>>>
>>>>      If this is a known issue does anyone know when it might be fixed ?
>>>>
>>>>
>>>> Thanks in advance,
>>>> Ben.
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-wireless"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>



-- 
thanks,
shafi

--20cf3071cc68cddb0704ca9b465c
Content-Type: application/octet-stream; name="wpa2-ath6kl-fix.patch"
Content-Disposition: attachment; filename="wpa2-ath6kl-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7ki66n11

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wvdXNiLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL3VzYi5jCmluZGV4IGE2ZDEzNzcuLjVjODg4NmMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wvdXNiLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDZrbC91c2IuYwpAQCAtODAzLDcgKzgwMywxMSBA
QCBzdGF0aWMgaW50IGF0aDZrbF91c2JfbWFwX3NlcnZpY2VfcGlwZShzdHJ1Y3QgYXRoNmtsICph
ciwgdTE2IHN2Y19pZCwKIAkJKmRsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfUlhfREFUQTsKIAkJ
YnJlYWs7CiAJY2FzZSBXTUlfREFUQV9WSV9TVkM6Ci0JCSp1bF9waXBlID0gQVRINktMX1VTQl9Q
SVBFX1RYX0RBVEFfTVA7CisKKwkJaWYgKGFyLT52ZXJzaW9uLnRhcmdldF92ZXIgPT0gQVI2MDA0
X0hXXzFfM19WRVJTSU9OKQorCQkJKnVsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfVFhfREFUQV9M
UDsKKwkJZWxzZQorCQkJKnVsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfVFhfREFUQV9NUDsKIAkJ
LyoKIAkJKiBEaXNhYmxlIHJ4ZGF0YTIgZGlyZWN0bHksIGl0IHdpbGwgYmUgZW5hYmxlZAogCQkq
IGlmIEZXIGVuYWJsZSByeGRhdGEyCkBAIC04MTEsNyArODE1LDExIEBAIHN0YXRpYyBpbnQgYXRo
NmtsX3VzYl9tYXBfc2VydmljZV9waXBlKHN0cnVjdCBhdGg2a2wgKmFyLCB1MTYgc3ZjX2lkLAog
CQkqZGxfcGlwZSA9IEFUSDZLTF9VU0JfUElQRV9SWF9EQVRBOwogCQlicmVhazsKIAljYXNlIFdN
SV9EQVRBX1ZPX1NWQzoKLQkJKnVsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfVFhfREFUQV9IUDsK
KworCQlpZiAoYXItPnZlcnNpb24udGFyZ2V0X3ZlciA9PSBBUjYwMDRfSFdfMV8zX1ZFUlNJT04p
CisJCQkqdWxfcGlwZSA9IEFUSDZLTF9VU0JfUElQRV9UWF9EQVRBX0xQOworCQllbHNlCisJCQkq
dWxfcGlwZSA9IEFUSDZLTF9VU0JfUElQRV9UWF9EQVRBX01QOwogCQkvKgogCQkqIERpc2FibGUg
cnhkYXRhMiBkaXJlY3RseSwgaXQgd2lsbCBiZSBlbmFibGVkCiAJCSogaWYgRlcgZW5hYmxlIHJ4
ZGF0YTIK
--20cf3071cc68cddb0704ca9b465c--
