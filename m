Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57166 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaHEFmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 01:42:49 -0400
Message-ID: <53E06EB3.4000507@linux.intel.com> (sfid-20140805_074252_589011_2B5E8ECA)
Date: Tue, 05 Aug 2014 13:42:11 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: brudley@broadcom.com, Franky Lin <frankyl@broadcom.com>,
	meuleman@broadcom.com, linville@tuxdriver.com,
	pieterpg@broadcom.com, dekim@broadcom.com, mcgrof@do-not-panic.com,
	antonio@open-mesh.com, johannes.berg@intel.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: prevent watchdog from interfering with	scanning
 and connecting
References: <539E8559.3010601@linux.intel.com> <539EA79C.7010206@broadcom.com> <53A30F96.3010206@linux.intel.com> <53A311E4.301@broadcom.com> <53CCC44C.2070507@linux.intel.com> <53D124B3.7030807@linux.intel.com> <53DFB6A1.7040900@linux.intel.com> <20140804165202.GG30282@n2100.arm.linux.org.uk> <53DFE933.2080805@broadcom.com>
In-Reply-To: <53DFE933.2080805@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2014/8/5 4:12, Arend van Spriel wrote:
> On 08/04/14 18:52, Russell King - ARM Linux wrote:
>> On Tue, Aug 05, 2014 at 12:36:49AM +0800, Fu, Zhonghui wrote:
>>> Hi, Arend
>>>
>>> I investigated this issue, and its root cause is still that sdio
>>> controller can't receive interrupts from WiFi chip on sdio bus when
>>> sdio controller is in runtime suspend status. I am running 3.16-rc5
>>> linux kernel on ASUS T100TA tablet, and using sdhci-acpi driver.
>>
>> That's the root cause.  I fixed this with the Freescale i.MX SD driver
>> which is now able to report pending SDIO interrupts while runtime PM
>> suspended.
>>
>> Other host drivers probably need fixing too, or having runtime PM
>> disabled on them - if you can't receive SDIO interrupts while runtime
>> PM suspended, then entering runtime PM while you have a SDIO device
>> attached is a bug.
>>
>> This is something for the MMC people to deal with rather than Arend.
>
> Occasionally, the itch is there to fix mmc code, but this looks a bit tricky. The fun starts in sdio.c:mmc_attach_sdio():
>
>     /*
>      * Enable runtime PM only if supported by host+card+board
>      */
>     if (host->caps & MMC_CAP_POWER_OFF_CARD) {
>         /*
>          * Let runtime PM core know our card is active
>          */
>         err = pm_runtime_set_active(&card->dev);
>         if (err)
>             goto remove;
>
>         /*
>          * Enable runtime PM for this card
>          */
>         pm_runtime_enable(&card->dev);
>     }
>
> The comment above the if statement seems to be stating the right idea, but the code only looks at the host controller capability flags.

Yes, this code section is not implemented as its comments.

Thanks,
Zhonghui

>
> Regards,
> Arend
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

