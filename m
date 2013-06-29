Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:57167 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3F2LYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 07:24:19 -0400
Message-ID: <51CEC26C.2020600@openwrt.org> (sfid-20130629_132426_006269_C0A406A0)
Date: Sat, 29 Jun 2013 13:18:04 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 01/19] rt2x00: rt2800lib: add BBP register
 initialization for RT3593
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org> <1372446753-11408-2-git-send-email-juhosg@openwrt.org> <51CE6FB5.2000706@01019freenet.de>
In-Reply-To: <51CE6FB5.2000706@01019freenet.de>
Content-Type: multipart/mixed;
 boundary="------------050805060002000100060906"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050805060002000100060906
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Hi Adnreas,

> thanks for your submission. I tried to test it, but stuck at the problem
> mentioned below.
> 
> 
> Regards,
> Andreas
> 
> Gabor Juhos wrote:
>> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>> driver.
>>
>> References:
>>   NICInitRT3593BbpRegisters in chips/rt3593.c
>>   NICInitBBP in common/rtmp_init.c
>>   NICInitAsicFromEEPROM in common/rtmp_init.c
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |   19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 6f58ceb..32ecd1a 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4505,6 +4505,22 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
>>  	rt2800_disable_unused_dac_adc(rt2x00dev);
>>  }
>>  
>> +static void rt2800_init_bbp_3593(struct rt2x00_dev *rt2x00dev)
>> +{
>> +	rt2800_init_bbp_early(rt2x00dev);
>> +
>> +	rt2800_bbp_write(rt2x00dev, 79, 0x13);
>> +	rt2800_bbp_write(rt2x00dev, 80, 0x05);
>> +	rt2800_bbp_write(rt2x00dev, 81, 0x33);
>> +	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
>> +
>> +	rt2800_bbp_write(rt2x00dev, 84, 0x19);
>> +
>> +	/* Enable DC filter */
>> +	if (rt2x00_rt_rev_gte(rt2x00dev, RT3593, REV_RT3593E))
> 
> Where is REV_RT3593E defined?
> 
> /tmp/backports-20130617/drivers/net/wireless/rt2x00/rt2800lib.c: In
> function ‘rt2800_init_bbp_3593’:
> /tmp/backports-20130617/drivers/net/wireless/rt2x00/rt2800lib.c:5325:43:
> error: ‘REV_RT3593E’ undeclared (first use in this function)

You are right, the patch-set should have contained 20 patches, but the first one
is missing. I will post that along with the second version of the series.

However if you want to try it in the meantime, you can find the patch in the
attachment. It must be applied before the other patches.

-Gabor

--------------050805060002000100060906
Content-Type: text/x-patch;
 name="0001-rt2x00-rt2800lib-add-MAC-register-initialization-for.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rt2x00-rt2800lib-add-MAC-register-initialization-for.pa";
 filename*1="tch"

>From 9afda5e728c713da1a3e55ba0860a3705e5a2cd6 Mon Sep 17 00:00:00 2001
From: Gabor Juhos <juhosg@openwrt.org>
Date: Thu, 9 May 2013 14:20:09 +0200
Subject: [PATCH v2 01/20] rt2x00: rt2800lib: add MAC register initialization
 for RT3593

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  NICInitRT3593MacRegisters in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9216834..02bc80d 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -88,6 +88,7 @@
 #define REV_RT3071E			0x0211
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
+#define REV_RT3593E			0x0211
 #define REV_RT5390F			0x0502
 #define REV_RT5390R			0x1502
 #define REV_RT5592C			0x0221
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7b216f9..6f58ceb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3715,6 +3715,23 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+	} else if (rt2x00_rt(rt2x00dev, RT3593)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000402);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3593, REV_RT3593E)) {
+			rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1,
+					   &eeprom);
+			if (rt2x00_get_field16(eeprom,
+					       EEPROM_NIC_CONF1_DAC_TEST))
+				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
+						      0x0000001f);
+			else
+				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
+						      0x0000000f);
+		} else {
+			rt2800_register_write(rt2x00dev, TX_SW_CFG2,
+					      0x00000000);
+		}
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
 		   rt2x00_rt(rt2x00dev, RT5392) ||
 		   rt2x00_rt(rt2x00dev, RT5592)) {
-- 
1.7.10


--------------050805060002000100060906--
