Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46152 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759595Ab3DHWYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 18:24:49 -0400
Received: by mail-oa0-f44.google.com with SMTP id h1so6804379oag.17
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 15:24:49 -0700 (PDT)
Message-ID: <516343AE.6020503@lwfinger.net> (sfid-20130409_002452_993759_1EA3CF5D)
Date: Mon, 08 Apr 2013 17:24:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi: rtl8188ee: Add new driver
References: <20130407093859.GA28809@longonot.mountain>
In-Reply-To: <20130407093859.GA28809@longonot.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2013 04:39 AM, Dan Carpenter wrote:
> Hi Larry,
>
> I had a question about f0eb856e0b6c: "rtlwifi: rtl8188ee: Add new
> driver" from Mar 24, 2013.
>
> drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
>    1631          for (path = 0; path < MAX_RF_PATH; path++) {
>    1632                  /*2.4G default value*/
>    1633                  for (i = 0; i < MAX_CHNL_GROUP_24G; i++) {
>    1634                          pwr2g->index_cck_base[path][i] = hwinfo[eadr++];
>    1635                          if (pwr2g->index_cck_base[path][i] == 0xFF)
>    1636                                  pwr2g->index_cck_base[path][i] = 0x2D;
>    1637                  }
>    1638                  for (i = 0; i < MAX_CHNL_GROUP_24G-1; i++) {
>                                          ^^^^^^^^^^^^^^^^^^^^
> We skip the last element of the array.  It's declared on the stack in
> the caller function so it just has uninitialized stack data.  It doesn't
> look intentional to me.
>
>    1639                          pwr2g->index_bw40_base[path][i] = hwinfo[eadr++];
>    1640                          if (pwr2g->index_bw40_base[path][i] == 0xFF)
>    1641                                  pwr2g->index_bw40_base[path][i] = 0x2D;
>    1642                  }
>
> regards,

Dan,

Thanks for noticing this difference. I agree that there is no reason for any 
difference in the range os the two loops.

I will submit a patch.

Larry


