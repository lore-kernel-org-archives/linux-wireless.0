Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59316 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaILQ3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 12:29:39 -0400
Received: by mail-wi0-f173.google.com with SMTP id em10so954544wid.6
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2014 09:29:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <1472277.xX1dghvxoC@bs8>
References: <CAN8YU5NOApnft04+N3rSQF3j9d9N47-A6m4n-1-2KNHq+1EYKA@mail.gmail.com>
 <1472277.xX1dghvxoC@bs8>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Fri, 12 Sep 2014 18:29:17 +0200
Message-ID: <CAN8YU5OHAmYp-7Ojti3aSeGWJr=dU0Xb=Du_w_QqPUezno_=DQ@mail.gmail.com> (sfid-20140912_182944_788177_37E55D0A)
Subject: Re: Rtl8187se regression [was: rtl8187se - serious regressions since
 merge out of staging into 818x]
To: Bernhard Schiffner <bernhard@schiffner-limbach.de>
Cc: ralf@czekalla.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: multipart/mixed; boundary=e89a8f2354ef8f95450502e0ca77
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--e89a8f2354ef8f95450502e0ca77
Content-Type: text/plain; charset=UTF-8

> Because of the problems I'am going now to a special site, where I have a local
> networks (LAN/WLAN), good internet connection and root access to Linux
> machines.
> This should be a good thing to do real testing.

Excellent!
Thank you Bernhard!

> 1.) Andrea, can you resend me the latest patches (perhaps against 3.16)
> please?
> (only to confirm that we are in "synchronous" mode.)

Sure, I attach a cumulative patch, including all the changes I think
may matter (signal strength fix not included)

> 2.) Andrea, Larry, John are you interested to have root access to my laptop
> using the rtl8187se?
> (Perhaps it can stay there over the weekend too.)

Thank you for offering this :)
In case it turns out that you actually face performance regressions,
then it might help me to make some experiments using your machine.

I will do a register dump and I will try to tune some parameters in
the driver. This should NOT crash the machine, but if it is vital for
you that the machine remains alive, then maybe I will avoid at least
certain experiments..

Possibly tomorrow afternoon (Italian time) I will have some spare time
to work on this.

> 3.) My test for maximal troughput is to run a connection /dev/zero -> nc ->|->
> nc -> /dev/null.
> Any other ideas?

Usually I use two Linux hosts (the DUT and my production system) and I
use "iperf" program on both
On the production system (the iperf server) I run
iperf -s -u -b30M
On the DUT I run
iperf -c 192.168.1.2 -r -u -b30M

This will cause an UDP data exchange and will perform both downstream
and upstream throughput measurements.
I usually do this (at least) two times, and I discard results from the
first run, because rate selection algorithm might eventually need a
bit settle to a "good" rate.

> 4.) I think to have this setup ready about 11:30 UTC.

I was at my workplace, I really couldn't do quicker than this..
Sorry.. I hope we are still in time...

> I'am open to any suggestion from your side.

Tests that may also help are:
- test performance regression when you are both close to the AP and
enough far from it that performances significantly drops.
- check if the rtl818x_pci driver and the old driver settles at
(about) the same rates..

>
> Bernhard

Thank you really much Bernhard for you help.
I hope this can lead to solve issues, and anyway I appreciate it very much :)

Andrea

> Am Freitag, 12. September 2014, 02:18:03 schrieb Andrea Merello:
>> My aplogies for this quick and a bit messy reply: I m from mobile.
>>
>> @Xose
>> Thank you for forwarding me that. I wasn t aware of it.
>>
>> (BTW a couple of other people reported a similar issue)
>>
>> @Ralf
>> The driver still have some not implemented features, including signal
>> strenght measure, furthermore some fixes that might improve performances
>> should be on the way for 3.17.
>>
>> @Larry, Bernhard
>> I think those fixes was basically the same of some RFT patch I sent you
>> some time ago..
>> Have you had any occasion to test those patches?
>>
>> @Ralf, all..
>> I must say that I never been able to reproduce any severe performance
>> regression here, for this reason I'm asking people who reports this to make
>> some testing for me if possible..
>>
>> Here you can find  a similar report and my answer where I asked for the
>> tests:
>> https://bugzilla.kernel.org/show_bug.cgi?id=83631
>>
>> If you could do some of those test for me, that would be great.
>>
>

--e89a8f2354ef8f95450502e0ca77
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-rtl818x_pci-backport-rtl8187se-fixes-to-3.16.patch"
Content-Disposition: attachment;
	filename="0001-rtl818x_pci-backport-rtl8187se-fixes-to-3.16.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hzzqgzli0

