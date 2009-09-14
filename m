Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:2466 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINQuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 12:50:17 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1015682fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 09:50:18 -0700 (PDT)
Message-ID: <4AAE7446.3080407@lwfinger.net>
Date: Mon, 14 Sep 2009 11:50:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vignette consultant <vignette75@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187B wireless driver issue
References: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>	 <4AAE3DF7.7060504@lwfinger.net>	 <3b0e19890909140719y7971c9f4m5fe086a9008fd423@mail.gmail.com>	 <4AAE53C8.1060100@lwfinger.net> <3b0e19890909140905g4c6bfef3t38cd94a205d26f8@mail.gmail.com>
In-Reply-To: <3b0e19890909140905g4c6bfef3t38cd94a205d26f8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vignette consultant wrote:
>  Hi
> 
>  Attached files contain several logs of various commands. The log-1
> file is before running command and log-2 file is after running
> specific command.
> 
>  Here are commands that I give as soon as I log in. It's server edition.
> 
>  $ sudo ifconfig wlan0 up
>  $ sudo iwconfig wlan0 ESSID linksys
>  $ sudo dhclient wlan0 - results in no IP addr leased

Your wireless has not associated and has no communication, which is
why it cannot get an IP using DHCP.

A quick check with Google indicates that Ubuntu uses
/etc/network/interfaces to control the devices. Once that is correct,
you should be able to 'sudo /etc/init.d/networking restart' to start
the network. If the server is properly configured, the network should
start on boot.

BTW, the dmesg buffer is circular. All that usb monitoring output has
completely filled the buffer, and it contains no useful information.
