Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34787 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2KLRza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 12:55:30 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so7001iay.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 09:55:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121112001034.GA1150@kroah.com>
References: <CAKErNvpyUxNxEMEt6gcVCr_3MTNpHaSU=5yZy2YsYmYOSCJLsw@mail.gmail.com>
 <CAKErNvq9O5d_vEQnBhD6PSy-gc37UfvhRA4nRh1r=xFSdC98Yw@mail.gmail.com> <20121112001034.GA1150@kroah.com>
From: Maxim Mikityanskiy <maxtram95@gmail.com>
Date: Mon, 12 Nov 2012 19:55:05 +0200
Message-ID: <CAKErNvq=NBksnSkTGOkh0LnGLVKYCHGVfMbCdZ+bxYAZB=dReg@mail.gmail.com> (sfid-20121112_185534_598905_D820A9B9)
Subject: Re: Need help with RTL8187SE staging driver
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/12 Greg Kroah-Hartman <greg@kroah.com>:
> On Sun, Nov 11, 2012 at 11:48:46PM +0200, Maxim Mikityanskiy wrote:
>> (I'm sorry, mailing list rejected my previous letter, I'm resending)
>>
>> Hello,
>>
>> I've decided to refactor and improve rtl8187se kernel driver from
>> staging directory, because it is buggy and lacks some features. It
>> causes full system freeze after resume from suspend, there are some
>> typos in interrupt handler that affect logic, it causes OOPS when
>> rmmoding, it has not rfkill support, it uses private ieee80211 stack
>> etc.
>>
>> I'm writing to you, because your address is mentioned in
>> drivers/staging/rtl8187se/TODO file. Also I'm CCing to linux-wireless
>> mailing list in hope that there are people that could also help me.
>>
>> You can clone git repository with modified driver source code here:
>> git@bitbucket.org:gentoo_root/
>> rtl8187se-staging.git. At first, I've removed some non-vital features
>> and dead code from original driver in order to simplify code. Then
>> I've fixed some bugs and created more clear structure of code. For
>> now, I did not fully follow Linux kernel coding style, there are lots
>> of long lines, and I hope to fix that later.
>
> Why not send patches for this so we can get your cleanups and other dead
> code removal changes into the tree to make your further changes easier?
>
> thanks,
>
> greg k-h

I'm preparing some patches now, and they will be ready soon. They will
only contain some bug fixes and unused code removal. I can't commit
all of my changes, because it will remove some features such as power
management etc. I wanted to refactor vital code at first, and then
re-add missing features, but I'm stuck with switch to mac80211.

Really, it would be better and easier to fully rewrite that driver
from scratch using mac80211, skb queues and more clear structures
similar to the ones used in rtl8180 driver. I tried this way too, but
I faced the same problem with authentication timeouts. So I can't
continue my work unless I find a solution. That's why I'm asking for
help.
