Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60546 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0EGQgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 12:36:03 -0400
Received: by fxm10 with SMTP id 10so930377fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 09:36:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE43C18.2030806@create-net.org>
References: <4BE43C18.2030806@create-net.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 7 May 2010 18:35:41 +0200
Message-ID: <j2v69e28c911005070935wb720d757labf3a0484aedefb8@mail.gmail.com>
Subject: Re: Packet injection with ath9k
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
Are you sure it is not your injector that is having alignment issues?
AFAIK the radiotap parser explicitly uses endianness-aware function
everywhere.

On Fri, May 7, 2010 at 6:13 PM, Roberto Riggio
<roberto.riggio@create-net.org> wrote:
> Hi,
>
> I'm writing an application to inject traffic over a wireless interface. This
> app
> is working fine on an x86 machine. However if i compile the same app for
> an arm platform, no frame are sent over the wireless interface (ath9k).
>
> I'm guessing that this is because of some alignment issues but i cannot
> track
> the piece of code that is actually parsing the frame. I've found the
> __ieee80211_parse_tx_radiotap in net/mac80211/tx.c function, but it is
> not called when i try to inject some traffic, so the frame are dropped
> before that.
>
> Any hints?
>
> Thanks
> R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
