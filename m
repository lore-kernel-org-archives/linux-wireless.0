Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:54065 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932252AbaLBQUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 11:20:07 -0500
Message-ID: <1417537201.3365.3.camel@perches.com> (sfid-20141202_172012_772472_3FE3DA59)
Subject: Re: [PATCH v2 02/10] wil6210: introduce wil_err_ratelimited()
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Tue, 02 Dec 2014 08:20:01 -0800
In-Reply-To: <1745741.h3nTIlTg0C@lx-wigig-72>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1417513598-18304-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1417532867.3365.1.camel@perches.com> <1745741.h3nTIlTg0C@lx-wigig-72>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-02 at 18:07 +0200, Vladimir Kondratiev wrote:
> On Tuesday, December 02, 2014 07:07:47 AM Joe Perches wrote:
> > net_<foo>_ratelimited uses the same form.
> > 
> > include/linux/net.h:#define net_ratelimited_function(function, ...)             
> > include/linux/net.h-do {                                                        
> > include/linux/net.h-    if (net_ratelimit())                                    
> > include/linux/net.h-            function(__VA_ARGS__);                          
> > include/linux/net.h-} while (0)
> > 
> Yes, I see. There are representatives of both "schools". As counter example,
> netdev_<foo> uses "long" way:

These used to be macros.
They were converted to reduce overall code "size".

commit 256df2f3879efdb2e9808bdb1b54b16fbb11fa38
Date:   Sun Jun 27 01:02:35 2010 +0000

    netdevice.h net/core/dev.c: Convert netdev_<level> logging macros to functions
    
    Reduces an x86 defconfig text and data ~2k.
    text is smaller, data is larger.
    
    $ size vmlinux*
       text        data     bss     dec     hex filename
    7198862      720112 1366288 9285262  8dae8e vmlinux
    7205273      716016 1366288 9287577  8db799 vmlinux.device_h
    
    Uses %pV and struct va_format
    Format arguments are verified before printk

> I agree it is bad practice to have non-trivial arguments in printk-like functions,

true.

It limits the ability to make side-effect
free smaller code when printk is a no-op.

> but it is hard to detect, specifically if one just automatically replace function with its
> "ratelimited" version.

Also true.

It is and remains just a suggestion.

Your code, your choices...



