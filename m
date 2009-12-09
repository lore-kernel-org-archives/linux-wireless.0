Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33512 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbZLIDri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 22:47:38 -0500
Received: by bwz27 with SMTP id 27so4922399bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 19:47:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ws0x3ojk.fsf@purkki.valot.fi>
References: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com>
	 <87ws0x3ojk.fsf@purkki.valot.fi>
Date: Tue, 8 Dec 2009 22:47:43 -0500
Message-ID: <c4d76b3b0912081947m2ffcdb65of44f4ce10dfa00d2@mail.gmail.com>
Subject: Re: cfg80211 connect for at76c50x-usb
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 2:36 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Jason Andryuk <jandryuk@gmail.com> writes:
>
> Hi Jason,
>
>> I am unable to connect to my AP with at76c50x-usb.  I believe the
>> cause is at76c50x-usb and mac80211 trying to send separate auth and
>> assoc packets to an AP.  Unfortunately the packets for these commands,
>> while sent over USB to the device, are not actually transmitted.  My
>> understanding is prior to joining a network, packet transmission is
>> block.  However, there is a USB command, CMD_JOIN, for connecting to
>> wireless networks.
>
> I actually think that the problem is because of missing bssid. I
> recall that when I was, a long time ago, porting at76 to mac80211
> CMD_JOIN didn't work unless I used the correct bssid. I tried to find
> a workaround, for example all zeros or all 0xffs bssid, but no luck.
> So I had to make an ugly hack that uses CMD_SCAN if the bssid is not
> set and CMD_JOIN otherwise.
>
> If you have the time, you could test my theory by hardcoding the bssid
> for CMD_JOIN. Alternatively you could try Luciano Coelho's oper_bssid
> patches from a month back.

Kalle,

My logs do not show CMD_JOIN getting sent after executing an "iw
connect".  dmesg shows the three direct probe attempts being sent to
the device in at76_mac80211_tx, but a separate monitor interface does
see them transmitted.  at76_mac80211_tx_callback has urb->status == 0;

So I think the direct probes failure is halting mac80211 before it
gets any further.  This corresponds to the flows in Johannes's
mac80211 MLME diagrams.

Hacking in the bssid, by initially setting priv->bssid and re-copying
on _bss_info_changed, does have CMD_JOIN get sent.  However, it
returns "at76_wait_completion failed: 7"  CMD_STATUS_TIME_OUT == 0x07.

iw connect is hung too.

It looked like priv->essid wasn't getting set, so I hacked that one in
too.  With the essid hack, the at76_wait_completion disappears, but
there is still no connection.  However, there is still nothing seen on
the monitor interface and it is seeing plenty of other traffic.  I am
trying to filter with wlan.addr == <Mac Address> in wireshark for what
it's worth.

Since I am not seeing anything with the CMD_JOIN being sent, I am
wondering if my device has failed.

Jason
