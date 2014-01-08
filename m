Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28125 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaAHRlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 12:41:04 -0500
Message-ID: <52CD8DAB.8040307@broadcom.com> (sfid-20140108_184108_651220_7C243459)
Date: Wed, 8 Jan 2014 18:40:59 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>,
	<linux-sunxi@googlegroups.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chen-Yu Tsai <wens@csie.org>
Subject: Re: [linux-sunxi] [PATCH] brcmfmac: add support for bcm43362 device
References: <1389174573-5204-1-git-send-email-arend@broadcom.com> <CAGRGNgWySMpEecaPFL0NuynSwCik17xGRPk44z5cw+AAckaBvA@mail.gmail.com>
In-Reply-To: <CAGRGNgWySMpEecaPFL0NuynSwCik17xGRPk44z5cw+AAckaBvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2014 01:49 PM, Julian Calaby wrote:
> Hi Arend,
> 
> On Wed, Jan 8, 2014 at 8:49 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> This patch adds support for the bcm43362 1x1 11n chipset. This
>> chipset is used in AP6210 wifi module found on Cubieboard [1].
>>
>> [1] http://cubieboard.org/
>>
>> Reviewed-by: Franky Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> Hi John,
>>
>> Here a straggler for new device support that people
>> playing with Cubieboards have been asking for. Intended
>> for v3.14 kernel.
>>
>> Regards,
>> Arend
>> ---
>>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 +
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +++
>>  .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   33 ++++++++++++++++++++
>>  .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
>>  4 files changed, 40 insertions(+)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> index 2bf4757..9c7f08a 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> @@ -509,6 +509,8 @@ enum brcmf_sdio_frmtype {
>>  #define BCM4334_NVRAM_NAME             "brcm/brcmfmac4334-sdio.txt"
>>  #define BCM4335_FIRMWARE_NAME          "brcm/brcmfmac4335-sdio.bin"
>>  #define BCM4335_NVRAM_NAME             "brcm/brcmfmac4335-sdio.txt"
>> +#define BCM43362_FIRMWARE_NAME         "brcm/brcmfmac43362-sdio.bin"
>> +#define BCM43362_NVRAM_NAME            "brcm/brcmfmac43362-sdio.txt"
> 
> I haven't been following the discussion so this may be redundant, but
> is this firmware is presently winging it's way towards Linux-firmware?

Hi Julian,

The patch for that still has to go out. I am looking whether we have a
newer firmware release as the one found on cubieboard.org [1]. So the
firmware did not set sail yet (expect it soon :-) ).

Regards,
Arend

[1] http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/
