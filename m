Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.clear-code.com ([219.94.198.64]:54026 "EHLO
	mail.clear-code.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab0FPMzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 08:55:37 -0400
Date: Wed, 16 Jun 2010 21:55:23 +0900 (JST)
Message-Id: <20100616.215523.1718341995174283889.kou@clear-code.com>
To: mcgrof@gmail.com
Cc: Stephen.Chen@atheros.com, David.Quan@atheros.com,
	linux-wireless@vger.kernel.org, Michael.Green@atheros.com
Subject: Re: [PATCH] zd1211rw: ignore unknown regulatory domain.
From: Kouhei Sutou <kou@clear-code.com>
In-Reply-To: <AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
References: <AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
	<20100615.232558.867740727379709943.kou@clear-code.com>
	<AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Jun_16_21_55_23_2010_801)--"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

----Next_Part(Wed_Jun_16_21_55_23_2010_801)--
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

In <AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
  "Re: [PATCH] zd1211rw: ignore unknown regulatory domain." on Tue, 15 =
Jun 2010 08:22:09 -0700,
  "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> On Tue, Jun 15, 2010 at 7:25 AM, Kouhei Sutou <kou@clear-code.com> wr=
ote:
>> Hi,
>>
>> In <AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
>> =A0"Re: [PATCH] zd1211rw: ignore unknown regulatory domain." on Sun,=
 13 Jun 2010 13:23:20 -0700,
>> =A0"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>>
>>>> I'm using PLANEX GW-US54GXS (2019:5303) and it works with
>>>> the attached patch. Could you consider to merge the attached
>>>> patch?
>>>>
>>>> Problem: GW-US54GXS uses zd1211rw but zd1211rw doesn't have
>>>> a regulatory domain reported by GW-US54GXS (0x49).
>>>>
>>>> Solutions:
>>>>
>>>> =A0(1) add a new regulatory domain (0x49). Here is a patch to
>>>> =A0 =A0 =A0use the approach:
>>>
>>> Stephen, David, does 0x49 map to JP for zd1211 ? Are there other on=
es?
>>> Here is our list so far:
>> ...
>>> Kouhei, if no regulatory domain is found, instead we should world
>>> roam, we cannot allow letting the user change regulatory domains at=

>>> their whim. We can, however let them choose one to help compliance,=

>>> but you can only help compliance once you know your actual regulato=
ry
>>> domain.
>>
>> Luis, thanks for your input.
>> It seems that we can't use GW-US54GXS until 0x49 regulatory
>> domain is registered to zd1211rw. Is it right?
>>
>> If it is right, what I can do for GW-US54GXS? Should I wait
>> a response from Stephen and/or David?
> =

> We spoke and 0x49 - > JP is ok, can you send a patch for that?

OK.
I'll attach a patch for that.

I used 'ZD_REGDOMAIN_JAPAN_GW_US54GXS' as a macro name for
0x49 because 0x49 is used by GW-US54GXS. Is it OK? Or should
I use other name for it?


Thanks,
--
kou

----Next_Part(Wed_Jun_16_21_55_23_2010_801)--
Content-Type: Text/X-Patch; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-zd1211rw-add-0x49-JP-regulatory-domain-map.patch"

>From a530e66e6e995d8e8bc00ece2a9b3540ef88688f Mon Sep 17 00:00:00 2001
From: Kouhei Sutou <kou@clear-code.com>
Date: Wed, 16 Jun 2010 21:53:59 +0900
Subject: [PATCH] zd1211rw: add 0x49 -> JP regulatory domain map

0x49 is used by PLANEX GW-US54GXS (2019:5303).

Signed-off-by: Kouhei Sutou <kou@clear-code.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    1 +
 drivers/net/wireless/zd1211rw/zd_mac.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 163a8a0..faf45f1 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -43,6 +43,7 @@ static struct zd_reg_alpha2_map reg_alpha2_map[] = {
 	{ ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
 	{ ZD_REGDOMAIN_JAPAN, "JP" },
 	{ ZD_REGDOMAIN_JAPAN_ADD, "JP" },
+	{ ZD_REGDOMAIN_JAPAN_GW_US54GXS, "JP" },
 	{ ZD_REGDOMAIN_SPAIN, "ES" },
 	{ ZD_REGDOMAIN_FRANCE, "FR" },
 };
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 630c298..7ab19d5 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -214,6 +214,7 @@ struct zd_mac {
 #define ZD_REGDOMAIN_FRANCE	0x32
 #define ZD_REGDOMAIN_JAPAN_ADD	0x40
 #define ZD_REGDOMAIN_JAPAN	0x41
+#define ZD_REGDOMAIN_JAPAN_GW_US54GXS	0x49
 
 enum {
 	MIN_CHANNEL24 = 1,
-- 
1.7.1


----Next_Part(Wed_Jun_16_21_55_23_2010_801)----
