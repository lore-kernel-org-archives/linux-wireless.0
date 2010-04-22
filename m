Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41452 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0DVJ7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 05:59:45 -0400
Received: by wyb39 with SMTP id 39so4638659wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 02:59:43 -0700 (PDT)
Date: Thu, 22 Apr 2010 11:59:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: bug report: potential ERR_PTR dereference in iwm_debugfs_init()
Message-ID: <20100422095929.GS29647@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Zhu Yi,

This is a Smatch bug that has me a little puzzled.

drivers/net/wireless/iwmc3200wifi/debugfs.c +447 iwm_debugfs_init(26) 
	warn: 'iwm->dbg.devdir' dereferencing possible ERR_PTR()

   440          iwm->dbg.devdir = debugfs_create_dir(devdir, iwm->dbg.rootdir);
   441          result = PTR_ERR(iwm->dbg.devdir);
   442          if (IS_ERR(iwm->dbg.devdir) && (result != -ENODEV)) {
   443                  IWM_ERR(iwm, "Couldn't create devdir: %d\n", result);
   444                  goto error;
   445          }
   446
   447          iwm->dbg.dbgdir = debugfs_create_dir("debug", iwm->dbg.devdir);

It looks like "iwm->dbg.devdir" could be ERR_PTR(-ENODEV) on line 447 and 
that would cause a problem inside debugfs_create_dir().  But at the same 
time -ENODEV was deliberately singled out as OK from other possible errors 
that debugfs_create_dir() can return.

I'm confused.

regards,
dan carpenter
