Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47571 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1EPPMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 11:12:52 -0400
Received: by iwn34 with SMTP id 34so3998563iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 08:12:51 -0700 (PDT)
Message-ID: <4DD13EF0.2070803@lwfinger.net> (sfid-20110516_171255_225520_B6F786A6)
Date: Mon, 16 May 2011 10:12:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rob Browning <rlb@defaultvalue.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>	<4DD074E3.3090502@lwfinger.net>	<87vcxbe5xz.fsf@trouble.defaultvalue.org>	<4DD09C78.2010304@lwfinger.net> <8762pbkytq.fsf@trouble.defaultvalue.org>
In-Reply-To: <8762pbkytq.fsf@trouble.defaultvalue.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2011 12:18 AM, Rob Browning wrote:
> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>
>> You could patch either the linux-2.6 kernel (2.6.39-rc7), the
>> wireless-testing git tree, or get the source from your distro. You
>> will have to build the entire kernel as I do not have the necessary
>> make files to build the driver as an out of kernel module.
>
> That patch didn't seem to have an effect -- the receive rate still
> settles at about 60Kb/s.
>
> I patched the Debian linux-2.6 source package and rebuilt the kernel.
> The Debian kernel appeared to already have the wifi.h diff.
>
> Please let me know if I can help further.

Strange. With that patch in my system running with the current wireless-testing 
kernel, I get 19.8 Mbps download and 17.3 Mbps upload using tcpperf. The box at 
the other end is wired to my router/AP. The wireless connection is configured 
for 270 Mbps, thus rtl8192cu is not driving it at full rates, but that 
performance should be satisfactory.

Please run the following command for a couple of minutes to see what rate you get:

wget 
http://ftp.utexas.edu/opensuse/factory/iso/openSUSE-NET-x86_64-Build0018-Media.iso

That mirror might not be the best one for you to use, but that should be the 
best one to duplicate my results.

On my system, the instantaneous download rate ranges between 250 and 700 K/s. 
Without the patch, the rate is 48 K/s.

Larry
