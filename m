Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dm-mail03.mozilla.org ([63.245.208.213]:49431 "EHLO
	dm-mail03.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2BCW5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 17:57:32 -0500
Message-ID: <4F2C61A0.7070802@mozilla.com> (sfid-20120203_235735_413313_F1CF37D0)
Date: Fri, 03 Feb 2012 14:37:20 -0800
From: John Schoenick <jschoenick@mozilla.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Scott Sanbar <scott.sanbar@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: BCM4331 fails to associate after suspend
References: <20120203222818.GA3749@ubuntu-mba>
In-Reply-To: <20120203222818.GA3749@ubuntu-mba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2012 02:28 PM, Seth Forshee wrote:
> I've been looking into some association problems seen with a MacBook Pro
> 8,2 that has BCM4331 wireless, which I've confirmed still exist in
> wireless-testing. The association failures reliably start appearing
> after the machine is resumed from s3 without external power applied
> (whether or not power is applied when the machine is suspended doesn't
> matter).
>
> When the association failures are happening the BCM4331 seems to be able
> to receive packets okay, as it can scan successfully. Transmissions
> don't work though; no frames from the BCM4331 are ever seen on the air,
> as though the tx path is off. Reloading both the b43 and bcma drivers
> gets things working again, but reloading just b43 does not.
>
> I've been looking around a bit in the b43 and bcma drivers, but so far I
> haven't found the reason why this happens. Any help would be
> appreciated. Let me know if there's additional information I can
> provide.
>
> Thanks,
> Seth
>
> _______________________________________________
> b43-dev mailing list
> b43-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/b43-dev

I can add that reloading the modules after a suspend/resumes restores 
functionality, though oddly adding them to SUSPEND_MODULES in pm-utils 
config does not.
