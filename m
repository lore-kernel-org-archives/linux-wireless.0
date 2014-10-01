Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48022 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaJAXuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 19:50:14 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 6FD0840A79A
	for <linux-wireless@vger.kernel.org>; Wed,  1 Oct 2014 16:50:13 -0700 (PDT)
Message-ID: <542C9335.6050900@candelatech.com> (sfid-20141002_015018_959395_29B581D3)
Date: Wed, 01 Oct 2014 16:50:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Setting legacy bit-rates no longer works?
References: <542C8798.30807@candelatech.com>
In-Reply-To: <542C8798.30807@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2014 04:00 PM, Ben Greear wrote:
> I tried this on a 3.17.0-rc7+ kernel, but reported tx-rate stays at 54Mbps
> 
> iw dev sta1 set bitrates legacy-5 24
> 
> Driver is ath9k, but wpa_supplicant is configured to disable HT.
> 
> I'm going to go dig into this, but if someone has any suggestions,
> please let me know.

Ok, so my problem is that I was trying to set legacy-2.4 rates with one call to iw,
and legacy-5 rates with another.  Any non-specified rates get set to full bit-rate,
so that is why it wasn't working.

You have to do something like:

iw dev sta1 set bitrates legacy-2.4 24 legacy-5 24

Probably any time supplicant sets the rates, even if not specifying
legacy, it is going to over-write your previously set legacy rates.

I think the kernel should just not make any changes if the user does
not specify that entry in the netlink message, but that is a problem
for another day.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

