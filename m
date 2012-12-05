Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57086 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2LEKds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 05:33:48 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so3816645iay.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 02:33:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354702978.6234.29.camel@cumari.coelho.fi>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	<1354095769-8724-3-git-send-email-arik@wizery.com>
	<1354700103.6234.16.camel@cumari.coelho.fi>
	<CAB3XZEc+OPP4fZjJDXL2ijg-zwDMOm96T3PFnjEim6ZnCDRAUw@mail.gmail.com>
	<1354702978.6234.29.camel@cumari.coelho.fi>
Date: Wed, 5 Dec 2012 12:33:48 +0200
Message-ID: <CAB3XZEfAwphUbptBWTku+pBZMmEgUh8BaBncfPbZ=DHSFRe2KA@mail.gmail.com> (sfid-20121205_113352_121391_1D50A8CC)
Subject: Re: [PATCH 02/20] wlcore: add ACX_PEER_CAP command
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 5, 2012 at 12:22 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-12-05 at 12:17 +0200, Eliad Peller wrote:
>> On Wed, Dec 5, 2012 at 11:35 AM, Luciano Coelho <coelho@ti.com> wrote:
>> > On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
>> >> From: Eliad Peller <eliad@wizery.com>
>> >>
>> >> ACX_PEER_CAP command is just ACX_PEER_HT_CAP, but allows
>> >> configuring the peer's support rates as well.
>> >>
>> >> this is needed because we start the station role when
>> >> the remote rates are not known yet.
>> >>
>> >> the two commands should be unified in future fw versions,
>> >> but for now add a new set_peer_cap per-hw op, that will
>> >> use ACX_PEER_CAP for 18xx, and ACX_PEER_HT_CAP for 12xx.
>> >>
>> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> >> ---
>> >
>> > [...]
>> >
>> >> diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
>> >> index 71137aa..ecdd5e6 100644
>> >> --- a/drivers/net/wireless/ti/wlcore/wlcore.h
>> >> +++ b/drivers/net/wireless/ti/wlcore/wlcore.h
>> >> @@ -106,6 +106,11 @@ struct wlcore_ops {
>> >>       u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
>> >>       void (*sta_rc_update)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>> >>                             struct ieee80211_sta *sta, u32 changed);
>> >> +     int (*set_peer_cap)(struct wl1271 *wl,
>> >> +                         struct ieee80211_sta_ht_cap *ht_cap,
>> >> +                         bool allow_ht_operation,
>> >> +                         u32 rate_set, u8 hlid);
>> >> +
>> >
>> > I think it would be much nicer to do all this with a quirk instead.
>> > Then we don't need to add ops that will have to be removed later and
>> > make all this ping-pong of calls between the modules.
>> >
>> i'm not sure what do you mean by using a quirk here.
>> currently, this is 18xx-specific command, so we need this op.
>
> I meant that the new ACX could be fully implemented in wlcore (because
> the expectation was that it would also become available in wl12xx in the
> future) and we would have a quirk to tell wlcore not to use the new ACX
> for wl12xx until it becomes available (when we would disable the quirk).
>
well, i don't think it fits our current abstraction.
e.g. ACX_PEER_CAP is defined only in 18xx, so it means we'll have to
separate the 18xx-specific commands into 2 enums.

i agree this is all pretty ugly, but these are the fw interfaces that
we were given...

> With the quirk, we could even continue supporting older wl12xx firmware
> versions quite easily.
we already support it quite easily...

i suggest keeping it that way for now, and if this command will be
implemented in 12xx as well, we can easily remove this op, as you
suggested.

Eliad.
