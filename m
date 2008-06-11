Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:35686 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761884AbYFKPrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 11:47:09 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2159974fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 08:47:05 -0700 (PDT)
Message-ID: <484FF375.8010002@gmail.com> (sfid-20080611_174737_264918_C2EA7207)
Date: Wed, 11 Jun 2008 18:47:01 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ipw3945-devel@lists.sourceforge.net
Subject: Re: [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> I recently bought an acer aspire 5720G, and wireless didn't work with
> standard ubuntu 2.6.24 kernel.
> 
> I found that specifying the above option 'fixes' the driver
> but I also noticed that list of available access points shrinks
> to just one (the connected) point.
> 
> Moreover there is a trouble in changing a access point, it just hangs.
> the button that toggles wireless does work, but doesn't blink.
> 
> I then installed latest -git kernel (~ 2.6.26-rc4) and got this:
> 
> * I still have to use disable_hw_scan=1
> * Wireless led works thanks to acer-wmi
> * If I disable wireless with the button, I _can't_ re-enable it unless
>   I reload the module.
> 
> * List of access points doesn't shrink, and I can switch between those points.
> 
> 
> When I omit disable_hw_scan=1, I get errors about REPLY_SCAN_CMD
> I will send detailed debug info later.
> 
> Best regards,
> 	Maxim Levitsky


I found why I can't reenable wireless with wireless button.

It turns out that iwlwifi doesn't enable the wireless function after a 
R/F kill switch was enabled ether by the button or explicitly.

I bisected this to commit 5a66926aa9230810704fd5a127966215fd58881e
in linus tree.

Best regards,
	Maxim Levitsky
