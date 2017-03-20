Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36401 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbdCTCDk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Mar 2017 22:03:40 -0400
Received: by mail-oi0-f47.google.com with SMTP id r203so11886636oib.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Mar 2017 19:03:39 -0700 (PDT)
Subject: Re: Wireless failed
To: Fernanda Vejar <fvejar85@gmail.com>, linux-wireless@vger.kernel.org
References: <CADND2bqVLdSmmY=RG7m8r2maWyc7yGgvKUO4O4YGPLVnMx0pqg@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <34e317ae-a112-79bc-41ef-c18433e8cc49@lwfinger.net> (sfid-20170320_030558_664711_D826349D)
Date: Sun, 19 Mar 2017 21:03:37 -0500
MIME-Version: 1.0
In-Reply-To: <CADND2bqVLdSmmY=RG7m8r2maWyc7yGgvKUO4O4YGPLVnMx0pqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2017 12:15 PM, Fernanda Vejar wrote:
> Dear Sir or Madam, I am writing you because I cannot make the wireless
> connection work. I have just installed a new Linux operative system
> which has no driver for the wireless card. I have the device "Intel
> Centrino Wireless-N 2230" into my computer and I have been trying to
> follow the instructions given by "wireless.wiki.kernel" with the
> following steps: 1) I installed the corresponding firmware
> "iwlwifi-2030-ucode-18.168.6.1.". 2) I installed the driver LinuxCore5
> as indicated and rebooted. 3) As I found no change, I have noted that
> the hostap was absent. Than I cloned it. 4) Since it also didn't work,
> I took "linux-firmware" and I installed "-9 ucode: 7260, 3160, 7265"
> at /lib/firmware. I think I maybe did something wrong, but I don't
> know how can I undo all these steps and try again. I really hope you
> can give me some hint. Thank you very much in advance. Best Regards,
> Fernand Vejar

I have nothing to do with any Intel wireless drivers, but I will give you some 
advice regarding your problem.

Whenever you are reporting a problem, you must ABSOLUTELY specify the distro and 
version of your Linux. You should also specify the kernel version as shown by 
the "uname -r" command. It is also helpful if you specify the wireless hardware 
by posting the appropriate stanza from the "lspci -nn" command.

The above will verify what device you have, but the most probable driver is 
iwlwifi, which has been in the kernel for a very long time. I would be very 
surprised if any distributed kernel did not have this driver available. You can 
run the lsmod command to see if the driver is loaded. You should also check the 
log using "dmesg | less" to see if the firmware is missing.

Larry

-- 
If I was stranded on an island and the only way to get off
the island was to make a pretty UI, I’d die there.

Linus Torvalds
