Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57525 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbZKFVpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 16:45:53 -0500
Received: by bwz27 with SMTP id 27so1658326bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 13:45:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: James Grossmann <cctsurf@gmail.com>
Subject: Re: Prism54/p54pci
Date: Fri, 6 Nov 2009 22:45:51 +0100
Cc: linux-wireless@vger.kernel.org
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com> <200911062133.38842.chunkeey@googlemail.com> <167ae39b0911061252x790d69fei9e798e8c6080f175@mail.gmail.com>
In-Reply-To: <167ae39b0911061252x790d69fei9e798e8c6080f175@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911062245.51445.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 21:52:42 James Grossmann wrote:
> my caps lock & scroll lock leds are not blinking, and yet the computer
> is frozen.  (I'm not the best at terminology, I guess that might not
> be defined as a hard lock.)  I get no odd messages in my syslog.  I am
> using Ubuntu right now, so I'm guessing that they have all the
> prettyness going that they can, covering the important messages, but
> as it's not an actual oops, I'm not certain that's hurting us.

Ubuntu's kernel team provide some helpful texts about getting more
informations out of the crashes: (a bit of a hassle)
https://wiki.ubuntu.com/KernelTeam/CrashdumpRecipe
https://help.ubuntu.com/community/DebuggingSystemCrash

but maybe you can save you some time:
1. if possible update your compat-wireless
   a crash bug (affects compat-wireless, wireless-testing and even -rcX series)
   has been fixed. This bug is known to strike on configurations with a
   high number of auth/assoc/deauth - cycles.

	http://thread.gmane.org/gmane.linux.kernel/908831/focus=41872

2. Quintin Pitts had/has problems with the reliability of his
   p54pci <-> pci-bus and wrote a patch:
       http://patchwork.kernel.org/patch/53004/raw/

    unfortunately for him, his pci-bridge is known to be faulty,
    but maybe he found some real bugs after all.

3. replace firmware:
	http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.13.1.0.arm
	http://daemonizer.de/prism54/prism54-fw/fw-softmac/lmac_2.7.0.0.arm

> I am using network-manager, so it does reconnect, however, I find that
> to be less than optimal.
yeah, normally you can see such phenomena when you have a funky AP and 
enable wifi powersaving... but this is unlikely, as the ps is disabled
(can be enabled with iwconfig wlanX power on) for this reason.

can you please tell me more about your AP?
e.g: Product Name, Vendor, firmware revision,
is it 802.11 a/b/g/n, is WEP/WPA(2) enabled, or is it just an open ap?
