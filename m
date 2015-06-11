Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbFKAlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 20:41:02 -0400
Date: Wed, 10 Jun 2015 17:40:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Rachel.kim@atmel.com, dean.lee@atmel.com, tony.cho@atmel.com,
	chris.park@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: modify data type
Message-ID: <20150611004059.GA30902@kroah.com> (sfid-20150611_024106_579493_E566BFE5)
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
 <1433923607-20927-2-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433923607-20927-2-git-send-email-johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 05:06:44PM +0900, Johnny Kim wrote:
> -static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
> +static int wilc_wlan_cfg_commit(int type, size_t drvHandler)

Shouldn't this just be a void *?  And if so, why not the real function
pointer instead?

Also, lots of these seem to be just pointers, please use a pointer
instead of hiding it in a size_t as that's the most portable, and
correct, way to do it.  No need to hide any function pointers here, this
isn't Windows :)

thanks,

greg k-h
