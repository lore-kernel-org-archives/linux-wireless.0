Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2BFPFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 10:05:24 -0500
Date: Mon, 6 Feb 2012 20:35:16 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: add blocking debugfs file for retrieving
 firmware logs
Message-ID: <20120206150515.GA4024@chvasanth-lnx> (sfid-20120206_160528_002678_CFBB9A7C)
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
 <20120206062340.20231.55630.stgit@localhost6.localdomain6>
 <20120206090654.GA3260@chvasanth-lnx>
 <4F2FC989.5000306@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F2FC989.5000306@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 02:37:29PM +0200, Kalle Valo wrote:
> On 02/06/2012 11:06 AM, Vasanthakumar Thiagarajan wrote:
> > On Mon, Feb 06, 2012 at 08:23:40AM +0200, Kalle Valo wrote:
> >> When debugging firmware issues it's not always enough to get
> >> the latest firmware logs, sometimes we need to get logs from a longer
> >> period. To make this possible, add a debugfs file named fwlog_block. When
> >> reading from this file ath6kl will send firmware logs whenever available
> >> and otherwise it will block and wait for new logs.
> >>
> >> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> [...]
> 
> >> +	not_copied = copy_to_user(user_buf, buf, len);
> >> +	if (not_copied != 0) {
> >> +		ret_cnt = -EFAULT;
> >> +		goto out;
> >> +	}
> >> +
> >> +	*ppos = *ppos + len;
> > 
> > Why not to use simple_read_from_buffer()?, looks like it can also
> > takes care of len == 0 case in the following check.
> > 
> > if (pos >= available || !count)
> >         return 0;
> > 
> > when available (len) is 0, pos = available with
> > ath6kl_fwlog_block_read().
> 
> I actually used simple_read_from_buffer() first, but the problem is that
> it assumes that there's just one buffer from which the data is copied.
> But in this case there can be multiple buffers from which I copy data.
> 
> Ok, that was a bit confusing, let's try to explain a bit differently :)
> 
> If 'ppos > 0' (for example during the second function call)
> simple_read_from_buffer() will try to copy from 'user_buf + ppos' but I
> would want to copy from 'user_buf'.

I think you mean s/user_buf/buf. Are you not making sure that the
length of the data is not more than the requested one which is
passed to copy_to_user() so that read() is always called with
*ppos=0?. The following code seems to do that

 while ((skb = __skb_dequeue(&ar->debug.fwlog_queue))) {
+               if (skb->len > count - len) {
+                       /* not enough space, put skb back and leave
*/
+                       __skb_queue_head(&ar->debug.fwlog_queue,
skb);
+                       break;
+               }

May be my understanding is wrong. 

Vasanth
