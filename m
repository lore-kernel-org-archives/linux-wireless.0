Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:12214 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZHCVea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 17:34:30 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1092455fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 14:34:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908032316.30237.mb@bu3sch.de>
References: <4A7610AE.5000908@gmail.com> <69e28c910908031341n439384b4ned41f2983ab1de29@mail.gmail.com>
	<4A774F76.6020207@lwfinger.net> <200908032316.30237.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 3 Aug 2009 23:34:09 +0200
Message-ID: <69e28c910908031434q53fd7d6jb346f49927a634a7@mail.gmail.com>
Subject: Re: [PATCH RESEND] b43: implement baseband init for LP-PHY <= rev1
To: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 3, 2009 at 11:16 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Monday 03 August 2009 22:58:30 Larry Finger wrote:
>> Gábor states it the way the Broadcom routine is written. They have the
>> flags divided into 3 16-bit values - high, middle, and low. The values
>> are kept in arrays - one set is for the current band and the other is
>> for both bands. When the routine is entered, the appropriate quantity
>> is saved in a temporary, then the array value is maskset. Only when
>> the resulting value changes is the shared memory location updated. The
>> implication is that shared memory writes are expensive. Is that true?
>
> No. I think it has other reasons.
>
> --
> Greetings, Michael.
>

In that case, is the code correct:

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
