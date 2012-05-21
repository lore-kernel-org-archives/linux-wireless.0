Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2EULzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 07:55:45 -0400
Date: Mon, 21 May 2012 13:55:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Woody Hung <Woody.Hung@mediatek.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00 : RT3290 chip support v1
Message-ID: <20120521115526.GB2290@redhat.com> (sfid-20120521_135602_716416_CB8E1BA4)
References: <1337587307-2740-1-git-send-email-Woody.Hung@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1337587307-2740-1-git-send-email-Woody.Hung@mediatek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Woody

On Mon, May 21, 2012 at 04:01:47PM +0800, Woody Hung wrote:
> +	if (rt2x00dev->chip.rf == RF3290 ||
> +		rt2x00dev->chip.rf == RF5370 ||
> +		rt2x00dev->chip.rf == RF5372 ||
> +		rt2x00dev->chip.rf == RF5390) {

Please fix indention of "if" statement arguments by n*tab + m*spaces,
where m is less than 8, and use rt2x00_rf function i.e:

	if (rt2x00_rf(rt2x00dev, RF3290) ||
	    rt2x00_rf(rt2x00dev, RF5380) ||

>  	if (rt2x00_rt(rt2x00dev, RT3071) ||
>  	    rt2x00_rt(rt2x00dev, RT3090) ||
> -	    rt2x00_rt(rt2x00dev, RT3390)) {
> -		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
> +	    rt2x00_rt(rt2x00dev, RT3390) ||
> +		rt2x00_rt(rt2x00dev, RT3290)) {
[snip]
> -	if (rt2x00_rt(rt2x00dev, RT5390) ||
> +	if (rt2x00_rt(rt2x00dev, RT3290) ||
> +		rt2x00_rt(rt2x00dev, RT5390) ||
>  		rt2x00_rt(rt2x00dev, RT5392)) {
Again "if" indention, please fix that on any place in the patch
where bottom "if" argument is unaligned to upper "if" argument.

> +EXPORT_SYMBOL_GPL(rt2800_enable_wlan_rt3290);
Why not define this function in file where it is used.

>  	struct rt2x00_dev *rt2x00dev;
>  	int retval;
> +	u16 device_id;
>  
>  	retval = pci_enable_device(pci_dev);
>  	if (retval) {
> @@ -305,6 +306,14 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
>  	if (retval)
>  		goto exit_free_device;
>  
> +	/*
> +	 * Because rt3290 chip use different efuse offset to read efuse data.
> +	 * So before read efuse it need one parameter to indicate it is the
> +	 * rt3290 or not.
> +	 */
> +	pci_read_config_word(pci_dev, PCI_DEVICE_ID, &device_id);
> +	rt2x00dev->chip.device_id = device_id;
Not needed, the same data is available in:

to_pci_dev(rt2x00dev->dev)->device

Thanks
Stanislaw
