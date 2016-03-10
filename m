Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbcCJOxQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:53:16 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 054/113] rtl8xxxu: Implement 8723bu power on sequence
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-55-git-send-email-Jes.Sorensen@redhat.com>
	<87twkejtd4.fsf@purkki.adurom.net>
Date: Thu, 10 Mar 2016 09:53:14 -0500
In-Reply-To: <87twkejtd4.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
	10 Mar 2016 16:32:55 +0200")
Message-ID: <wrfjfuvy2xlx.fsf@redhat.com> (sfid-20160310_155318_826865_10D3EEEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This implements the 8723bu specific power on sequence as it is
>> different from that of the 8723au chips.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> [...]
>
>> @@ -140,7 +144,10 @@
>>  #define REG_MAC_PINMUX_CFG		0x0043
>>  #define REG_GPIO_PIN_CTRL		0x0044
>>  #define REG_GPIO_INTM			0x0048
>> +#define  GPIO_INTM_EDGE_TRIG_IRQ	BIT(9)
>> +
>>  #define REG_LEDCFG0			0x004c
>> +#define  LEDCFG0_DPDT_SELECT		BIT(23)
>>  #define REG_LEDCFG1			0x004d
>>  #define REG_LEDCFG2			0x004e
>>  #define  LEDCFG2_DPDT_SELECT		BIT(7)
>> @@ -154,9 +161,13 @@
>>  #define REG_GPIO_PIN_CTRL_2		0x0060
>>  /*  RTL8723 WIFI/BT/GPS Multi-Function GPIO Select. */
>>  #define REG_GPIO_IO_SEL_2		0x0062
>> +#define  GPIO_IO_SEL_2_GPIO09_INPUT	BIT(1)
>> +#define  GPIO_IO_SEL_2_GPIO09_IRQ	BIT(9)
>>  
>>  /*  RTL8723B */
>>  #define REG_PAD_CTRL1			0x0064
>> +#define  PAD_CTRL1_SW_DPDT_SEL_DATA	BIT(0)
>
> Why two spaces after define?

I use two spaces for bit defines, so it refers to the register
above. It's consistent throughout the code.

Jes
