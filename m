Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:51732 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933461AbaDJHA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:00:59 -0400
Message-ID: <1397113251.4418.78.camel@dubbel> (sfid-20140410_090104_900730_515EDE5B)
From: Luca Coelho <luca@coelho.fi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com,
	yegorslists@googlemail.com
Date: Thu, 10 Apr 2014 10:00:51 +0300
In-Reply-To: <1397112633-24486-1-git-send-email-luca@coelho.fi>
References: <1397112633-24486-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] wlcore: ignore dummy packet events in PLT mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 09:50 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luca@coelho.fi>
> 
> Sometimes the firmware sends a dummy packet event while we are in PLT
> mode.  This doesn't make sense, it's a firmware bug.  Fix this by
> ignoring dummy packet events when we're PLT mode.
> 
> Reported-by: Yegor Yefremov <yegorslists@googlemail.com>
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Luciano Coelho <luca@coelho.fi>
> ---
>  drivers/net/wireless/ti/wlcore/event.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
> index 1f9a360..8d5174c 100644
> --- a/drivers/net/wireless/ti/wlcore/event.c
> +++ b/drivers/net/wireless/ti/wlcore/event.c
> @@ -158,6 +158,11 @@ EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
>  
>  void wlcore_event_dummy_packet(struct wl1271 *wl)
>  {
> +	if (wl->plt) {
> +		wl1271_info(DEBUG_EVENT, "Got DUMMY_PACKET event in PLT mode.  FW bug, ignoring.");

Gack! I changed wl1271_debug to wl1271_info and forgot to compile.  This
doesn't compile.  v2 coming in a sec.

--
Luca.

