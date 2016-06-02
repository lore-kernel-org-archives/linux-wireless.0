Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35358 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbcFBJBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 05:01:54 -0400
Received: by mail-oi0-f47.google.com with SMTP id w184so67398584oiw.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 02:01:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464854569880.79341@qti.qualcomm.com>
References: <20160530132225.4d297678@canb.auug.org.au>
	<574C4851.9090201@gmail.com>
	<87fusy3cqx.fsf_-_@kamboji.qca.qualcomm.com>
	<574D3EAA.3060102@gmail.com>
	<1464764036580.70506@qti.qualcomm.com>
	<574EC331.1080901@gmail.com>
	<574ED297.4080004@gmail.com>
	<1464854569880.79341@qti.qualcomm.com>
Date: Thu, 2 Jun 2016 11:01:53 +0200
Message-ID: <CALhHN=q=pK8vzEnr4YfDsGaRqXegzEJh8GRzwRMMVMBkWAB6=w@mail.gmail.com> (sfid-20160602_110219_934534_C96C47F9)
Subject: Re: ath9k gpio request
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Miaoqing Pan <miaoqing@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2016 at 10:02, Pan, Miaoqing <miaoqing@qti.qualcomm.com> wrote:
> Seems there are something wrong in the datasheet,  try
>
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h
> @@ -1122,8 +1122,8 @@ enum {
>  #define AR9300_NUM_GPIO                          16
>  #define AR9330_NUM_GPIO                                 16
>  #define AR9340_NUM_GPIO                                 23
> -#define AR9462_NUM_GPIO                                 10
> -#define AR9485_NUM_GPIO                                 12
> +#define AR9462_NUM_GPIO                                 14
> +#define AR9485_NUM_GPIO                                 11
>  #define AR9531_NUM_GPIO                                 18
>  #define AR9550_NUM_GPIO                                 24
>  #define AR9561_NUM_GPIO                                 23
> @@ -1139,8 +1139,8 @@ enum {
>  #define AR9300_GPIO_MASK                        0x0000F4FF
>  #define AR9330_GPIO_MASK                        0x0000F4FF
>  #define AR9340_GPIO_MASK                        0x0000000F
> -#define AR9462_GPIO_MASK                        0x000003FF
> -#define AR9485_GPIO_MASK                        0x00000FFF
> +#define AR9462_GPIO_MASK                        0x00003FFF
> +#define AR9485_GPIO_MASK                        0x000007FF
>  #define AR9531_GPIO_MASK                        0x0000000F
>  #define AR9550_GPIO_MASK                        0x0000000F
>  #define AR9561_GPIO_MASK                        0x0000000F
>

Thanks, changes in reg.h solve the problem (my card AR9462 rev 01).

BR
Janusz

> Thanks,
> Miaoqing
>
> ________________________________________
> From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Sent: Wednesday, June 1, 2016 8:18 PM
> To: Pan, Miaoqing; Kalle Valo
> Cc: Stephen Rothwell; ath9k-devel; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org; netdev@vger.kernel.org; Miaoqing Pan
> Subject: Re: ath9k gpio request
>
> On Wednesday 01 June 2016 04:42 PM, Sudip Mukherjee wrote:
>> On Wednesday 01 June 2016 12:24 PM, Pan, Miaoqing wrote:
>>> which chip ?  And what's the GPIO number ?
>>
>> lspci -v reports:
>> 09:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network
>> Adapter (rev 01)
>>      Subsystem: Foxconn International, Inc. Device e052
>>      Flags: bus master, fast devsel, latency 0, IRQ 19
>>      Memory at c0500000 (64-bit, non-prefetchable) [size=512K]
>>      Expansion ROM at c0580000 [disabled] [size=64K]
>>      Capabilities: [40] Power Management version 2
>>      Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
>>      Capabilities: [70] Express Endpoint, MSI 00
>>      Capabilities: [100] Advanced Error Reporting
>>      Capabilities: [140] Virtual Channel
>>      Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
>>      Kernel driver in use: ath9k
>>
>> Any easy way to find out the gpio number or i can modify the module to
>> find that out.
>
> Its trying for GPIO 11 with label ath9k-rfkill.
>
> The attached dmesg is with some modification as below.
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
> b/drivers/net/wireless/ath/ath9k/hw.c
> index 8b2895f9..23deea7 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2729,14 +2729,16 @@ static void ath9k_hw_gpio_cfg_wmac(struct ath_hw
> *ah, u32 gpio, bool out,
>   static void ath9k_hw_gpio_request(struct ath_hw *ah, u32 gpio, bool out,
>                                    const char *label, u32 ah_signal_type)
>   {
> -       WARN_ON(gpio >= ah->caps.num_gpio_pins);
> +//     WARN_ON(gpio >= ah->caps.num_gpio_pins);
> +
> +       pr_err("sudip: %d %s\n", gpio, label);
>
>          if (BIT(gpio) & ah->caps.gpio_mask)
>                  ath9k_hw_gpio_cfg_wmac(ah, gpio, out, ah_signal_type);
>          else if (AR_SREV_SOC(ah))
>                  ath9k_hw_gpio_cfg_soc(ah, gpio, out, label);
> -       else
> -               WARN_ON(1);
> +//     else
> +//             WARN_ON(1);
>   }
>
> Regards
> Sudip
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
