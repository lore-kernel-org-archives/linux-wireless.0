Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57469 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab1FBKmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 06:42:38 -0400
Received: by iyb14 with SMTP id 14so538142iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 03:42:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE74AAF.2060800@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-35-git-send-email-rvossen@broadcom.com> <BANLkTimGZiOaSmAJ7xeH+=0LK2+Rqit3zw@mail.gmail.com>
 <4DE74AAF.2060800@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 20:42:17 +1000
Message-ID: <BANLkTikrUwACOpnP3z6kQjE1Q-DAqMHcwg@mail.gmail.com> (sfid-20110602_124241_930674_5963AB95)
Subject: Re: [PATCH 35/83] staging: brcm80211: moved header files to more
 specific directory
To: Arend van Spriel <arend@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 2, 2011 at 18:32, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/02/2011 02:08 AM, Julian Calaby wrote:
>>
>> On Wed, Jun 1, 2011 at 21:45, Roland Vossen<rvossen@broadcom.com>  wrote:
>>>
>>> Code cleanup. Header files only used by the softmac were moved to the
>>> brcmsmac dir, same approach for fullmac header files.
>>>
>>> Signed-off-by: Roland Vossen<rvossen@broadcom.com>
>>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
>>
>> Again, should there be some code changes associated with the header
>> file move or am I missing something?
>
> Hi Julian,
>
> This change (and 38/83) move the include file from brcm80211/include to
> brcmfmac or brcmsmac depending which driver is actually using it. So these
> include files can still be found by the preprocessor and no other changes
> are needed to make it compile. The remaining issue would be a style issue
> replacing brackets by quotes. Roland is currently going over all c sources
> to cleanup file inclusion and the style issue is part of that cleanup. Not
> sure if this is kind of code change you were expecting. If not please give
> some more hints ;-)

I was expecting the header files to be included using a directive like:

#include "includes/bcmotp.h"

Not

#include <bcmotp.h>

as you've done it. I was unaware that you were using the c-flags
setting in the Makefile to make that work.

Under my assumption, I was expecting to see a number of changes like:

-#include "includes/bcmotp.h"
+#include "brcmsmac/bcmotp.h"

But now that I have seen the actual code in one of the later patches,
I understand what you're doing here.

Sorry for the noise.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
