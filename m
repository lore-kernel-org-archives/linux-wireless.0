Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1767 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab3DKNJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 09:09:40 -0400
Message-ID: <5166B608.8030803@broadcom.com> (sfid-20130411_150944_173743_613BCF98)
Date: Thu, 11 Apr 2013 15:09:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: Re: [PATCH 11/15] brcmfmac: define and use platform specific
 data for SDIO.
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
 <1365679740-25679-12-git-send-email-arend@broadcom.com>
 <5166A745.9080709@hauke-m.de>
In-Reply-To: <5166A745.9080709@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 02:06 PM, Hauke Mehrtens wrote:
> On 04/11/2013 01:28 PM, Arend van Spriel wrote:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> This patch adds support for platform specific data for SDIO
>> fullmac devices. Currently OOB interrupts are configured by Kconfig
>> BRCMFMAC_SDIO_OOB but that is now determined dynamically by checking
>> availibility of platform data.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Piotr Haber <phaber@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>   drivers/net/wireless/brcm80211/Kconfig             |    9 --
>>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  155 ++++++++++----------
>>   .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  114 ++++----------
>>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++--
>>   .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 +-
>>   include/linux/brcmfmac_platform.h                  |  125 ++++++++++++++++
>>   6 files changed, 251 insertions(+), 187 deletions(-)
>>   create mode 100644 include/linux/brcmfmac_platform.h
>>
>
> ....
>
>> --- /dev/null
>> +++ b/include/linux/brcmfmac_platform.h
>
> This should be placed into include/linux/platform_data/
>

Are you sure. This file specifies the platform data API so it does not 
contain actual platform_data. At first glance this folder seems to 
contain board specific platform data, but did not look closely.

Regards,
Arend




