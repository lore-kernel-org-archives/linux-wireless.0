Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:60208 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbbFRI1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 04:27:53 -0400
Message-ID: <55828106.7060004@broadcom.com> (sfid-20150618_102800_236331_51E37D48)
Date: Thu, 18 Jun 2015 10:27:50 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <joerg.krause@embedded.rocks>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No space
 left on device)
References: <1433766944.28058.16.camel@embedded.rocks>				 <55758D7E.3000603@broadcom.com>		 <1433771289.28058.24.camel@embedded.rocks>		 <5575C6FA.6030104@broadcom.com>		 <1433794640.28058.26.camel@embedded.rocks> <557605CC.6070907@broadcom.com>	 <1434448766.21949.9.camel@embedded.rocks> <55803214.2030204@broadcom.com> <1434608018.5481.4.camel@embedded.rocks>
In-Reply-To: <1434608018.5481.4.camel@embedded.rocks>
Content-Type: multipart/mixed;
	boundary="------------030908010501010809070609"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------030908010501010809070609
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 06/18/15 08:13, Jörg Krause wrote:
> Hi Arend,
>
> On Di, 2015-06-16 at 16:26 +0200, Arend van Spriel wrote:
>> On 06/16/15 11:59, Jörg Krause wrote:
>>> Hi Arend,
>>>
>>> as I wrote in my previous mail ("brcmfmac: brcmf_p2p_create_p2pdev:
>>> timeout occurred") I get a p2p0 interface when loading the brcmfmac
>>> module with p2pon=1 (Linux kernel 4.0.5, BCM43362).
>>>
>>> Unfortunatly, if I try to use the p2p0 interface with
>>> wpa_supplicant
>>> 2.4 I get an error:
>>>
>>>       Failed to create interface p2p-dev-p2p0: -28 (No space left on
>>>       device)
>>>       nl80211: Failed to create a P2P Device interface p2p-dev-p2p0
>>>       P2P: Failed to enable P2P Device interface
>>
>> Using p2pon=1 is old-school p2p, ie. it creates a regular netdev for
>> doing p2p management stuff. Problem is that brcmfmac also indicates
>> p2p
>> device support. We can remove p2pon parameter or not indicate p2p dev
>>
>> support when p2pon=1.
>
> I used p2pon because the p2p0 interface is not created without it. It
> fails with the error message "brcmf_p2p_create_p2pdev: timeout
> occurred" as written in my previous mails. I would prefer not to use
> it, so maybe we can find a solution how to get it working without it.

43362 firmware may have issues with regular p2p dev support so let's 
stick with p2pon for now.
>>
>> Can you patch brcmfmac and give it a try. Need to start
>> wpa_supplicant
>> for two interface and if I recall correctly p2p0 must be specified
>> first.
>
> Can you give me a hint where to patch brcmfmac. Many thanks!

Attached is patch against 4.0.5 kernel.

Regards,
Arend

--------------030908010501010809070609
Content-Type: text/plain;
	name="0001-brcmfmac-disable-p2pdev-support-when-using-p2pon-1.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-brcmfmac-disable-p2pdev-support-when-using-p2pon-1.patc";
	filename*1="h"

RnJvbSA5OWJiYmFhNTQwZmU5NTQzMTU2MDE4YjdmODU5NmI0NmY2MGE3MjNjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBcmVuZCB2YW4gU3ByaWVsIDxhcmVuZEBicm9hZGNv
bS5jb20+CkRhdGU6IFRodSwgMTggSnVuIDIwMTUgMTA6MjM6NTAgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBicmNtZm1hYzogZGlzYWJsZSBwMnBkZXYgc3VwcG9ydCB3aGVuIHVzaW5nIHAy
cG9uPTEKCkF2b2lkIHdwYV9zdXBwbGljYW50IGZyb20gY3JlYXRpbmcgYSBwMnBkZXYgaW50
ZXJmYWNlIHdoZW4gd2UKYWxyZWFkeSBoYXZlIGEgcDJwMCBpbnRlcmZhY2UsIGllLiBsb2Fk
ZWQgdGhlIGRyaXZlciB3aXRoIHAycG9uPTEuCgpTaWduZWQtb2ZmLWJ5OiBBcmVuZCB2YW4g
U3ByaWVsIDxhcmVuZEBicm9hZGNvbS5jb20+Ci0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMgfCA3ICsrKysrLS0KIDEgZmlsZSBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYwppbmRleCBi
NTliOGM2Li4xMGVhYWJmIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icmNt
ODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9i
cmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYwpAQCAtNTc4OSw4ICs1Nzg5LDExIEBAIHN0
YXRpYyBpbnQgYnJjbWZfc2V0dXBfd2lwaHkoc3RydWN0IHdpcGh5ICp3aXBoeSwgc3RydWN0
IGJyY21mX2lmICppZnApCiAJCQkJIEJJVChOTDgwMjExX0lGVFlQRV9BREhPQykgfAogCQkJ
CSBCSVQoTkw4MDIxMV9JRlRZUEVfQVApIHwKIAkJCQkgQklUKE5MODAyMTFfSUZUWVBFX1Ay
UF9DTElFTlQpIHwKLQkJCQkgQklUKE5MODAyMTFfSUZUWVBFX1AyUF9HTykgfAotCQkJCSBC
SVQoTkw4MDIxMV9JRlRZUEVfUDJQX0RFVklDRSk7CisJCQkJIEJJVChOTDgwMjExX0lGVFlQ
RV9QMlBfR08pOworCS8qIG9ubHkgYW5ub3VjZSBwMnBkZXYgd2hlbiBwMnBvbiBpcyB6ZXJv
ICovCisJaWYgKCFpZnAtPmRydnItPmlmbGlzdFsxXSkKKwkJd2lwaHktPmludGVyZmFjZV9t
b2RlcyB8PSBCSVQoTkw4MDIxMV9JRlRZUEVfUDJQX0RFVklDRSk7CisKIAkvKiBuZWVkIFZT
REIgZmlybXdhcmUgZmVhdHVyZSBmb3IgY29uY3VycmVudCBjaGFubmVscyAqLwogCWlmY19j
b21ibyA9IGJyY21mX2lmYWNlX2NvbWJvc1swXTsKIAlpZiAoYnJjbWZfZmVhdF9pc19lbmFi
bGVkKGlmcCwgQlJDTUZfRkVBVF9NQ0hBTikpCi0tIAoxLjkuMQoK
--------------030908010501010809070609--
