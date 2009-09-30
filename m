Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:14962 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZI3PBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 11:01:05 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1418328fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 08:01:09 -0700 (PDT)
Message-ID: <4AC372B6.1000806@lwfinger.net>
Date: Wed, 30 Sep 2009 10:01:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Reiner Schmidt <schmidtreiner@gmx.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: B43 Module on Compaq HP615 Laptop
References: <200909301304.33903.schmidtreiner@gmx.net>
In-Reply-To: <200909301304.33903.schmidtreiner@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reiner Schmidt wrote:
> Hello, 
> I am trying to install the newest compat-wireless package (from 30.09.2009) 
> onto this notebook. It has a Broadcom 4312 compatible  WLAN device on it .
> Its id is:14e4:4315.
> I use s debian sidux distribution with an 2.6.29-4 liquorix-kernel.
> Unfortunately I can currently use newer kernels on this notebook because it 
> wouldn't boot up. Tried several 2.6.30 and -31 kernels up too 2.6.31-1.
> 
> Compiling the package works so far but when loading the module b43 manually or 
> via /etc/modules it complains heavily about ssb-related issues.

Some distros include b44 and ssb in their initrd so that the box can
netboot. It is likely that yours is one of them. In this case, this
means that the wrong ssb is already loaded when you try to load b43.

The solution that Gabor gave you is correct; however if you rebuild
mkinitrd after building the compat modules, then it should work.

Larry

