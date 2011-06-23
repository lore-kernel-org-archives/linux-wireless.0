Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18423 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759575Ab1FWPov (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 11:44:51 -0400
Message-ID: <4E035F71.20602@gnu.org> (sfid-20110623_174455_010179_169C80E6)
Date: Thu, 23 Jun 2011 11:44:49 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Maya it <maya1625it@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] dev_base list head in the linux kernel code
References: <BANLkTinvscyX=xh_auh96nf2UPV=njkYXg@mail.gmail.com>
In-Reply-To: <BANLkTinvscyX=xh_auh96nf2UPV=njkYXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2011 10:12 PM, Maya it wrote:
> Hi all,
>
> I have two wireless cards (wlan0 and wlan1) and want to access them
> separately. I plan to keep both in adhoc mode and communicate with wlan0 and
> wlan1 respectively at the other end of this communication. But since I am
> working at the kernel level, and I want to access these devices from the
> dev_base list. As far as I know, dev_base saves the net_devices which are
> initialized at boot up time. So I want to open the device and change its
> configuration after the kernel has loaded.
>
> Please guide and let me know if I am wrong in understanding the basics of
> the dev_base list.

Please don't cross-post.  Cross-posting should be reserved for really 
important topics, such as announcements by lead developers.  I'm 
trimming the cc list.  Actually, your question would be suitable for the 
netdev list, as there it nothing specific in your question about 
wireless devices, let alone ath9k.  Or better yet, maybe you could find 
some forum or list for the newbies in kernel programming?

I suggest that you check the latest kernel source for examples before 
asking questions.  You can easily find that access to dev_base is 
encapsulated by macros defined in netdevice.h, such as for_each_netdev.

Now you can look for examples of for_each_netdev in the code and see if 
they do what you need.

-- 
Regards,
Pavel Roskin
