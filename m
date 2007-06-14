Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:37999 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbXFNXp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 19:45:29 -0400
Received: by wa-out-1112.google.com with SMTP id v27so906925wah
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2007 16:45:28 -0700 (PDT)
Message-ID: <c02c330c0706141645v4f26cf2bo7730c4bdff94969d@mail.gmail.com>
Date: Fri, 15 Jun 2007 01:45:28 +0200
From: "Kasper F. Brandt" <poizan42@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Got rtl8187 somewhat working in master mode with hostapd
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_44813_27793738.1181864728494"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_44813_27793738.1181864728494
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello
I have managed to get my rtl8187 based wireless USB dongle (a Netgear
WG111/v2) working in master mode - but with some strange problems and
some even stranger workarounds. But first things first - i have
attached the modifications i have made to the driver (patch is against
wireless-dev git head) - they are not really doing anything else than
simply "enabling" master mode. It doesn't seems to be sending any
beacons when simply put into master mode (should the driver somehow
tell mac80211 that it's not generating them itself?) But when i use
hostapd everything seems to be working - until i try to associated...

Without any encyption i could associated my laptop to the ap (actually
a Linksys NSLU2 using big-endian arm) - but i couldn't get any data
both ways. My laptop would see the packages sent from the ap and
answer them, but the ap wouldn't get the packages - at least most of
the time :/ Furthermore my laptop disconnected from the ap every 5 (or
maybe 10) seconds and associated with the ap again.

But when i started tcpdump on my nslu2, so i could find out what was
going wrong, it suddenly worked. I could send data both ways without
any problems - but my laptop was disconnecting and reconnecting about
every 5 seconds when it wasn't receiving anything. As a temporary
workaround i can keep the connection alive by having a ping running in
the background. And well beside of that it seems to be working just
fine - even with encryption.

So why does it suddenly work when i start tcpdump? It's putting the
interface into promiscous mode but when i tried to do that manually it
didn't work...
And why does the client keep on disconnection after a short time of
inactivity? Is an accesspoint usually sending some sort of keep-alive
packets that mac80211 doesn't send automatically when the interface is
in master mode?

I really hope someone can help me out with this.

- Kasper F. Brandt

------=_Part_44813_27793738.1181864728494
Content-Type: application/octet-stream; name=rtl8187-enable-mastermode.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2xvp5ic
Content-Disposition: attachment; filename="rtl8187-enable-mastermode.patch"

LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFjODAyMTEvcnRsODE4N19kZXYuYwkyMDA3LTA2
LTEzIDE0OjEwOjIyLjAwMDAwMDAwMCArMDIwMAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9t
YWM4MDIxMS9ydGw4MTg3X2Rldi5jCTIwMDctMDYtMTUgMDA6MjU6NTIuMDAwMDAwMDAwICswMjAw
CkBAIC00NjAsNiArNDYwLDcgQEAKIAlzd2l0Y2ggKGNvbmYtPnR5cGUpIHsKIAljYXNlIElFRUU4
MDIxMV9JRl9UWVBFX1NUQToKIAljYXNlIElFRUU4MDIxMV9JRl9UWVBFX01OVFI6CisJY2FzZSBJ
RUVFODAyMTFfSUZfVFlQRV9BUDoKIAkJcHJpdi0+bW9kZSA9IGNvbmYtPnR5cGU7CiAJCWJyZWFr
OwogCWRlZmF1bHQ6CkBAIC01MTAsMTMgKzUxMSwyMCBAQAogCXN0cnVjdCBydGw4MTg3X3ByaXYg
KnByaXYgPSBkZXYtPnByaXY7CiAJaW50IGk7CiAKLQlmb3IgKGkgPSAwOyBpIDwgRVRIX0FMRU47
IGkrKykKLQkJcnRsODE4eF9pb3dyaXRlOChwcml2LCAmcHJpdi0+bWFwLT5CU1NJRFtpXSwgY29u
Zi0+YnNzaWRbaV0pOwotCi0JaWYgKGlzX3ZhbGlkX2V0aGVyX2FkZHIoY29uZi0+YnNzaWQpKQot
CQlydGw4MTh4X2lvd3JpdGU4KHByaXYsICZwcml2LT5tYXAtPk1TUiwgUlRMODE4WF9NU1JfSU5G
UkEpOworCWlmIChwcml2LT5tb2RlID09IElFRUU4MDIxMV9JRl9UWVBFX0FQKSB7CisJCWlmICgh
Y29uZi0+YnNzaWQpCisJCQljb25mLT5ic3NpZCA9IHByaXYtPmh3YWRkcjsKKwl9CiAJZWxzZQot
CQlydGw4MTh4X2lvd3JpdGU4KHByaXYsICZwcml2LT5tYXAtPk1TUiwgUlRMODE4WF9NU1JfTk9f
TElOSyk7CisJeworCQlmb3IgKGkgPSAwOyBpIDwgRVRIX0FMRU47IGkrKykKKwkJCXJ0bDgxOHhf
aW93cml0ZTgocHJpdiwgJnByaXYtPm1hcC0+QlNTSURbaV0sIGNvbmYtPmJzc2lkW2ldKTsKKwor
CQlpZiAoaXNfdmFsaWRfZXRoZXJfYWRkcihjb25mLT5ic3NpZCkpCisJCQlydGw4MTh4X2lvd3Jp
dGU4KHByaXYsICZwcml2LT5tYXAtPk1TUiwgUlRMODE4WF9NU1JfSU5GUkEpOworCQllbHNlCisJ
CQlydGw4MTh4X2lvd3JpdGU4KHByaXYsICZwcml2LT5tYXAtPk1TUiwgUlRMODE4WF9NU1JfTk9f
TElOSyk7CisJfQogCiAJcmV0dXJuIDA7CiB9Cg==
------=_Part_44813_27793738.1181864728494--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
