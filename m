Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36786 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbHREY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 00:24:29 -0400
Date: Tue, 18 Aug 2015 09:54:17 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv3] staging: wilc1000: use netdev_* instead of printk
Message-ID: <20150818042417.GA2941@sudip-pc> (sfid-20150818_062445_443036_6A5BD0A5)
References: <20150817195542.GB6591@kroah.com>
 <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 07:06:40PM -0400, Raphaël Beamonte wrote:
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
> index 16a0abc..9a36b78 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -2001,7 +2001,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
>  							pstrWIDs[counter].u16WIDid,
>  							(counter == u32WIDsCount - 1), drvHandler)) {
>  				ret = -1;
> -				printk("[Sendconfigpkt]Get Timed out\n");
> +				netdev_err("[Sendconfigpkt]Get Timed out\n");
This will not compile. you can not just replace printk with
netdev_*, you need to mention a net_device.

regards
sudip
