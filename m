Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58345 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3GBGmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 02:42:40 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Chang Liu <liuchang.ee@gmail.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<erez.kirshenbaum@wilocity.com>, <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: User-level question: on wil6210
Date: Tue, 2 Jul 2013 09:42:34 +0300
Message-ID: <5387010.IR5Cfn11iz@lx-vladimir> (sfid-20130702_084243_916208_2F6F9FED)
In-Reply-To: <20130701160759.GA20999@tuxdriver.com>
References: <CAGvsL42OLgD2hYKAd_uwLr+Np_SYu6yuasEK=BdU0YbZphB-jQ@mail.gmail.com> <CAGvsL40K1ON3eNttF4cAexw23PMYTx7wEs2RwKygtyVw-6cc2A@mail.gmail.com> <20130701160759.GA20999@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 01, 2013 12:07:59 PM John W. Linville wrote:
> Chang,
> 
> It looks to me like you should be using the ath9k driver.  What makes
> you think that you have a wil6210?
> 
> In any case, I've Cc'ed Vladimir and Sujith -- hopefully one of them
> can be more helpful. :-)
> 
> John

John,

Thanks for forwarding. Indeed, it is for me.

> 
> On Sat, Jun 29, 2013 at 10:41:20AM +0200, Chang Liu wrote:
> > Dear John,
> > 
> > My name is Chang, currently a student. I have a problem when I try to use
> > wil6210 as driver. Sorry to bother you with this letter here. I read the
> > notice on wireless.kernel.org and asked the same question on IRC but got no
> > reply. I subscribed the mailing list and I know you are respected in this
> > field. So I am here for help. I hope this doesn't bother you much.
> > 
> > The thing is: I have a laptop Dell 6430u, which has wil6210 inside. I
> > downloaded the driver "compat driver-3.8.3-2-snp" and later run *make
> > install* and *modprobe wil6210*. No error returned. When I check iw
> > --version, it shows iw version 3.2.
> > 
> > Now I want to check whether or not I have installed the driver correctly
> > and whether it works. I have no docking station (the access point) at hand
> > right now. First I run* lspci -nn*, which returns:
> > 
<skip>
> > 02:00.0 PCI bridge [0604]: Device [1ae9:0101] (rev 03)
> > 03:00.0 PCI bridge [0604]: Device [1ae9:0200] (rev 03)
> > 03:02.0 PCI bridge [0604]: Device [1ae9:0201] (rev 13)
> > 03:03.0 PCI bridge [0604]: Device [1ae9:0201] (rev 13)
> > 04:00.0 Network controller [0280]: Atheros Communications Inc. AR9462
> > Wireless Network Adapter [168c:0034] (rev 01)

Yes, these 5 devices above are from wil6210, so you definetely have wil6210
card on your laptop.
This card is composite device. For details, see wiki
http://wireless.kernel.org/en/users/Drivers/wil6210
On this card, there is firmware that is stored in the on-card flash memory, and
is not loaded by the driver. Unfortunately, firmware on your laptop (and all
laptops like this) flashed with device 1ae9:0301 disabled. This firmware support
only so called WBE, that is essentially PCIE over 60g, for wireless docking.
Wireless docking stations that are used with WBE are NOT access points; as far as I
know there is no 60g access points available at this moment. You can run AP on another
Linux laptop with wil6210.

In order to support wifi, appropriate firmware need to be flashed on this card,
and then you will see wi-fi device 1ae9:0301.
To flash firmware, you need to contact Wilocity (adding Erez).

> > 
> > Now comes the question:
> > 1. I saw on the website that the device 6210 should be "wil6210 device,
> > 1ae9:0301" (from linux wireless wil6210 page
> > http://wireless.kernel.org/en/users/Drivers/wil6210), which I cannot see
> > now. How should I find where the device is?
> > 
> > 2. About the driver, I have no idea how to check whether it works.
> > 
> > I use Ubuntu 12.04.2 LTS, and uname -a give information as follows:
> > Linux george-Latitude-6430U 3.5.0-23-generic #35~precise1-Ubuntu SMP Fri
> > Jan 25 17:13:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
You better use latest kernels since support for 60g band was integrated to versions
3.7 (some initial bits) to 3.10; and even some more patches are in the pipe for
inclusion in next versions.
> > 
<skip
> > 
> > 
> > I am not familiar with linux, please help me with this. My id on the IRC
> > channel #linux-wireless is george_.I have tried google but not much
> > found.  I really hope you could help me with this. Thank you in advance!
In general, 60g technology is in very early stages; wil6210 is 1-st commercially
available device. For now, I'd say it is better to have good knowledge in Linux
and wireless to experiment with this matter. You will also need to compile latest
wpa_supplicant and iw from git, released with Ubuntu 12.10 versions are not
good for 60g.
> > 
> > Best regards!
> > Chang

Thanks, Vladimir
