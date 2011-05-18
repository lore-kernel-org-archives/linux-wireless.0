Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57458 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab1ERPpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 11:45:21 -0400
Received: by wya21 with SMTP id 21so1289926wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 08:45:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTik23CDQ531gb3LN9YR1Vh_NPf2ruQ@mail.gmail.com>
References: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com>
	<294183.47547.qm@web161601.mail.bf1.yahoo.com>
	<BANLkTimwBB35HhOBjOq=OyhrVWq9MOZ3tA@mail.gmail.com>
	<4DD3C0B9.5070400@gmail.com>
	<BANLkTinj6CyWPipu0BuZtrug6ajvqedC7Q@mail.gmail.com>
	<4DD3DA7F.7020809@lwfinger.net>
	<BANLkTik23CDQ531gb3LN9YR1Vh_NPf2ruQ@mail.gmail.com>
Date: Wed, 18 May 2011 21:15:20 +0530
Message-ID: <BANLkTi=Ksn=WCfwDzM496ZwbV1u2FkTqPQ@mail.gmail.com> (sfid-20110518_174527_052269_6217F0B2)
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Walter Goldens <goldenstranger@yahoo.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Mark Huijgen <mark@huijgen.tk>
Content-Type: multipart/mixed; boundary=0022158c16a5a27a3c04a38ec6c7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0022158c16a5a27a3c04a38ec6c7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

just a quick update, once again I blindly used this patches which
seems to solve the problem,
agg-rx.c still uses the call_rcu thing, so I thought work.c ,
aggr-tx.c can make use of call_rcu .
thanks to the guy who mailed this patch!

need to test more


On Wed, May 18, 2011 at 8:16 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Wed, May 18, 2011 at 8:11 PM, Larry Finger <Larry.Finger@lwfinger.net>=
 wrote:
>> On 05/18/2011 08:04 AM, Mohammed Shafi wrote:
>>>
>>> On Wed, May 18, 2011 at 6:21 PM, Gertjan van Wingerde
>>> <gwingerde@gmail.com> =A0wrote:
>>>>
>>>> On 05/18/11 14:41, Mohammed Shafi wrote:
>>>>>
>>>>> On Wed, May 18, 2011 at 5:26 PM, Walter Goldens
>>>>> <goldenstranger@yahoo.com> =A0wrote:
>>>>>>>>
>>>>>>>> A very peculiar bug.
>>>>>>>>
>>>>>>>> With compat-wireless from 16.05 a nasty bug started to
>>>>>>>
>>>>>>> manifest itself. Right around association time, the
>>>>>>> rt2800usb causes kernel panic. The system freezes and the
>>>>>>> Caps Lock and Num Lock leds on the keyboard begin to flash.
>>>>>>>
>>>>>>> also ath9k, iwlagn.
>>>>>>>
>>>>>>>>
>>>>>>>> Unfortunately there are no recoverable traces after
>>>>>>>
>>>>>>> the system failure to aid this bug report or to indicate its
>>>>>>> origin.
>>>>>>>>
>>>>>>>> I believe it may somehow be related to Ubuntu's
>>>>>>>
>>>>>>> network-manager. If I turn off the network-manager service,
>>>>>>> I can go into monitor mode for example, but if
>>>>>>> network-manager is running and I plug my USB dongle, it
>>>>>>> starts to associate, a second or two later the system is in
>>>>>>> complete meltdown.
>>>>>>>
>>>>>>> same thing, monitor mode worked perfectly fine.
>>>>>>>
>>>>>>>>
>>>>>>>> Nothing concrete, but a hunch is telling me this has
>>>>>>>
>>>>>>> something to do with the association mechanism of the
>>>>>>> rt2800usb. Compat-wireless from few days back exhibits no
>>>>>>> such foul play.
>>>>>>>
>>>>>>> yes just right at the association complete freeze.
>>>>>>>
>>>>>>
>>>>>> That's strange. I wonder what's the connection with this bug and
>>>>>> network-manager. Because when I manually tried to associate, dmesg r=
eported
>>>>>> the association attempt timed out.
>>>>>
>>>>> no even when we use iw dev connect command we can see the panic.
>>>>
>>>> Yeah, I've seen this freeze as well using one of the later
>>>> compat-wireless packages using just iw and wpa_supplicant to bring up =
the
>>>> card. This is on all sorts of rt2x00 supported devices.
>>>>
>>>> However, I don't believe this to be an rt2x00-specific bug, as exactly
>>>> the same rt2x00 sources inside a compat-wireless-2.6.39rc7 package do =
not
>>>> produce the freeze.
>>>>
>>>>> some expert suspected that there is a chance of kfree_rcu in
>>>>> compat-wireless may have caused the problem
>>>>>
>>>>
>>>> That's where my suspicion is as well, but I didn't have the time to
>>>> further investigate. Since my focus was on rt2x00 I used the
>>>> compat-wireless-2.6.39rc7 package to test my patches. I only did a qui=
ck
>>>> check, and the kfree_rcu compatibility fix that was done in compat-wir=
eless
>>>> did seem to match the kfree_rcu code is present in linux-next, but may=
be
>>>> there is an odd side-effect.
>>>
>>> I could not exactly remember this panic came just after kfree_rcu
>>> backported..
>>
>> This problem also occurs with rtl8192se from compat-wireless. When it wa=
s
>> reported to me, a photo of the console log was included (attached). The
>> crash is a NULL pointer in rcu_do_batch.clone.19 (I think - the photo
>> quality is minimal.).
>
> thanks!, same type of call trace which I had also obtained, hopefully the=
re in
> =A0http://pastebin.com/CZrSZrme
> =A0http://pastebin.com/gwZJGDG4
>
>
>
>>
>> Larry
>>
>>
>>
>>
>
>
>
> --
> shafi
>



