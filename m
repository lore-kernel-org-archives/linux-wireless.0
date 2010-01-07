Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:41463 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab0AGBjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 20:39:24 -0500
Received: by iwn32 with SMTP id 32so2021222iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 17:39:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001021004r2c9cf855p52b007a88123bba7@mail.gmail.com>
References: <4B3DBB6B.4010107@free.fr> <43e72e891001011524r190950c8pdfc89e765afb205d@mail.gmail.com>
	<4B3F1010.3070906@free.fr> <43e72e891001021004r2c9cf855p52b007a88123bba7@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Jan 2010 17:39:03 -0800
Message-ID: <43e72e891001061739t5ded13e7u6b16c73f1b26b246@mail.gmail.com>
Subject: Re: Issue connecting to an HT40 AP that sends a Country IE
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636d34a9b03987a047c892465
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001636d34a9b03987a047c892465
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 2, 2010 at 10:04 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote=
:
> On Sat, Jan 2, 2010 at 4:21 AM, Benoit PAPILLAULT
> <benoit.papillault@free.fr> wrote:
>> Luis R. Rodriguez a =C3=A9crit :
>>>
>>> On Fri, Jan 1, 2010 at 4:07 AM, Benoit PAPILLAULT
>>> <benoit.papillault@free.fr> wrote:
>>>
>>>>
>>>> Hello,
>>>>
>>>> I'd like to report an issue I have when trying to connect a laptop
>>>> running ath9k to a 802.11n AP in HT40 mode. What happens is that the
>>>> laptop cannot associate if the AP is running in HT40 mode. Association
>>>> is OK if the AP is running in HT20 mode. Here is an excerpt from syslo=
g :
>>>>
>>>> [ =C2=A0577.166241] wlan0: associate with AP 00:15:6d:e8:88:84 (try 1)
>>>> [ =C2=A0577.167448] wlan0: RX AssocResp from 00:15:6d:e8:88:84 (capab=
=3D0x411
>>>> status=3D10 aid=3D257)
>>>> [ =C2=A0577.167451] wlan0: AP denied association (code=3D10)
>>>> [ =C2=A0577.167460] wlan0: deauthenticating from 00:15:6d:e8:88:84 by =
local
>>>> choice (reason=3D3)
>>>>
>>>> What's wrong is that the Associate Request (built by
>>>> ieee80211_send_assoc) does not set the bit in HT Capabilities IE sayin=
g
>>>> : "The station supports both HT20 & HT40".
>>>>
>>>> Looking into the code, it appears that both (flags &
>>>> IEEE80211_CHAN_NO_HT40PLUS) and (flags & IEEE80211_CHAN_NO_HT40MINUS)
>>>> are true, thus disabling the IEEE80211_HT_CAP_SUP_WIDTH_20_40 which is
>>>> the culprit mentioned above.
>>>>
>>>> Digging further down, both flags are set in reg.c by :
>>>> =C2=A0if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
>>>> =C2=A0 =C2=A0 =C2=A0bw_flags =3D IEEE80211_CHAN_NO_HT40;
>>>>
>>>> Indeed, at this stage, max_bandwidth_khz is 20 MHz only... Looking up =
in
>>>> my syslog, I found this :
>>>>
>>>> [ =C2=A0506.036923] cfg80211: Received country IE:
>>>> [ =C2=A0506.036927] cfg80211: Regulatory domain: FR
>>>> [ =C2=A0506.036928] =C2=A0 =C2=A0 (start_freq - end_freq @ bandwidth),
>>>> (max_antenna_gain, max_eirp)
>>>> [ =C2=A0506.036931] =C2=A0 =C2=A0 (5170000 KHz - 5190000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036933] =C2=A0 =C2=A0 (5190000 KHz - 5210000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036936] =C2=A0 =C2=A0 (5210000 KHz - 5230000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036938] =C2=A0 =C2=A0 (5230000 KHz - 5250000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036940] =C2=A0 =C2=A0 (5250000 KHz - 5270000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036943] =C2=A0 =C2=A0 (5270000 KHz - 5290000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036945] =C2=A0 =C2=A0 (5290000 KHz - 5310000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036948] =C2=A0 =C2=A0 (5310000 KHz - 5330000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036950] =C2=A0 =C2=A0 (5490000 KHz - 5510000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036952] =C2=A0 =C2=A0 (5510000 KHz - 5530000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036955] =C2=A0 =C2=A0 (5530000 KHz - 5550000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036957] =C2=A0 =C2=A0 (5550000 KHz - 5570000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036959] =C2=A0 =C2=A0 (5570000 KHz - 5590000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036962] =C2=A0 =C2=A0 (5590000 KHz - 5610000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036964] =C2=A0 =C2=A0 (5610000 KHz - 5630000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036966] =C2=A0 =C2=A0 (5630000 KHz - 5650000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036969] =C2=A0 =C2=A0 (5650000 KHz - 5670000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036971] =C2=A0 =C2=A0 (5670000 KHz - 5690000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>> [ =C2=A0506.036974] =C2=A0 =C2=A0 (5690000 KHz - 5710000 KHz @ 40000 K=
Hz), (10000 mBi,
>>>> 10000 mBm)
>>>>
>>>> [ =C2=A0506.036975] cfg80211: CRDA thinks this should applied:
>>>> [ =C2=A0506.036976] cfg80211: Regulatory domain: FR
>>>> [ =C2=A0506.036978] =C2=A0 =C2=A0 (start_freq - end_freq @ bandwidth),
>>>> (max_antenna_gain, max_eirp)
>>>> [ =C2=A0506.036980] =C2=A0 =C2=A0 (2402000 KHz - 2482000 KHz @ 40000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.036982] =C2=A0 =C2=A0 (5170000 KHz - 5250000 KHz @ 40000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.036984] =C2=A0 =C2=A0 (5250000 KHz - 5330000 KHz @ 40000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.036987] =C2=A0 =C2=A0 (5490000 KHz - 5710000 KHz @ 40000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>>
>>>> [ =C2=A0506.036988] cfg80211: We intersect both of these and get:
>>>> [ =C2=A0506.037005] cfg80211: Regulatory domain: 98
>>>> [ =C2=A0506.037006] =C2=A0 =C2=A0 (start_freq - end_freq @ bandwidth),
>>>> (max_antenna_gain, max_eirp)
>>>> [ =C2=A0506.037008] =C2=A0 =C2=A0 (5170000 KHz - 5190000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037011] =C2=A0 =C2=A0 (5190000 KHz - 5210000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037013] =C2=A0 =C2=A0 (5210000 KHz - 5230000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037015] =C2=A0 =C2=A0 (5230000 KHz - 5250000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037017] =C2=A0 =C2=A0 (5250000 KHz - 5270000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037019] =C2=A0 =C2=A0 (5270000 KHz - 5290000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037021] =C2=A0 =C2=A0 (5290000 KHz - 5310000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037024] =C2=A0 =C2=A0 (5310000 KHz - 5330000 KHz @ 20000 K=
Hz), (N/A, 2000
>>>> mBm)
>>>> [ =C2=A0506.037026] =C2=A0 =C2=A0 (5490000 KHz - 5510000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037028] =C2=A0 =C2=A0 (5510000 KHz - 5530000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037030] =C2=A0 =C2=A0 (5530000 KHz - 5550000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037032] =C2=A0 =C2=A0 (5550000 KHz - 5570000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037035] =C2=A0 =C2=A0 (5570000 KHz - 5590000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037037] =C2=A0 =C2=A0 (5590000 KHz - 5610000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037039] =C2=A0 =C2=A0 (5610000 KHz - 5630000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037041] =C2=A0 =C2=A0 (5630000 KHz - 5650000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037043] =C2=A0 =C2=A0 (5650000 KHz - 5670000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037045] =C2=A0 =C2=A0 (5670000 KHz - 5690000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>> [ =C2=A0506.037047] =C2=A0 =C2=A0 (5690000 KHz - 5710000 KHz @ 20000 K=
Hz), (N/A, 2700
>>>> mBm)
>>>>
>>>> So, at this stage, max_bandwidth_khz is indeed 20 MHz!
>>>>
>>>> What's the real meaning of max_bandwidth_khz? If this is just the
>>>> difference between the upper/lower frequency of each channels, then it=
's
>>>> useless. If it is a capability features saying 40 MHz channel wide are
>>>> allowed, then it should be left to 40 MHz even if upper/lower
>>>> frequencies are only 20 MHz apart (since the ability to use 40 MHz
>>>> depends on the list of all frequencies, not a single frequency).
>>>>
>>>
>>> Your AP is sending a country IE channel triplet for each channel it
>>> allows. Its the first time I see an AP do this and its good that you
>>> report this. What AP do you have?
>>>
>>> reg.c treats each triplet as a regulatory rule though and since you
>>> have a rule for each channel it will restrict this to the triplet
>>> range which is just one channel and as such 20 MHz only makes sense. A
>>> fix would be to expand on the ht40 checks to check connecting
>>> frequency rules.
>>>
>>> =C2=A0Luis
>>>
>>
>> Hello,
>>
>> My AP is a NanoStation M5 configured with Country "FR" and 40 MHz.
>>
>> Could you detail the fix you are proposing?
>>
>> On my side, I would propose to leave max_bandwidth_khz to 40 MHz and use=
 it
>> as a capability features.
>
> Since the country IE does not have a max bandwidth we stuff a default
> 40 MHz to it as part of the frequency rule it creates.
>
>> This way we would consider valid the case where
>> upper/lower frequencies are just 20 MHz apart but max_bandwidth_khz is 4=
0
>> MHz.
>
> The issue should =C2=A0be that a frequency rule is being created for each
> channel and although 40 MHz is being specified as max bandwidth
> logistically only 20 MHz fits into that frequency rule. So what the
> intersection needs to learn is how to merge rules or at least
> understand them together. It may be easier to parse insaneIEs like the
> ones your AP generates and re-generate one with actual ranges with
> contiguity channels merged. And then use that one for the
> intersection.

I have a patch in mind now for this, can you please apply this patch
on iw, scan and send me the output of the scan for your AP?

  Luis

--001636d34a9b03987a047c892465
Content-Type: text/x-patch; charset=US-ASCII; name="country-IE-new.patch"
Content-Disposition: attachment; filename="country-IE-new.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g44vdm0i0

RnJvbSA4ODMxZmQ2N2Q3MGI3YWYyZjM3ZjgzMGQ1ZTBmMDRkMTRmODQ3MGFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMdWlzIFIuIFJvZHJpZ3VleiA8bHJvZHJpZ3VlekBhdGhlcm9z
LmNvbT4KRGF0ZTogV2VkLCA2IEphbiAyMDEwIDE3OjM2OjU5IC0wODAwClN1YmplY3Q6IFtQQVRD
SF0gaXc6IGFkZCBjb3VudHJ5IElFIHBhcnNpbmcKClNpZ25lZC1vZmYtYnk6IEx1aXMgUi4gUm9k
cmlndWV6IDxscm9kcmlndWV6QGF0aGVyb3MuY29tPgotLS0KIHNjYW4uYyB8ICAgODcgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
CiAxIGZpbGVzIGNoYW5nZWQsIDcwIGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL3NjYW4uYyBiL3NjYW4uYwppbmRleCAzMDhkNDk5Li5mNzBkNDJjIDEwMDY0NAot
LS0gYS9zY2FuLmMKKysrIGIvc2Nhbi5jCkBAIC0zNSw2ICszNSwyMyBAQCBzdHJ1Y3Qgc2Nhbl9w
YXJhbXMgewogCWVudW0gcHJpbnRfaWVfdHlwZSB0eXBlOwogfTsKIAorI2RlZmluZSBJRUVFODAy
MTFfQ09VTlRSWV9FWFRFTlNJT05fSUQgMjAxCisKK3N0cnVjdCBpZWVlODAyMTFfY291bnRyeV9p
ZV90cmlwbGV0IHsKKwl1bmlvbiB7CisJCXN0cnVjdCB7CisJCQlfX3U4IGZpcnN0X2NoYW5uZWw7
CisJCQlfX3U4IG51bV9jaGFubmVsczsKKwkJCV9fczggbWF4X3Bvd2VyOworCQl9IF9fYXR0cmli
dXRlX18gKChwYWNrZWQpKSBjaGFuczsKKwkJc3RydWN0IHsKKwkJCV9fdTggcmVnX2V4dGVuc2lv
bl9pZDsKKwkJCV9fdTggcmVnX2NsYXNzOworCQkJX191OCBjb3ZlcmFnZV9jbGFzczsKKwkJfSBf
X2F0dHJpYnV0ZV9fICgocGFja2VkKSkgZXh0OworCX07Cit9IF9fYXR0cmlidXRlX18gKChwYWNr
ZWQpKTsKKwogc3RhdGljIGludCBoYW5kbGVfc2NhbihzdHJ1Y3Qgbmw4MDIxMV9zdGF0ZSAqc3Rh
dGUsCiAJCSAgICAgICBzdHJ1Y3QgbmxfY2IgKmNiLAogCQkgICAgICAgc3RydWN0IG5sX21zZyAq
bXNnLApAQCAtMTQyLDI5ICsxNTksNjUgQEAgc3RhdGljIHZvaWQgcHJpbnRfZHMoY29uc3QgdWlu
dDhfdCB0eXBlLCB1aW50OF90IGxlbiwgY29uc3QgdWludDhfdCAqZGF0YSkKIAlwcmludGYoIiBj
aGFubmVsICVkXG4iLCBkYXRhWzBdKTsKIH0KIAotc3RhdGljIHZvaWQgcHJpbnRfY291bnRyeShj
b25zdCB1aW50OF90IHR5cGUsIHVpbnQ4X3QgbGVuLCBjb25zdCB1aW50OF90ICpkYXRhKQorc3Rh
dGljIGNvbnN0IGNoYXIgKmNvdW50cnlfZW52X3N0cihjaGFyIGVudmlyb25tZW50KQogewotCWlu
dCBpOwotCi0JcHJpbnRmKCIgJS4qcyIsIDIsIGRhdGEpOwotCXN3aXRjaCAoZGF0YVsyXSkgewor
CXN3aXRjaCAoZW52aXJvbm1lbnQpIHsKIAljYXNlICdJJzoKLQkJcHJpbnRmKCIgKGluZG9vciki
KTsKLQkJYnJlYWs7CisJCXJldHVybiAiSW5kb29yIG9ubHkiOwogCWNhc2UgJ08nOgotCQlwcmlu
dGYoIiAob3V0ZG9vcikiKTsKLQkJYnJlYWs7CisJCXJldHVybiAiT3V0ZG9vciBvbmx5IjsKIAlj
YXNlICcgJzoKLQkJcHJpbnRmKCIgKGluL291dGRvb3IpIik7Ci0JCWJyZWFrOworCQlyZXR1cm4g
IkluZG9vci9PdXRkb29yIjsKIAlkZWZhdWx0OgotCQlwcmludGYoIiAoaW52YWxpZCBlbnZpcm9u
bWVudCkiKTsKLQkJYnJlYWs7CisJCXJldHVybiAiYm9ndXMiOwogCX0KLQlwcmludGYoIiwgZGF0
YToiKTsKLQlmb3IoaT0wOyBpPGxlbi0zOyBpKyspCi0JCXByaW50ZigiICUuMDJ4IiwgZGF0YVtp
ICsgM10pOwotCXByaW50ZigiXG4iKTsKK30KKworc3RhdGljIHZvaWQgcHJpbnRfY291bnRyeShj
b25zdCB1aW50OF90IHR5cGUsIHVpbnQ4X3QgbGVuLCBjb25zdCB1aW50OF90ICpkYXRhKQorewor
CXByaW50ZigiICUuKnMiLCAyLCBkYXRhKTsKKworCXByaW50ZigiXHRFbnZpcm9ubWVudDogJXNc
biIsIGNvdW50cnlfZW52X3N0cihkYXRhWzJdKSk7CisKKwlkYXRhICs9IDM7CisJbGVuIC09IDM7
CisKKwlpZiAobGVuIDwgMykgeworCQlwcmludGYoIlx0XHRObyBjb3VudHJ5IElFIHRyaXBsZXRz
IHByZXNlbnRcbiIpOworCQlyZXR1cm47CisJfQorCisJcHJpbnRmKCJcdENvdW50cnkgSUUgdHJp
cGxldHM6XG4iKTsKKworCXdoaWxlIChsZW4gPj0gMykgeworCQlpbnQgZW5kX2NoYW5uZWw7CisJ
CXN0cnVjdCBpZWVlODAyMTFfY291bnRyeV9pZV90cmlwbGV0ICp0cmlwbGV0ID0KKwkJCShzdHJ1
Y3QgaWVlZTgwMjExX2NvdW50cnlfaWVfdHJpcGxldCAqKSBkYXRhOworCisJCWlmICh0cmlwbGV0
LT5leHQucmVnX2V4dGVuc2lvbl9pZCA+PSBJRUVFODAyMTFfQ09VTlRSWV9FWFRFTlNJT05fSUQp
IHsKKwkJCXByaW50ZigiXHRcdEV4dGVuc2lvbiBJRDogJWQgUmVndWxhdG9yeSBDbGFzczogJWQg
Q292ZXJhZ2UgY2xhc3M6ICVkXG4iLAorCQkJICAgICAgIHRyaXBsZXQtPmV4dC5yZWdfZXh0ZW5z
aW9uX2lkLAorCQkJICAgICAgIHRyaXBsZXQtPmV4dC5yZWdfY2xhc3MsCisJCQkgICAgICAgdHJp
cGxldC0+ZXh0LmNvdmVyYWdlX2NsYXNzKTsKKworCQkJZGF0YSArPSAzOworCQkJbGVuIC09IDM7
CisJCQljb250aW51ZTsKKwkJfQorCisJCS8qIDIgR0h6ICovCisJCWlmICh0cmlwbGV0LT5jaGFu
cy5maXJzdF9jaGFubmVsIDw9IDE0KQorCQkJZW5kX2NoYW5uZWwgPSB0cmlwbGV0LT5jaGFucy5m
aXJzdF9jaGFubmVsICsgKHRyaXBsZXQtPmNoYW5zLm51bV9jaGFubmVscyAtIDEpOworCQllbHNl
CisJCQllbmRfY2hhbm5lbCA9ICB0cmlwbGV0LT5jaGFucy5maXJzdF9jaGFubmVsICsgKDQgKiAo
dHJpcGxldC0+Y2hhbnMubnVtX2NoYW5uZWxzIC0gMSkpOworCisJCXByaW50ZigiXHRcdENoYW5u
ZWxzIFslZCAtICVkXVxuIiwgdHJpcGxldC0+Y2hhbnMuZmlyc3RfY2hhbm5lbCwgZW5kX2NoYW5u
ZWwpOworCisJCWRhdGEgKz0gMzsKKwkJbGVuIC09IDM7CisJfQorCisJcmV0dXJuOwogfQogCiBz
dGF0aWMgdm9pZCBwcmludF9wb3dlcmNvbnN0cmFpbnQoY29uc3QgdWludDhfdCB0eXBlLCB1aW50
OF90IGxlbiwgY29uc3QgdWludDhfdCAqZGF0YSkKLS0gCjEuNi4zLjMKCg==
--001636d34a9b03987a047c892465--
