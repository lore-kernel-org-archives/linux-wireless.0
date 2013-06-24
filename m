Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49061 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3FXTRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 15:17:55 -0400
Message-ID: <51C89B66.8010509@openwrt.org> (sfid-20130624_211758_817125_1D309222)
Date: Mon, 24 Jun 2013 21:17:58 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 3/3] rt2x00: rt2800lib: turn on tertiary PAs/LNAs for
 3T/3R devices
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org> <1371915734-13966-4-git-send-email-juhosg@openwrt.org> <3B42FB1E-C6CE-4580-9C71-47BB609B4CB8@gmail.com>
In-Reply-To: <3B42FB1E-C6CE-4580-9C71-47BB609B4CB8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan,

> Sent from my iPad
> 
> On 22 jun. 2013, at 17:42, Gabor Juhos <juhosg@openwrt.org> wrote:
> 
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |   14 ++++++++++++++
>> 1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index f4cd3d8..664e9e1 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -2684,12 +2684,26 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>>                   rf->channel > 14);
>>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
>>                   rf->channel <= 14);
>> +
>> +        if (rt2x00dev->default_ant.tx_chain_num > 2) {
>> +            /* Turn on tertiary PAs for 3T devices */
>> +            rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN,
>> +                    rf->channel > 14);
>> +            rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
>> +                    rf->channel <= 14);
>> +        }
>>    }
>>
>>    if (rt2x00dev->default_ant.rx_chain_num > 1) {
>>        /* Turn on secondary LNAs for 2R and for 3R devices */
>>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
>>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
>> +
>> +        if (rt2x00dev->default_ant.rx_chain_num > 2) {
>> +            /* Turn on tertiary LNAs for 3R devices */
>> +            rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
>> +            rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
>> +        }
>>    }
> 
> Stylistic I would prefer the if outside of if block you included it in.
> Something like:
> 
> if (tx_chain_num > 2) {
>      /* Turn on tertiary PAs for 3T devices */
> }
> if (tx_chain_num > 1) {
>     /* Turn on secondary PAs for 2T and for 3T devices */
> }
> /* Turn on primary PAs for 1T, 2T and for 3T devices */

> At least to me this is easier to read.

Yes it would be more readable. The only disadvantage of separated if statements
is that both conditions will be evaluated on 1T devices.

> Alternatively it could be changed to a switch statement wit fall-through
> cases for the number of RX/TX streams.

This sounds more reasonable, I will change the code to use switch statements.

Thanks,
Gabor
