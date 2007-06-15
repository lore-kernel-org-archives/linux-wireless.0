Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:6442 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXFOIve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2007 04:51:34 -0400
Received: by nz-out-0506.google.com with SMTP id n1so885002nzf
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2007 01:51:34 -0700 (PDT)
Message-ID: <c02c330c0706150151s7fa30492xde3d52179afed8c1@mail.gmail.com>
Date: Fri, 15 Jun 2007 10:51:33 +0200
From: "Kasper F. Brandt" <poizan42@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Got rtl8187 somewhat working in master mode with hostapd
In-Reply-To: <c02c330c0706141645v4f26cf2bo7730c4bdff94969d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_48123_5385772.1181897493453"
References: <c02c330c0706141645v4f26cf2bo7730c4bdff94969d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_48123_5385772.1181897493453
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, the patch was wrong. Here is the correct patch.

2007/6/15, Kasper F. Brandt <poizan42@gmail.com>:
> Hello
> I have managed to get my rtl8187 based wireless USB dongle (a Netgear
> WG111/v2) working in master mode - but with some strange problems and
> some even stranger workarounds. But first things first - i have
> attached the modifications i have made to the driver (patch is against
> wireless-dev git head) - they are not really doing anything else than
> simply "enabling" master mode. It doesn't seems to be sending any
> beacons when simply put into master mode (should the driver somehow
> tell mac80211 that it's not generating them itself?) But when i use
> hostapd everything seems to be working - until i try to associated...
>
> Without any encyption i could associated my laptop to the ap (actually
> a Linksys NSLU2 using big-endian arm) - but i couldn't get any data
> both ways. My laptop would see the packages sent from the ap and
> answer them, but the ap wouldn't get the packages - at least most of
> the time :/ Furthermore my laptop disconnected from the ap every 5 (or
> maybe 10) seconds and associated with the ap again.
>
> But when i started tcpdump on my nslu2, so i could find out what was
> going wrong, it suddenly worked. I could send data both ways without
> any problems - but my laptop was disconnecting and reconnecting about
> every 5 seconds when it wasn't receiving anything. As a temporary
> workaround i can keep the connection alive by having a ping running in
> the background. And well beside of that it seems to be working just
> fine - even with encryption.
>
> So why does it suddenly work when i start tcpdump? It's putting the
> interface into promiscous mode but when i tried to do that manually it
> didn't work...
> And why does the client keep on disconnection after a short time of
> inactivity? Is an accesspoint usually sending some sort of keep-alive
> packets that mac80211 doesn't send automatically when the interface is
> in master mode?
>
> I really hope someone can help me out with this.
>
> - Kasper F. Brandt
>
>

------=_Part_48123_5385772.1181897493453
Content-Type: application/octet-stream; name=rtl8187-enable-mastermode.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2yf7j6a
Content-Disposition: attachment; filename="rtl8187-enable-mastermode.patch"

LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFjODAyMTEvcnRsODE4eC9ydGw4MTg3X2Rldi5j
CTIwMDctMDYtMTMgMTQ6MTA6MjIuMDAwMDAwMDAwICswMjAwCisrKyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21hYzgwMjExL3J0bDgxOHgvcnRsODE4N19kZXYuYwkyMDA3LTA2LTE1IDAwOjI1OjUy
LjAwMDAwMDAwMCArMDIwMApAQCAtNDYwLDYgKzQ2MCw3IEBACiAJc3dpdGNoIChjb25mLT50eXBl
KSB7CiAJY2FzZSBJRUVFODAyMTFfSUZfVFlQRV9TVEE6CiAJY2FzZSBJRUVFODAyMTFfSUZfVFlQ
RV9NTlRSOgorCWNhc2UgSUVFRTgwMjExX0lGX1RZUEVfQVA6CiAJCXByaXYtPm1vZGUgPSBjb25m
LT50eXBlOwogCQlicmVhazsKIAlkZWZhdWx0OgpAQCAtNTEwLDEzICs1MTEsMjAgQEAKIAlzdHJ1
Y3QgcnRsODE4N19wcml2ICpwcml2ID0gZGV2LT5wcml2OwogCWludCBpOwogCi0JZm9yIChpID0g
MDsgaSA8IEVUSF9BTEVOOyBpKyspCi0JCXJ0bDgxOHhfaW93cml0ZTgocHJpdiwgJnByaXYtPm1h
cC0+QlNTSURbaV0sIGNvbmYtPmJzc2lkW2ldKTsKLQotCWlmIChpc192YWxpZF9ldGhlcl9hZGRy
KGNvbmYtPmJzc2lkKSkKLQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+bWFwLT5NU1Is
IFJUTDgxOFhfTVNSX0lORlJBKTsKKwlpZiAocHJpdi0+bW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQ
RV9BUCkgeworCQlpZiAoIWNvbmYtPmJzc2lkKQorCQkJY29uZi0+YnNzaWQgPSBwcml2LT5od2Fk
ZHI7CisJfQogCWVsc2UKLQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+bWFwLT5NU1Is
IFJUTDgxOFhfTVNSX05PX0xJTkspOworCXsKKwkJZm9yIChpID0gMDsgaSA8IEVUSF9BTEVOOyBp
KyspCisJCQlydGw4MTh4X2lvd3JpdGU4KHByaXYsICZwcml2LT5tYXAtPkJTU0lEW2ldLCBjb25m
LT5ic3NpZFtpXSk7CisKKwkJaWYgKGlzX3ZhbGlkX2V0aGVyX2FkZHIoY29uZi0+YnNzaWQpKQor
CQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+bWFwLT5NU1IsIFJUTDgxOFhfTVNSX0lO
RlJBKTsKKwkJZWxzZQorCQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+bWFwLT5NU1Is
IFJUTDgxOFhfTVNSX05PX0xJTkspOworCX0KIAogCXJldHVybiAwOwogfQo=
------=_Part_48123_5385772.1181897493453--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
