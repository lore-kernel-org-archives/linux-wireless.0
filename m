Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57081 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbZHDRM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 13:12:59 -0400
Received: by ewy10 with SMTP id 10so499807ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 10:12:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 1/2] rt61pci: fix module reloading
Date: Tue, 4 Aug 2009 19:12:55 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com
References: <20090802183002.16766.4142.stgit@ct.roinet.com>
In-Reply-To: <20090802183002.16766.4142.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908041912.56012.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 August 2009, Pavel Roskin wrote:
> Unloading rt61pci can leave the device in such state that reloading
> rt61pci would fail to reinitialize it.  Bogus data would be read from
> the EEPROM and the RF version won't be recognized.
> 
> It appears that unloading rt61pci with power saving enabled would have
> such effect.  To initialize the device properly, SOFT_RESET_CSR should
> be set to the same value as rt61pci_config_ps() uses to wake up the
> device.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>

I'm not really happy with the patch, but if it works, it works.
I got no better alternative to fix this correctly so we might as well merge
this into wireless-testing now. :)

Thanks.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index fb95b8c..e20dd74 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2601,6 +2601,11 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>  	int retval;
>  
>  	/*
> +	 * Disable power saving.
> +	 */
> +	rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
> +
> +	/*
>  	 * Allocate eeprom data.
>  	 */
>  	retval = rt61pci_validate_eeprom(rt2x00dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


