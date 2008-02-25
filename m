Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59583 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYBYCcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 21:32:41 -0500
Subject: Re: can't bring up wlan0
From: Zhu Yi <yi.zhu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080224180419.b7b44524.akpm@linux-foundation.org>
References: <20080223153142.da9fc4e4.akpm@linux-foundation.org>
	 <1203904312.3082.156.camel@debian.sh.intel.com>
	 <20080224180419.b7b44524.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 10:31:51 +0800
Message-Id: <1203906711.3082.168.camel@debian.sh.intel.com> (sfid-20080225_023300_592765_E85B69B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2008-02-24 at 18:04 -0800, Andrew Morton wrote:
> 
> I don't think ipw2200 worked that way?  I'm fairly sure I used to be
> able to configure the interface whichever way the switch was
> positioned?

Yes, the iwlwifi driver changes the behaviour (vs. ipw2200) to load the
firmware from pci_probe to network interface open (ifconfig up). It is
expected to support 1) wireless driver buildin kernel (ipw2200 doesn't
support it because network device is initialized before hard disk in
boot up process: no firmware found); 2) saves more power when you load
the module but don't use wireless.

So when the RF kill switch is turned on, the firmware loading is failed.

BTW, we also have patches to delay ipw2100/2200 firmware loading like
this.

Thanks,
-yi