RnJvbSAzNDViNGZjN2YyMmM0YTgzZTJhNDgxYjY1YTg0ODllYTJhNDc1ZTVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZWEgTWVyZWxsbyA8YW5kcmVhLm1lcmVsbG9AZ21haWwu
Y29tPgpEYXRlOiBGcmksIDEyIFNlcCAyMDE0IDE3OjM0OjA0ICswMjAwClN1YmplY3Q6IFtQQVRD
SF0gcnRsODE4eF9wY2k6IGJhY2twb3J0IHJ0bDgxODdzZSBmaXhlcyB0byAzLjE2CgotIEZpeCBm
b3IgcGFja2V0IHJldHJpZXMgd3JvbmcgY291bnQgYW5kIGJyb2tlbiByYXRlIHNjYWxpbmcKLSBB
ZGRlZCBtZW1vcnkgYmFycmllcnMgdG8gZW5zdXJlIHBhY2tldCBjb3JyZWN0bmVzcwotIEZpeGVk
IEJTU0lEIHJlZ2lzdGVyIHdyaXRlIGZhaWxzIG9uIGNlcnRhaW4gQVNJQ3MgKG5vdCBzdXJlIGlm
IGFueSBydGw4MTg3c2UgbWF5IGJlIGFmZmVjdGVkKQoKU2lnbmVkLW9mZi1ieTogQW5kcmVhIE1l
cmVsbG8gPGFuZHJlYS5tZXJlbGxvQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVz
cy9ydGw4MTh4L3J0bDgxODAvZGV2LmMgfCAyNCArKysrKysrKysrKysrKystLS0tLS0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4MC9kZXYuYyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4MC9kZXYuYwppbmRleCAyYzFjMDJiLi4xZWZlZmNi
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGw4MTh4L3J0bDgxODAvZGV2LmMK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsODE4eC9ydGw4MTgwL2Rldi5jCkBAIC0yMjIs
MTIgKzIyMiwyMCBAQCBzdGF0aWMgdm9pZCBydGw4MTgwX2hhbmRsZV9yeChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpkZXYpCiAJCQlzdHJ1Y3QgcnRsODE4N3NlX3J4X2Rlc2MgKmRlc2MgPSBlbnRyeTsK
IAogCQkJZmxhZ3MgPSBsZTMyX3RvX2NwdShkZXNjLT5mbGFncyk7CisJCQkvKiBpZiBvd25lcnNo
aXAgZmxhZyBpcyBzZXQsIHRoZW4gd2UgY2FuIHRydXN0IHRoZQorCQkJICogSFcgaGFzIHdyaXR0
ZW4gb3RoZXIgZmllbGRzLiBXZSBtdXN0IG5vdCB0cnVzdAorCQkJICogb3RoZXIgZGVzY3JpcHRv
ciBkYXRhIHJlYWQgYmVmb3JlIHdlIGNoZWNrZWQgKHJlYWQpCisJCQkgKiB0aGUgb3duZXJzaGlw
IGZsYWcKKwkJCSAqLworCQkJcm1iKCk7CiAJCQlmbGFnczIgPSBsZTMyX3RvX2NwdShkZXNjLT5m
bGFnczIpOwogCQkJdHNmdCA9IGxlNjRfdG9fY3B1KGRlc2MtPnRzZnQpOwogCQl9IGVsc2Ugewog
CQkJc3RydWN0IHJ0bDgxODBfcnhfZGVzYyAqZGVzYyA9IGVudHJ5OwogCiAJCQlmbGFncyA9IGxl
MzJfdG9fY3B1KGRlc2MtPmZsYWdzKTsKKwkJCS8qIHNhbWUgYXMgYWJvdmUgKi8KKwkJCXJtYigp
OwogCQkJZmxhZ3MyID0gbGUzMl90b19jcHUoZGVzYy0+ZmxhZ3MyKTsKIAkJCXRzZnQgPSBsZTY0
X3RvX2NwdShkZXNjLT50c2Z0KTsKIAkJfQpAQCAtMzM2LDcgKzM0NCw2IEBAIHN0YXRpYyB2b2lk
IHJ0bDgxODBfaGFuZGxlX3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmRldiwgdW5zaWduZWQgaW50
IHByaW8pCiAJCQlpbmZvLT5mbGFncyB8PSBJRUVFODAyMTFfVFhfU1RBVF9BQ0s7CiAKIAkJaW5m
by0+c3RhdHVzLnJhdGVzWzBdLmNvdW50ID0gKGZsYWdzICYgMHhGRikgKyAxOwotCQlpbmZvLT5z
dGF0dXMucmF0ZXNbMV0uaWR4ID0gLTE7CiAKIAkJaWVlZTgwMjExX3R4X3N0YXR1c19pcnFzYWZl
KGRldiwgc2tiKTsKIAkJaWYgKHJpbmctPmVudHJpZXMgLSBza2JfcXVldWVfbGVuKCZyaW5nLT5x
dWV1ZSkgPT0gMikKQEAgLTUyOCw5ICs1MzUsNyBAQCBzdGF0aWMgdm9pZCBydGw4MTgwX3R4KHN0
cnVjdCBpZWVlODAyMTFfaHcgKmRldiwKIAllbnRyeS0+cGxjcF9sZW4gPSBjcHVfdG9fbGUxNihw
bGNwX2xlbik7CiAJZW50cnktPnR4X2J1ZiA9IGNwdV90b19sZTMyKG1hcHBpbmcpOwogCi0JZW50
cnktPmZsYWdzMiA9IGluZm8tPmNvbnRyb2wucmF0ZXNbMV0uaWR4ID49IDAgPwotCQlpZWVlODAy
MTFfZ2V0X2FsdF9yZXRyeV9yYXRlKGRldiwgaW5mbywgMCktPmJpdHJhdGUgPDwgNCA6IDA7Ci0J
ZW50cnktPnJldHJ5X2xpbWl0ID0gaW5mby0+Y29udHJvbC5yYXRlc1swXS5jb3VudDsKKwllbnRy
eS0+cmV0cnlfbGltaXQgPSBpbmZvLT5jb250cm9sLnJhdGVzWzBdLmNvdW50IC0gMTsKIAogCS8q
IFdlIG11c3QgYmUgc3VyZSB0aGF0IHR4X2ZsYWdzIGlzIHdyaXR0ZW4gbGFzdCBiZWNhdXNlIHRo
ZSBIVwogCSAqIGxvb2tzIGF0IGl0IHRvIGNoZWNrIGlmIHRoZSByZXN0IG9mIGRhdGEgaXMgdmFs
aWQgb3Igbm90CkBAIC04NTIsNyArODU3LDcgQEAgc3RhdGljIGludCBydGw4MTgwX2luaXRfaHco
c3RydWN0IGllZWU4MDIxMV9odyAqZGV2KQogCiAJaWYgKHByaXYtPmNoaXBfZmFtaWx5ICE9IFJU
TDgxOFhfQ0hJUF9GQU1JTFlfUlRMODE4MCkgewogCQlydGw4MTh4X2lvd3JpdGU4KHByaXYsICZw
cml2LT5tYXAtPldQQV9DT05GLCAwKTsKLQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+
bWFwLT5SQVRFX0ZBTExCQUNLLCAweDgxKTsKKwkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJp
di0+bWFwLT5SQVRFX0ZBTExCQUNLLCAwKTsKIAl9IGVsc2UgewogCQlydGw4MTh4X2lvd3JpdGU4
KHByaXYsICZwcml2LT5tYXAtPlNFQ1VSSVRZLCAwKTsKIApAQCAtMTQ1MCw5ICsxNDU1LDEwIEBA
IHN0YXRpYyB2b2lkIHJ0bDgxODBfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpkZXYsCiAJdmlmX3ByaXYgPSAoc3RydWN0IHJ0bDgxODBfdmlmICopJnZpZi0+ZHJ2X3ByaXY7
CiAKIAlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JTU0lEKSB7Ci0JCWZvciAoaSA9IDA7IGkg
PCBFVEhfQUxFTjsgaSsrKQotCQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+bWFwLT5C
U1NJRFtpXSwKLQkJCQkJIGluZm8tPmJzc2lkW2ldKTsKKwkJcnRsODE4eF9pb3dyaXRlMTYocHJp
diwgKF9fbGUxNiBfX2lvbWVtICopJnByaXYtPm1hcC0+QlNTSURbMF0sCisJCQkJICBsZTE2X3Rv
X2NwdSgqKF9fbGUxNiAqKWluZm8tPmJzc2lkKSk7CisJCXJ0bDgxOHhfaW93cml0ZTMyKHByaXYs
IChfX2xlMzIgX19pb21lbSAqKSZwcml2LT5tYXAtPkJTU0lEWzJdLAorCQkJCSAgbGUzMl90b19j
cHUoKihfX2xlMzIgKikoaW5mby0+YnNzaWQgKyAyKSkpOwogCiAJCWlmIChpc192YWxpZF9ldGhl
cl9hZGRyKGluZm8tPmJzc2lkKSkgewogCQkJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQ
RV9BREhPQykKQEAgLTE3MjMsNyArMTcyOSw3IEBAIHN0YXRpYyBpbnQgcnRsODE4MF9wcm9iZShz
dHJ1Y3QgcGNpX2RldiAqcGRldiwKIAlwcml2ID0gZGV2LT5wcml2OwogCXByaXYtPnBkZXYgPSBw
ZGV2OwogCi0JZGV2LT5tYXhfcmF0ZXMgPSAyOworCWRldi0+bWF4X3JhdGVzID0gMTsKIAlTRVRf
SUVFRTgwMjExX0RFVihkZXYsICZwZGV2LT5kZXYpOwogCXBjaV9zZXRfZHJ2ZGF0YShwZGV2LCBk
ZXYpOwogCi0tIAoxLjkuMQoK
--e89a8f2354ef8f95450502e0ca77--
