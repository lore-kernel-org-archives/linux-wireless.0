Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33989 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782Ab1FFTff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 15:35:35 -0400
Received: by mail-ew0-f50.google.com with SMTP id 10so1556521ewy.9
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 12:35:33 -0700 (PDT)
Subject: Re: [PATCH stable] nl80211: fix check for valid SSID size in scan
 operations
From: Luciano Coelho <coelho@ti.com>
To: stable@kernel.org
Cc: gregkh@suse.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1307388656-19240-1-git-send-email-coelho@ti.com>
References: <13073811693022@kroah.org>
	 <1307388656-19240-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 22:35:30 +0300
Message-ID: <1307388930.23002.422.camel@cumari> (sfid-20110606_213538_511314_C13088DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 22:30 +0300, Luciano Coelho wrote: 
> In both trigger_scan and sched_scan operations, we were checking for
> the SSID length before assigning the value correctly.  Since the
> memory was just kzalloc'ed, the check was always failing and SSID with
> over 32 characters were allowed to go through.
> 
> This was causing a buffer overflow when copying the actual SSID to the
> proper place.
> 
> This bug has been there since 2.6.29-rc4.
> 
> Backported from commit 208c72f4fe44fe09577e7975ba0e7fa0278f3d03.
> 
> Cc: stable@kernel.org
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---

FWIW, this patch applies cleanly on all stable kernels at least as far
back as 2.6.35, probably even earlier.

-- 
Cheers,
Luca.

