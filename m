Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42262 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1H0TQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 15:16:03 -0400
Received: by gxk21 with SMTP id 21so3761815gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 12:16:02 -0700 (PDT)
Message-ID: <4E59426F.1050401@lwfinger.net> (sfid-20110827_211608_345592_AE68789B)
Date: Sat, 27 Aug 2011 14:15:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Fix smatch warning
References: <1314469560-28255-1-git-send-email-Larry.Finger@lwfinger.net> <20110827205404.62de7b31@milhouse>
In-Reply-To: <20110827205404.62de7b31@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2011 01:54 PM, Michael Büsch wrote:
> On Sat, 27 Aug 2011 13:26:00 -0500
> Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
>>    CHECK   drivers/net/wireless/b43/main.c
>> drivers/net/wireless/b43/main.c +4115 b43_wireless_core_stop(7) warn: variable dereferenced before check 'dev'
>
>> This is next material.
>
> -next, just because the bug is not in the current kernel?
> Or because you think this is harmless?
>
> I'm not sure whether this is harmless. It effectively is that kind
> of bug that triggers dangerous compiler optimizations.
> I think the compiler has some freedom to assume dev can not be NULL when
> the function is entered and thus optimize out the !dev check.

No, the check has to be left in due to the changing of dev in the routine 
followed by a 'goto redo'.

According to 'git blame', the commit that added the part that swatch does not 
like was

36dbd954 (Michael Buesch 2009-09-04 22:51:29 +0200 4115)

That was when the branch back to redo was added. As your comment says

  * Returns the current dev. This might be different from the passed in dev,
  * because the core might be gone away while we unlocked the mutex. */

In fact, a bug in the original code is unlikely, but my patch did add one. I 
think the code should be

	if (!dev)
		return NULL;
	wl = dev->wl;
redo:

That should work correctly and satisfy swatch. Would that do too much damage to 
the compiler's optimization?

Larry
