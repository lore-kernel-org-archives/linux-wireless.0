Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f52.google.com ([74.125.83.52]:51665 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1IVQiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 12:38:55 -0400
Received: by gwb1 with SMTP id 1so3150518gwb.11
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 09:38:55 -0700 (PDT)
Message-ID: <4E7B64A0.6060202@lwfinger.net> (sfid-20110922_183859_263084_EF1D6FE7)
Date: Thu, 22 Sep 2011 11:38:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Edwin <void@edwin.nimell.com>
CC: linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [Bug?] Machine hangs, rtl8192se possible cause
References: <CAFdoEiT54o+NQKO=dAcOXgyf6GJ1E51w_H_p7PJyRmynz8Sbzg@mail.gmail.com>	<4E36C693.6000705@lwfinger.net> <CAFdoEiRBPMx0C+YXwd4-Q=_nHpOb+r2+GspwujZrPh6S4tDwEQ@mail.gmail.com> <4E3772C5.70606@lwfinger.net> <loom.20110922T174352-81@post.gmane.org>
In-Reply-To: <loom.20110922T174352-81@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2011 11:06 AM, Edwin wrote:
>
> Did you ever find any solution to this issue? Because I got very similar
> problems with my laptop, which is the same as Fedewicz'.
>
> Although the issues started to appear after I upgraded from kernel 2.6.something
> to kernel 3.0.4-1. Before that I only had issues causing the laptop to freeze
> after resuming form suspend or hibernation, if the rtl8192se module wasn't
> unloaded before issuing pm-suspend.
>
> I might add that the freezes have just occurred when I'm on my school's network,
> using WPA2 with PEAP and MSCHAPv2. I have yet to see it freeze when connected to
> a unsecured network, but that might just be an coincidence.
>
> I don't know if I'm able to get any dumps. And I can't try to do a magic sysrq
> either, as the laptop is missing the SysRq-key...

No, I have nothing further. These freezes do not happen here and no one has 
submitted any traceback information.

Please try the following sequence:

modprobe -rv rtl8192se
modprobe -v rfl8192se ips=0

That will disable power save, which might be a cause of the problem.

Larry
