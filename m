Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56420 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3EEPm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 11:42:59 -0400
Received: by mail-bk0-f45.google.com with SMTP id je9so1279466bkc.18
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 08:42:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: =?iso-8859-15?q?Rub=E9n_Porras?= <nahoo82@gmail.com>
Subject: Re: Carl9170 is working very slow (linux 3.6.9 and WN111(v2))
Date: Sun, 5 May 2013 17:42:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAJ7BrsQ2xrgC=XQU7cTLjdcL-H8AjNMBco5bUacQ14AvJJsbiQ@mail.gmail.com>
In-Reply-To: <CAJ7BrsQ2xrgC=XQU7cTLjdcL-H8AjNMBco5bUacQ14AvJJsbiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201305051742.58822.chunkeey@googlemail.com> (sfid-20130505_174303_767117_536C42C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rubén,

On Sunday, May 05, 2013 03:20:30 PM Rubén Porras wrote:
> the module carl9170 is working very slow in linux version 3.6.9 with the
> dongle WN111(v2), although I am able to transmit/receive information for a
> while using it, eventually the transmission hangs and it is not possible to
> send any data, and I must reset the connection (ifdown wlan0 and ifup
> wlan0). Several warnings follows which are available in the kernel
> messages, which probably help to track the problem. If it helps to track
> the problem I can test any patches you send me.
> 
> PD: From the post https://forum.openwrt.org/viewtopic.php?id=43243 I
> suppose that I am not the only one having the problem.
> 
> [   25.543551] ------------[ cut here ]------------
> [   25.543570] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:992
> carl9170_op_tx+0x1f0/0x72f [carl9170]()

Ah, this sounds familiar. The good news is that the interoperability
problem between minstrel_ht and carl9170 was discovered and
fixed back in February already [the mainline is not affected].

If you know how to apply patches and compile drivers, then you can
easily fix it yourself by applying the following patch:
"carl9170: fix frame drop and WARN due to minstrel_ht change"
<https://patchwork.kernel.org/patch/2174121/>

and compile the new carl9170 module.

Regards,
	Christian

BTW: I assume you are also running some version of openwrt. Is this
correct? Can you tell me which one? Since if this affects a stable
release, we should notify the OpenWRT folks, so they can take action.
