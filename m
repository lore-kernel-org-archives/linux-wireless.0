Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:52277 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZINDlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2009 23:41:18 -0400
Received: by ey-out-2122.google.com with SMTP id 25so522620eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2009 20:41:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	 <4A9C0ADC.6050607@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <4A9D7DC0.6050701@ufra.edu.br> <4AAC240E.20104@ufra.edu.br>
	 <3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com>
Date: Mon, 14 Sep 2009 04:41:19 +0100
Message-ID: <3ace41890909132041w2d3f10b7r72e0eb855f1ab2a5@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d7e32d5babbc0473817073
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016e6d7e32d5babbc0473817073
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Sep 13, 2009 at 11:13 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Sat, Sep 12, 2009 at 11:43 PM, Leonardo H. Souza Hamada
> <leonardo.hamada@ufra.edu.br> wrote:
>> Hi all,
>>
>> At this moment, after tweaking the zd1211rw code in kernel
>> 2.6.31-gentoo, finally I am able to use the WLI-U2-KG54L wireless usb
>> dongle on this old ibook.
>>
>> Browsing the source with a cross referencing tool
>> (http://lxr.free-electrons.com) and making additional checking points, I
>> could trace the issue as follow.
>>
>> The problem is that this device returns a regulatory region of 0x49,
>> which is not defined in the zd1211rw tables. So the call
>>
>> r <http://lxr.free-electrons.com/ident?i=r> = zd_reg2alpha2 <http://lxr.free-electrons.com/ident?i=zd_reg2alpha2>(mac <http://lxr.free-electrons.com/ident?i=mac>->regdomain, alpha2);
>>
>> will fail the initialization process.
>>
>>
>> Workaround:
>>
>> ----snip----
>> int zd_mac_init_hw(struct ieee80211_hw *hw)
>> {
>> ...
>>        r = zd_read_regdomain(chip, &default_regdomain);
>>        /* A unknown regulatory of 0x49 will be set default to
>> ZD_REGDOMAIN_FCC. */
>>        if (0x49 == default_regdomain)
>>                default_regdomain = ZD_REGDOMAIN_FCC;
>> ...
>> ----snip----
>>
>> The above code will force the default regulatry to be FCC code for this
>> case. I think that this was the case in previous zd1211rw driver. What
>> is the country code for 0x49 region? There is a better way?
>>
>>
>> Thanks all,
>>
>> Phew!! Leonardo
>
> The vendor driver has quite a lot more regdomain code defined, and
> 0x49 is apparently
>
> ZD_Region_Japan_3           = 0x49,//G channel->ch1-13; A channel->8~16,34~46;
>
> the rw driver code probably should set it to most restrictive than let
> it fail...
>

Can you give this patch a try against a recent
wireless-testing/compat-wireless? I think this is the correct way to
do things.

Here is the content of the patch for others who doesn't like
attachments - it just sets 0x49 as Japan.
==============================
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6d66635..b0d32c4 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -42,6 +42,7 @@ static struct zd_reg_alpha2_map reg_alpha2_map[] = {
 	{ ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
 	{ ZD_REGDOMAIN_JAPAN, "JP" },
 	{ ZD_REGDOMAIN_JAPAN_ADD, "JP" },
+	{ ZD_REGDOMAIN_JAPAN_3, "JP" },
 	{ ZD_REGDOMAIN_SPAIN, "ES" },
 	{ ZD_REGDOMAIN_FRANCE, "FR" },
 };
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h
b/drivers/net/wireless/zd1211rw/zd_mac.h
index 7c27591..9701935 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -193,6 +193,7 @@ struct zd_mac {
 #define ZD_REGDOMAIN_FRANCE	0x32
 #define ZD_REGDOMAIN_JAPAN_ADD	0x40
 #define ZD_REGDOMAIN_JAPAN	0x41
+#define ZD_REGDOMAIN_JAPAN_3	0x49

 enum {
 	MIN_CHANNEL24 = 1,
============================================

--0016e6d7e32d5babbc0473817073
Content-Type: text/x-patch; charset=US-ASCII; name="zd1211rw_jp3.diff"
Content-Disposition: attachment; filename="zd1211rw_jp3.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzknz0730

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3pkMTIxMXJ3L3pkX21hYy5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvemQxMjExcncvemRfbWFjLmMKaW5kZXggNmQ2NjYzNS4uYjBkMzJj
NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvemQxMjExcncvemRfbWFjLmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvemQxMjExcncvemRfbWFjLmMKQEAgLTQyLDYgKzQyLDcg
QEAgc3RhdGljIHN0cnVjdCB6ZF9yZWdfYWxwaGEyX21hcCByZWdfYWxwaGEyX21hcFtdID0gewog
CXsgWkRfUkVHRE9NQUlOX0VUU0ksICJERSIgfSwgLyogR2VuZXJpYyBFVFNJLCB1c2UgbW9zdCBy
ZXN0cmljdGl2ZSAqLwogCXsgWkRfUkVHRE9NQUlOX0pBUEFOLCAiSlAiIH0sCiAJeyBaRF9SRUdE
T01BSU5fSkFQQU5fQURELCAiSlAiIH0sCisJeyBaRF9SRUdET01BSU5fSkFQQU5fMywgIkpQIiB9
LAogCXsgWkRfUkVHRE9NQUlOX1NQQUlOLCAiRVMiIH0sCiAJeyBaRF9SRUdET01BSU5fRlJBTkNF
LCAiRlIiIH0sCiB9OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvemQxMjExcncv
emRfbWFjLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy96ZDEyMTFydy96ZF9tYWMuaAppbmRleCA3
YzI3NTkxLi45NzAxOTM1IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy96ZDEyMTFy
dy96ZF9tYWMuaAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy96ZDEyMTFydy96ZF9tYWMuaApA
QCAtMTkzLDYgKzE5Myw3IEBAIHN0cnVjdCB6ZF9tYWMgewogI2RlZmluZSBaRF9SRUdET01BSU5f
RlJBTkNFCTB4MzIKICNkZWZpbmUgWkRfUkVHRE9NQUlOX0pBUEFOX0FERAkweDQwCiAjZGVmaW5l
IFpEX1JFR0RPTUFJTl9KQVBBTgkweDQxCisjZGVmaW5lIFpEX1JFR0RPTUFJTl9KQVBBTl8zCTB4
NDkKIAogZW51bSB7CiAJTUlOX0NIQU5ORUwyNCA9IDEsCg==
--0016e6d7e32d5babbc0473817073--
