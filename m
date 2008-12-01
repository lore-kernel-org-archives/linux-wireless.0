Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:55236 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYLAWKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 17:10:31 -0500
Received: by gxk11 with SMTP id 11so284830gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 14:10:29 -0800 (PST)
Message-ID: <43e72e890812011410y69c5ca89q1eb26b42a52ec600@mail.gmail.com> (sfid-20081201_231041_827929_F1B2D371)
Date: Mon, 1 Dec 2008 14:10:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: [PATCH 1/6 v2.2] mac80211: add sta_notify_ps callback
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W Linville" <linville@tuxdriver.com>,
	"Stefan Steuerwald" <salsasepp@googlemail.com>
In-Reply-To: <200812012300.52218.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200812012300.52218.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 1, 2008 at 2:00 PM, Christian Lamparter <chunkeey@web.de> wrote:
> On Monday 01 December 2008 20:17:23 Luis R. Rodriguez wrote:
>> On Sat, Nov 29, 2008 at 03:48:41PM -0800, Christian Lamparter wrote:
>> > This patch is necessary in order to provide a proper Access point support for p54.
>> > Unfortunately for us, there is no documented way to disable the interfering
>> > power save buffering mechanism in firmware completely.
>> >
>> > Therefore we give in and notify the driver through our new sta_notify_ps callback,
>> > so that we can update the filter state.
>> >
>> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
>> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
>> > ---
>> >  the extra patch for mac80211_hwsim is no longer needed...
>> > This whole series is all for wireless-testing.
>> >
>> > erm... now with a updated documentation!!1one
>> > ---
>> > > >
>> > > >     clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
>> > > > +   if (local->ops->sta_notify_ps)
>> > > > +           local->ops->sta_notify_ps(local_to_hw(local), STA_WOKE_UP,
>> > > > +                                     &sta->sta);
>> > >
>> > > With this patch, STA_WILL_SLEEP and STA_WOKE_UP are undefined. Is there a
>> > > prerequisite that I missed?
>> > > Larry
>> > no it's just fsck fallout. one file got synced in time... the other didn't.
>> > SLUB_DEBUG/SLAB_DEBUG don't work at all with p54usb.
>> > ---
>> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> > index 6a1d4ea..4b972fc 100644
>> > --- a/include/net/mac80211.h
>> > +++ b/include/net/mac80211.h
>> > @@ -779,6 +779,19 @@ enum sta_notify_cmd {
>> >  };
>> >
>> >  /**
>> > + * enum sta_notify_ps_cmd - sta power save notify command
>> > + *
>> > + * Used with the sta_notify_ps() callback in &struct ieee80211_ops to
>> > + * notify the driver if a station made a power state transition.
>> > + *
>> > + * @STA_NOTIFY_SLEEP: a station is now sleeping
>> > + * @STA_NOTIFY_AWAKE: a sleeping station woke up
>> > + */
>> > +enum sta_notify_ps_cmd {
>> > +       STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
>> > +};
>> > +
>> > +/**
>> >   * enum ieee80211_tkip_key_type - get tkip key
>> >   *
>> >   * Used by drivers which need to get a tkip key for skb. Some drivers need a
>> > @@ -1248,6 +1261,9 @@ enum ieee80211_ampdu_mlme_action {
>> >   * @sta_notify: Notifies low level driver about addition or removal
>> >   *     of associated station or AP.
>> >   *
>> > + * @sta_ps_notify: Notifies low level driver about the power state transition
>> > + *     of a associated station. Must be atomic.
>> > + *
>>
>> Can we add documentation that this is only required when the AP cannot
>> figure this out by itself? This can help people working on AP support to
>> not think they need to implement this for all drivers.
>>
> Hmm, yeah... should I edit the documentation for sta_notify as well?

Would be good if it helps.

  Luis
