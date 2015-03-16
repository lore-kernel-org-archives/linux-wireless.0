Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37922 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbbCPQHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:07:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wl18xx: show rx_frames_per_rates as an array as it really is
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426231034-20163-1-git-send-email-nicolas.iooss_linux@m4x.org>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: eliad@wizery.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-Id: <20150316160734.00F6113FC52@smtp.codeaurora.org> (sfid-20150316_170739_134859_B76EB7A5)
Date: Mon, 16 Mar 2015 16:07:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In struct wl18xx_acx_rx_rate_stat, rx_frames_per_rates field is an
> array, not a number.  This means WL18XX_DEBUGFS_FWSTATS_FILE can't be
> used to display this field in debugfs (it would display a pointer, not
> the actual data).  Use WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY instead.
> 
> This bug has been found by adding a __printf attribute to
> wl1271_format_buffer.  gcc complained about "format '%u' expects
> argument of type 'unsigned int', but argument 5 has type 'u32 *'".
> 
> Fixes: c5d94169e818 ("wl18xx: use new fw stats structures")
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
