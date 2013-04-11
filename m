Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49517 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987Ab3DKXQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:10 -0400
Message-ID: <5167440A.3040205@hauke-m.de> (sfid-20130412_011616_996667_4F27DA5A)
Date: Fri, 12 Apr 2013 01:15:22 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 11/15] brcmfmac: define and use platform specific data
 for SDIO.
References: <1365679740-25679-1-git-send-email-arend@broadcom.com> <1365679740-25679-12-git-send-email-arend@broadcom.com> <5166A745.9080709@hauke-m.de> <5166B608.8030803@broadcom.com>
In-Reply-To: <5166B608.8030803@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 03:09 PM, Arend van Spriel wrote:
> On 04/11/2013 02:06 PM, Hauke Mehrtens wrote:
>> On 04/11/2013 01:28 PM, Arend van Spriel wrote:
>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>
>>> This patch adds support for platform specific data for SDIO
>>> fullmac devices. Currently OOB interrupts are configured by Kconfig
>>> BRCMFMAC_SDIO_OOB but that is now determined dynamically by checking
>>> availibility of platform data.
>>>
>>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Reviewed-by: Piotr Haber <phaber@broadcom.com>
>>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>>   drivers/net/wireless/brcm80211/Kconfig             |    9 --
>>>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  155
>>> ++++++++++----------
>>>   .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  114
>>> ++++----------
>>>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++--
>>>   .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 +-
>>>   include/linux/brcmfmac_platform.h                  |  125
>>> ++++++++++++++++
>>>   6 files changed, 251 insertions(+), 187 deletions(-)
>>>   create mode 100644 include/linux/brcmfmac_platform.h
>>>
>>
>> ....
>>
>>> --- /dev/null
>>> +++ b/include/linux/brcmfmac_platform.h
>>
>> This should be placed into include/linux/platform_data/
>>
> 
> Are you sure. This file specifies the platform data API so it does not
> contain actual platform_data. At first glance this folder seems to
> contain board specific platform data, but did not look closely.

I think, all the files in include/linux/platform_data/*.h are defining
some struct used in pdev->dev.platform_data in various drivers. The
content of such structs is mostly located in the arch code where the SoC
gets initialized, but I am not sure about this.

Hauke
