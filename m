Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:14708 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbYF1LV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 07:21:56 -0400
Received: by wf-out-1314.google.com with SMTP id 27so825245wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 04:21:54 -0700 (PDT)
Message-ID: <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com> (sfid-20080628_132158_960231_8A9E56B3)
Date: Sat, 28 Jun 2008 13:21:54 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "George Fong" <george@lateralplains.com>
Subject: Re: Problem making compat-wireless-2.6
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200806281953.16371.george@lateralplains.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806281953.16371.george@lateralplains.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 11:53 AM, George Fong <george@lateralplains.com> wrote:
> Hi guys
>
> Not sure if this is a bug but I have not been able to make the compat wireless
> drivers.
>
> I am running off Fedora 9 (x86_64) with kernel 2.6.25.6-55.fc9.x86_64. I am
> interested in the iwl4965 driver.
>
> Everything goes OK until we hit the compilation of part of the b43 driver.
> This is what I get:
>
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/rfkill.c:
> In function 'b43_rfkill_soft_toggle':
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/rfkill.c:91:
> error: 'RFKILL_STATE_UNBLOCKED' undeclared (first use in this function)
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/rfkill.c:91:
> error: (Each undeclared identifier is reported only once
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/rfkill.c:91:
> error: for each function it appears in.)
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/rfkill.c:101:
> error: 'RFKILL_STATE_SOFT_BLOCKED' undeclared (first use in this function)
> make[4]: ***
> [/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/rfkill.o]
> Error 1
> make[3]: ***
> [/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43]
> Error 2
> make[2]: ***
> [/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless] Error
> 2
> make[1]: *** [_module_/home/george/Download/compat-wireless-2008-06-28] Error
> 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.25.6-55.fc9.x86_64'
> make: *** [modules] Error 2
>
> It is entirely likely that I am doing something wrong but I don't know what.
>
> Hope this is all OK to report.
>
> Cheers
> G,
>
>
> --
> George Fong
> Lateral Plains Pty Ltd
> Tel: +61 3 53 302 880
> Fax: +61 3 53 302 881
> Just remember, wherever you go .... there you are.
>

Try editing drivers/net/wireless/b43/rfkill.c, and replacing
RFKILL_STATE_UNBLOCKED with RFKILL_STATE_ON and
RFKILL_STATE_SOFT_BLOCKED with RFKILL_STATE_OFF. Looks like rfkill is
not part of the compat package, and no work has been done to match
compat-wireless to older RFKILLs.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
