Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:39216 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3I1JqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Sep 2013 05:46:23 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1317959bkb.41
        for <linux-wireless@vger.kernel.org>; Sat, 28 Sep 2013 02:46:22 -0700 (PDT)
Message-ID: <5246A56C.6030909@gmail.com> (sfid-20130928_114627_468784_AF6E83C6)
Date: Sat, 28 Sep 2013 11:46:20 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Paul Stewart <pstew@chromium.org>
CC: Bing Zhao <bzhao@marvell.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sven Neumann <s.neumann@raumfeld.com>,
	Andreas Fenkart <afenkart@gmail.com>,
	Dylan Reid <dgreid@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH 3.12] mwifiex: fix SDIO interrupt lost issue
References: <1380304538-2816-1-git-send-email-bzhao@marvell.com> <5245D495.3010505@gmail.com> <CAMcMvsjFurVFS2f1zCPt0uqh2gCYAvHOvos-pY=k06=ynDH=aQ@mail.gmail.com>
In-Reply-To: <CAMcMvsjFurVFS2f1zCPt0uqh2gCYAvHOvos-pY=k06=ynDH=aQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27.09.2013 23:11, Paul Stewart wrote:
> On Fri, Sep 27, 2013 at 11:55 AM, Daniel Mack <zonque@gmail.com
> <mailto:zonque@gmail.com>> wrote:
> 
>     On 27.09.2013 19 <tel:27.09.2013%2019>:55, Bing Zhao wrote:
>     > From: Amitkumar Karwar <akarwar@marvell.com
>     <mailto:akarwar@marvell.com>>
>     >
>     > 601216e "mwifiex: process RX packets in SDIO IRQ thread directly"
>     > introduced a command timeout issue which can be reproduced easily on
>     > an AM33xx platform using a test application written by Daniel Mack:
>     >
>     > https://gist.github.com/zonque/6579314
> 
>     Actually, just out of pure curiosity, I would be interested whether the
>     issue is also as easily reproducible on other platform like Chromebooks.
>     Could anyone give that a try maybe?
> 
> I would hesitate to say "easily".   Even on a kernel before your change,
> running your test application

That might be a dumb remark, but you noticed that the interface name in
the code doesn't actually match the name of the interface mwifiex
creates by default? We changed that to "wlan0" in our system to bring it
in line with other platforms.

I changed the test tool in the gist so it requires you to pass the name
as first argument.


Daniel

