Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47180 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2A0DHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 22:07:48 -0500
Received: by wgbgn7 with SMTP id gn7so673116wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 19:07:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALGY4ft1y00caq9xEhMkm4L3jO9pt0NDXYjUO+TLS12w8ZAT5g@mail.gmail.com>
References: <CALGY4ft1y00caq9xEhMkm4L3jO9pt0NDXYjUO+TLS12w8ZAT5g@mail.gmail.com>
Date: Thu, 26 Jan 2012 19:07:46 -0800
Message-ID: <CANUX_P3g4Gh0sgbxu7priapZmqeZXAKx6h22QrpiNtZatU1mCw@mail.gmail.com> (sfid-20120127_040750_478231_18EAC6F6)
Subject: Re: iwlwifi regression
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d0442829c1926cd04b779cd03
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d0442829c1926cd04b779cd03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

please try the attached patch + debug=3D0xC0000000. It will be noisy
Emmanuel Grumbach
egrumbach@gmail.com



On Thu, Jan 26, 2012 at 18:46, Nikolay Martynov <mar.kolya@gmail.com> wrote=
:
> Hi.
>
> =A0I seeing regression in iwlwifi using intel 5300 card. It used to
> work fine but after one upgrade is started to fail. Symptom: at some
> point card stops transmitting or receiving any data, but still holds
> connection. No specific errors in logs. Disconnecting/reconnecting
> helps for very short period.
> =A0I was able to track it down and it looks like the problem was
> introduced in next-20111222. I.e. next-20111221 is fine, next-20111222
> is not (compat-wireless-2011-12-18 is fine, 2011-12-23 is broken).
>
> =A0I tried to look into diff between next-20111221 and next-20111222
> but it looks quite large and I do not really know how to bisect it
> further. So I'd appreciate any hint on this.
> =A0I'd be happy to provide any additional information and can try
> patches locally.
> =A0Thanks!
>
> --
> Truthfully yours,
> Martynov Nikolay.
> Email: mar.kolya@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

--f46d0442829c1926cd04b779cd03
Content-Type: application/octet-stream; name="tid.patch"
Content-Disposition: attachment; filename="tid.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxwmsvj50

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi10eC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKaW5kZXggZDlkNzU4ZS4u
MWI3MDA0OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXR4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKQEAg
LTk1LDYgKzk1LDcgQEAgc3RhdGljIHZvaWQgaXdsYWduX3R4X2NtZF9idWlsZF9iYXNpYyhzdHJ1
Y3QgaXdsX3ByaXYgKnByaXYsCiAJCQl0eF9mbGFncyB8PSBUWF9DTURfRkxHX1NFUV9DVExfTVNL
OwogCQllbHNlCiAJCQl0eF9mbGFncyAmPSB+VFhfQ01EX0ZMR19TRVFfQ1RMX01TSzsKKwkJdHhf
Y21kLT50aWRfdHNwZWMgPSBJV0xfTUFYX1RJRF9DT1VOVDsKIAl9CiAKIAlpd2xhZ25fdHhfY21k
X3Byb3RlY3Rpb24ocHJpdiwgaW5mbywgZmMsICZ0eF9mbGFncyk7CkBAIC04MDgsNiArODA5LDgg
QEAgc3RhdGljIHZvaWQgaXdsX3J4X3JlcGx5X3R4X2FnZyhzdHJ1Y3QgaXdsX3ByaXYgKnByaXYs
CiAJdTMyIHN0YXR1cyA9IGxlMTZfdG9fY3B1KHR4X3Jlc3AtPnN0YXR1cy5zdGF0dXMpOwogCWlu
dCBpOwogCisgICAgICAgIFdBUk5fT04odGlkID09IElXTF9NQVhfVElEX0NPVU5UKTsKKwogCWlm
IChhZ2ctPndhaXRfZm9yX2JhKQogCQlJV0xfREVCVUdfVFhfUkVQTFkocHJpdiwKIAkJCSJnb3Qg
dHggcmVzcG9uc2Ugdy9vIGJsb2NrLWFja1xuIik7CkBAIC0xMDM1LDEwICsxMDM4LDEyIEBAIGlu
dCBpd2xhZ25fcnhfcmVwbHlfdHgoc3RydWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3QgaXdsX3J4
X21lbV9idWZmZXIgKnJ4YiwKIAkJfQogCiAJCV9fc2tiX3F1ZXVlX2hlYWRfaW5pdCgmc2ticyk7
Ci0JCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1lZCA9IG5leHRfcmVj
bGFpbWVkOwogCi0JCUlXTF9ERUJVR19UWF9SRVBMWShwcml2LCAiTmV4dCByZWNsYWltZWQgcGFj
a2V0OiVkIiwKLQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCWlmICh0aWQgIT0gSVdMX01BWF9U
SURfQ09VTlQpIHsKKwkJCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1l
ZCA9IG5leHRfcmVjbGFpbWVkOworCQkJSVdMX0RFQlVHX1RYX1JFUExZKHByaXYsICJOZXh0IHJl
Y2xhaW1lZCBwYWNrZXQ6JWQiLAorCQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCX0KIAogCQkv
KndlIGNhbiBmcmVlIHVudGlsIHNzbiAlIHEubl9iZCBub3QgaW5jbHVzaXZlICovCiAJCVdBUk5f
T04oaXdsX3RyYW5zX3JlY2xhaW0odHJhbnMocHJpdiksIHN0YV9pZCwgdGlkLCB0eHFfaWQsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMKaW5kZXggYWE4
Nzk5NC4uZmExYjM2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtdHJhbnMtcGNpZS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRy
YW5zLXBjaWUuYwpAQCAtMTU1MSw3ICsxNTUxLDcgQEAgc3RhdGljIGludCBpd2xfdHJhbnNfcGNp
ZV9yZWNsYWltKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBpbnQgc3RhX2lkLCBpbnQgdGlkLAog
CiAJdHhxLT50aW1lX3N0YW1wID0gamlmZmllczsKIAotCWlmICh1bmxpa2VseSh0eHFfaWQgPj0g
SVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCisJaWYgKHVubGlrZWx5KHRpZCAhPSBJV0xfTUFY
X1RJRF9DT1VOVCAmJiB0eHFfaWQgPj0gSVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCiAJCSAg
ICAgdHhxX2lkICE9IHRyYW5zX3BjaWUtPmFnZ190eHFbc3RhX2lkXVt0aWRdKSkgewogCQkvKgog
CQkgKiBGSVhNRTogdGhpcyBpcyBhIHVDb2RlIGJ1ZyB3aGljaCBuZWVkIHRvIGJlIGFkZHJlc3Nl
ZCwK
--f46d0442829c1926cd04b779cd03--
