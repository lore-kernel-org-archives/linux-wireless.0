Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:42230 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbYJKR7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 13:59:37 -0400
Received: by ug-out-1314.google.com with SMTP id k3so183716ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 10:59:35 -0700 (PDT)
Message-ID: <48F0E983.8010708@gmail.com> (sfid-20081011_195943_640693_CD6ED0C9)
Date: Sat, 11 Oct 2008 18:59:31 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] orinoco: cache downloadable firmware image in memory
 for use during resume
References: <200810111816.26370.arvidjaar@mail.ru> <200810111821.34045.arvidjaar@mail.ru>
In-Reply-To: <200810111821.34045.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> orinoco: cache downloadable firmware image in memory for use during resume
> 
> If card is using downloadable firmware (like Agere 9.x), firmware has
> to be reloaded during resume. It is not possible to use request_firmware
> for that, because tasks are still frozen, so request_firmware will
> just timeout and fail. So cache firmware image in memory for later
> reuse in ->resume method.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> ---
> 
> Unfortunately this is the only way to do it given current infrastructure.
> I think that extra memory cost (~60kb) does not warrant anything more
> sophisticated - even if this is possible. Also users not using dowloadable
> firmware won't be penalized at all.

Spectrum_cs has had firmware download for a while. It achieves the firmware reload on resume by doing schedule_work(&priv->reset_work).

Would the same work for orinoco_cs?

If not, is there a way to avoid the caching when you've got the firmware built into the kernel image?



Regards,

Dave.
