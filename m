Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab0DWMDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 08:03:52 -0400
Subject: Re: bug report: potential ERR_PTR dereference in iwm_debugfs_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100423114358.GD29093@bicker>
References: <20100422095929.GS29647@bicker>
	 <1271990911.14773.24.camel@debian>  <20100423114358.GD29093@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 14:03:47 +0200
Message-ID: <1272024227.17055.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-23 at 13:43 +0200, Dan Carpenter wrote:
> > > This is a Smatch bug that has me a little puzzled.
> > > 
> > > drivers/net/wireless/iwmc3200wifi/debugfs.c +447 iwm_debugfs_init(26) 
> > > 	warn: 'iwm->dbg.devdir' dereferencing possible ERR_PTR()
> > > 
> > >    440          iwm->dbg.devdir = debugfs_create_dir(devdir, iwm->dbg.rootdir);
> > >    441          result = PTR_ERR(iwm->dbg.devdir);
> > >    442          if (IS_ERR(iwm->dbg.devdir) && (result != -ENODEV)) {
> > >    443                  IWM_ERR(iwm, "Couldn't create devdir: %d\n", result);
> > >    444                  goto error;
> > >    445          }
> > >    446
> > >    447          iwm->dbg.dbgdir = debugfs_create_dir("debug", iwm->dbg.devdir);
> > > 
> > > It looks like "iwm->dbg.devdir" could be ERR_PTR(-ENODEV) on line 447 and 
> > > that would cause a problem inside debugfs_create_dir().  But at the same 
> > > time -ENODEV was deliberately singled out as OK from other possible errors 
> > > that debugfs_create_dir() can return.
> > 
> > We take -ENODEV for debugfs_create_dir if CONFIG_DEBUG_FS is not
> > enabled. We returns 0 deliberately in this case for rootdir create. I
> > agree we don't need to check it for the subdirs like we did now. But I
> > found lots of code don't even check (or don't use IS_ERR to check) the
> > return value of debugfs_create_dir. Maybe that's more problematic?
> 
> Ah.  Thanks for the explanation.
> 
> The bit that was problematic in this code for me is that passing
> ERR_PTR(-ENODEV) to debugfs_create_dir() on line 447 will cause an oops.
> But, as you point out, the check on line 442 is never true because we
> already established that debugfs is enabled.

I don't think so. See, that function will only return -ENODEV when
debugfs is not compiled into the kernel, and in that case the argument
to debugfs_create_dir is never used anyway.

johannes

