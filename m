Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:49691 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3F2Foq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 01:44:46 -0400
Message-ID: <51CE6FB5.2000706@01019freenet.de> (sfid-20130629_074453_735318_D0E644DF)
Date: Sat, 29 Jun 2013 07:25:09 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 01/19] rt2x00: rt2800lib: add BBP register
 initialization for RT3593
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org> <1372446753-11408-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1372446753-11408-2-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,

thanks for your submission. I tried to test it, but stuck at the problem
mentioned below.


Regards,
Andreas

Gabor Juhos wrote:
> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.
> 
> References:
>   NICInitRT3593BbpRegisters in chips/rt3593.c
>   NICInitBBP in common/rtmp_init.c
>   NICInitAsicFromEEPROM in common/rtmp_init.c
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 6f58ceb..32ecd1a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4505,6 +4505,22 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
>  	rt2800_disable_unused_dac_adc(rt2x00dev);
>  }
>  
> +static void rt2800_init_bbp_3593(struct rt2x00_dev *rt2x00dev)
> +{
> +	rt2800_init_bbp_early(rt2x00dev);
> +
> +	rt2800_bbp_write(rt2x00dev, 79, 0x13);
> +	rt2800_bbp_write(rt2x00dev, 80, 0x05);
> +	rt2800_bbp_write(rt2x00dev, 81, 0x33);
> +	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
> +
> +	rt2800_bbp_write(rt2x00dev, 84, 0x19);
> +
> +	/* Enable DC filter */
> +	if (rt2x00_rt_rev_gte(rt2x00dev, RT3593, REV_RT3593E))

Where is REV_RT3593E defined?

/tmp/backports-20130617/drivers/net/wireless/rt2x00/rt2800lib.c: In
function ‘rt2800_init_bbp_3593’:
/tmp/backports-20130617/drivers/net/wireless/rt2x00/rt2800lib.c:5325:43:
error: ‘REV_RT3593E’ undeclared (first use in this function)


Thanks,
Andreas
