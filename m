Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:25747 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761588AbYJKRmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 13:42:49 -0400
Received: by nf-out-0910.google.com with SMTP id d3so472902nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 10:42:47 -0700 (PDT)
Message-ID: <48F0E58F.6000900@gmail.com> (sfid-20081011_194254_726656_903EE267)
Date: Sat, 11 Oct 2008 18:42:39 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] orinoco: reload firmware on resume
References: <200810111816.26370.arvidjaar@mail.ru>
In-Reply-To: <200810111816.26370.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On resume card state is likely lost so we have to reload firmware
> again.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> ---
> 
> This is non-functional without second patch. Currently you simply
> have no way to load request firmware from user space in ->resume.

Does it work when you compile the firmware into the kernel image
with CONFIG_FIRMWARE_KERNEL, CONFIG_EXTRA_FIRMWARE and
CONFIG_EXTRA_FIRMWARE_DIR?
 
> --- a/drivers/net/wireless/orinoco.c
> +++ b/drivers/net/wireless/orinoco.c
> @@ -2298,9 +2298,14 @@ int orinoco_reinit_firmware(struct net_device *dev)
>  {
>  	struct orinoco_private *priv = netdev_priv(dev);
>  	struct hermes *hw = &priv->hw;
> -	int err;
> +	int err = 0;

The explicit initialisation is unneccesary.

>  	err = hermes_init(hw);
> +	if (priv->do_fw_download && !err) {

Otherwise this looks right.


Regards,

Dave.
