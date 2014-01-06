Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:46022 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaAFMhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 07:37:52 -0500
Received: by mail-bk0-f45.google.com with SMTP id mx13so5692547bkb.32
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 04:37:50 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julian Gordon <jewelsofthought@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r92su driver for realtek rtl8192su usb wireless adapter
Date: Mon, 06 Jan 2014 13:37:33 +0100
Message-ID: <1655218.I1JJMSx2BO@debian64> (sfid-20140106_133800_257462_DAF99C8D)
In-Reply-To: <CAP+W=6QCwL1hbz5fRKuBr7dCS58_fVFTQ-mFjgW5rTr6y6QO-w@mail.gmail.com>
References: <CAP+W=6QCwL1hbz5fRKuBr7dCS58_fVFTQ-mFjgW5rTr6y6QO-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, January 06, 2014 11:18:27 AM you wrote:
> I have downloaded the dirver from http://github.com/chunkeey/rtl8192su for
> the adapter.
> 
> Upon running the make, it reports an error: it cannot find
> IEEE80211_NUM_TIDS in file r92/su/sta.h:120:26.
> 
> Where can I find the correct defintion for this varaible or an alternative
> to it?
Ah, IEEE80211_NUM_TIDS is probably just the tip. There are a few more
definitions and functions missing for the driver to compile with anything
older than 3.10 [0].

Either you can update the kernel to 3.10+ (if possible to 3.12). Or, if
you want to stick with 3.2,0-58-generic, then take a look backports [1]
project. [However, this is more complicated since you'll have to integrate
r92su into backports first].

Regards,

Christian

[0] <https://github.com/chunkeey/rtl8192su/issues/1>
[1] <https://backports.wiki.kernel.org/index.php/Main_Page>


