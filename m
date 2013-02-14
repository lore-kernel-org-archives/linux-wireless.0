Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:44036 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593Ab3BNMOo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 07:14:44 -0500
Message-ID: <511CD3E7.50900@neratec.com> (sfid-20130214_131449_244525_4C2A169C)
Date: Thu, 14 Feb 2013 13:09:11 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Magnus_Cederl=F6f?= <mcider@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Possible bug with probe_send_count set to 0 and then checked
 if greater than 0
References: <CAND6uNnMB0i9fvVSmqHtCMkf4XVr8dHUz+m1m3CxDCT+j2XD5Q@mail.gmail.com>
In-Reply-To: <CAND6uNnMB0i9fvVSmqHtCMkf4XVr8dHUz+m1m3CxDCT+j2XD5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 12:58 PM, Magnus Cederlöf wrote:
> In net/mac80211/mlme.c function ieee80211_sta_tx_notify:
> If a null frame was acked, ieee80211_sta_reset_conn_monitor is called.
> This function sets probe_send_count to 0.
> After the call to ieee80211_sta_reset_conn_monitor, it is checked if
> probe_set_count is > 0.
> This means that ieee80211_queue_work will not be called even though
> the nullfunc was successful.
>
> The symptom of this error is that when using power save, it will take
> 500ms to enter power save again after a successfully acked null frame.
I am looking at it now and I see that it happens without power save
as well. I have just started putting printk around so I am not so far.

Wojtek
> What case will the check for 'probe_send_count > 0' cover?
>
> Regards,
> Magnus Cederlöf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

