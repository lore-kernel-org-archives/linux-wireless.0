Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43306 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2CLUKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 16:10:23 -0400
Received: by ghrr11 with SMTP id r11so2992208ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 13:10:22 -0700 (PDT)
Message-ID: <4F5E582B.7020407@lwfinger.net> (sfid-20120312_211027_266659_6F889D52)
Date: Mon, 12 Mar 2012 15:10:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: althaser <althaser@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Linux Kernel /staging/rtl8192e network module
References: <CAD=6cZrpC9WhoEZyespjt69LFR2Ay5vW5mSLojzY4cmrm-jPaQ@mail.gmail.com> <4F5E291D.8090809@lwfinger.net> <CAD=6cZo91uXx38OuJhjctT5ZrFOduYcMvUPUxNC8hFV0mbSVrQ@mail.gmail.com>
In-Reply-To: <CAD=6cZo91uXx38OuJhjctT5ZrFOduYcMvUPUxNC8hFV0mbSVrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 01:13 PM, althaser wrote:

> debian sid here
>
> $ lsmod |grep 8192
> rtl8192se              74082  0
> rtlwifi                81350  1 rtl8192se
> mac80211              192768  2 rtlwifi,rtl8192se

I put my RTL8192E in my computer, and using kernel 3.3-rc6, I got both rtl8192se 
and r8192e_pci loaded as expected, with r8192e_pci active. The bad news is that 
the driver got broken since the last time I tested it. I'm not the maintainer, 
and only acquired one of the cards when I discovered the PCI ID overlap with 
rtl8192se, which I do maintain.

I will try to bisect the driver to see what might be wrong.

The main difference between our two systems is the user-space components. My 
system is running version 173 of udevd, which is likely the component in question.

You should be able to blacklist rtl8192se and rtlwifi to get r8192e_pci working. 
Let me know if 3.2.9 works. Mine is unable to authenticate with 3.3-rc6.

Larry
