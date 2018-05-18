Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751858AbeERHma (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 03:42:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4I7eRQw032099
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 00:42:29 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2j0fs2fgeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 00:42:29 -0700
From: Xinming Hu <huxm@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [bug report] mwifiex: add rx histogram statistics support
Date: Fri, 18 May 2018 07:42:27 +0000
Message-ID: <1526629347198.90308@marvell.com> (sfid-20180518_094233_876894_65758E5F)
References: <20180517092707.GA5900@mwanda>
In-Reply-To: <20180517092707.GA5900@mwanda>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the report!
We also notice it recently, and have already fix it.
Just upstream the below fix
https://patchwork.kernel.org/patch/10408353/

Regards,
Simon
________________________________________
From: Dan Carpenter <dan.carpenter@oracle.com>
Sent: Thursday, May 17, 2018 17:27
To: Xinming Hu
Cc: linux-wireless@vger.kernel.org
Subject: [EXT] [bug report] mwifiex: add rx histogram statistics support

External Email

----------------------------------------------------------------------
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
