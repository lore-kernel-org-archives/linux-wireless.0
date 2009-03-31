Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:62561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZCaIKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:10:44 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2899261rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 01:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238485738.5970.64.camel@johannes.local>
References: <1238471826-3980-1-git-send-email-lrodriguez@atheros.com>
	<1238485738.5970.64.camel@johannes.local>
Date: Tue, 31 Mar 2009 01:10:27 -0700
Message-ID: <43e72e890903310110l49b8a6b8hfe42202d5da0304@mail.gmail.com> (sfid-20090331_101053_097693_94125708)
Subject: Re: [PATCH] cfg80211: send regulatory beacon hint events to userspace
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 12:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-03-30 at 23:57 -0400, Luis R. Rodriguez wrote:

>> =C2=A0 * @NL80211_CMD_AUTHENTICATE: authentication request and notif=
ication.
>> =C2=A0 * =C2=A0 This command is used both as a command (request to a=
uthenticate) and
>> @@ -254,6 +273,7 @@ enum nl80211_commands {
>> =C2=A0 =C2=A0 =C2=A0 NL80211_CMD_SCAN_ABORTED,
>>
>> =C2=A0 =C2=A0 =C2=A0 NL80211_CMD_REG_CHANGE,
>> + =C2=A0 =C2=A0 NL80211_CMD_REG_BEACON_HINT,
>>
>> =C2=A0 =C2=A0 =C2=A0 NL80211_CMD_AUTHENTICATE,
>> =C2=A0 =C2=A0 =C2=A0 NL80211_CMD_ASSOCIATE,
>
> No go for adding in the middle.

Eh, that's what I get for just rebasing and not looking at the order,
sorry yeah, not the intention.

>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -3391,6 +3391,93 @@ void nl80211_send_rx_disassoc(struct cfg80211=
_registered_device *rdev,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NL80211_CMD_DISASSOCIATE);
>> =C2=A0}
>>
>> +void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ieee80211_channel =
*channel_before,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ieee80211_channel =
*channel_after)
>> +{
>> + =C2=A0 =C2=A0 struct sk_buff *msg;
>> + =C2=A0 =C2=A0 void *hdr;
>> + =C2=A0 =C2=A0 enum ieee80211_band band;
>> + =C2=A0 =C2=A0 struct nlattr *nl_bands, *nl_band, *nl_freqs, *nl_fr=
eq;
>> + =C2=A0 =C2=A0 struct ieee80211_channel *chan;
>> + =C2=A0 =C2=A0 unsigned int i;
>> +
>> + =C2=A0 =C2=A0 msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
>> + =C2=A0 =C2=A0 if (!msg)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> +
>> + =C2=A0 =C2=A0 hdr =3D nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_REG=
_BEACON_HINT);
>> + =C2=A0 =C2=A0 if (!hdr) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nlmsg_free(msg);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0* Since we are applying the beacon hint to a w=
iphy we know its
>> + =C2=A0 =C2=A0 =C2=A0* wiphy_idx is valid
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(w=
iphy));
>> +
>> + =C2=A0 =C2=A0 band =3D channel_after->band;
>> + =C2=A0 =C2=A0 if (WARN_ON(!wiphy->bands[band]))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> +
>> + =C2=A0 =C2=A0 /* Unforunately this is needed */
>> + =C2=A0 =C2=A0 nl_bands =3D nla_nest_start(msg, NL80211_ATTR_WIPHY_=
BANDS);
>> + =C2=A0 =C2=A0 if (!nl_bands)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> + =C2=A0 =C2=A0 nl_band =3D nla_nest_start(msg, band);
>> + =C2=A0 =C2=A0 if (!nl_band)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> +
>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0* Our hack is to piggy back the channel prior =
to beacon hint
>> + =C2=A0 =C2=A0 =C2=A0* and after the beacon hint so userspace can a=
nalyze the
>> + =C2=A0 =C2=A0 =C2=A0* differences. Right now only no-ibss and pass=
ive-scan flags
>> + =C2=A0 =C2=A0 =C2=A0* can change as that's the only thing we expec=
t to learn out
>> + =C2=A0 =C2=A0 =C2=A0* of a beacon for now. By re-using these attri=
butes we can
>> + =C2=A0 =C2=A0 =C2=A0* avoid introducing new structs.
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 nl_freqs =3D nla_nest_start(msg, NL80211_BAND_ATTR_F=
REQS);
>> + =C2=A0 =C2=A0 if (!nl_freqs)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> +
>> + =C2=A0 =C2=A0 for (i =3D 0; i <=3D 1; i++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nl_freq =3D nla_nest_sta=
rt(msg, i);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!nl_freq)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto nla_put_failure;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chan =3D (i =3D=3D 0) ? =
channel_before : channel_after;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NLA_PUT_U32(msg, NL80211=
_FREQUENCY_ATTR_FREQ,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 chan->center_freq);
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (chan->flags & IEEE80=
211_CHAN_PASSIVE_SCAN)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (chan->flags & IEEE80=
211_CHAN_NO_IBSS)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nla_nest_end(msg, nl_fre=
q);
>> + =C2=A0 =C2=A0 }
>
> I don't think I like this -- it's confusing to userspace code that wa=
nts
> to use a unified message parser.

I know the feeling, more on this below.

> Do we really need that before/after thing anyway? I think if we reall=
y
> need this then we should add new attributes.

Well we can definitely add new attributes, but remember we still have
to pass the center of freq. The cleanest solution is to define an
attribute with a center-freq, if-passive-lifted, if-beaconing-enabled
flags. But that ends up adding all that for something we already have
attributes for. I chose to use what we have.

Let me know what you think.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
