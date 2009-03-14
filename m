Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:12163 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbZCNUSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 16:18:16 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1118181wfa.4
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 13:18:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090314171452.11126.11618.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171452.11126.11618.stgit@tikku>
Date: Sat, 14 Mar 2009 13:18:14 -0700
Message-ID: <43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com> (sfid-20090314_211822_897542_1D431D30)
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2009 at 10:14 AM, Kalle Valo <kalle.valo@nokia.com> wro=
te:
> Add IEEE80211_HW_BEACON_FILTERING flag so that driver inform that it =
supports
> beacon filtering. Drivers need to call the new function
> ieee80211_beacon_loss() to notify about beacon loss.
>
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>
> =C2=A0include/net/mac80211.h =C2=A0 =C2=A0 | =C2=A0 18 ++++++++++++++=
++++
> =C2=A0net/mac80211/ieee80211_i.h | =C2=A0 =C2=A02 ++
> =C2=A0net/mac80211/iface.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A03 +++
> =C2=A0net/mac80211/mlme.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 39 ++++=
++++++++++++++++++++++++++++++++++-
> =C2=A04 files changed, 61 insertions(+), 1 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 9ef131d..1262b83 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -888,6 +888,13 @@ enum ieee80211_tkip_key_type {
> =C2=A0*
> =C2=A0* @IEEE80211_HW_MFP_CAPABLE:
> =C2=A0* =C2=A0 =C2=A0 Hardware supports management frame protection (=
MFP, IEEE 802.11w).
> + *
> + * @IEEE80211_HW_BEACON_FILTER: Hardware can drop similar beacon fra=
mes to
> + * =C2=A0 =C2=A0 avoid waking up cpu. Enabling this flag disables th=
e beacon check
> + * =C2=A0 =C2=A0 in mac80211 when in power save mode and the hardwar=
e must have an
> + * =C2=A0 =C2=A0 event to notify that beacons are lost. Use ieee8021=
1_beacon_loss()
> + * =C2=A0 =C2=A0 to notify the event to the stack. The filtering mus=
t be enabled
> + * =C2=A0 =C2=A0 only when IEEE80211_CONF_PS is set.
> =C2=A0*/

Lets add to the documentation a little detail explaining how beacon fil=
tering
is expected to work, and elaborate on what we expect from the driver, i=
f
anything all.

I'd like to review this just once more.

Last we reviewed this it seemed we were set on only allowing this for
hardware which supports beacon filtering with support for checksumming
of the beacons. Reason checksumming is important is for considerations
of DFS with the channel switch announcements, HT with with channel widt=
h
changes. In fact I'm curious why checksumming would be required for 2.4=
 GHz
single band devices. Kalle, do you happen to know?

Considering that power saving features are important I think its worth
to revisit
this position in detail.

An alternative to this above position is that if the devices do not
support checksumming
of the beacons to let the driver figure when this should be enabled
dynamically. For example
if devices do not support checksumming but are single 2.4 GHz band
non-HT capable
devices we should let drivers enable this feature.

Other devices which do not support checksumming should only enable this=
 only
when associating to an AP on non-DFS channels and when not using HT.

In practice this would mean allowing both ath5k and ath9k to take advan=
tage
of this feature.

Technically we could move the conditional logic check when this should
be enabled
to mac80211 as well. When we reviewed this it was seen as unnecessary
complexity,
I actually don't see it as too complex and think the the advantage is
worth to consider.

Thoughts?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
