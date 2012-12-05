Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45774 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2LEKXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 05:23:41 -0500
Message-ID: <1354702978.6234.29.camel@cumari.coelho.fi> (sfid-20121205_112344_503509_EC757028)
Subject: Re: [PATCH 02/20] wlcore: add ACX_PEER_CAP command
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 5 Dec 2012 12:22:58 +0200
In-Reply-To: <CAB3XZEc+OPP4fZjJDXL2ijg-zwDMOm96T3PFnjEim6ZnCDRAUw@mail.gmail.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-3-git-send-email-arik@wizery.com>
	 <1354700103.6234.16.camel@cumari.coelho.fi>
	 <CAB3XZEc+OPP4fZjJDXL2ijg-zwDMOm96T3PFnjEim6ZnCDRAUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 12:17 +0200, Eliad Peller wrote:
> On Wed, Dec 5, 2012 at 11:35 AM, Luciano Coelho <coelho@ti.com> wrote:
> > On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> >> From: Eliad Peller <eliad@wizery.com>
> >>
> >> ACX_PEER_CAP command is just ACX_PEER_HT_CAP, but allows
> >> configuring the peer's support rates as well.
> >>
> >> this is needed because we start the station role when
> >> the remote rates are not known yet.
> >>
> >> the two commands should be unified in future fw versions,
> >> but for now add a new set_peer_cap per-hw op, that will
> >> use ACX_PEER_CAP for 18xx, and ACX_PEER_HT_CAP for 12xx.
> >>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >
> > [...]
> >
> >> diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
> >> index 0218edd..951b88c 100644
> >> --- a/drivers/net/wireless/ti/wl12xx/main.c
> >> +++ b/drivers/net/wireless/ti/wl12xx/main.c
> >> @@ -1623,6 +1623,15 @@ static int wl12xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
> >>       return wlcore_set_key(wl, cmd, vif, sta, key_conf);
> >>  }
> >>
> >> +static int wl12xx_set_peer_cap(struct wl1271 *wl,
> >> +                            struct ieee80211_sta_ht_cap *ht_cap,
> >> +                            bool allow_ht_operation,
> >> +                            u32 rate_set, u8 hlid)
> >> +{
> >> +     return wl1271_acx_set_ht_capabilities(wl, ht_cap, allow_ht_operation,
> >> +                                           hlid);
> >> +}
> >> +
> >
> > This is quite ugly, because you're just calling wlcore back to perform
> > this op.
> >
> right. but that's how it's been done in other places as well (e.g.
> wl12xx_set_key).

Ugliness doesn't justify more ugliness. :P


> >> diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
> >> index 801d8af..a169bb5 100644
> >> --- a/drivers/net/wireless/ti/wl18xx/acx.c
> >> +++ b/drivers/net/wireless/ti/wl18xx/acx.c
> >> @@ -140,3 +140,57 @@ out:
> >>       return ret;
> >>
> >>  }
> >> +
> >> +/*
> >> + * this command is basically the same as wl1271_acx_ht_capabilities,
> >> + * with the addition of supported rates. they should be unified in
> >> + * the next fw api change
> >> + */
> >
> > Has this been already unified? What's the status or plan for this new
> > API change? I guess we're only waiting for the change in the wl12xx
> > firmware to catch up with wl18xx, right?
> >
> it hasn't been unified yet.
> i don't know what is the future plan...

Too bad... probably will never happen.


> >> diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
> >> index b57e348..0e636de 100644
> >> --- a/drivers/net/wireless/ti/wl18xx/acx.h
> >> +++ b/drivers/net/wireless/ti/wl18xx/acx.h
> >> @@ -297,11 +297,44 @@ struct wlcore_peer_ht_operation_mode {
> >>       u8 padding[2];
> >>  };
> >>
> >> +/*
> >> + * ACX_PEER_CAP
> >> + * this struct is very similar to wl1271_acx_ht_capabilities, with the
> >> + * addition of supported rates
> >> + */
> >> +struct wlcore_acx_peer_cap {
> >> +     struct acx_header header;
> >> +
> >> +     /* bitmask of capability bits supported by the peer */
> >> +     __le32 ht_capabilites;
> >> +
> >> +     /* rates supported by the remote peer */
> >> +     __le32 supported_rates;
> >> +
> >> +     /* Indicates to which link these capabilities apply. */
> >> +     u8 hlid;
> >> +
> >> +     /*
> >> +      * This the maximum A-MPDU length supported by the AP. The FW may not
> >> +      * exceed this length when sending A-MPDUs
> >> +      */
> >> +     u8 ampdu_max_length;
> >> +
> >> +     /* This is the minimal spacing required when sending A-MPDUs to the AP*/
> >> +     u8 ampdu_min_spacing;
> >> +
> >> +     u8 padding;
> >> +} __packed;
> >
> > If we're sure this will be also changed in the wl12xx firmware, maybe
> > this could already be in the wlcore acx.h? Otherwise we'll just be
> > moving this around...
> >
> unfortunately, we can't really be sure about it :/

As usual. :(


> >> diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
> >> index 71137aa..ecdd5e6 100644
> >> --- a/drivers/net/wireless/ti/wlcore/wlcore.h
> >> +++ b/drivers/net/wireless/ti/wlcore/wlcore.h
> >> @@ -106,6 +106,11 @@ struct wlcore_ops {
> >>       u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
> >>       void (*sta_rc_update)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
> >>                             struct ieee80211_sta *sta, u32 changed);
> >> +     int (*set_peer_cap)(struct wl1271 *wl,
> >> +                         struct ieee80211_sta_ht_cap *ht_cap,
> >> +                         bool allow_ht_operation,
> >> +                         u32 rate_set, u8 hlid);
> >> +
> >
> > I think it would be much nicer to do all this with a quirk instead.
> > Then we don't need to add ops that will have to be removed later and
> > make all this ping-pong of calls between the modules.
> >
> i'm not sure what do you mean by using a quirk here.
> currently, this is 18xx-specific command, so we need this op.

I meant that the new ACX could be fully implemented in wlcore (because
the expectation was that it would also become available in wl12xx in the
future) and we would have a quirk to tell wlcore not to use the new ACX
for wl12xx until it becomes available (when we would disable the quirk).

With the quirk, we could even continue supporting older wl12xx firmware
versions quite easily.

--
Luca.

