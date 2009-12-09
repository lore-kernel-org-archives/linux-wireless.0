Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65527 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZLIIcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 03:32:55 -0500
Received: by bwz27 with SMTP id 27so5012649bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 00:33:01 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: cfg80211 connect for at76c50x-usb
References: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com>
	<87ws0x3ojk.fsf@purkki.valot.fi>
	<c4d76b3b0912081947m2ffcdb65of44f4ce10dfa00d2@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 09 Dec 2009 10:32:58 +0200
In-Reply-To: <c4d76b3b0912081947m2ffcdb65of44f4ce10dfa00d2@mail.gmail.com> (Jason Andryuk's message of "Tue\, 8 Dec 2009 22\:47\:43 -0500")
Message-ID: <87skbk35tx.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> Kalle,

Hi Jason,

> My logs do not show CMD_JOIN getting sent after executing an "iw
> connect".  dmesg shows the three direct probe attempts being sent to
> the device in at76_mac80211_tx, but a separate monitor interface does
> see them transmitted.  at76_mac80211_tx_callback has urb->status == 0;

Earlier I have noticed that transmission doesn't work at all with
CMD_SCAN. I used it only to enable monitoring.

> So I think the direct probes failure is halting mac80211 before it
> gets any further.  This corresponds to the flows in Johannes's
> mac80211 MLME diagrams.

Yes, that seems to be the case here.

> Hacking in the bssid, by initially setting priv->bssid and re-copying
> on _bss_info_changed, does have CMD_JOIN get sent.  However, it
> returns "at76_wait_completion failed: 7"  CMD_STATUS_TIME_OUT == 0x07.
>
> iw connect is hung too.
>
> It looked like priv->essid wasn't getting set, so I hacked that one in
> too.  With the essid hack, the at76_wait_completion disappears, but
> there is still no connection.

Ok, so CMD_JOIN should work properly then.

I have to admit that the firmware is weird and I have frustrutated
with multiple times. Maybe it's now preventing probe requests and only
allowing authentication and association requuests? If you can hack
mac80211 to skip or ignore probe request phase, that might tell us
more.

> However, there is still nothing seen on the monitor interface and it
> is seeing plenty of other traffic. I am trying to filter with
> wlan.addr == <Mac Address> in wireshark for what it's worth.
>
> Since I am not seeing anything with the CMD_JOIN being sent, I am
> wondering if my device has failed.

Unfortunately I'm busy with other stuff and I can't test it. But if
you can send the patches anyway, and if I find the time at some point,
I can test it with my device.

-- 
Kalle Valo
