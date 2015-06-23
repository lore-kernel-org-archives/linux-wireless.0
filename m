Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:25164 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbbFWMIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 08:08:36 -0400
Message-ID: <55894C40.1070108@broadcom.com> (sfid-20150623_140840_174700_1FCEE350)
Date: Tue, 23 Jun 2015 14:08:32 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <joerg.krause@embedded.rocks>
CC: Arend van Spriel <aspriel@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No space
 left on device)
References: <1433766944.28058.16.camel@embedded.rocks>						 <55758D7E.3000603@broadcom.com>				 <1433771289.28058.24.camel@embedded.rocks>				 <5575C6FA.6030104@broadcom.com>				 <1433794640.28058.26.camel@embedded.rocks>		 <557605CC.6070907@broadcom.com>	 <1434448766.21949.9.camel@embedded.rocks>		 <55803214.2030204@broadcom.com> <1434608018.5481.4.camel@embedded.rocks>		 <55828106.7060004@broadcom.com> <1434658050.2532.6.camel@embedded.rocks>	 <55872A3C.7030704@gmail.com> <1435059083.4765.2.camel@embedded.rocks>
In-Reply-To: <1435059083.4765.2.camel@embedded.rocks>
Content-Type: multipart/mixed;
	boundary="------------000504030908070102010005"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------000504030908070102010005
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 06/23/15 13:31, Jörg Krause wrote:
> Hi Arend,
>
> On So, 2015-06-21 at 23:18 +0200, Arend van Spriel wrote:
>>
>> My bad. The patch removes p2pdev from interface modes, but it is
>> still
>> listed in the interface combinations and cfg80211 will complain about
>> it. Have to extend the patch. I better do that after a good nights
>> sleep.
>
> Never mind! Did you had a good night sleep already :-) ?

Several ;-) Did not get to this earlier. Thanks for the reminder.

Had a closer look at wiphy_verify_combinations() and I am hopeful the 
attached patch will fix the wiphy_register() failure.

Regards,
Arend

> Best regards
> Jörg Krause


--------------000504030908070102010005
Content-Type: text/plain;
	name="0001-brcmfmac-no-p2pdev-limit-needed-when-p2pon-1-is-used.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-brcmfmac-no-p2pdev-limit-needed-when-p2pon-1-is-used.pa";
	filename*1="tch"

RnJvbSBmNDkwYTdjZGIyYTc1NGFjNzlhZjlkOTA4MmI4NTI2ODEyMTY0ZDRmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBcmVuZCB2YW4gU3ByaWVsIDxhcmVuZEBicm9hZGNv
bS5jb20+CkRhdGU6IFR1ZSwgMjMgSnVuIDIwMTUgMTM6NTk6MjMgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBicmNtZm1hYzogbm8gcDJwZGV2IGxpbWl0IG5lZWRlZCB3aGVuIHAycG9uPTEg
aXMgdXNlZAoKQXZvaWQgZmFpbHVyZSB1cG9uIHdpcGh5X3JlZ2lzdGVyKCkgYnkgbm90IHBy
b3ZpZGluZyB0aGUgbGltaXQKZm9yIGlmdHlwZSBQMlBfREVWSUNFLgoKU2lnbmVkLW9mZi1i
eTogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmRAYnJvYWRjb20uY29tPgotLS0KIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL2JyY204MDIxMS9icmNtZm1hYy9jZmc4MDIxMS5jIHwgNCArKysrCiAx
IGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYwppbmRleCAxMGVhYWJm
Li5mZmE5YWNhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icmNtODAyMTEv
YnJjbWZtYWMvY2ZnODAyMTEuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icmNtODAy
MTEvYnJjbWZtYWMvY2ZnODAyMTEuYwpAQCAtNTgwMiw2ICs1ODAyLDEwIEBAIHN0YXRpYyBp
bnQgYnJjbWZfc2V0dXBfd2lwaHkoc3RydWN0IHdpcGh5ICp3aXBoeSwgc3RydWN0IGJyY21m
X2lmICppZnApCiAJCWlmY19jb21iby5uX2xpbWl0cyA9IEFSUkFZX1NJWkUoYnJjbWZfaWZh
Y2VfbGltaXRzX21ic3MpLAogCQlpZmNfY29tYm8ubGltaXRzID0gYnJjbWZfaWZhY2VfbGlt
aXRzX21ic3M7CiAJfQorCS8qIGRvbid0IGdpdmUgcDJwZGV2IGxpbWl0IHdoZW4gcDJwb24g
aXMgc2V0ICovCisJaWYgKGlmcC0+ZHJ2ci0+aWZsaXN0WzFdKQorCQlpZmNfY29tYm8ubGlt
aXRzLS07CisKIAl3aXBoeS0+aWZhY2VfY29tYmluYXRpb25zID0ga21lbWR1cCgmaWZjX2Nv
bWJvLAogCQkJCQkgICAgc2l6ZW9mKGlmY19jb21ibyksCiAJCQkJCSAgICBHRlBfS0VSTkVM
KTsKLS0gCjEuOS4xCgo=
--------------000504030908070102010005--
