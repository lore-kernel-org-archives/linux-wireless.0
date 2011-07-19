Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56828 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab1GSDSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 23:18:25 -0400
Message-ID: <20110718231824.xl0vv9csjs4oowwc-cebfxv@webmail.spamcop.net> (sfid-20110719_051854_167374_3A6CD968)
Date: Mon, 18 Jul 2011 23:18:24 -0400
From: Pavel Roskin <proski@gnu.org>
To: JJLee <jjleecareer@gmail.com>
Cc: wy408 <wy52119514@163.com>, linux-wireless@vger.kernel.org
Subject: Re: compat-wireless cross compile
References: <loom.20110716T174804-267@post.gmane.org>
	<4E24589B.5030303@gnu.org>
	<CABmiYRZ9vdHyTrxt8ZRxrseHn+M0Z_7O+s7fWXXNwwSE9o7VGQ@mail.gmail.com>
In-Reply-To: <CABmiYRZ9vdHyTrxt8ZRxrseHn+M0Z_7O+s7fWXXNwwSE9o7VGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting JJLee <jjleecareer@gmail.com>:

> maybe your corss compile gcc not support elseif keywords

Please don't top-post.  Top-posting kills an intelligent discussion.

>>> config.mk:26:*****missing "endif"........

If you actually read the text you quoted you would have realized that  
the message comes from the make program that fails to interpret  
config.mk.  The compiler is not involved at this stage.

There is no "elseif" or even "elsif" anywhere in  
compat-wireless-2.6.39, and if GNU make failed to understand a  
keyword, it would have reported it differently:

$ cat makefile
ifeq (0,0)
elseif
$ make
makefile:2: *** missing separator.  Stop.

BSD make would stop of the first like of the compat-wireless Makefile  
without even getting to config.mk:

$ bmake
bmake: "/home/proski/src/compat-wireless-2.6.39-1-sn/Makefile" line 1:  
Need an operator

-- 
Regards,
Pavel Roskin
