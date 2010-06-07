Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.184.189]:38294 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab0FGIEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 04:04:15 -0400
Received: from mx51.mymxserver.com (mail5104.internal [172.16.51.4])
	by emita2.mittwald.de (Postfix) with ESMTP id E9C2A1F9E23
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 09:55:03 +0200 (CEST)
From: Holger Schurig <holgerschurig@gmail.com>
To: Ray <raystinger@gmail.com>
Subject: Re: New developer to linux and ath5k, request for assistance :)
Date: Mon, 7 Jun 2010 09:54:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <ED64ABDC-524D-4A77-BEAB-95125A54822C@gmail.com>
In-Reply-To: <ED64ABDC-524D-4A77-BEAB-95125A54822C@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006070954.53380.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The next step I suppose is to download the ATH5k source and start to look
> into the codes. But I have several questions in mind and would appreciate if
> some of you can shed me some light and point me to the right direction.

Go and visit

http://wireless.kernel.org/

There's a large section there for "Developers".


You don't download the source of ath5k. Instead, you download the source of 
Linux, it contains the source of ath5k. The best option is to use the 
wireless-testing tree. More info about that on the above mentioned web page.


> I understand that this version is Ubuntu already comes with ATH5k installed
> by default.

For any serious linux kernel hacking you need to learn how to work without a 
Distribution supplied kernel. Basically, you want to load and run your own 
kernel on your distribution. Forget about all the Distribution supplied 
things. At least this is what I make, your mileage may vary. I personally get 
the "vanilla" or "wireless-testing" source tree via git, do a "make xconfig" 
or similar, and then a "make && make install". Now I reboot into this kernel, 
look if everything works still, and maybe do one more iteration. I keep the 
distro-supplied kernel just for reference, or in case I make something 
horribly. then I reboot into the distro-kernel via the grub menu.

Later, when you have your wireless-kernel up & running, you simply do "make && 
make modules_install", remove all old modules and reload the new modules, 
without booting into new kernels. I have made my own custom scripts for that.


I'm assuming you already know "Linux Device Drivers 3", available as paper-
book and in the web?  And also http://kernelnewbies.org?



Which parts of ath5k do you want to modify?
