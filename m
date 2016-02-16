Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33307 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbcBPQCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 11:02:45 -0500
Received: by mail-ob0-f180.google.com with SMTP id jq7so80742918obb.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 08:02:44 -0800 (PST)
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
To: Souptick Joarder <jrdr.linux@gmail.com>
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
 <CAFqt6zbRK610rbWEUvsw=Ci5hXVJ6YQL3io_Rh5hF38maRWdvQ@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56C3480B.3020807@lwfinger.net> (sfid-20160216_170248_483106_743EBA1A)
Date: Tue, 16 Feb 2016 10:02:19 -0600
MIME-Version: 1.0
In-Reply-To: <CAFqt6zbRK610rbWEUvsw=Ci5hXVJ6YQL3io_Rh5hF38maRWdvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2016 12:17 AM, Souptick Joarder wrote:
> On Tue, Feb 16, 2016 at 3:42 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
--snip--

>>          else if (addr == 0xf9)
>> -               udelay(1);
>> +               usleep_range(1, 2);
>
>           why udelay is replaced by usleep_range?

I'm not sure of your level of sophistication, but here goes.

All delay statements cause a processor to stay in control and make the system 
wait for that amount of time. A sleep statement allows a context switch, and the 
processor is able to run some other job. For that reason, sleeps are always 
preferred over delays as long as the code is not running in atomic context.

There used to be a usleep() function, but as the system cannot promise to return 
from sleep after a specific delay, it was replaced with usleep_range().

It is true that the difference between delaying and sleeping for 1 usec would 
not be too destructive to the system, but I decided to convert every branch of 
that if structure to sleep statements.

Larry

