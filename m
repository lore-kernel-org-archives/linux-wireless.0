Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:6860 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbYFLMsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 08:48:35 -0400
Received: by gv-out-0910.google.com with SMTP id e6so844714gvc.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 05:48:34 -0700 (PDT)
Message-ID: <48511B1D.4010901@gmail.com> (sfid-20080612_144845_240444_45B900AB)
Date: Thu, 12 Jun 2008 15:48:29 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
References: <484FF375.8010002@gmail.com> <1213237561.7814.688.camel@debian.sh.intel.com>
In-Reply-To: <1213237561.7814.688.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> On Wed, 2008-06-11 at 18:47 +0300, Maxim Levitsky wrote:
>> I found why I can't reenable wireless with wireless button.
>>
>> It turns out that iwlwifi doesn't enable the wireless function after a
>> R/F kill switch was enabled ether by the button or explicitly.
>>
>> I bisected this to commit 5a66926aa9230810704fd5a127966215fd58881e
>> in linus tree.
> 
> The card will receive an interrupt when you disable the rf kill switch
> anyway whatever the wireless function is enabled or not. So the driver
> will enable the wireless function again. Please check if the interface
> (wlan0) is up when you disable the rf kill switch later. If it is not,
> you have to bring it up manually (i.e. ifconfig wlan0 up) to enable the
> wireless function. Otherwise please provide the dmesg with
> debug=0x20000.
> 
> Thanks,
> -yi
> 

Why didn't I thought about this before...
This is exactly what happens, so this isn't a bug.

What happens is the Network manager brings wlan0 down is it detects that
there is no link, but this now removes the firmware.

I guess that the right solution is to listen to the wireless button (via 
input layer), and turn card on manually.

If I remember correctly there is something like that in kernel, I try to 
enable this.

Otherwise this can be implemented in userspace.

Best regards,
	Maxim Levitsky
