Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36703 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNURT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 16:17:19 -0400
Received: by mail-oa0-f46.google.com with SMTP id k1so2705589oag.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 13:17:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
Date: Thu, 14 Mar 2013 21:17:18 +0100
Message-ID: <CACna6rzvqo-CdrwkSH0p9=b=Qn+L78jQQSuGcGbgT865_uKvSw@mail.gmail.com> (sfid-20130314_211729_637144_644B46F6)
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, isedev@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/14 Larry Finger <Larry.Finger@lwfinger.net>:
> From: Iestyn C. Elfick <isedev@gmail.com>
>
> Intermittently, b43 will report "Out of order TX status report on DMA ring".
> When this happens, the driver must be reset before communication can resume.
> The cause of the problem is believed to be an error in the closed-source
> firmware; however, all versions of the firmware are affected.
>
> This change uses the observation that the expected status is always 2 less
> than the observed value, and supplies a fake status report to skip one
> header/data pair.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
>
> Although this is a hack, it seems to work for the OP. It should not cause any
> ill effects on any device that does not have the problem.
>
> It does need a lot more testing, particularly on systems prone to the out-of-order
> status report problem.
>
> If anyone can think of a cleaner, less intrusive solution, please let us know.

I wonder if this is hardware supporting unaligned access with
full-addressing for DMA engine. Maybe it support index-based indexes
for backward compatibility only, and it's somehow broken?

Can we test full-addressing first? I'll try to prepare a patch for
this during the weekend.

-- 
Rafał
