Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49431 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDIQdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 12:33:25 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so2727213pab.34
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 09:33:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
 <1393852248.10039.5.camel@jlt4.sipsolutions.net> <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
 <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
 <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
 <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
 <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
 <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com> <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 9 Apr 2014 19:33:09 +0300
Message-ID: <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com> (sfid-20140409_183329_636759_5C0F6292)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
To: Colleen T <colleen@cozybit.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: multipart/mixed; boundary=001a1134ab3cdc444604f69ea802
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a1134ab3cdc444604f69ea802
Content-Type: text/plain; charset=ISO-8859-1

Hey Collen, Luis,

On Sun, Mar 16, 2014 at 9:04 PM, Colleen T <colleen@cozybit.com> wrote:
> On Sat, Mar 15, 2014 at 9:42 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Sat, Mar 15, 2014 at 8:59 AM, Janusz Dziedzic
>> <janusz.dziedzic@gmail.com> wrote:
>>> 2014-03-15 2:03 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
>>>> On Fri, Mar 14, 2014 at 3:12 PM, Colleen T <colleen@cozybit.com> wrote:
>>>>> I'm on mac80211-next/master, sha is
>>>>> 5a970df8990d173e7e4092952f2e3da1de69b27d
>>>>
>>>> I tried to reproduce by just merging the fixes in question onto Linus'
>>>> tree and using radios=3 but no go. Can you provide the full kernel
>>>> log, I'm particularly interested in what happened before. The
>>>> COUNTRY=US on debian, which I believe you're on, should just trigger a
>>>> regulatory domain setting to US upon initialization. Depending on how
>>>> Debian does it this could either trigger as a module parameter or as a
>>>> userspace event *after* the world regdom get set.
>
> I'm attaching a full kernel log that shows the warning being
> triggered.  You are correct, I'm on debian.  In the attached case I
> ran:
> $ modprobe mac80211_hwsim radios=4
>  I pulled the fixes onto Linus' tree and I end up with the same result.
>