--=20
shafi

--0022158c16a5a27a3c04a38ec6c7
Content-Type: text/x-diff; charset=US-ASCII; name="compat-wireless-no-kfree-rcu.patch"
Content-Disposition: attachment;
	filename="compat-wireless-no-kfree-rcu.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnufzg0l0

ZGlmZiAtLWdpdCBiL25ldC9tYWM4MDIxMS9hZ2ctdHguYyBhL25ldC9tYWM4MDIxMS9hZ2ctdHgu
YwppbmRleCA1M2RlZmFmLi42M2Q4NTJjIDEwMDY0NAotLS0gYi9uZXQvbWFjODAyMTEvYWdnLXR4
LmMKKysrIGEvbmV0L21hYzgwMjExL2FnZy10eC5jCkBAIC0xMzYsNiArMTM2LDE0IEBAIHZvaWQg
aWVlZTgwMjExX3NlbmRfYmFyKHN0cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhLCB1
OCAqcmEsIHUxNiB0aWQsIHUxCiAJaWVlZTgwMjExX3R4X3NrYihzZGF0YSwgc2tiKTsKIH0KIAor
c3RhdGljIHZvaWQga2ZyZWVfdGlkX3R4KHN0cnVjdCByY3VfaGVhZCAqcmN1X2hlYWQpCit7CisJ
c3RydWN0IHRpZF9hbXBkdV90eCAqdGlkX3R4ID0KKwkgICAgY29udGFpbmVyX29mKHJjdV9oZWFk
LCBzdHJ1Y3QgdGlkX2FtcGR1X3R4LCByY3VfaGVhZCk7CisKKwlrZnJlZSh0aWRfdHgpOworfQor
CiBpbnQgX19faWVlZTgwMjExX3N0b3BfdHhfYmFfc2Vzc2lvbihzdHJ1Y3Qgc3RhX2luZm8gKnN0
YSwgdTE2IHRpZCwKIAkJCQkgICAgZW51bSBpZWVlODAyMTFfYmFja19wYXJ0aWVzIGluaXRpYXRv
ciwKIAkJCQkgICAgYm9vbCB0eCkKQEAgLTE1NSw3ICsxNjMsNyBAQCBpbnQgX19faWVlZTgwMjEx
X3N0b3BfdHhfYmFfc2Vzc2lvbihzdHJ1Y3Qgc3RhX2luZm8gKnN0YSwgdTE2IHRpZCwKIAkJLyog
bm90IGV2ZW4gc3RhcnRlZCB5ZXQhICovCiAJCXJjdV9hc3NpZ25fcG9pbnRlcihzdGEtPmFtcGR1
X21sbWUudGlkX3R4W3RpZF0sIE5VTEwpOwogCQlzcGluX3VubG9ja19iaCgmc3RhLT5sb2NrKTsK
LQkJa2ZyZWVfcmN1KHRpZF90eCwgcmN1X2hlYWQpOworCQljYWxsX3JjdSgmdGlkX3R4LT5yY3Vf
aGVhZCwga2ZyZWVfdGlkX3R4KTsKIAkJcmV0dXJuIDA7CiAJfQogCkBAIC0zMTQsNyArMzIyLDcg
QEAgdm9pZCBpZWVlODAyMTFfdHhfYmFfc2Vzc2lvbl9oYW5kbGVfc3RhcnQoc3RydWN0IHN0YV9p
bmZvICpzdGEsIGludCB0aWQpCiAJCXNwaW5fdW5sb2NrX2JoKCZzdGEtPmxvY2spOwogCiAJCWll
ZWU4MDIxMV93YWtlX3F1ZXVlX2FnZyhsb2NhbCwgdGlkKTsKLQkJa2ZyZWVfcmN1KHRpZF90eCwg
cmN1X2hlYWQpOworCQljYWxsX3JjdSgmdGlkX3R4LT5yY3VfaGVhZCwga2ZyZWVfdGlkX3R4KTsK
IAkJcmV0dXJuOwogCX0KIApAQCAtNjkzLDcgKzcwMSw3IEBAIHZvaWQgaWVlZTgwMjExX3N0b3Bf
dHhfYmFfY2Ioc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwgdTggKnJhLCB1OCB0aWQpCiAKIAlp
ZWVlODAyMTFfYWdnX3NwbGljZV9maW5pc2gobG9jYWwsIHRpZCk7CiAKLQlrZnJlZV9yY3UodGlk
X3R4LCByY3VfaGVhZCk7CisJY2FsbF9yY3UoJnRpZF90eC0+cmN1X2hlYWQsIGtmcmVlX3RpZF90
eCk7CiAKICB1bmxvY2tfc3RhOgogCXNwaW5fdW5sb2NrX2JoKCZzdGEtPmxvY2spOwpkaWZmIC0t
Z2l0IGIvbmV0L21hYzgwMjExL3dvcmsuYyBhL25ldC9tYWM4MDIxMS93b3JrLmMKaW5kZXggZDJl
N2YwZS4uYTk0YjMxMiAxMDA2NDQKLS0tIGIvbmV0L21hYzgwMjExL3dvcmsuYworKysgYS9uZXQv
bWFjODAyMTEvd29yay5jCkBAIC02NSw5ICs2NSwxNyBAQCBzdGF0aWMgdm9pZCBydW5fYWdhaW4o
c3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwsCiAJCW1vZF90aW1lcigmbG9jYWwtPndvcmtf
dGltZXIsIHRpbWVvdXQpOwogfQogCitzdGF0aWMgdm9pZCB3b3JrX2ZyZWVfcmN1KHN0cnVjdCBy
Y3VfaGVhZCAqaGVhZCkKK3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3dvcmsgKndrID0KKwkJY29udGFp
bmVyX29mKGhlYWQsIHN0cnVjdCBpZWVlODAyMTFfd29yaywgcmN1X2hlYWQpOworCisJa2ZyZWUo
d2spOworfQorCiB2b2lkIGZyZWVfd29yayhzdHJ1Y3QgaWVlZTgwMjExX3dvcmsgKndrKQogewot
CWtmcmVlX3JjdSh3aywgcmN1X2hlYWQpOworCWNhbGxfcmN1KCZ3ay0+cmN1X2hlYWQsIHdvcmtf
ZnJlZV9yY3UpOwogfQogCiBzdGF0aWMgaW50IGllZWU4MDIxMV9jb21wYXRpYmxlX3JhdGVzKGNv
bnN0IHU4ICpzdXBwX3JhdGVzLCBpbnQgc3VwcF9yYXRlc19sZW4sCg==
--0022158c16a5a27a3c04a38ec6c7--
