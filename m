Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3979 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab2LFIrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 03:47:25 -0500
Message-ID: <50C05B64.5050702@broadcom.com> (sfid-20121206_094728_701199_9403053C)
Date: Thu, 6 Dec 2012 09:46:28 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 05/11] brcmfmac: error messages should not be
 suppressed
References: <1354717564-7183-6-git-send-email-arend@broadcom.com>
 <1354742910-8822-1-git-send-email-arend@broadcom.com>
 <1354775578.8320.26.camel@joe-AO722>
In-Reply-To: <1354775578.8320.26.camel@joe-AO722>
Content-Type: multipart/mixed;
 boundary=------------010606040201010003070001
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------010606040201010003070001
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit

On 12/06/2012 07:32 AM, Joe Perches wrote:
> On Wed, 2012-12-05 at 22:28 +0100, Arend van Spriel wrote:
>> The call to brcmf_dbg(ERROR, ...) only resulted in a log message
>> when compiled with -DDEBUG. Error messages are valuable for resolving
>> issues so this patch replaces it with brcmf_err(...) so they always
>> end up in the log.
> []
>> Reviewed-by: Joe Perches <joe@perches.com>
> 
> Don't add signatures unless the person actually gives one.
> I didn't.

Sorry about that.

> []
> 
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
> []
>> @@ -35,20 +34,11 @@
>>  
>>  #if defined(DEBUG)
>>  
>> -#define brcmf_dbg(level, fmt, ...)					\
>> -do {									\
>> -	if (BRCMF_ERROR_VAL == BRCMF_##level##_VAL) {			\
>> -		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
>> -			if (net_ratelimit())				\
>> -				pr_debug("%s: " fmt,			\
>> -					 __func__, ##__VA_ARGS__);	\
>> -		}							\
>> -	} else {							\
>> -		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
>> -			pr_debug("%s: " fmt,				\
>> -				 __func__, ##__VA_ARGS__);		\
>> -		}							\
>> -	}								\
>> +#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
> 
> You still lost the net_ratelimit() for the DEBUG case.
> 
> This brcmf_err macro should probably be in dhd.h,
> not in a debug header and not guarded by DEBUG at all.

I thought I explained why in my email response to you, but now I don't
see that one on the mailing list archives (attached now). When we are
debugging we do not want error messages to be filtered.

Gr. AvS

--------------010606040201010003070001
Content-Type: application/x-extension-eml;
 name="Re: [PATCH 05_11] brcmfmac: error messages should not be suppressed.eml"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="Re: [PATCH 05_11] brcmfmac: error messages should not be sup";
 filename*1=pressed.eml

TWVzc2FnZS1JRDogPDUwQkY4NDRDLjgwNjAwMDZAYnJvYWRjb20uY29tPg0KRGF0ZTogV2Vk
LCAwNSBEZWMgMjAxMiAxODoyODo0NCArMDEwMA0KRnJvbTogQXJlbmQgdmFuIFNwcmllbCA8
YXJlbmRAYnJvYWRjb20uY29tPg0KVXNlci1BZ2VudDogTW96aWxsYS81LjAgKFgxMTsgTGlu
dXggaTY4NjsgcnY6MTYuMCkgR2Vja28vMjAxMjEwMjggVGh1bmRlcmJpcmQvMTYuMC4yDQpN
SU1FLVZlcnNpb246IDEuMA0KVG86IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5jb20+DQpD
QzogIkpvaG4gVy4gTGludmlsbGUiIDxsaW52aWxsZUB0dXhkcml2ZXIuY29tPiwgDQogTGlu
dXggV2lyZWxlc3MgTGlzdCA8bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnPg0KU3Vi
amVjdDogUmU6IFtQQVRDSCAwNS8xMV0gYnJjbWZtYWM6IGVycm9yIG1lc3NhZ2VzIHNob3Vs
ZCBub3QgYmUgc3VwcHJlc3NlZA0KUmVmZXJlbmNlczogPDEzNTQ3MTc1NjQtNzE4My0xLWdp
dC1zZW5kLWVtYWlsLWFyZW5kQGJyb2FkY29tLmNvbT4gPDEzNTQ3MTc1NjQtNzE4My02LWdp
dC1zZW5kLWVtYWlsLWFyZW5kQGJyb2FkY29tLmNvbT4gPDEzNTQ3MTg0ODkuODMyMC4xLmNh
bWVsQGpvZS1BTzcyMj4NCkluLVJlcGx5LVRvOiA8MTM1NDcxODQ4OS44MzIwLjEuY2FtZWxA
am9lLUFPNzIyPg0KWC1FbmlnbWFpbC1WZXJzaW9uOiAxLjQuNQ0KQ29udGVudC1UeXBlOiB0
ZXh0L3BsYWluOyBjaGFyc2V0PUlTTy04ODU5LTENCkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rp
bmc6IDdiaXQNCg0KT24gMTIvMDUvMjAxMiAwMzo0MSBQTSwgSm9lIFBlcmNoZXMgd3JvdGU6
DQo+IE9uIFdlZCwgMjAxMi0xMi0wNSBhdCAxNToyNSArMDEwMCwgQXJlbmQgdmFuIFNwcmll
bCB3cm90ZToNCj4+IFRoZSBjYWxsIHRvIGJyY21mX2RiZyhFUlJPUiwgLi4uKSBvbmx5IHJl
c3VsdGVkIGluIGEgbG9nIG1lc3NhZ2UNCj4+IHdoZW4gY29tcGlsZWQgd2l0aCAtRERFQlVH
LiBFcnJvciBtZXNzYWdlcyBhcmUgdmFsdWFibGUgZm9yIHJlc29sdmluZw0KPj4gaXNzdWVz
IHNvIHRoaXMgcGF0Y2ggcmVwbGFjZXMgaXQgd2l0aCBicmNtZl9lcnIoLi4uKSBzbyB0aGV5
IGFsd2F5cw0KPj4gZW5kIHVwIGluIHRoZSBsb2cuDQo+IA0KPiBTZWVtcyBsaWtlIGEgZ29v
ZCBpZGVhIGJ1dCB5b3UgYWxzbw0KPiByZW1vdmVkIHRoZSBuZXRfcmF0ZWxpbWl0KCkgd2hp
Y2ggZG9lc24ndC4NCg0KVGhhbmtzLCBKb2UNCg0KSSBkaWQgYXMgaXQgd2FzIG5hZ2dpbmcg
dXMgd2hlbiBkZWJ1Z2dpbmcuIEhvdyBhYm91dCB1c2luZw0KbmV0X3JhdGVsaW1pdCgpIGlm
IERFQlVHIGlzIG5vdCBkZWZpbmVkIHNvOg0KDQojaWYgIWRlZmluZWQoREVCVUcpDQojZGVm
aW5lIGJyY21mX2VycihmbXQsIC4uLikgXA0KCWRvIHsgXA0KCQlpZiAobmV0cmF0ZV9saW1p
dCgpKSBcDQoJCQlwcl9lcnIoIiVzOiAiIGZtdCwgX19mdW5jX18sICMjX19WQV9BUkdTX18p
OyBcDQoJd2hpbGUgKDApDQojZWxzZQ0KI2RlZmluZSBicmNtZl9lcnIoZm10LCAuLi4pIHBy
X2VycigiJXM6ICIgZm10LCBfX2Z1bmNfXywgIyNfX1ZBX0FSR1NfXykNCiA6DQojZW5kaWYN
Cg0KR3IuIEF2Uw0K
--------------010606040201010003070001--

