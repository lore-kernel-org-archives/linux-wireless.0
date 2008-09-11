Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYIKJCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 05:02:55 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 17:02:59 +0800
Message-Id: <1221123779.2513.88.camel@debian.sh.intel.com> (sfid-20080911_110259_705263_9B4920F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel!

On Thu, 2008-09-11 at 10:04 +0200, Marcel Holtmann wrote:
> However I tried to reproduce it without Bluetooth enabled, it didn't  
> show or I didn't wait long enough. Once I started bluetoothd it showed  
> within a few minutes.
> 
> So the best I got was the attached screenshot of an oops. It is  
> clearly the iwlwifi driver crashing here and killing the machine, but  
> I have no idea why.

>From the screenshot line:

iwl_tx_cmd_complete+0x43/0x245

It should be triggered by the BUG_ON() in the function. Are you able to
confirm it with netconsole or maybe even a frame buffer enabled console
(it just shows more lines)? If this is the culprit, Tomas has been
already working on it. But your BT coexist finding should help us
reproducing the bug.
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

Thanks,
-yi

