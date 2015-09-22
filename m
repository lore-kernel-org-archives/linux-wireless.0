Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16915 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbbIVK7D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 06:59:03 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch v2] mwifiex: fix mwifiex_rdeeprom_read()
Date: Tue, 22 Sep 2015 10:58:59 +0000
Message-ID: <bd6f0967147e436fae399297d295fd34@SC-EXCH04.marvell.com> (sfid-20150922_125907_905348_9E7BA874)
References: <87lhcz5z70.fsf@kamboji.qca.qualcomm.com>
 <20150921161953.GQ5004@mwanda>
In-Reply-To: <20150921161953.GQ5004@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, September 21, 2015 9:50 PM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; Kalle Valo; linux-wireless@vger.kernel.org;
> kernel-janitors@vger.kernel.org
> Subject: [patch v2] mwifiex: fix mwifiex_rdeeprom_read()
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
> ---
> v2:  My first part introduced a bug.  :(
> 
> Sorry for the delay on this.
> 
> diff --git a/drivers/net/wireless/mwifiex/debugfs.c
> b/drivers/net/wireless/mwifiex/debugfs.c
> index 5a0636d4..5583856 100644
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
> @@ -748,17 +748,17 @@ mwifiex_rdeeprom_read(struct file *file, char
> __user *ubuf,
>  				  (u16) saved_bytes, value);
>  	if (ret) {
>  		ret = -EINVAL;
> -		goto done;
> +		goto out_free;
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
> -
> -	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
> +		pos += scnprintf(buf + pos, PAGE_SIZE - pos, "%d ",
> value[i]);
> 
>  done:
> +	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
> +out_free:
>  	free_page(addr);
>  	return ret;
>  }

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
