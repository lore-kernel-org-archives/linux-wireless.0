Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:57658 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZFQRxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 13:53:04 -0400
Received: by gxk10 with SMTP id 10so772096gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 10:53:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cdc21430906171032gf4f4d0byd0c7e9396206d11f@mail.gmail.com>
References: <cdc21430906171031o3091a099ubf9c042bb90777d7@mail.gmail.com>
	<cdc21430906171032gf4f4d0byd0c7e9396206d11f@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 17 Jun 2009 10:52:47 -0700
Message-ID: <43e72e890906171052w23882422sa592a0da940ba4a1@mail.gmail.com>
Subject: Re: Newbie: Need help with ath9k module compilation.
	(CONFIG_MODVERSIONS)
To: Rakesh Kumar <gopchandani@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2009 at 10:32 AM, Rakesh Kumar<gopchandani@gmail.com> wrote:
> Hello All,
>
> So, I pulled kernel source from the git (correspondes to 2.6.30 and
> also other dev patches happening) and executed make in the folder
> which resulted in compilation of the whole kernel and also modules in
> the source I downloaded. I am particular interested in ath9k wireless
> drivers. My machine has  kernel version  2.6.27-14 (Ubuntu 8.10) and
> it also already contains ath9k module. What I wanted to do was to
> download latest code for ath9k and replace/temporarily load the new
> module instead of one I have currently. I rmmod ath9k and tried to:
>
> rakesh@pineapple:~/wireless-testing/drivers/net/wireless/ath/ath9k$
> sudo insmod ath9k.ko
>
> which results in:
>
> insmod: error inserting 'ath9k.ko': -1 Invalid module format
>
> and dmesg says:
>
> [82375.379869] ath9k: no symbol version for struct_module
>
> I looked up for this error: http://lkml.org/lkml/2005/6/22/1
>
> It says that I am supposed to have compiled the kernel being used and
> the module in question both with CONFIG_MODVERSIONS=Y
>
> I do know that my .config file has CONFIG_MODVERSIONS=Y and I also
> verified it by checking the CRC tags which are generated as a result
> such configuration during compilation according to this:
> http://www.skynet.ie/~mark/home/kernel/symbols.html
>
> But what I am stuck on is how to compile a kernel module with
> CONFIG_MODVERSIONS=Y, I suppose when I run make for the pulled code,
> it uses this tag inherently for modules also but I am not sure about
> that.
>
> So what am I missing her which would compile the module right to be
> plugged into a slightly older kernel version?

You can't do that, you would need a backport. We have automatic
backports available at:

http://wireless.kernel.org/en/users/Download

that's bleeding edge though, from wireless-testing, if you want 2.6.30
stuff check out:

http://wireless.kernel.org/en/users/Download/stable/

  Luis
