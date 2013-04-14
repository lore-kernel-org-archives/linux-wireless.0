Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60185 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3DNOPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 10:15:07 -0400
Received: by mail-qc0-f174.google.com with SMTP id z24so1236020qcq.33
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 07:15:05 -0700 (PDT)
Message-ID: <516AB9E7.1010701@lwfinger.net> (sfid-20130414_161513_491147_72AB9BB6)
Date: Sun, 14 Apr 2013 09:15:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Davide Marchi <danjde@msw.it>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: realtek usb wifi based on "rtl8192cu"
References: <516539DC.8060004@msw.it> <51657D84.2080308@lwfinger.net> <5166E8CB.3040802@msw.it> <516A86DF.6020605@msw.it>
In-Reply-To: <516A86DF.6020605@msw.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/14/2013 05:37 AM, Davide Marchi wrote:
> On 04/10/2013  04:56 PM,Larry Finger wrote:
>> If 3.8.6 does not fix it, then try the kernel from the wireless-testing git tree.
> ok, i've tryed the wireless-testing git tree kernel (3.9.0-rc6 #1 SMP x86_64
> GNU/Linux), and doesn't work.
> Infinitely it ask me the wep/wpa key..
>
> any other suggestion? Module loading options?

That particular module has very few options - only "swenc=1" to force software 
encryption, and "debug=X" to set the debug level. I doubt that either would help.

What are the details of your connection? You have never told what encryption you 
are trying to use. I have no details of your AP make/model, and what firmware 
you are using in it. Are you using NetworkManager, or some other means to 
control the connection? If NM, what does the NM log show?

Does Fedora allow you to set the debug level in wpa-supplicant? If so, set it to 
-ddd and post that log.

The final thing would be to capture the over-the-air traffic with wireshark or 
kismet. The best results would be to use a third computer to capture the 
encryption handshaking.

Larry

