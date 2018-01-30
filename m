Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752872AbeA3Ogj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 09:36:39 -0500
Date: Tue, 30 Jan 2018 17:36:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild test robot <lkp@intel.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        kbuild-all@01.org, aditya.shankar@microchip.com
Subject: Re: [PATCH v2 13/14] staging: wilc1000: rename Handle_Connect() to
 avoid camelCase
Message-ID: <20180130143614.uci2td7lcihvna5b@mwanda> (sfid-20180130_153732_446103_5692A257)
References: <1516616547-24654-14-git-send-email-ajay.kathat@microchip.com>
 <201801300113.VYPjzW6k%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201801300113.VYPjzW6k%fengguang.wu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 30, 2018 at 02:13:53AM +0800, kbuild test robot wrote:
> Hi Ajay,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on staging/staging-testing]
> [cannot apply to v4.15 next-20180126]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Ajay-Singh/fix-to-remove-unnecessary-parenthesis-typedef-and-avoid-camelCase/20180123-115314
> 
> New smatch warnings:
> drivers/staging/wilc1000/host_interface.c:937 handle_connect() error: potential null dereference 'hif_drv->usr_conn_req.ssid'.  (kmalloc returns null)
> 

It's not really a new warning, it's just that we renamed variables.  But
that's fine because it's a real bug and we should fix it.

What I don't understand is that this warning was introduced in patch 9
so I don't know why the script is responding to patch 13.  I would have
expect it to reply to patch 9 (because that's where the warning is
introduced) or patch 0 or patch 14 (if it's testing the whole patchset
instead of individual patches).

regards,
dan carpenter
