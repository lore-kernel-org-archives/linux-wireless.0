Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49978 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3IFQhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 12:37:19 -0400
Message-ID: <522A04B4.3050708@hauke-m.de> (sfid-20130906_183724_122916_15EDCBAB)
Date: Fri, 06 Sep 2013 18:37:08 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcma problem on x86_64
References: <522879D0.2030107@broadcom.com> <CACna6ryc0_9xcQonuJbK6aB0-ak_izLTi_LNGHB=Lsx0Q5t-Zw@mail.gmail.com> <52299AC3.5010809@broadcom.com> <5229F3D1.9000200@broadcom.com>
In-Reply-To: <5229F3D1.9000200@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------020406000102000105030605"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020406000102000105030605
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/06/2013 05:25 PM, Arend van Spriel wrote:
> On 09/06/2013 11:05 AM, Arend van Spriel wrote:
>> On 09/06/2013 10:05 AM, Rafał Miłecki wrote:
>>> Hi,
>>>
>>> 2013/9/5 Arend van Spriel <arend@broadcom.com>:
>>>> Since 3.11-rc4 I am seeing a problem with bcma on x64 (see attached
>>>> log). I
>>>> thought I misconfigured my setup, but just upgraded to 3.11 and I am
>>>> still
>>>> seeing the same issue. Did you have any reports like this?
>>>
>>> Unfortunately I wasn't testing final 3.11 with x86_64, I'll give it a
>>> try over the weekend.
>>>
>>
>> I am bisecting. Will let you know when I find something.
> 
> Bisect points to:
> 
> fd4edf197544bae1c77d84bad354aa7ce1d08ce1 is the first bad commit
> commit fd4edf197544bae1c77d84bad354aa7ce1d08ce1
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Mon Jul 15 13:15:08 2013 +0200
> 
>     bcma: fix handling of big addrl
> 
>     The return value of bcma_erom_get_addr_desc() is a unsigned value
> and it
>     could wrap around in the two complement writing. This happens for one
>     core in the BCM4708 SoC.
> 
>     Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> It is probably caused by using IS_ERR_VALUE() macro which does a
> unsigned long cast, which gives different results on 64-bit platform.
> 
> This patch was submitted upstream yesterday by Dave for 3.12-rc1.
> 
> Regards,
> Arend
> 
Hi Arend,

Thanks for spotting this. This commit is not in final 3.11, otherwise
I would have suspected it before.

Could you please try the attached patch.

Hauke




--------------020406000102000105030605
Content-Type: text/x-patch;
 name="0001-bcma-fix-error-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-bcma-fix-error-handling.patch"

>From 4a6337b38369977b94d6e752c57b09e7f4539830 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Fri, 6 Sep 2013 18:32:41 +0200
Subject: [PATCH] bcma: fix error handling

---
 drivers/bcma/scan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index cd6b20f..b7906d5 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -269,6 +269,8 @@ static struct bcma_device *bcma_find_core_reverse(struct bcma_bus *bus, u16 core
 	return NULL;
 }
 
+#define IS_ERR_VALUE_U32 unlikely((x) >= (u32)-MAX_ERRNO)
+
 static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			      struct bcma_device_id *match, int core_num,
 			      struct bcma_device *core)
@@ -351,11 +353,11 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	 * the main register space for the core
 	 */
 	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
-	if (tmp == 0 || IS_ERR_VALUE(tmp)) {
+	if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
 		/* Try again to see if it is a bridge */
 		tmp = bcma_erom_get_addr_desc(bus, eromptr,
 					      SCAN_ADDR_TYPE_BRIDGE, 0);
-		if (tmp == 0 || IS_ERR_VALUE(tmp)) {
+		if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
 			return -EILSEQ;
 		} else {
 			bcma_info(bus, "Bridge found\n");
@@ -369,7 +371,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_SLAVE, i);
-			if (IS_ERR_VALUE(tmp)) {
+			if (IS_ERR_VALUE_U32(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: slave port %d "
 				 * "has %d descriptors\n", i, j); */
@@ -386,7 +388,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_MWRAP, i);
-			if (IS_ERR_VALUE(tmp)) {
+			if (IS_ERR_VALUE_U32(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: master wrapper %d "
 				 * "has %d descriptors\n", i, j); */
@@ -404,7 +406,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_SWRAP, i + hack);
-			if (IS_ERR_VALUE(tmp)) {
+			if (IS_ERR_VALUE_U32(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: master wrapper %d "
 				 * has %d descriptors\n", i, j); */
-- 
1.7.10.4


--------------020406000102000105030605--
