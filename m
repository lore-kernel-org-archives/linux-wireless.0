Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64093 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3LDUtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 15:49:24 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so23148919pdj.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 12:49:24 -0800 (PST)
Message-ID: <529F9550.7030604@lwfinger.net> (sfid-20131204_214928_185977_0523CB9F)
Date: Wed, 04 Dec 2013 14:49:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Nikita N." <nikitan@operamail.com>, linux-wireless@vger.kernel.org
Subject: Re: RTL8187 bugs
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com> <52966D64.2030805@lwfinger.net> <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com> <52968893.6060405@lwfinger.net> <1385812990.14905.53777877.7646278B@webmail.messagingengine.com> <529A1B52.6040605@lwfinger.net> <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com> <529A36C5.4060209@lwfinger.net> <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com> <529E0166.90302@lwfinger.net> <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com> <529E9437.7020305@lwfinger.net> <1386143567.23274.55300753.5C861343@webmail.messagingengine.com>
In-Reply-To: <1386143567.23274.55300753.5C861343@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/2013 01:52 AM, Nikita N. wrote:
> Hi Larry :) thank you very much for the comments on my patch, really
> appreciated.
>
> Anyway, lets try to stick on the issue, ok?
> The issue is the malfunction of *MONITOR* mode.
> I can't see any monitor mode call from your log, you tested only managed
> mode, isn't it?
> I repeat, managed mode works perfectly also in my interfaces, no need to
> test it.
> We need to test *MONITOR* mode.
>
> Since you say that at you, the *MONITOR* mode works ok, I need to
> reproduce your environment here, in order to test the *MONITOR* mode.
> As already asked in previous email, what OS Linux distro do you use
> exactly when you test *MONITOR* mode in your 8187 interfaces?
> What programs suite do you use exactly when you test *MONITOR* mode in
> your 8187 interfaces?

Until I fixed your patch, I could not be assured that it would work. I get 
nervous when that small a patch generates that many warhings.

I was finally able to test monitor mode this morning, and found that it is 
failing for kernel 3.13-rc2 as you said. The system set promiscous mode, but no 
off-channel data is returned. I use openSUSE 13.1 on an ancient laptop. It is 
installed without X - not enough memory. I use kismet to capture over-the-air 
data. I am currently building a v3.0 kernel to see when the failure happened. At 
least I am pretty sure that I used rtl8187 in monitor mode in the past.

The logged data for my most recent run is

[  295.841561] device wlan2 entered promiscuous mode
[  295.842068] rtl8187_configure_filter
[  295.842104] IN>changed_flags=0x3 ,total_flags=0x80000001 ,multicast=0x3 
,priv->rx_conf=0x9094fc0e
[  295.842114] >FIF_ALLMULTI
[  295.842190] OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
[  295.901636] rtl8187_configure_filter
[  295.901690] IN>changed_flags=0xf3 ,total_flags=0x800000f1 ,multicast=0x3 
,priv->rx_conf=0x9094fc0e
[  295.901702] >FIF_CONTROL
[  295.901711] >FIF_OTHER_BSS
[  295.902016] >FIF_ALLMULTI, ***** Also has FIF_PSPOLL and FIF_PROBE_REQ set
[  295.902113] OUT>total_flags=0x62 ,priv->rx_conf=0x909cfc0f
[  296.279678] device wlan2mon entered promiscuous mode
[  296.282327] rtl8187_configure_filter
[  296.282363] IN>changed_flags=0x93 ,total_flags=0x800000f1 ,multicast=0x3 
,priv->rx_conf=0x909cfc0f
[  296.282373] >FIF_ALLMULTI
[  296.282445] OUT>total_flags=0x62 ,priv->rx_conf=0x909cfc0f

Larry

