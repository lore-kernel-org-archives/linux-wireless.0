Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f201.google.com ([209.85.221.201]:55309 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbZFQRc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 13:32:57 -0400
Received: by qyk39 with SMTP id 39so636076qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 10:33:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cdc21430906171031o3091a099ubf9c042bb90777d7@mail.gmail.com>
References: <cdc21430906171031o3091a099ubf9c042bb90777d7@mail.gmail.com>
Date: Wed, 17 Jun 2009 12:32:59 -0500
Message-ID: <cdc21430906171032gf4f4d0byd0c7e9396206d11f@mail.gmail.com>
Subject: Newbie: Need help with ath9k module compilation. (CONFIG_MODVERSIONS)
From: Rakesh Kumar <gopchandani@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

So, I pulled kernel source from the git (correspondes to 2.6.30 and
also other dev patches happening) and executed make in the folder
which resulted in compilation of the whole kernel and also modules in
the source I downloaded. I am particular interested in ath9k wireless
drivers. My machine has  kernel version  2.6.27-14 (Ubuntu 8.10) and
it also already contains ath9k module. What I wanted to do was to
download latest code for ath9k and replace/temporarily load the new
module instead of one I have currently. I rmmod ath9k and tried to:

rakesh@pineapple:~/wireless-testing/drivers/net/wireless/ath/ath9k$
sudo insmod ath9k.ko

which results in:

insmod: error inserting 'ath9k.ko': -1 Invalid module format

and dmesg says:

[82375.379869] ath9k: no symbol version for struct_module

I looked up for this error: http://lkml.org/lkml/2005/6/22/1

It says that I am supposed to have compiled the kernel being used and
the module in question both with CONFIG_MODVERSIONS=Y

I do know that my .config file has CONFIG_MODVERSIONS=Y and I also
verified it by checking the CRC tags which are generated as a result
such configuration during compilation according to this:
http://www.skynet.ie/~mark/home/kernel/symbols.html

But what I am stuck on is how to compile a kernel module with
CONFIG_MODVERSIONS=Y, I suppose when I run make for the pulled code,
it uses this tag inherently for modules also but I am not sure about
that.

So what am I missing her which would compile the module right to be
plugged into a slightly older kernel version?

--
Rakesh
