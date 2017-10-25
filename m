Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:53255 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdJYQKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 12:10:45 -0400
Received: by mail-oi0-f46.google.com with SMTP id h6so868787oia.10
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2017 09:10:44 -0700 (PDT)
Subject: Re: Searching help for Linux support for RTL8812AU
To: "txt.file" <txt.file@txtfile.eu>, linux-wireless@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
References: <8a62a06d-8a80-6df7-4f30-160a0231dac9@txtfile.eu>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e8cf8c3a-bd7d-b94f-ed42-ee8d7431a9f5@lwfinger.net> (sfid-20171025_181049_072189_44A0382B)
Date: Wed, 25 Oct 2017 11:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <8a62a06d-8a80-6df7-4f30-160a0231dac9@txtfile.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2017 08:24 AM, txt.file wrote:
> Hey Linux wireless list,
> 
> A while ago I bought an ALFA Network AWUS036AC[0] which does not yet
> seem to be supported in Linux mainline. I would like to get it supported.
> 
> The problem is that I have not that much experience doing software
> development.
> 
> kind regards
> txt.file
> 
> PS: Please keep me in CC as I am not subscribed to the lists.
> 
> [0] https://wikidevi.com/wiki/ALFA_Network_AWUS036AC

I can provide you with an out-of-kernel driver for the RTL8812AU. Please be 
aware that these Realtek USB drivers require many changes before they can be 
accepted into even the staging tree of the kernel. One other consideration is 
that staging drivers should (must?) have a definite path for inclusion into the 
main kernel trees. For wireless, this means using mac80211. For these Realtek 
drivers with their own MAC code, that is a major change.

My suggestion is that you work to get your device handled by driver rtl8xxxu, 
which is in the kernel. I have no idea how much effort that would be, but 
certainly a lot less than converting the Realtek driver.

Larry

PS: Please keep the list in the Cc as I tend to disregard private requests for 
consulting!
