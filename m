Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34756 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3JRPkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 11:40:19 -0400
Received: by mail-ob0-f174.google.com with SMTP id wm4so3138221obc.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 08:40:18 -0700 (PDT)
Message-ID: <52615661.7050204@lwfinger.net> (sfid-20131018_174023_412496_C7E27092)
Date: Fri, 18 Oct 2013 10:40:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Martins?= <sna7e_7@hotmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RTL8723AE] Driver problems
References: <BLU0-SMTP28669C5469915F5D8D155AF89060@phx.gbl>
In-Reply-To: <BLU0-SMTP28669C5469915F5D8D155AF89060@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/2013 07:55 PM, André Martins wrote:
> Hi!
> This is a copy I've sent to Larry Finger and his bot told me to sent to this
> e-mail address instead.
> Basically I've bought a computer with the 8723ae card and unfortunately the
> wireless connection is really bad. Although I'm a last year student on MSc in
> computers and telematics engineering I don't have any skills what so ever on
> kernel's source code. Thus, I want to ask you if you could help me out and tell
> me where to begin to fix this and create a great rtl8723ae driver for Linux. I
> could help you with the tests what whatever I could. The main problem with this
> card is the connection on my university, it's always dropping and impossible to
> have a stable connection. On my house I'm a few meters way of my AP and the link
> quality is either on 38/70 or 70/70.
> Since you take the time to read this e-mail I thank you already.

André,

I am sure you understand why I do not answer requests for debugging from E-mail 
that is sent to me alone.

Does the card work at your house? You need to be as clear as possible in what 
you write.

What are the details at the University? How far are you from the AP there? What 
kind of encryption is used (WPA, WPA2, etc.)? How much interference is there on 
the channel used? Posting the output of 'sudo /usr/sbin/iw wlan0 scan' will 
answer that.

For debugging, please try the following commands:

sudo /sbin/modprobe -rv rtl8187ae
sudo /sbin/modprobe -v rtl8723ae ips=0

Does that help?

When the disconnects happen, what is the indication in the output of dmesg?

Finally, we need to check your firmware. The md5sum values for the fw on my 
system are

ce50dfe07dbb1bfe9e14bdb315a4b28a  /lib/firmware/rtlwifi/rtl8723fw_B.bin
69ccaffbe94cc0ef1b89c25290e19b2e  /lib/firmware/rtlwifi/rtl8723fw.bin

 From the dmesg output, which one is being used on your system?

Larry

