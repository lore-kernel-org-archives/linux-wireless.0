Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2253 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab0DWCth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 22:49:37 -0400
Subject: Re: bug report: potential ERR_PTR dereference in iwm_debugfs_init()
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100422095929.GS29647@bicker>
References: <20100422095929.GS29647@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 10:48:31 +0800
Message-ID: <1271990911.14773.24.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-22 at 17:59 +0800, Dan Carpenter wrote:
> Hi Zhu Yi,
> 
> This is a Smatch bug that has me a little puzzled.
> 
> drivers/net/wireless/iwmc3200wifi/debugfs.c +447 iwm_debugfs_init(26) 
> 	warn: 'iwm->dbg.devdir' dereferencing possible ERR_PTR()
> 
>    440          iwm->dbg.devdir = debugfs_create_dir(devdir, iwm->dbg.rootdir);
>    441          result = PTR_ERR(iwm->dbg.devdir);
>    442          if (IS_ERR(iwm->dbg.devdir) && (result != -ENODEV)) {
>    443                  IWM_ERR(iwm, "Couldn't create devdir: %d\n", result);
>    444                  goto error;
>    445          }
>    446
>    447          iwm->dbg.dbgdir = debugfs_create_dir("debug", iwm->dbg.devdir);
> 
> It looks like "iwm->dbg.devdir" could be ERR_PTR(-ENODEV) on line 447 and 
> that would cause a problem inside debugfs_create_dir().  But at the same 
> time -ENODEV was deliberately singled out as OK from other possible errors 
> that debugfs_create_dir() can return.

We take -ENODEV for debugfs_create_dir if CONFIG_DEBUG_FS is not
enabled. We returns 0 deliberately in this case for rootdir create. I
agree we don't need to check it for the subdirs like we did now. But I
found lots of code don't even check (or don't use IS_ERR to check) the
return value of debugfs_create_dir. Maybe that's more problematic?

Thanks,
-yi

