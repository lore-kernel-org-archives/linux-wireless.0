Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbYFLC00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 22:26:26 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
From: Zhu Yi <yi.zhu@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <484FF375.8010002@gmail.com>
References: <484FF375.8010002@gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 10:26:01 +0800
Message-Id: <1213237561.7814.688.camel@debian.sh.intel.com> (sfid-20080612_042706_555889_193B3C2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-11 at 18:47 +0300, Maxim Levitsky wrote:
> 
> I found why I can't reenable wireless with wireless button.
> 
> It turns out that iwlwifi doesn't enable the wireless function after a
> R/F kill switch was enabled ether by the button or explicitly.
> 
> I bisected this to commit 5a66926aa9230810704fd5a127966215fd58881e
> in linus tree.

The card will receive an interrupt when you disable the rf kill switch
anyway whatever the wireless function is enabled or not. So the driver
will enable the wireless function again. Please check if the interface
(wlan0) is up when you disable the rf kill switch later. If it is not,
you have to bring it up manually (i.e. ifconfig wlan0 up) to enable the
wireless function. Otherwise please provide the dmesg with
debug=0x20000.

Thanks,
-yi

