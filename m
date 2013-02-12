Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57432 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915Ab3BLPs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 10:48:56 -0500
Received: by mail-ob0-f176.google.com with SMTP id v19so215699obq.35
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 07:48:55 -0800 (PST)
Message-ID: <511A6465.8050307@lwfinger.net> (sfid-20130212_164903_719066_8FBB192C)
Date: Tue, 12 Feb 2013 09:48:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E1rk_V=E1rdai?= <vardai.mark@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8723e linux driver
References: <CABXVimEHA4WabDT-ycvmdcQd6VT3rmhNzy1UjR+qv=QD6W8JpQ@mail.gmail.com> <CABXVimHizEXzHqjvBTJyYZMXaqZRYLUQDxwfZ1B83bftMrgT9w@mail.gmail.com>
In-Reply-To: <CABXVimHizEXzHqjvBTJyYZMXaqZRYLUQDxwfZ1B83bftMrgT9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2013 09:13 AM, Márk Várdai wrote:
> Hi All,
>
> I got back an email-bot of Larry Finger's inbox, so that's why I'm
> writting to this list in connection with my laptop Toshiba Satellite
> C855-10M. It has wireless network card: rtl8273e (I'm not 100% sure
> whether my problem could come from the last letters, but hope the best
> not :)). So I have ubuntu 12.04 installed on this computer. I tried
> out the compat-driver and what I have found on ubuntu wiki
> http://askubuntu.com/questions/139632/wireless-card-realtek-rtl8723ae-bt-is-not-recognized
> too. Both was working but not 100%. Later I tried out the latest
> mainstream kernel from ubuntu
> (http://kernel.ubuntu.com/~kernel-ppa/mainline/) v3.8-rc7-raring/
> <http://kernel.ubuntu.com/%7Ekernel-ppa/mainline/v3.8-rc7-raring/>. To get
> it work I separately copied the firmware (at this moment only what was included
> in the
> |rtl_92ce_92se_92de_8723ae_linux_mac80211_0006.0514.2012.tar.gz file or to
> be more precise from the version 0007, but I do not find the download link
> for it.|

As my mail bot told you, I don't do private consulting of the type you wanted.

The firmware is found in the linux-firmware git repo. There is no separate 
download site for it. Ubuntu needs to update whatever package provides the 
firmware to provide the latest firmware files. You should pass that info on to them.

> With ubuntu 12.04/kernel-3.8rc7+firmware it was working except one special
> thing. I can't tell the exact reproduction step, but what is very close
> to it I would say a really cold reboot ( I mean here that switch off the
> computer and let is for some hours to really cool down, for example for a
> night.) then turn on the computer and then it can't connect to
> the wifi router. But If I switch off manually the wifi on the laptop (it can
> be managed by keyboard settings) and turn it back again that from that moment
> it is working (not all the cases,but most of the cases is working ). So my
> question would be whether does any of you have any idea what I can do
> to avoid this
> strange situation? The laptop is used by my mother so for her it is
> not an option to
> switch it off and on again. I can accept it that I write a small script to
> disable and enable again the wifi but in the past when I tried out the
> previous methods (so not kernel 3.8) unloading the module and load it
> back sometimes
> does not solve the problem. The wifi is good, because under windows 7/8 it is
> working well. Can any of you help me to solve this issue? What should
> I have to do,
> what kind of log should I send and so on.

When you are having the cold start problem, are scans working? In other words, 
does the command 'sudo /usr/sbin/iwlist scan' return any APs?

Is the wifi blocked? What is the output of '/usr/sbin/rfkill list'?

Finally, what does the log shown by the output of dmesg show? I will not need 
all of it - only the part after rtl8723ae starts.

I am not a user of Ubuntu and that distro might place iwlist and rfkill in 
different places than on my system. In addition, rfkill might not be installed. 
If not, then use the package loader to install it.

Larry




