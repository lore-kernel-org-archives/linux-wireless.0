Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2941 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab3ABUwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 15:52:16 -0500
Message-ID: <50E49DF3.60503@broadcom.com> (sfid-20130102_215220_261632_2D91310C)
Date: Wed, 2 Jan 2013 21:52:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 08/18] brcmfmac: define pr_fmt in one place
References: <1357136572-18273-9-git-send-email-arend@broadcom.com>
 <1357158010-9767-1-git-send-email-arend@broadcom.com>
 <1357158897.25181.5.camel@joe-AO722>
In-Reply-To: <1357158897.25181.5.camel@joe-AO722>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2013 09:34 PM, Joe Perches wrote:
> On Wed, 2013-01-02 at 21:20 +0100, Arend van Spriel wrote:
>> Several source files (but not all) define the pr_fmt() macro in exactly
>> the same way. Instead this commit defines it in a header file so driver
>> logging is consistent.
>>
>> Cc: Joe Perches <joe@perches.com>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> Hi John,
>>
>> Joe caught this so here is the replacement patch for previous patch with
>> message id: <1357136572-18273-9-git-send-email-arend@broadcom.com>
>>
>> Regards,
>> Arend
>> ---
>>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c       |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c      |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h      |    4 ++++
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c     |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    2 --
>>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 --
>>  9 files changed, 4 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> index be35a2f..11fd1c7 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> @@ -15,8 +15,6 @@
>>   */
>>  /* ****************** SDIO CARD Interface Functions **************************/
>>  
>> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> -
>>  #include <linux/types.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/export.h>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
>> index d33e559..d92d373 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
>> @@ -14,8 +14,6 @@
>>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>   */
>>  
>> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> -
>>  #include <linux/types.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/mmc/sdio.h>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
>> index 8392355..0c83998 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
>> @@ -19,8 +19,6 @@
>>   * For certain dcmd codes, the dongle interprets string data from the host.
>>   ******************************************************************************/
>>  
>> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> -
>>  #include <linux/types.h>
>>  #include <linux/netdevice.h>
>>  
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
>> index f8b52e5..4544342 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
>> @@ -14,8 +14,6 @@
>>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>   */
>>  
>> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> -
>>  #include <linux/kernel.h>
>>  #include <linux/string.h>
>>  #include <linux/netdevice.h>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
>> index f2ab01c..ea3f5f5 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
>> @@ -34,6 +34,10 @@
>>  #define BRCMF_SCAN_VAL	0x4000
>>  #define BRCMF_CONN_VAL	0x8000
>>  
>> +/* set default print format */
>> +#undef pr_fmt
>> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>> +
> 
> The only negative I see to this is that
> any pr_<level> in any include file like:
> 
> include/linux/netdevice.h:1892:              pr_info("netif_stop_queue() cannot be called before register_netdev()\n");
> 
> may not be prefixed.
> 
> I expect that one day all these 
> #define pr_fmt(fmt) KBUILD_MODNAME etc...
> will be made unnecessary as kernel.h should
> be eventually changed to make it the default.
> 
> Something like:
> 
> https://lkml.org/lkml/2012/3/27/247

Got my vote for that.

Regards,
Arend


