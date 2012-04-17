Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44348 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2DQJHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 05:07:18 -0400
Date: Tue, 17 Apr 2012 12:07:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: colin@cozybit.com
Cc: linux-wireless@vger.kernel.org
Subject: re: libertas: if_spi, driver for libertas GSPI devices
Message-ID: <20120417090717.GA2339@elgon.mountain> (sfid-20120417_110744_463685_E9145D7F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

I was going through some old stuff and I had a question about a
potential overfow in if_spi_c2h_cmd().

   714          } else if (len > IF_SPI_CMD_BUF_SIZE) {
                           ^^^^^^^^^^^^^^^^^^^^^^^^^
We cap "len" at 2400 bytes here.

   715                  netdev_err(priv->dev,
   716                             "%s: error: response packet too large: %d bytes, but maximum is %d\n",
   717                             __func__, len, IF_SPI_CMD_BUF_SIZE);
   718                  err = -EINVAL;
   719                  goto out;
   720          }
   721  
   722          /* Read the data from the WLAN module into our command buffer */
   723          err = spu_read(card, IF_SPI_CMD_RDWRPORT_REG,
   724                                  card->cmd_buffer, ALIGN(len, 4));
   725          if (err)
   726                  goto out;
   727  
   728          spin_lock_irqsave(&priv->driver_lock, flags);
   729          i = (priv->resp_idx == 0) ? 1 : 0;
   730          BUG_ON(priv->resp_len[i]);
   731          priv->resp_len[i] = len;
   732          memcpy(priv->resp_buf[i], card->cmd_buffer, len);
                       ^^^^^^^^^^^^^^^^
But ->resp_buf[i] can only hold LBS_UPLD_SIZE (2312) bytes, so we could
write past the end of the array.

   733          lbs_notify_command_response(priv, i);

regards,
dan carpenter

