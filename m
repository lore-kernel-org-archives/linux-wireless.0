Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51736 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbFVJ3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 05:29:51 -0400
Date: Mon, 22 Jun 2015 12:29:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dean Lee <dean.lee@atmel.com>, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com
Subject: Re: [PATCH 1/2] staging: wilc1000: modify type casting warning
Message-ID: <20150622092937.GX28762@mwanda> (sfid-20150622_112954_920310_4DDBE41D)
References: <1434438685-24336-1-git-send-email-dean.lee@atmel.com>
 <20150616130643.GB11143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150616130643.GB11143@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 06:06:43AM -0700, Greg KH wrote:
> This shows you are doing something really wrong here, why not just fix
> the function type to be a real pointer to a real structure?

You are right, of course.

> Or even better, just remove the parameter as I don't think they are
> even used.

I don't know how far you traced the code, you may be right.  It
eventually becomes driver_handler[] in wilc_wlan_cfg_commit() and we
do this:

drivers/staging/wilc1000/wilc_wlan.c
  1883          cfg->wid_header[1] = seq_no;    /* sequence number */
  1884          cfg->wid_header[2] = (uint8_t)total_len;
  1885          cfg->wid_header[3] = (uint8_t)(total_len >> 8);
  1886          cfg->wid_header[4] = (uint8_t)driver_handler;
  1887          cfg->wid_header[5] = (uint8_t)(driver_handler >> 8);
  1888          cfg->wid_header[6] = (uint8_t)(driver_handler >> 16);
  1889          cfg->wid_header[7] = (uint8_t)(driver_handler >> 24);

We put it in the header.

  1890          p->cfg_seq_no = seq_no;
  1891  
  1892          /**
  1893           *      Add to TX queue
  1894           **/
  1895  
  1896          /*Edited by Amr - BugID_4720*/
  1897          if (!wilc_wlan_txq_add_cfg_pkt(&cfg->wid_header[0], total_len))

And I don't know what we do with it after this.

  1898                  return -1;
  1899  
  1900          return 0;
  1901  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
