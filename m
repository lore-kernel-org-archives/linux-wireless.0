Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56683 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab0DWLoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 07:44:14 -0400
Received: by qyk9 with SMTP id 9so12942995qyk.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 04:44:13 -0700 (PDT)
Date: Fri, 23 Apr 2010 13:43:59 +0200
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bug report: potential ERR_PTR dereference in iwm_debugfs_init()
Message-ID: <20100423114358.GD29093@bicker>
References: <20100422095929.GS29647@bicker> <1271990911.14773.24.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271990911.14773.24.camel@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 23, 2010 at 10:48:31AM +0800, Zhu Yi wrote:
> On Thu, 2010-04-22 at 17:59 +0800, Dan Carpenter wrote:
> > Hi Zhu Yi,
> > 
> > This is a Smatch bug that has me a little puzzled.
> > 
> > drivers/net/wireless/iwmc3200wifi/debugfs.c +447 iwm_debugfs_init(26) 
> > 	warn: 'iwm->dbg.devdir' dereferencing possible ERR_PTR()
> > 
> >    440          iwm->dbg.devdir = debugfs_create_dir(devdir, iwm->dbg.rootdir);
> >    441          result = PTR_ERR(iwm->dbg.devdir);
> >    442          if (IS_ERR(iwm->dbg.devdir) && (result != -ENODEV)) {
> >    443                  IWM_ERR(iwm, "Couldn't create devdir: %d\n", result);
> >    444                  goto error;
> >    445          }
> >    446
> >    447          iwm->dbg.dbgdir = debugfs_create_dir("debug", iwm->dbg.devdir);
> > 
> > It looks like "iwm->dbg.devdir" could be ERR_PTR(-ENODEV) on line 447 and 
> > that would cause a problem inside debugfs_create_dir().  But at the same 
> > time -ENODEV was deliberately singled out as OK from other possible errors 
> > that debugfs_create_dir() can return.
> 
> We take -ENODEV for debugfs_create_dir if CONFIG_DEBUG_FS is not
> enabled. We returns 0 deliberately in this case for rootdir create. I
> agree we don't need to check it for the subdirs like we did now. But I
> found lots of code don't even check (or don't use IS_ERR to check) the
> return value of debugfs_create_dir. Maybe that's more problematic?

Ah.  Thanks for the explanation.

The bit that was problematic in this code for me is that passing
ERR_PTR(-ENODEV) to debugfs_create_dir() on line 447 will cause an oops.
But, as you point out, the check on line 442 is never true because we
already established that debugfs is enabled.

Couldn't we just check "if (debugfs_initialized()) { " and remove all
the ERR_PTR checking?

If you would like I can send a patch to do this.

regards,
dan carpenter


