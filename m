Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755310AbdHYOD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 10:03:56 -0400
Subject: Re: [PATCH 2/2] brcmfmac: Use separate firmware for revision 0 of the
 brcm43430 chip
To: =?UTF-8?Q?J=c3=b6rg_Krause?= <joerg.krause@embedded.rocks>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Jelle van der Waa <jelle@vdwaa.nl>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
References: <20170616131449.12108-1-hdegoede@redhat.com>
 <20170616131449.12108-2-hdegoede@redhat.com>
 <1503669327.8480.3.camel@embedded.rocks>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <c851671c-1147-94cc-cf98-d0b20b051b3b@redhat.com> (sfid-20170825_160407_215144_7D6C7CCB)
Date: Fri, 25 Aug 2017 16:03:52 +0200
MIME-Version: 1.0
In-Reply-To: <1503669327.8480.3.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 25-08-17 15:55, Jörg Krause wrote:
> Hi,
> 
> On Fri, 2017-06-16 at 15:14 +0200, Hans de Goede wrote:
>> The brcm43430 chip needs different firmware files for chip revision 0
>> and 1. The file currently in linux-firmware is for revision 1 only.
>>
>> This commit makes brcmfmac request brcmfmac43430a0-sdio.bin instead
>> of brcmfmac43430-sdio.bin for revision 0 chips.
>>
>> Note that the behavior for revision 1 chips is not changed, ideally those
>> would load brcmfmac43430a1-sdio.bin, but that will break existing setups.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 4ed40c94bda9..5125aeeb5310 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -612,7 +612,9 @@ BRCMF_FW_NVRAM_DEF(43340, "brcmfmac43340-sdio.bin", "brcmfmac43340-sdio.txt");
>>   BRCMF_FW_NVRAM_DEF(4335, "brcmfmac4335-sdio.bin", "brcmfmac4335-sdio.txt");
>>   BRCMF_FW_NVRAM_DEF(43362, "brcmfmac43362-sdio.bin", "brcmfmac43362-sdio.txt");
>>   BRCMF_FW_NVRAM_DEF(4339, "brcmfmac4339-sdio.bin", "brcmfmac4339-sdio.txt");
>> -BRCMF_FW_NVRAM_DEF(43430, "brcmfmac43430-sdio.bin", "brcmfmac43430-sdio.txt");
>> +BRCMF_FW_NVRAM_DEF(43430A0, "brcmfmac43430a0-sdio.bin", "brcmfmac43430a0-sdio.txt");
>> +/* Note the names are not postfixed with a1 for backward compatibility */
>> +BRCMF_FW_NVRAM_DEF(43430A1, "brcmfmac43430-sdio.bin", "brcmfmac43430-sdio.txt");
>>   BRCMF_FW_NVRAM_DEF(43455, "brcmfmac43455-sdio.bin", "brcmfmac43455-sdio.txt");
>>   BRCMF_FW_NVRAM_DEF(4354, "brcmfmac4354-sdio.bin", "brcmfmac4354-sdio.txt");
>>   BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-sdio.bin", "brcmfmac4356-sdio.txt");
>> @@ -630,7 +632,8 @@ static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>>   	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, 4335),
>>   	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, 43362),
>>   	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
>> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFF, 43430),
>> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000001, 43430A0),
>> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFE, 43430A1),
>>   	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, 43455),
>>   	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
>>   	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356)
> 
> Unfortunately, there is no "brcmfmac43430a0-sdio.bin" in linux-
> firmware. Therefore, my custom board fails:
> 
> # [   24.894241] brcmfmac mmc0:0001:1: Direct firmware load for
> brcm/brcmfmac43430a0-sdio.bin failed with error -2
> [   25.914322] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000):
> clkctl 0x50
> [   26.934186] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000):
> clkctl 0x50
> 
> Can someone provide the firmware file, please?

I've put all the versions I've been able to find here:

http://jwrdegoede.danny.cz/brcm-firmware/

Note that the 7.x.y.z version does not seem to have any useful meaning,
higher is not necessarily newer :|

[hans@shalem brcm-firmware]$ for i in brcmfmac43430a0-sdio.bin*; do echo $i && strings $i | tail -n 1; done
brcmfmac43430a0-sdio.bin.7.10.1.244.ucode940.1020
43430a0-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-lpc-wl11u-rcc-fmc-wepso-ccx-okc-fbt-noccxaka-txpwr-ampduhostreorder-clm_43xx_lg-ndoe Version: 7.10.1.244 CRC: 73c82137 Date: Fri 2016-07-01 18:03:15 KST Ucode Ver: 940.1020 FWID: 01-bae8afee
brcmfmac43430a0-sdio.bin.7.10.226.49.no_ucode_version
43430a0-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-lpc-wl11u-rcc-fmc-wepso-ccx-okc-fbt-noccxaka-txpwr-ampduhostreorder-clm_43xx_lg Version: 7.10.226.49 CRC: bf92cb0b Date: Fri 2014-06-06 14:55:15 KST FWID 01-8962686a
brcmfmac43430a0-sdio.bin.7.10.68.5.ucode997.0
43430a0-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-ampduhostreorder-lpc-wl11u-rcc-fmc-wepso-ccx-okc-anqpo-ltecx-sr-ndoe Version: 7.10.68.5 CRC: 5168922 Date: Thu 2015-04-30 04:20:43 PDT Ucode Ver: 997.0 FWID: 01-2bde7d77

So date wise brcmfmac43430a0-sdio.bin.7.10.1.244.ucode940.1020 is the newest
and IIRC that one works well for me.

ucode version wise, brcmfmac43430a0-sdio.bin.7.10.68.5.ucode997.0 is newer,
but the .0 in 997.0 makes it feel like an unproven release to me.

Regards,

Hans
