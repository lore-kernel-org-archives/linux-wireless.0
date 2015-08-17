Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbHQTzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:55:43 -0400
Date: Mon, 17 Aug 2015 12:55:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv2 2/5] staging: wilc1000: use pr_* instead of printk
Message-ID: <20150817195542.GB6591@kroah.com> (sfid-20150817_215558_822192_DFDEFEBA)
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
 <6c2cf9ae657db1d6222551a81aa011422f079b96.1439838526.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <6c2cf9ae657db1d6222551a81aa011422f079b96.1439838526.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 03:28:27PM -0400, Raphaël Beamonte wrote:
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c  |  4 ++--
>  drivers/staging/wilc1000/linux_wlan.c        |  8 ++++----
>  drivers/staging/wilc1000/linux_wlan_common.h | 28 ++++++++++++++--------------
>  drivers/staging/wilc1000/linux_wlan_sdio.c   |  2 +-
>  drivers/staging/wilc1000/linux_wlan_spi.c    |  2 +-
>  drivers/staging/wilc1000/wilc_debugfs.c      | 16 ++++++++--------
>  drivers/staging/wilc1000/wilc_exported_buf.c |  2 --
>  7 files changed, 30 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 1a5b165..8a0ebba 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -2005,7 +2005,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
>  							pstrWIDs[counter].u16WIDid,
>  							(counter == u32WIDsCount - 1), drvHandler)) {
>  				ret = -1;
> -				printk("[Sendconfigpkt]Get Timed out\n");
> +				pr_err("[Sendconfigpkt]Get Timed out\n");

This is a network driver, please use the proper logging statement for
such a thing (i.e. netdev_err()).

thanks,

greg k-h
