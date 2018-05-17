Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbeEQJ1R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 05:27:17 -0400
Date: Thu, 17 May 2018 12:27:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: huxm@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mwifiex: add rx histogram statistics support
Message-ID: <20180517092707.GA5900@mwanda> (sfid-20180517_112730_442084_900C5557)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Xinming Hu,

The patch cbf6e05527a7: "mwifiex: add rx histogram statistics
support" from Dec 23, 2014, leads to the following static checker
warning:

	drivers/net/wireless/marvell/mwifiex/util.c:714 mwifiex_hist_data_set()
	error: buffer underflow 'phist_data->snr' '(-128)-127'

drivers/net/wireless/marvell/mwifiex/util.c
   706  /* function to add histogram record */
   707  void mwifiex_hist_data_set(struct mwifiex_private *priv, u8 rx_rate, s8 snr,
                                                                             ^^^^^^
   708                             s8 nflr)
   709  {
   710          struct mwifiex_histogram_data *phist_data = priv->hist_data;
   711  
   712          atomic_inc(&phist_data->num_samples);
   713          atomic_inc(&phist_data->rx_rate[rx_rate]);
   714          atomic_inc(&phist_data->snr[snr]);
   715          atomic_inc(&phist_data->noise_flr[128 + nflr]);
   716          atomic_inc(&phist_data->sig_str[nflr - snr]);

Smatch complains that "snr" comes from skb->data so it's untrusted and
it can be less than zero and underflow the ->snr array.

->snr, ->noise_flr and ->sig_str all have 256 elements.  Obviously it
seems like "snr" should be declared as a u8 instead of an s8.  But I'm
not totally sure what to do about the ->noise_flr and ->sig_str[]
arrays.

   717  }

regards,
dan carpenter
