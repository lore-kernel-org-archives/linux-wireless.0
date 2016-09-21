Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbcIUKNT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 06:13:19 -0400
Date: Wed, 21 Sep 2016 12:13:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, Nicolai Stange <nicstange@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/4] carl9170: fix debugfs crashes
Message-ID: <20160921101325.GA22263@kroah.com> (sfid-20160921_121324_018237_CF1BC49A)
References: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com>
 <ccf228acb7af8ee3bbd82f72f28ebc068f37cb8e.1474140477.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ccf228acb7af8ee3bbd82f72f28ebc068f37cb8e.1474140477.git.chunkeey@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 17, 2016 at 09:43:02PM +0200, Christian Lamparter wrote:
> Ben Greear reported:
> > I see lots of instability as soon as I load up the carl9710 NIC.
> > My application is going to be poking at it's debugfs files...
> >
> > BUG: KASAN: slab-out-of-bounds in carl9170_debugfs_read+0xd5/0x2a0
> > [carl9170] at addr ffff8801bc1208b0
> > Read of size 8 by task btserver/5888
> > =======================================================================
> > BUG kmalloc-256 (Tainted: G        W      ): kasan: bad access detected
> > -----------------------------------------------------------------------
> >
> > INFO: Allocated in seq_open+0x50/0x100 age=2690 cpu=2 pid=772
> >...
> 
> This breakage was caused by the introduction of intermediate
> fops in debugfs by commit 9fd4dcece43a
> ("debugfs: prevent access to possibly dead file_operations at file open")
> 
> Thankfully, the original/real fops are still available in d_fsdata.
> 
> Reported-by: Ben Greear <greearb@candelatech.com>
> Reviewed-by: Nicolai Stange <nicstange@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Cc: stable <stable@vger.kernel.org> # 4.7+
> ---
>  drivers/net/wireless/ath/carl9170/debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
> index 01a0919..ad7ffd5 100644
> --- a/drivers/net/wireless/ath/carl9170/debug.c
> +++ b/drivers/net/wireless/ath/carl9170/debug.c
> @@ -75,7 +75,7 @@ static ssize_t carl9170_debugfs_read(struct file *file, char __user *userbuf,
>  
>  	if (!ar)
>  		return -ENODEV;
> -	dfops = container_of(file->f_path.dentry->d_fsdata,
> +	dfops = container_of(debugfs_real_fops(file),
>  			     struct carl9170_debugfs_fops, fops);
>  
>  	if (!dfops->read)
> @@ -128,7 +128,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
>  
>  	if (!ar)
>  		return -ENODEV;
> -	dfops = container_of(file->f_path.dentry->d_fsdata,
> +	dfops = container_of(debugfs_real_fops(file),
>  			     struct carl9170_debugfs_fops, fops);
>  	if (!dfops->write)
>  		return -ENOSYS;

What tree is this against?  I can't apply it to 4.8-rc5, or 4.8-rc7, are
you sure it is still needed?

thanks,

greg k-h
