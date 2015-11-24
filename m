Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39186 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbKXNqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 08:46:05 -0500
Date: Tue, 24 Nov 2015 16:45:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: zhaolei@cn.fujitsu.com
Cc: linux-wireless@vger.kernel.org
Subject: re: Fix debugfs_create_*'s error checking method for wireless/rt2x00/
Message-ID: <20151124134551.GA25396@mwanda> (sfid-20151124_144613_685410_08197F15)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Zhaolei,

The patch cfa3fa405a5e: "Fix debugfs_create_*'s error checking method
for wireless/rt2x00/" from Oct 22, 2008, leads to the following
static checker warning:

	drivers/net/wireless/ralink/rt2x00/rt2x00debug.c:674 rt2x00debug_register()
	warn: 'intf->driver_entry' isn't an ERR_PTR

drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
   651  void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
   652  {
   653          const struct rt2x00debug *debug = rt2x00dev->ops->debugfs;
   654          struct rt2x00debug_intf *intf;
   655  
   656          intf = kzalloc(sizeof(struct rt2x00debug_intf), GFP_KERNEL);
   657          if (!intf) {
   658                  rt2x00_err(rt2x00dev, "Failed to allocate debug handler\n");
   659                  return;
   660          }
   661  
   662          intf->debug = debug;
   663          intf->rt2x00dev = rt2x00dev;
   664          rt2x00dev->debugfs_intf = intf;
   665  
   666          intf->driver_folder =
   667              debugfs_create_dir(intf->rt2x00dev->ops->name,
   668                                 rt2x00dev->hw->wiphy->debugfsdir);
   669          if (IS_ERR(intf->driver_folder) || !intf->driver_folder)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
This code ensures that debugfs is enabled.

   670                  goto exit;
   671  
   672          intf->driver_entry =
   673              rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
   674          if (IS_ERR(intf->driver_entry) || !intf->driver_entry)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^
So there is no need to check again.

rt2x00debug_create_file_driver() is not a raw debugfs call, but
generally the correct thing is that we should not check debugfs
functions for errors.  Debugfs functions are designed so that, for
example, if debugfs_create_dir() fails then the files will just be
created in the root directory.  You don't need to have error checking
for debugfs_create_dir(), even if it returns null that's handled.

   675                  goto exit;
   676  
   677          intf->chipset_entry =
   678              rt2x00debug_create_file_chipset("chipset",
   679                                              intf, &intf->chipset_blob);
   680          if (IS_ERR(intf->chipset_entry) || !intf->chipset_entry)
   681                  goto exit;
   682  
   683          intf->dev_flags = debugfs_create_file("dev_flags", S_IRUSR,
   684                                                intf->driver_folder, intf,
   685                                                &rt2x00debug_fop_dev_flags);
   686          if (IS_ERR(intf->dev_flags) || !intf->dev_flags)
   687                  goto exit;
   688  

regards,
dan carpenter
