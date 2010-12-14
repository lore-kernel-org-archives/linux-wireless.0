Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:34868 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab0LNBUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 20:20:40 -0500
Received: by iwn42 with SMTP id 42so46527iwn.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 17:20:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101214100417.8BB0.2E210E2F@nifty.com>
References: <20101213144718.8BA8.2E210E2F@nifty.com> <20101213180853.GF637@tux>
 <20101214100417.8BB0.2E210E2F@nifty.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 13 Dec 2010 17:20:18 -0800
Message-ID: <AANLkTi=JvgeGZM3b4M-Nt7h72GUPvfZK3BchcjrdWkns@mail.gmail.com>
Subject: Re: [ath9k-devel] Build Error Report
To: Masahiro Inoue <miyabi.-.inoue@nifty.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 5:04 PM, Masahiro Inoue
<miyabi.-.inoue@nifty.com> wrote:
> Mr. Luis
>
> Thank you for the reply.
>
>> Like you just need PCI_EXP_LNKCTL_ES defined added via 322162a7 on
>> v2.6.29-rc1~181^2~19.  Can you try this simple patch?
>>
>> --- include/linux/compat-2.6.29.h.orig        2010-12-13 10:08:19.697355996 -0800
>> +++ include/linux/compat-2.6.29.h     2010-12-13 10:07:58.307355996 -0800
>> @@ -17,6 +17,8 @@
>>  #include <linux/skbuff.h>
>>  #include <linux/usb.h>
>>
>> +#define  PCI_EXP_LNKCTL_ES     0x0080  /* Extended Synch */
>> +
>>  /*
>>   * Older kernels do not have struct net_device_ops but what we can
>>   * do is just define the data structure and use a caller to let us
>
> It applied immediately and it tried.
> It completed it without trouble. Thank you.

Alright, thanks I'll include this in the next compat-wireless tarballs.

  Luis
