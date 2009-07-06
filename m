Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34784 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZGFOSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 10:18:09 -0400
Received: by fxm18 with SMTP id 18so4154480fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 07:18:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907061600.14196.chunkeey@web.de>
References: <200907040053.05654.chunkeey@web.de>
	 <73aaf0dd0907060611w5a288828h4c4728f52fe4e16c@mail.gmail.com>
	 <200907061600.14196.chunkeey@web.de>
Date: Mon, 6 Jul 2009 18:18:06 +0400
Message-ID: <73aaf0dd0907060718n133cd4d1xbe3f92db9d945eb8@mail.gmail.com>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Anyway skb that carry data frame will be handed to the mac
>> and replaced with new one. That is, this patch does not eliminate
>> possibility of control frame loss due to insufficient memory.
> control frames loss?
> can you please point me exactly where?
> Since this is a bug that needs to be fixed.
>
> as control frames' skb should be (and hopefully are) always reused.
> (see @ txrx.c line 590 - p54_rx_control -> return skb; )
>
>> Maybe we'd better have separate reusable skb for control frames which
>> is never handed out from the driver?
> well as a matter of fact this is already true for p54pci & p54usb
> (based on the assumption we are really recycling all control frames...
>  and not somehow forgot a case and got a leak there?!)

Sorry, now I see, it's ok. Missed these lines in p54_rx_data:

+       tmp = dev_alloc_skb(priv->rx_mtu);
+       if (!tmp)
+               return skb;


-- 
Max
