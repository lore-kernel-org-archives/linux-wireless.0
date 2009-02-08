Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:21803 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752976AbZBHSXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 13:23:52 -0500
Message-ID: <20090208192343.106487dmjra19g6o@neo.wg.de> (sfid-20090208_192408_621407_DB086D32)
Date: Sun, 08 Feb 2009 19:23:43 +0100
From: Jan Schneider <jan@horde.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: Microcode SW error detected.
References: <20090206233134.11116cap9kcroxgc@neo.wg.de>
 <1233960318.11530.114.camel@rc-desk>
In-Reply-To: <1233960318.11530.114.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zitat von reinette chatre <reinette.chatre@intel.com>:

> On Fri, 2009-02-06 at 14:31 -0800, Jan Schneider wrote:
>> I've seen in a post from January that someone already had this problem
>> but couldn't reproduce it.
>> I can't reliably reproduce, but I see this more often than I like.
>> When this happens, it usually doesn't help to reload the kernel
>> module. Sometimes it helps to use the rfkill switch though.
>>
>> Here's a log with debug=0x43fff:
>
> It does not seem as though your driver is compiled with debug support.
> You can confirm that by looking at the version number of the driver
> printed when it loads ... it should have a "d" in it like "1.2.26kds".
> Could you please recompile the driver with debug support (IWLWIFI_DEBUG)
> and rerun your test?  This will provide us with a complete event log of
> the uCode error.

Enabling debug didn't help:

Feb  7 00:04:40 tank kernel: [ 2769.084395] iwlagn: Intel(R) Wireless  
WiFi Link
AGN driver for Linux, 1.3.27kds


/etc/modprobe.d/iwlagn:

options iwlagn debug=0x43fff


I still get:

Feb  8 18:40:53 tank kernel: [77584.979829] iwlagn 0000:0c:00.0:  
Microcode SW er
ror detected.  Restarting 0x2000000.
Feb  8 18:40:53 tank kernel: [77585.029747] Registered led device:  
iwl-phy0::rad
io
Feb  8 18:40:53 tank kernel: [77585.030765] Registered led device:  
iwl-phy0::ass
oc
Feb  8 18:40:53 tank kernel: [77585.031602] Registered led device:  
iwl-phy0::RX
Feb  8 18:40:53 tank kernel: [77585.032467] Registered led device:  
iwl-phy0::TX

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

