Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3AHRlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 12:41:15 -0500
Date: Tue, 8 Jan 2013 11:41:11 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
Message-ID: <20130108174111.GB20290@thinkpad-t410> (sfid-20130108_184118_626330_5198444F)
References: <1357654597-8493-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357654597-8493-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 08, 2013 at 04:16:37PM +0200, Victor Goldenshtein wrote:
> Block frame processing during scan might delay the
> ADDBA response, which eventually timeouts and
> significantly reduces the device throughput.
> Remove this constrain as it's not required for the
> HW scan.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  net/mac80211/iface.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 06fac29..a26ee36 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1063,7 +1063,7 @@ static void ieee80211_iface_work(struct work_struct *work)
>  	if (!ieee80211_sdata_running(sdata))
>  		return;
>  
> -	if (local->scanning)
> +	if (local->scanning && !local->ops->hw_scan)

Wouldn't checking for SCAN_HW_SCANNING be better?

Seth
