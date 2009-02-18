Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:39380 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZBRUbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:31:34 -0500
Received: by fk-out-0910.google.com with SMTP id f33so72206fkf.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 12:31:32 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 22:31:30 +0200
In-Reply-To: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com> (Jason Andryuk's message of "Mon\, 16 Feb 2009 19\:43\:55 -0500")
Message-ID: <8763j7qyfx.fsf@litku.valot.fi> (sfid-20090218_213145_271771_96ECD149)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> With the latest mac80211 stack, the driver needs to be updated for
> cfg80211 scanning.  I based the changes off of modifications for
> at76_usb found here:
> http://johannes.sipsolutions.net/patches/old/all/2008-09-19-13:35/020-cfg80211-scan.patch
>
> The trick was that max_signal also needs to be set to avoid a divide
> by zero Oops.  I just guessed and used the value 100 for now.

Thank you for doing this. Unfortunately the patch was corrupted, so I
had to manually take your changes. I also included the
ieee80211_scan_compileted() fix to this patch.

> Additionally, I added some ieee80211_{wake,stop}_queues calls that
> were contained in the older at76_usb.  There is ambiguity as to
> whether at76_join should be called before or after waking the queues.

I would like to have a separate patch for this. Also I would like to
know what kind of bug this fixes.

Sorry to be so picky, but I'm going to push the driver into mainline
soon and I try avoid regressions right now.

-- 
Kalle Valo
