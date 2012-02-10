Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:32784 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2BJG5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 01:57:12 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RvkPu-0000Fb-GB
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 07:57:10 +0100
Received: from localhost ([::1]:56319 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RvkPu-0003RS-C4
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 07:57:10 +0100
Received: from [195.4.92.28] (port=51350 helo=18.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RvkNv-0002pp-EF
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 07:55:07 +0100
Received: from [2002:4fde:d74:2:5054:ff:feb8:40bd] (port=51931 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RvkNu-0006Os-Ui
	for linux-wireless@vger.kernel.org; Fri, 10 Feb 2012 07:55:07 +0100
Message-ID: <4F34BF3C.9030809@01019freenet.de> (sfid-20120210_075718_351481_6C538C0A)
Date: Fri, 10 Feb 2012 07:54:52 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Alfonso Fiore <alfonso.fiore@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com> <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com> <20120207171538.3336af0c@mj> <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com>
In-Reply-To: <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alfonso Fiore schrieb:
> On Tue, Feb 7, 2012 at 11:15 PM, Pavel Roskin <proski@gnu.org> wrote:
>>
>> On Tue, 7 Feb 2012 09:20:53 +0100
>> Alfonso Fiore <alfonso.fiore@gmail.com> wrote:
>>
>>> I also found out about ath_info
>>> http://madwifi-project.org/wiki/UserDocs/AthInfo and I rewrote my
>>> regdomain:
>>> ./ath_info -v -g 4:0 -w 0xeffd0000 regdomain 0x68
>>
>> That may be dangerous.  Not all cards work with ath_info, and some can
>> be broken by it permanently.  It's much safer to adjust
>> ath_regd_sanitize() in drivers/net/wireless/ath/regd.c.
> 
> Hi Pavel and thank you,
> 
> I tried for days and finally I realized that when I do "make install"
> still my box does not run my new code.
> The only way I managed to use 5 GHz channels was setting my regdomain
> to 0x00 with ath_info.
> 
> I really would like to know why my debian based box does not run my
> modified compat-wireless code after "make install".

I always have to issue a "depmod -a" after make install. You can check
if the new modules are used afterwards with
"modinfo modname[without .ko]" and check the given path. It should
contain "updates".
Sometimes, it is necessary for me to insert a "depmod -a" even before
make install, because of missing files, which are needed by the
installation and which are created by depmod -a.


Kind regards,
Andreas
