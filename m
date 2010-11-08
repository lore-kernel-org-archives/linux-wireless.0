Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45860 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab0KHUk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 15:40:58 -0500
Received: by gxk23 with SMTP id 23so3717945gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 12:40:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011031743550.21873@bigbill>
References: <alpine.DEB.2.00.1011031743550.21873@bigbill>
Date: Mon, 8 Nov 2010 21:40:57 +0100
Message-ID: <AANLkTin6AiuCn6e1+sCpWaSTm3sY+hRrcr9O1-0dX+gG@mail.gmail.com>
Subject: Re: [RFC] ath9k: fix beacon race conditions
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/3 Björn Smedman <bjorn.smedman@venatech.se>
> Hi all,
>
> The beacon processing in ath9k is done in a tasklet. This tasklet may race
> against beacon allocation/deallocation in process context. The patch below
> is an attempt to point out / avoid these race conditions. My hope is that
> this will stabilize ath9k in a use-case I'm interested in where ap vif
> interfaces are added and removed quite often.
>
> This is purely an RFC, and it's probably synchronizing a bit too much. I'm
> currently testing this patch with no obvious problems so far (except for
> the part in xmit.c which I've commented out). More testing is necessary
> but so is a rewrite of the patch anyway.
>
> Any thoughts?

Anybody?

In principle at least, don't you agree it's a bad idea letting the
beacon tasklet race against the beacon allocation/deallocation?

Do you think it's a good idea to disable the tasklet, or should we add
some spin_lock_bh's instead?

Best regards,

Björn
