Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:64398 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbZH0AQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 20:16:06 -0400
Received: by ey-out-2122.google.com with SMTP id 25so147987eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 17:16:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	 <43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
	 <3ace41890908261555g339e65d1n6627cc3d1713287e@mail.gmail.com>
	 <43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
Date: Thu, 27 Aug 2009 01:16:06 +0100
Message-ID: <3ace41890908261716m52f948c9g97db8eeac4fdda56@mail.gmail.com>
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187: Implement
	rfkill support)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	hal@lists.freedesktop.org, htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364c70564f24e704721479c6
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016364c70564f24e704721479c6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Thu, Aug 27, 2009 at 12:45 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> Johannes, did kernels < 2.6.31 have /sys/class/rfkill ?

2.6.30 has /sys/class/rfkill (it is exposed by the vendor as-shipped
rfkill.ko). But I just tried something like this, and it seems to work
- the patch is simple enough and just 3 hunks - what it does:
1) 'make unload' should unload rfkill also,
2) remove the compat-wireless class renaming hunk (so it advertise
itself as 'rfkill' rather than 'rfkill_backport')
3) remove the compat-wireless input hander renaming hunk.

I am not sure what the input handle->name (3) is for, somebody care to
explain? Is there any reason why I should do something like outlined
here in the patch?

Hin-Tak

--0016364c70564f24e704721479c6
Content-Type: text/x-patch; charset=US-ASCII;
	name="compat-wireless_remove_backport_naming.diff"
Content-Disposition: attachment;
	filename="compat-wireless_remove_backport_naming.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fyuqefwm0

ZGlmZiAtLWdpdCBhL2NvbXBhdC9wYXRjaGVzLzAzLXJma2lsbC5wYXRjaCBiL2NvbXBhdC9wYXRj
aGVzLzAzLXJma2lsbC5wYXRjaAppbmRleCA2MWViNzYyLi4zNjg3NjdmIDEwMDY0NAotLS0gYS9j
b21wYXQvcGF0Y2hlcy8wMy1yZmtpbGwucGF0Y2gKKysrIGIvY29tcGF0L3BhdGNoZXMvMDMtcmZr
aWxsLnBhdGNoCkBAIC0zNCwxNSArMzQsNiBAQCBqdXN0IGtlZXAgL2Rldi9yZmtpbGwgYW5kIG5v
dCAvZGV2L3Jma2lsbF9iYWNrcG9ydC4KICAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4KICAKICAj
aW5jbHVkZSAicmZraWxsLmgiCi1AQCAtMjI5LDcgKzIzMyw3IEBAIHN0YXRpYyBpbnQgcmZraWxs
X2Nvbm5lY3Qoc3RydWN0IGlucHV0X2gKLSAKLSAJaGFuZGxlLT5kZXYgPSBkZXY7Ci0gCWhhbmRs
ZS0+aGFuZGxlciA9IGhhbmRsZXI7Ci0tCWhhbmRsZS0+bmFtZSA9ICJyZmtpbGwiOwotKwloYW5k
bGUtPm5hbWUgPSAicmZraWxsX2JhY2twb3J0IjsKLSAKLSAJLyogY2F1c2VzIHJma2lsbF9zdGFy
dCgpIHRvIGJlIGNhbGxlZCAqLwotIAllcnJvciA9IGlucHV0X3JlZ2lzdGVyX2hhbmRsZShoYW5k
bGUpOwogLS0tIGEvbmV0L3Jma2lsbC9jb3JlLmMJMjAwOS0wOC0yMCAxMzo0ODozNi4wODMyNjcz
OTcgLTA3MDAKICsrKyBiL25ldC9yZmtpbGwvY29yZS5jCTIwMDktMDgtMjAgMTM6NDg6MzcuMDUx
MjY3MDk4IC0wNzAwCiBAQCAtMjYsNyArMjYsNyBAQApAQCAtODEsMTUgKzcyLDYgQEAganVzdCBr
ZWVwIC9kZXYvcmZraWxsIGFuZCBub3QgL2Rldi9yZmtpbGxfYmFja3BvcnQuCiAgc3RhdGljIGF0
b21pY190IHJma2lsbF9pbnB1dF9kaXNhYmxlZCA9IEFUT01JQ19JTklUKDApOwogIAogIC8qKgot
QEAgLTc3Niw3ICs3NzYsNyBAQAotIH0KLSAKLSBzdGF0aWMgc3RydWN0IGNsYXNzIHJma2lsbF9j
bGFzcyA9IHsKLS0JLm5hbWUJCT0gInJma2lsbCIsCi0rCS5uYW1lCQk9ICJyZmtpbGxfYmFja3Bv
cnQiLAotIAkuZGV2X3JlbGVhc2UJPSByZmtpbGxfcmVsZWFzZSwKLSAJLmRldl9hdHRycwk9IHJm
a2lsbF9kZXZfYXR0cnMsCi0gCS5kZXZfdWV2ZW50CT0gcmZraWxsX2Rldl91ZXZlbnQsCiBAQCAt
OTIyLDcgKzkyMiw3IEBACiAgCWlmICghcmZraWxsLT5wZXJzaXN0ZW50IHx8IHJma2lsbF9lcG9f
bG9ja19hY3RpdmUpIHsKICAJCXNjaGVkdWxlX3dvcmsoJnJma2lsbC0+c3luY193b3JrKTsKZGlm
ZiAtLWdpdCBhL3NjcmlwdHMvdW5sb2FkLnNoIGIvc2NyaXB0cy91bmxvYWQuc2gKaW5kZXggNzVi
YmZjOS4uMDUzNzA1NiAxMDA3NTUKLS0tIGEvc2NyaXB0cy91bmxvYWQuc2gKKysrIGIvc2NyaXB0
cy91bmxvYWQuc2gKQEAgLTI1LDYgKzI1LDcgQEAgTU9EVUxFUz0iJE1PRFVMRVMgcm5kaXNfd2xh
biBybmRpc19ob3N0IGNkY19ldGhlciB1c2JuZXQiCiAjIGVlcHJvbV85M2N4NiBpcyB1c2VkIGJ5
IHJ0MngwMCAocnQ2MXBjaSwgcnQyNTAwcGNpLCBydDI0MDBwY2kpIAogIyBhbmQgUmVhbHRlayBk
cml2ZXJzICggcnRsODE4NywgcnRsODE4MCkKIE1PRFVMRVM9IiRNT0RVTEVTIGVlcHJvbV85M2N4
NiIKK01PRFVMRVM9IiRNT0RVTEVTIHJma2lsbCIKIE1PRFVMRVM9IiRNT0RVTEVTIGxpYjgwMjEx
X2NyeXB0X2NjbXAgbGliODAyMTFfY3J5cHRfdGtpcCBsaWI4MDIxMV9jcnlwdF93ZXAiCiBNT0RV
TEVTPSIkTU9EVUxFUyBtYWM4MDIxMSBjZmc4MDIxMSBsaWI4MDIxMSIKIE1BRFdJRklfTU9EVUxF
Uz0iYXRoX3BjaSBhdGhfcmF0ZV9zYW1wbGUgd2xhbl9zY2FuX3N0YSB3bGFuIGF0aF9oYWwiCg==
--0016364c70564f24e704721479c6--