Seems I might have found the culprit - reg_todo is called while the
request to CRDA is in flight and the patch in question causes the
already-in-process user-request to be handled again. Since it's the
same regdomain as the last request (it's the last request itself), we
get this:

treatment = __reg_process_hint_user(user_request);
if (treatment == REG_REQ_IGNORE ||
   treatment == REG_REQ_ALREADY_SET) {
kfree(user_request); <------
return treatment;
}

Can you try adding the attached patch? It just replaced relevant
kfree-s with a function that avoids freeing the last request.

Also, in the current scheme of things, CRDA might be called twice for
the same request in some corner cases, but that's not a problem, since
reg_is_valid_request() will block the second set_regdom().

Regards,
Arik

--001a1134ab3cdc444604f69ea802
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-cfg80211-avoid-freeing-last_request-while-in-flight.patch"
Content-Disposition: attachment;
	filename="0001-cfg80211-avoid-freeing-last_request-while-in-flight.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htsu3mjc1

RnJvbSBjMDVjNGU1ZWVmYzU2YTFkZDFkNzRkNzMyNmE1OTlkZWI0NGM2ODQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcmlrIE5lbXRzb3YgPGFyaWtAd2l6ZXJ5LmNvbT4KRGF0ZTog
V2VkLCA5IEFwciAyMDE0IDE5OjI0OjE2ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gY2ZnODAyMTE6
IGF2b2lkIGZyZWVpbmcgbGFzdF9yZXF1ZXN0IHdoaWxlIGluIGZsaWdodAoKQXZvaWQgZnJlZWlu
ZyB0aGUgbGFzdCByZXF1ZXN0IHdoaWxlIGl0IGlzIGJlaW5nIHByb2Nlc3NlZC4gVGhpcyBjYW4K
aGFwcGVuIGluIHNvbWUgY2FzZXMgaWYgcmVnX3dvcmsgaXMga2lja2VkIGZvciBzb21lIHJlYXNv
biB3aGlsZSB0aGUKY3VycmVudGx5IHBlbmRpbmcgcmVxdWVzdCBpcyBpbiBmbGlnaHQuCgpTaWdu
ZWQtb2ZmLWJ5OiBBcmlrIE5lbXRzb3YgPGFyaWtAd2l6ZXJ5LmNvbT4KLS0tCiBuZXQvd2lyZWxl
c3MvcmVnLmMgfCAyMiArKysrKysrKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTQg
aW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3Mv
cmVnLmMgYi9uZXQvd2lyZWxlc3MvcmVnLmMKaW5kZXggYmEwNGM2My4uYmFkMDk0YiAxMDA2NDQK
LS0tIGEvbmV0L3dpcmVsZXNzL3JlZy5jCisrKyBiL25ldC93aXJlbGVzcy9yZWcuYwpAQCAtMjQw
LDcgKzI0MCwxMyBAQCBzdGF0aWMgY2hhciB1c2VyX2FscGhhMlsyXTsKIG1vZHVsZV9wYXJhbShp
ZWVlODAyMTFfcmVnZG9tLCBjaGFycCwgMDQ0NCk7CiBNT0RVTEVfUEFSTV9ERVNDKGllZWU4MDIx
MV9yZWdkb20sICJJRUVFIDgwMi4xMSByZWd1bGF0b3J5IGRvbWFpbiBjb2RlIik7CiAKLXN0YXRp
YyB2b2lkIHJlZ19mcmVlX3JlcXVlc3Qoc3RydWN0IHJlZ3VsYXRvcnlfcmVxdWVzdCAqbHIpCitz
dGF0aWMgdm9pZCByZWdfZnJlZV9yZXF1ZXN0KHN0cnVjdCByZWd1bGF0b3J5X3JlcXVlc3QgKnJl
cXVlc3QpCit7CisJaWYgKHJlcXVlc3QgIT0gZ2V0X2xhc3RfcmVxdWVzdCgpKQorCQlrZnJlZShy
ZXF1ZXN0KTsKK30KKworc3RhdGljIHZvaWQgcmVnX2ZyZWVfbGFzdF9yZXF1ZXN0KHN0cnVjdCBy
ZWd1bGF0b3J5X3JlcXVlc3QgKmxyKQogewogCWlmIChsciAhPSAmY29yZV9yZXF1ZXN0X3dvcmxk
ICYmIGxyKQogCQlrZnJlZV9yY3UobHIsIHJjdV9oZWFkKTsKQEAgLTI1NCw3ICsyNjAsNyBAQCBz
dGF0aWMgdm9pZCByZWdfdXBkYXRlX2xhc3RfcmVxdWVzdChzdHJ1Y3QgcmVndWxhdG9yeV9yZXF1
ZXN0ICpyZXF1ZXN0KQogCWlmIChsciA9PSByZXF1ZXN0KQogCQlyZXR1cm47CiAKLQlyZWdfZnJl
ZV9yZXF1ZXN0KGxyKTsKKwlyZWdfZnJlZV9sYXN0X3JlcXVlc3QobHIpOwogCXJjdV9hc3NpZ25f
cG9pbnRlcihsYXN0X3JlcXVlc3QsIHJlcXVlc3QpOwogfQogCkBAIC0xNjE2LDcgKzE2MjIsNyBA
QCByZWdfcHJvY2Vzc19oaW50X3VzZXIoc3RydWN0IHJlZ3VsYXRvcnlfcmVxdWVzdCAqdXNlcl9y
ZXF1ZXN0KQogCXRyZWF0bWVudCA9IF9fcmVnX3Byb2Nlc3NfaGludF91c2VyKHVzZXJfcmVxdWVz
dCk7CiAJaWYgKHRyZWF0bWVudCA9PSBSRUdfUkVRX0lHTk9SRSB8fAogCSAgICB0cmVhdG1lbnQg
PT0gUkVHX1JFUV9BTFJFQURZX1NFVCkgewotCQlrZnJlZSh1c2VyX3JlcXVlc3QpOworCQlyZWdf
ZnJlZV9yZXF1ZXN0KHVzZXJfcmVxdWVzdCk7CiAJCXJldHVybiB0cmVhdG1lbnQ7CiAJfQogCkBA
IC0xNjc2LDE0ICsxNjgyLDE0IEBAIHJlZ19wcm9jZXNzX2hpbnRfZHJpdmVyKHN0cnVjdCB3aXBo
eSAqd2lwaHksCiAJY2FzZSBSRUdfUkVRX09LOgogCQlicmVhazsKIAljYXNlIFJFR19SRVFfSUdO
T1JFOgotCQlrZnJlZShkcml2ZXJfcmVxdWVzdCk7CisJCXJlZ19mcmVlX3JlcXVlc3QoZHJpdmVy
X3JlcXVlc3QpOwogCQlyZXR1cm4gdHJlYXRtZW50OwogCWNhc2UgUkVHX1JFUV9JTlRFUlNFQ1Q6
CiAJCS8qIGZhbGwgdGhyb3VnaCAqLwogCWNhc2UgUkVHX1JFUV9BTFJFQURZX1NFVDoKIAkJcmVn
ZCA9IHJlZ19jb3B5X3JlZ2QoZ2V0X2NmZzgwMjExX3JlZ2RvbSgpKTsKIAkJaWYgKElTX0VSUihy
ZWdkKSkgewotCQkJa2ZyZWUoZHJpdmVyX3JlcXVlc3QpOworCQkJcmVnX2ZyZWVfcmVxdWVzdChk
cml2ZXJfcmVxdWVzdCk7CiAJCQlyZXR1cm4gUkVHX1JFUV9JR05PUkU7CiAJCX0KIAkJcmN1X2Fz
c2lnbl9wb2ludGVyKHdpcGh5LT5yZWdkLCByZWdkKTsKQEAgLTE3NzcsMTAgKzE3ODMsMTAgQEAg
cmVnX3Byb2Nlc3NfaGludF9jb3VudHJ5X2llKHN0cnVjdCB3aXBoeSAqd2lwaHksCiAJY2FzZSBS
RUdfUkVRX0lHTk9SRToKIAkJLyogZmFsbCB0aHJvdWdoICovCiAJY2FzZSBSRUdfUkVRX0FMUkVB
RFlfU0VUOgotCQlrZnJlZShjb3VudHJ5X2llX3JlcXVlc3QpOworCQlyZWdfZnJlZV9yZXF1ZXN0
KGNvdW50cnlfaWVfcmVxdWVzdCk7CiAJCXJldHVybiB0cmVhdG1lbnQ7CiAJY2FzZSBSRUdfUkVR
X0lOVEVSU0VDVDoKLQkJa2ZyZWUoY291bnRyeV9pZV9yZXF1ZXN0KTsKKwkJcmVnX2ZyZWVfcmVx
dWVzdChjb3VudHJ5X2llX3JlcXVlc3QpOwogCQkvKgogCQkgKiBUaGlzIGRvZXNuJ3QgaGFwcGVu
IHlldCwgbm90IHN1cmUgd2UKIAkJICogZXZlciB3YW50IHRvIHN1cHBvcnQgaXQgZm9yIHRoaXMg
Y2FzZS4KQEAgLTE4NDEsNyArMTg0Nyw3IEBAIHN0YXRpYyB2b2lkIHJlZ19wcm9jZXNzX2hpbnQo
c3RydWN0IHJlZ3VsYXRvcnlfcmVxdWVzdCAqcmVnX3JlcXVlc3QpCiAJcmV0dXJuOwogCiBvdXRf
ZnJlZToKLQlrZnJlZShyZWdfcmVxdWVzdCk7CisJcmVnX2ZyZWVfcmVxdWVzdChyZWdfcmVxdWVz
dCk7CiB9CiAKIC8qCi0tIAoxLjguMS4yCgo=
--001a1134ab3cdc444604f69ea802--
