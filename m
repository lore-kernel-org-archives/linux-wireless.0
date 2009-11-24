Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39115 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZKXFhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 00:37:47 -0500
Received: by pwi3 with SMTP id 3so3936542pwi.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 21:37:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b0b2bfc.wTVOnoPYuzV3oG6G%Larry.Finger@lwfinger.net>
References: <4b0b2bfc.wTVOnoPYuzV3oG6G%Larry.Finger@lwfinger.net>
Date: Tue, 24 Nov 2009 08:37:53 +0300
Message-ID: <adf480660911232137x5459441chde17fb77004e3cb4@mail.gmail.com>
Subject: Re: [PATCH] b43legacy: Fix problem for PPC architecture noted in Red
	Hat Bugzilla #538523
From: Peter Lemenkov <lemenkov@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All!

2009/11/24 Larry Finger <Larry.Finger@lwfinger.net>:
> For PPC architecture with PHY Revision < 3, a read of the register
> B43_MMIO_HWENABLED_LO will cause a CPU fault unless b43legacy_status()
> returns a value of 2 (B43legacy_STAT_STARTED); however, one finds that
> the driver is unable to associate after resuming from hibernation unless
> this routine returns 1. To satisfy both conditions, the routine is rewritten
> to return TRUE whenever b43legacy_status() returns a value < 2.
>
> This patch fixes the second problem listed in the postings for Red Hat
> Bugzilla #538523.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.org>

Seems that b43 has similar issue(s):

https://bugzilla.redhat.com/show_bug.cgi?id=539267

-- 
With best regards, Peter Lemenkov.
