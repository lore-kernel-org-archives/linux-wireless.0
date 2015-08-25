Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25187 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbbHYG4j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 02:56:39 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch] mwifiex: fix mwifiex_rdeeprom_read()
Date: Tue, 25 Aug 2015 06:56:34 +0000
Message-ID: <e7bbd1bc72994d84a9c44e6a73c65ed5@SC-EXCH04.marvell.com> (sfid-20150825_085658_151757_F726015D)
References: <20150820103037.GA5521@mwanda>
In-Reply-To: <20150820103037.GA5521@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, August 20, 2015 4:01 PM
> To: Amitkumar Karwar; Bing Zhao
> Cc: Nishant Sarmukadam; Kalle Valo; linux-wireless@vger.kernel.org;
> kernel-janitors@vger.kernel.org
> Subject: [patch] mwifiex: fix mwifiex_rdeeprom_read()
> 
> There were several bugs here.
> 
> 1)  The done label was in the wrong place so we didn't copy any
>     information out when there was no command given.
> 
> 2)  We were using PAGE_SIZE as the size of the buffer instead of
>     "PAGE_SIZE - pos".
> 
> 3)  snprintf() returns the number of characters that would have been
>     printed if there were enough space.  If there was not enough space
>     (and we had fixed the memory corruption bug #2) then it would result
>     in an information leak when we do simple_read_from_buffer().  I've
>     changed it to use scnprintf() instead.
> 
> I also removed the initialization at the start of the function, because
> I thought it made the code a little more clear.
> 
> Fixes: 5e6e3a92b9a4 ('wireless: mwifiex: initial commit for Marvell
> mwifiex driver')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/mwifiex/debugfs.c
> b/drivers/net/wireless/mwifiex/debugfs.c
> index 5a0636d4..bd2f5d2 100644
> --- a/drivers/net/wireless/mwifiex/debugfs.c
> +++ b/drivers/net/wireless/mwifiex/debugfs.c
> @@ -731,7 +731,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user
> *ubuf,
>  		(struct mwifiex_private *) file->private_data;
>  	unsigned long addr = get_zeroed_page(GFP_KERNEL);
>  	char *buf = (char *) addr;
> -	int pos = 0, ret = 0, i;
> +	int pos, ret, i;
>  	u8 value[MAX_EEPROM_DATA];
> 
>  	if (!buf)
> @@ -739,7 +739,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user
> *ubuf,
> 
>  	if (saved_offset == -1) {
>  		/* No command has been given */
> -		pos += snprintf(buf, PAGE_SIZE, "0");
> +		pos = snprintf(buf, PAGE_SIZE, "0");
>  		goto done;
>  	}
> 
> @@ -751,14 +751,14 @@ mwifiex_rdeeprom_read(struct file *file, char
> __user *ubuf,
>  		goto done;
>  	}
> 
> -	pos += snprintf(buf, PAGE_SIZE, "%d %d ", saved_offset,
> saved_bytes);
> +	pos = snprintf(buf, PAGE_SIZE, "%d %d ", saved_offset,
> saved_bytes);
> 
>  	for (i = 0; i < saved_bytes; i++)
> -		pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ",
> value[i]);
> +		pos += scnprintf(buf + pos, PAGE_SIZE - pos, "%d ",
> value[i]);
> 
> +done:
>  	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
> 
> -done:
>  	free_page(addr);
>  	return ret;
>  }

Looks good.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
