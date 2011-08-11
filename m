Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:51331 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab1HKLxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 07:53:18 -0400
Received: by mail-bw0-f49.google.com with SMTP id 17so1117663bke.8
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 04:53:17 -0700 (PDT)
Subject: Re: [PATCH 37/40] wl12xx: don't wait for disconnection event
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-38-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-38-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 14:53:13 +0300
Message-ID: <1313063593.2407.850.camel@cumari> (sfid-20110811_135321_816510_0A8ABF8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> Sometimes the fw doesn't send the DISCONNECT_EVENT_COMPLETE_ID
> on station role stop, so don't wait for it.

Why? A bug? Or any good reason for it?


> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 9ef8621..ad926d2 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -640,18 +640,12 @@ int wl1271_cmd_role_stop_sta(struct wl1271 *wl)
>  	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
>  	if (ret < 0) {
>  		wl1271_error("failed to initiate cmd role stop");
>  		goto out_free;
>  	}
>  
> -	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
> -	if (ret < 0) {
> -		wl1271_error("cmd role stop sta event completion error");
> -		goto out_free;
> -	}
> -

Can't this cause possible race conditions in the firmware if, for
instance, we stop and start the sta role quickly?


-- 
Cheers,
Luca.

