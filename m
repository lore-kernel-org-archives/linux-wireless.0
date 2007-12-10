Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:18355 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbXLJJD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 04:03:29 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1456059ugc
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 01:03:27 -0800 (PST)
Message-ID: <475D00D7.10309@gmail.com> (sfid-20071210_090334_133262_DA53D33B)
Date: Mon, 10 Dec 2007 10:03:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bruno Randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com
Subject: Re: [PATCH] ath5k: add debugfs entries for registers, tsf, beacon,
 reset
References: <1197274926-14334-1-git-send-email-bruno@thinktube.com>
In-Reply-To: <1197274926-14334-1-git-send-email-bruno@thinktube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2007 09:22 AM, Bruno Randolf wrote:
> i resend this patch to address jiris comments and with some small improvements.
> 
> 'registers' prints the name and value of some registers. this should be adapted
> to what we actually need later and is supposed to replace the hwdump facility i
> removed in my earlier debugging changes.
> 
> 'tsf' prints the current HW TSF. writing "reset" into the file will reset the
> TSF.
> 
> 'beacon' shows beacon relevant registers.  it is good for watching the beacon
> timers with something like "watch -n0 cat /dbg/ath5k/phy0/beacon". writing
> "enable" into the file will try to enable beacons by setting the flag
> AR5K_BEACON_ENABLE, "disable" will disable that bit.
> 
> 'reset' can be used to trigger a HW reset, by writing "reset" into it.
> 
> Changes-licensed-under: GPL
> 
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> Acked-by: Luis R. Rodriguez <mgrof@winlab.rutgers.edu>
> ---
>  drivers/net/wireless/ath5k/debug.c |  267 ++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath5k/debug.h |    4 +
>  2 files changed, 271 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> index 7427506..7e34684 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
[...]
> +static int open_file_registers(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *s;
> +	int res;
> +	res = seq_open(file, &register_seq_ops);
> +	s = file->private_data;
> +	s->private = inode->i_private;

Sorry for not noticing this earlier, if res is nonzero, you are dereferencing
NULL (s) here.

> +	return res;
> +}

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
