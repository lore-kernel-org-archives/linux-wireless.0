Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0HXMQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 08:16:37 -0400
Subject: Re: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
In-Reply-To: <20100824120743.GG29330@bicker>
References: <20100824120743.GG29330@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 14:17:52 +0200
Message-ID: <1282652273.3695.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-24 at 14:07 +0200, Dan Carpenter wrote:
> The indenting is not correct here.  I don't have this hardware and I'm
> just guessing as to what was intended.  I think that if there is an
> error we should return an error code, but if there isn't an error we
> should return success directly without releasing the firmware.

>  		goto release_firmware;
>  	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
>  				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
> +	if (err)
>  		goto release_firmware;
>  
> -	lbs_deb_spi("waiting for helper to boot...\n");
> +	lbs_deb_spi("helper firmware loaded...\n");
> +
> +	return 0;
>  
>  release_firmware:
>  	release_firmware(firmware);

This doesn't look correct, the caller of this function also sometimes
releases the firmware, but it looks like it could lead to a double-free?

johannes

