Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51782 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0CBKCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 05:02:49 -0500
Received: by fxm19 with SMTP id 19so65657fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 02:02:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100302094238.GA24391@jm.kir.nu>
References: <20100302025158.9527.43764.stgit@void> <20100302094238.GA24391@jm.kir.nu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 2 Mar 2010 11:02:28 +0100
Message-ID: <69e28c911003020202t1e55cc4avd3b36c71ffbbe691@mail.gmail.com>
Subject: Re: [PATCH v2] ath5k: fix injection in monitor mode
To: Jouni Malinen <j@w1.fi>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	benoit.papillault@free.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 2, 2010 at 10:42 AM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Mar 02, 2010 at 11:51:58AM +0900, Bruno Randolf wrote:
>> injected frames have to use AR5K_PKT_TYPE_NORMAL, otherwise the hardware thinks
>> it can mess with the contents of the frame - e.g. update the TSF of an injected
>> beacon. injected frames should be sent as they are provided.
>
> Why would we never want the hardware to update fields in injected
> frames? Unless I missed something, this seems to break hostapd use cases
> where the hardware is indeed expected to update the timestamp in Probe
> Response frames and set up seq# and duration etc. as appropriate for the
> frames (the latter may be driver/mac80211 work; the timestamp needs to
> come from hardware/firmware).
>
> If we want to have an option to prevent hardware from touching the frame
> payload, that really should be an option (a radiotap and TX control
> flags, etc.), not default functionality for monitor interface. The use
> case for this seems to be some kind of testing purpose and that should
> not really break more common functionality.
>
>
>> +     /* we don't want the hardware to mess with injected frames in monitor
>> +      * mode (e.g. update TSF in beacons) */
>> +     if (info->flags & IEEE80211_TX_CTL_INJECTED)
>> +             pkt_type = AR5K_PKT_TYPE_NORMAL;
>
> This is the part I object to. IEEE80211_TX_CTL_INJECTED should not be
> used for this.
>

Umm... what should be used, then? A check for monitor mode? That's
even more wrong...

> --
> Jouni Malinen                                            PGP id EFC895FA
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
