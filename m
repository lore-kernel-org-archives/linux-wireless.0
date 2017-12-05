Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:42498 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdLEQlX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:41:23 -0500
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
To: Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi
References: <20171202202332.10205-1-johannes@sipsolutions.net>
 <20171205.113145.172521292247335321.davem@davemloft.net>
 <1512491661.26976.19.camel@sipsolutions.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <fe8e7ad5-9579-31ce-0d02-a6c8522ba366@gmail.com> (sfid-20171205_174127_939112_BD0FA254)
Date: Tue, 5 Dec 2017 09:41:21 -0700
MIME-Version: 1.0
In-Reply-To: <1512491661.26976.19.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------215C1691EE29F28FBC7BDE3E"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------215C1691EE29F28FBC7BDE3E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/5/17 9:34 AM, Johannes Berg wrote:
> On Tue, 2017-12-05 at 11:31 -0500, David Miller wrote:
>>
>>> We could try to fix up the big endian problem here, but we
>>> don't know *how* userspace misbehaved - if using nla_put_u32
>>> then we could, but we also found a debug tool (which we'll
>>> ignore for the purposes of this regression) that was putting
>>> the padding into the length.
> 
>> We're stuck with this thing forever... I'd like to consider other
>> options.
>>
>> I've seen this problem at least one time before, therefore I
>> suggest when we see a U8 attribute with a U32's length:
>>
>> 1) We access it as a u32, this takes care of all endianness
>>    issues.
> 
> Possible, but as I said above, I've seen at least one tool (a debug
> only script) now that will actually emit a U8 followed by 3 bytes of
> padding to make it netlink-aligned, but set the length to 4. That would
> be broken by making this change.
> 
> I'm not saying this is bad - but there are different levels of
> compatibility and I'd probably go for "bug compatibility" here rather
> than "fix-it-up compatibility".
> 
> Your call, ultimately - I've already fixed the tool I had found :-)
> 
>> 2) We emit a warning so that the app gets fixes.
> 

The attached is my proposal. Basically, allow it the length mismatch but
print a warning. This restores previous behavior and tells users of bad
commands.

--------------215C1691EE29F28FBC7BDE3E
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-netlink-Relax-attr-validation-for-fixed-length-types.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-netlink-Relax-attr-validation-for-fixed-length-types.pa";
 filename*1="tch"

