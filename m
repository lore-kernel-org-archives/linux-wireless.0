Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:58322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZKMWOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 17:14:51 -0500
Received: by fg-out-1718.google.com with SMTP id d23so457227fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 14:14:55 -0800 (PST)
Subject: Re: [PATCH 15/16] iwlwifi: handle unicast PS buffering
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1258142198-3223-16-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
	 <1258142198-3223-16-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Nov 2009 00:14:51 +0200
Message-ID: <1258150491.4182.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-13 at 11:56 -0800, Reinette Chatre wrote: 
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> Using the new mac80211 functionality, this makes
> iwlwifi handle unicast PS buffering correctly.
> The device works like this:
> 
>  * when a station goes to sleep, the microcode notices
>    this and marks the station as asleep
>  * when the station is marked asleep, the microcode
>    refuses to transmit to the station and rejects all
>    frames queued to it with the failure status code
>    TX_STATUS_FAIL_DEST_PS (a previous patch handled
>    this correctly)
>  * when we need to send frames to the station _although_
>    it is asleep, we need to tell the ucode how many,
>    and this is asynchronous with sending so we cannot
>    just send the frames, we need to wait for all other
>    frames to be flushed, and then update the counter
>    before sending out the poll response frames. This
>    is handled partially in the driver and partially in
>    mac80211.
> 
> In order to do all this correctly, we need to
>  * keep track of how many frames are pending for each
>    associated client station (avoid doing it for other
>    stations to avoid the atomic ops)
>  * tell mac80211 that we driver-block the PS status
>    while there are still frames pending on the queues,
>    and once they are all rejected (due to the dest sta
>    being in PS) unblock mac80211

Does this cover iwl3945?
If so, AP mode would be possible?

Best regards,
Maxim Levitsky



