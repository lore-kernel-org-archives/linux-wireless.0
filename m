Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52180 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZG3SsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:48:01 -0400
Received: by ewy10 with SMTP id 10so989867ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 11:48:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [RFC PATCH] rt61pci: fix module reloading with power saving enabled
Date: Thu, 30 Jul 2009 20:47:58 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <1248846761.18329.20.camel@ct>
In-Reply-To: <1248846761.18329.20.camel@ct>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200907302047.58736.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wednesday 29 July 2009, Pavel Roskin wrote:
> Unloading rt61pci can leave the device in such state that reloading
> rt61pci would fail to reinitialize it.  Bogus data would be read from
> the EEPROM and the RF version won't be recognized.  Only reboot would
> return the device to a sane state.
> 
> It appears that it happens if rt61pci is unloaded while power saving is
> active.  To initialize the device properly, SOFT_RESET_CSR should be set
> to the same value as rt61pci_config_ps() uses to wake up the device.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
> 
> I don't know what 0x00000007 is and I don't want to make up a name for
> it.

I'll look it up in the specification document.

> rt61pci_config_ps() does other things, but this is the minimal required
> change.  If anyone has a specification for rt61, it should mention
> SOFT_RESET_CSR and possibly other registers to be set before EEPROM may
> be accessed.
> 
> Please note that unloading rt61pci (as well as rt73usb) can trigger an
> oops or panic in sysfs code that I didn't have a chance to fix yet.
> It's very elusive and manifests differently every time.  Fortunately
> (for everyone not debugging it), it's rare.
> 
> 
>  drivers/net/wireless/rt2x00/rt61pci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index fb95b8c..f615fe6 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2600,6 +2600,8 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
>  
> +	rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
> +
>  	/*
>  	 * Allocate eeprom data.
>  	 */

The only comment about the patch at this time is that it might require a nice comment. ;)
I'll also think that perhaps a more generic approach is required where rt2x00lib forces
PS to be disabled before probe_hw(), just in case other hardware also have these problems.

Thanks,

Ivo

