Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39191 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaC0QBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 12:01:17 -0400
Date: Thu, 27 Mar 2014 19:01:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fariya Fatima <fariyaf@gmail.com>, kbuild@01.org,
	linux-wireless@vger.kernel.org
Subject: Re: [kbuild-all] [wireless-next:master 316/316]
 drivers/net/wireless/rsi/rsi_91x_debugfs.c:296 rsi_init_dbgfs() error:
 potential null dereference 'dev_dbgfs'. (kzalloc returns null)
Message-ID: <20140327160105.GU7045@mwanda> (sfid-20140327_170129_627214_73FAEA59)
References: <53275729.QHDAYltTUiN7HGNZ%fengguang.wu@intel.com>
 <20140327154507.GA27177@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140327154507.GA27177@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 27, 2014 at 06:45:07PM +0300, Dan Carpenter wrote:
> > drivers/net/wireless/rsi/rsi_91x_usb.c:289 rsi_usb_write_register_multiple() warn: '__min2' 4096 can't fit into 255 'transfer'

The code for this one is:

	transfer = min_t(int, count, 4096);

It's complaining because "tranfers" is u8, but the cast to int always
makes me worry negative values.  In this case, count is not user
controlled so it's safe.  But that's a common security problem you
should be aware of.  It's better to cast it to an unsigned value.

regards,
dan carpenter

