Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53494 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2AFOVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 09:21:45 -0500
Received: by iaeh11 with SMTP id h11so2682985iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2012 06:21:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201061256190.16279@axis700.grange>
References: <Pine.LNX.4.64.1201061256190.16279@axis700.grange>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 7 Jan 2012 01:21:24 +1100
Message-ID: <CAGRGNgUj3EUPKc0SX+3yCbygdbhS7_CN4hgR7ZAzjXuULw9fLg@mail.gmail.com> (sfid-20120106_152149_001300_5EBB00CC)
Subject: Re: [PATCH] wireless: b43: fix Oops on card eject during transfer
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Guennadi,

On Fri, Jan 6, 2012 at 22:58, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> An Oops has once been observed, when the SDIO card had been ejected during
> IO. The PC value shows, that the dev pointer in b43_op_stop() was NULL.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Might also be good for stable
>
>  drivers/net/wireless/b43/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 5634d9a..3849c25 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4834,6 +4834,9 @@ static void b43_op_stop(struct ieee80211_hw *hw)
>        cancel_work_sync(&(wl->beacon_update_trigger));
>
>        mutex_lock(&wl->mutex);
> +       if (!dev)
> +               goto out_unlock;

Is there any reason to take this mutex, then jump to a label that
releases it immediately?

Would it be better to add a new label after the mutex_unlock() below
and jump to there immediately after the cancel_work_sync() call above?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