RnJvbSAyOWE1MDRjOGRlNTUzYzE3ZDRhYWZkNWEyY2I5Mzg0YTI4NjcyZmU0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+
CkRhdGU6IFN1biwgMyBEZWMgMjAxNyAwNzoyMjoyMCAtMDgwMApTdWJqZWN0OiBbUEFUQ0hd
IG5ldGxpbms6IFJlbGF4IGF0dHIgdmFsaWRhdGlvbiBmb3IgZml4ZWQgbGVuZ3RoIHR5cGVz
CgpDb21taXQgMjgwMzNhZTRlMGY1ICgibmV0OiBuZXRsaW5rOiBVcGRhdGUgYXR0ciB2YWxp
ZGF0aW9uIHRvIHJlcXVpcmUKZXhhY3QgbGVuZ3RoIGZvciBzb21lIHR5cGVzIikgcmVxdWly
ZXMgYXR0cmlidXRlcyB1c2luZyB0eXBlcyBOTEFfVSogYW5kCk5MQV9TKiB0byBoYXZlIGFu
IGV4YWN0IGxlbmd0aC4gVGhpcyBjaGFuZ2UgaXMgZXhwb3NpbmcgYnVncyBpbiB2YXJpb3Vz
CnVzZXJzcGFjZSBjb21tYW5kcyB0aGF0IGFyZSBzZW5kaW5nIGF0dHJpYnV0ZXMgd2l0aCBh
biBpbnZhbGlkIGxlbmd0aAooZS5nLiwgYXR0cmlidXRlIGhhcyB0eXBlIE5MQV9VOCBhbmQg
dXNlcnNwYWNlIHNlbmRzIE5MQV9VMzIpLiBXaGlsZQp0aGUgY29tbWFuZHMgYXJlIGNsZWFy
bHkgYnJva2VuIGFuZCBuZWVkIHRvIGJlIGZpeGVkLCB1c2VycyBhcmUgYXJndWluZwp0aGF0
IHRoZSBzdWRkZW4gY2hhbmdlIGluIGVuZm9yY2VtZW50IGlzIGJyZWFraW5nIG9sZGVyIGNv
bW1hbmRzIG9uCm5ld2VyIGtlcm5lbHMgZm9yIHVzZSBjYXNlcyB0aGF0IG90aGVyd2lzZSAi
d29ya2VkIi4KClJlbGF4IHRoZSB2YWxpZGF0aW9uIHRvIHByaW50IGEgd2FybmluZyBtZXNh
Z2Ugc2ltaWxhciB0byB3aGF0IGlzIGRvbmUKZm9yIG1lc3NhZ2VzIGNvbnRhaW5pbmcgZXh0
cmEgYnl0ZXMgYWZ0ZXIgcGFyc2luZy4KCkZpeGVzOiAyODAzM2FlNGUwZjUgKCJuZXQ6IG5l
dGxpbms6IFVwZGF0ZSBhdHRyIHZhbGlkYXRpb24gdG8gcmVxdWlyZSBleGFjdCBsZW5ndGgg
Zm9yIHNvbWUgdHlwZXMiKQpTaWduZWQtb2ZmLWJ5OiBEYXZpZCBBaGVybiA8ZHNhaGVybkBn
bWFpbC5jb20+Ci0tLQogbGliL25sYXR0ci5jIHwgMTUgKysrKysrKysrKystLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9saWIvbmxhdHRyLmMgYi9saWIvbmxhdHRyLmMKaW5kZXggOGJmNzhiNGI3OGYwLi42
MTIyNjYyOTA2YzggMTAwNjQ0Ci0tLSBhL2xpYi9ubGF0dHIuYworKysgYi9saWIvbmxhdHRy
LmMKQEAgLTI4LDggKzI4LDE2IEBAIHN0YXRpYyBjb25zdCB1OCBubGFfYXR0cl9sZW5bTkxB
X1RZUEVfTUFYKzFdID0gewogfTsKIAogc3RhdGljIGNvbnN0IHU4IG5sYV9hdHRyX21pbmxl
bltOTEFfVFlQRV9NQVgrMV0gPSB7CisJW05MQV9VOF0JPSBzaXplb2YodTgpLAorCVtOTEFf
VTE2XQk9IHNpemVvZih1MTYpLAorCVtOTEFfVTMyXQk9IHNpemVvZih1MzIpLAorCVtOTEFf
VTY0XQk9IHNpemVvZih1NjQpLAogCVtOTEFfTVNFQ1NdCT0gc2l6ZW9mKHU2NCksCiAJW05M
QV9ORVNURURdCT0gTkxBX0hEUkxFTiwKKwlbTkxBX1M4XQk9IHNpemVvZihzOCksCisJW05M
QV9TMTZdCT0gc2l6ZW9mKHMxNiksCisJW05MQV9TMzJdCT0gc2l6ZW9mKHMzMiksCisJW05M
QV9TNjRdCT0gc2l6ZW9mKHM2NCksCiB9OwogCiBzdGF0aWMgaW50IHZhbGlkYXRlX25sYV9i
aXRmaWVsZDMyKGNvbnN0IHN0cnVjdCBubGF0dHIgKm5sYSwKQEAgLTcwLDEwICs3OCw5IEBA
IHN0YXRpYyBpbnQgdmFsaWRhdGVfbmxhKGNvbnN0IHN0cnVjdCBubGF0dHIgKm5sYSwgaW50
IG1heHR5cGUsCiAJQlVHX09OKHB0LT50eXBlID4gTkxBX1RZUEVfTUFYKTsKIAogCS8qIGZv
ciBkYXRhIHR5cGVzIE5MQV9VKiBhbmQgTkxBX1MqIHJlcXVpcmUgZXhhY3QgbGVuZ3RoICov
Ci0JaWYgKG5sYV9hdHRyX2xlbltwdC0+dHlwZV0pIHsKLQkJaWYgKGF0dHJsZW4gIT0gbmxh
X2F0dHJfbGVuW3B0LT50eXBlXSkKLQkJCXJldHVybiAtRVJBTkdFOwotCQlyZXR1cm4gMDsK
KwlpZiAobmxhX2F0dHJfbGVuW3B0LT50eXBlXSAmJiBhdHRybGVuICE9IG5sYV9hdHRyX2xl
bltwdC0+dHlwZV0pIHsKKwkJcHJfd2Fybl9yYXRlbGltaXRlZCgibmV0bGluazogJyVzJzog
YXR0cmlidXRlIHR5cGUgJWQgaGFzIGFuIGludmFsaWQgbGVuZ3RoLlxuIiwKKwkJCQkgICAg
Y3VycmVudC0+Y29tbSwgdHlwZSk7CiAJfQogCiAJc3dpdGNoIChwdC0+dHlwZSkgewotLSAK
Mi4xMS4wCgo=
--------------215C1691EE29F28FBC7BDE3E--
