Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42374 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1HYJdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:33:51 -0400
Date: Thu, 25 Aug 2011 15:03:40 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<kvalo@adurom.com>
Subject: Re: [PATCH V2 3/3] ath6kl: Add debugfs file entry to dump credit
	distribution stats
Message-ID: <20110825093339.GA17131@vasanth-laptop> (sfid-20110825_113355_373310_865111EC)
References: <1314257441-8092-1-git-send-email-vthiagar@qca.qualcomm.com> <1314257441-8092-3-git-send-email-vthiagar@qca.qualcomm.com> <1314260797.15882.63.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314260797.15882.63.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 01:26:37AM -0700, Joe Perches wrote:
> On Thu, 2011-08-25 at 13:00 +0530, Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> []
> > diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> []
> > +static ssize_t read_file_credit_dist_stats(struct file *file,
> > +					   char __user *user_buf,
> > +					   size_t count, loff_t *ppos)
> > +{
> > +	struct ath6kl *ar = file->private_data;
> > +	struct htc_target *target = ar->htc_target;
> > +	struct htc_endpoint_credit_dist *ep_list;
> > +	char *buf;
> > +	unsigned int buf_len = 128, len = 0;
> > +	ssize_t ret_cnt;
> > +
> > +	buf_len += get_queue_depth(&target->cred_dist_list) * 128;
> 
> Doesn't look like 128 is the right size.

It is well enough, needed is only around 110 bytes.
> 
> > +	buf = kzalloc(buf_len, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> 
> kmalloc can run out of space pretty quickly if cred_dist_list
> is large.  Maybe vmalloc?
> 

Well, right now the size of cred_dist_list can be maximum of 9.
The maximum memory required would be around 2.5K, I think for 
this size kmalloc is fine.

> > +
> > +	len += scnprintf(buf + len, buf_len - len,
> > +			 " Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd"
> > +			 "  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist"
> > +			 "  qdepth\n");
> > +
> > +	list_for_each_entry(ep_list, &target->cred_dist_list, list) {
> > +		len += scnprintf(buf + len, buf_len - len, "  %2d",
> > +				 ep_list->endpoint);
> > +		len += scnprintf(buf + len, buf_len - len, "%10x",
> > +				 ep_list->dist_flags);
> 
> I think this is nearly unreadable.
> It doesn't line up well with your header.
> 
> Why not align them correctly or otherwise make no
> attempt to align them at all?

Right, totally unaligned is not readable either ;). Ok, the number
of digits that needed to represent the number of credits are not
going to exceed 3. I just tried to have it displayed around at the center
below the respective tag.

> 
> Your current header and field widths:
> 
>           1         2         3         4         5         6         7         8         9        10        11        12 
>  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
> 	len += scnprintf(buf + len, buf_len - len,
> " Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist  qdepth\n");
>    12          12345678         123456789          1234567890123            123456789              123456789012
>      1234567890        123456789         1234567890             123456789012         12345678901234
> 

It is very unlikely to have an output like above in real time.
Sample output that I got is


Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist  qdepth
   0         0       0        0        0         0            0        1664        1             0           0
   1  80000000       1        1        1         1            0        1664        1             0           0
   5         0       5        1        0         0            0        1664        1             0           0
   4         0       5        1        0         0            0        1664        1             0           0
   2  80000000       5        1        2         3            0        1664        1             0           0
   3  80000000       5        1        1         1            0        1664        1             0           0

> > +	list_for_each_entry(ep_list, &target->cred_dist_list, list) {
> > +		len += scnprintf(buf + len, buf_len - len, "  %2d",
> > +				 ep_list->endpoint);
> > +		len += scnprintf(buf + len, buf_len - len, "%10x",
> > +				 ep_list->dist_flags);
> 
> maybe use a macro:
> #define ep_list_field(fmt, field)	\ 
> 	len += scnprint(buf + len, buf_len - len, fmt, ep_list->field)
> 
> 		ep_list_field("  %2d", endpoint);
> 		ep_list_field("%9d", cred_min);
> 		ep_list_field("%9d", credits);
> etc

Makes sense.

Thanks for the review

Vasanth
