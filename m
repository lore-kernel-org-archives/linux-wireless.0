Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47576 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2FVQN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 12:13:56 -0400
Received: by gglu4 with SMTP id u4so1670117ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 09:13:56 -0700 (PDT)
Message-ID: <4FE499C0.8010902@lwfinger.net> (sfid-20120622_181400_287236_EE46FA27)
Date: Fri, 22 Jun 2012 11:13:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: santosh.adari@wipro.com
CC: wlanfae@realtek.com, pj.chiang@realcomtec.com, babu.vba@wipro.com,
	manjunathan.padua@wipro.com,
	wireless <linux-wireless@vger.kernel.org>,
	driverdevel <devel@driverdev.osuosl.org>
Subject: Re: RTL8712u driver information.
References: <5379C41A9569B24380950BE8B32390D864245DB2@BLR-EC-MBX5.wipro.com>
In-Reply-To: <5379C41A9569B24380950BE8B32390D864245DB2@BLR-EC-MBX5.wipro.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2012 08:50 AM, santosh.adari@wipro.com wrote:
> Hi All,
>
> I am using realtek driver version “v2.6.6.0.20110401” for RTL8712 chipset with
> linux 2.6.29 kernel version. I have built realtek driver as module and using the
> driver.
>
> I observe in linux 3.2 version there is realtek driver version “v7_0.20100831”
> for RTL8712 chipset.

Messages of this type should *always* be addressed to a general mailing list, 
and not only to module authors. Without such a general audience, you are asking 
for private consulting, but not offering to pay for it. I have added the 
wireless and driver-development mailing lists to the Cc's here.

>
> Queries:
>
> 1.which is the latest driver among these drivers?

Obviously, 20110401 is after 20100831. The version number inside the kernel is 
meaningless. The Linux kernel is regularly updated without changing that version.

> 2.What is the difference between these version of drivers?

The kernel version is built into the kernel!

> 3.Is the driver in linux 3.2 taken from relatek and integrated to
> drivers/staging/ of linux 3.2 ?

The Realtek driver was added to drivers/staging in the kernel in August 2010 for 
kernel 2.6.37 and was based on the latest version available at that time; 
however, as the Realtek version did not work on 64-bit systems, there were many 
changes. As Realtek has released later versions, the kernel driver has been 
updated to include those changes. For a while, I was feeding additional changes 
back to Realtek; however, those patches were ignored, thus I stopped.

To see what the differences are, you would need to carefully analyze the output 
of a "diff" command, and the pertinent sections of the "git log" output. Other 
than the kernel version working on 64-bit kernels, I do not know what they are. 
Other changes also include fixes for oops, etc.

Larry
