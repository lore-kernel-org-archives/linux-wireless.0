Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57239 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab1JXMiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:38:06 -0400
Received: by bkbzt19 with SMTP id zt19so8140145bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2011 05:38:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111024121559.GA4821@jm.kir.nu>
References: <20111023194059.GA18385@jm.kir.nu> <CA+XVXfdP5VjMLaYxh6Saa+SM+cDUG+h18L0ixheQmaAo+yQX+Q@mail.gmail.com>
 <20111024121559.GA4821@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 24 Oct 2011 14:37:50 +0200
Message-ID: <CA+XVXffbAHQg-9PVa3V3rnNxVqdi898JX1ex7M2ZKA1KLgV1Gw@mail.gmail.com> (sfid-20111024_143811_094103_08AC5990)
Subject: Re: [RFC] mac80211: Fix STA supported rate configuration with dummy entry
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2011 at 14:15, Jouni Malinen <j@w1.fi> wrote:
> On Mon, Oct 24, 2011 at 01:59:45PM +0200, Arik Nemtsov wrote:
>> Note that the sta-rates are not really required before second addition
>> (which also sets them). Initially the STA is not authorized for direct
>> Tx (as determined by the WLAN_STA_TDLS_PEER_AUTH bit).
>> We don't expect direct frames during link setup.
>
> OK.. Though, there can still be some direct frames like TDLS Discovery
> Response.

You have a point there - this one is not related to link setup. At
this point we really have no idea about peer supported rates (and no
STA entry).

I just tested this with hwsim and it seems to work. The rate chosen is
the the smallest non-basic rate (haven't looked at why that happens).
With cards that use HW rate control (like wl12xx), this will of course
be implementation defined.

>
>> The STA is added to let us know we should drop all non-setup packets
>> between TDLS peers currently in link setup. We could have used a
>> different indication, but the STA entry is make the most sense here
>> since it is automatically cleaned up when we are disconnected from the
>> AP (as all TDLS state should be).
>
> When you say "drop", I hope you mean "buffer for later delivery" and
> when you say "non-setup packets", I hope you mean "non-setup Data
> frames" ;-).

No I mean "drop". Initially a buffer was planned, but in reality the
setup process is extremely fast. I setup iperf between two regular
stations (about 15mb/s) and proceeded to setup TDLS. I managed to lose
only about 3-4 frames each time.
Of course there may be anomalies (bad link quality etc.), but IMHO for
real-world situations the extra complexity of a buffering mechanism is
not warranted. Also higher level protocols (like TCP) will generally
make up for any loss.

I'll change the second one to "non-setup Data frames" :)

>
>> How about this one instead (tested hwsim with it):
>> Subject: [RFC] mac80211: init rate-control for TDLS sta when supp-rates are
>>  known
>>
>> Initialize rate control algorithms only when supported rates are known
>> for a TDLS peer sta. Direct Tx between peers is not allowed before the
>> link is enabled. In turn, this only occurs after a change_station()
>> call that sets supported rates.
>
> I guess this could be fine, too, assuming TDLS is the only use case for
> this type of changing of STA supported rates.

Currently it is - we even check this explicitly higher up in
nl80211_set_station().

Arik
