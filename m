Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:46895 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbZDARAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 13:00:33 -0400
Received: by wf-out-1314.google.com with SMTP id 29so135461wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2009 10:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238574545.5970.137.camel@johannes.local>
References: <1238549294-29168-1-git-send-email-lrodriguez@atheros.com>
	<1238574545.5970.137.camel@johannes.local>
Date: Wed, 1 Apr 2009 10:00:16 -0700
Message-ID: <43e72e890904011000j3d7fb694j28921a3245dd7ed7@mail.gmail.com> (sfid-20090401_190037_370090_B00297A1)
Subject: Re: [PATCH v2] cfg80211: send regulatory beacon hint events to
	userspace
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 1, 2009 at 1:29 AM, Johannes Berg <johannes@sipsolutions.ne=
t> wrote:
> On Tue, 2009-03-31 at 21:28 -0400, Luis R. Rodriguez wrote:
>
>> + * @NL80211_CMD_REG_BEACON_HINT: indicates to userspace that an AP =
beacon
>> + * =C2=A0 has been found while world roaming thus enabling active s=
can or
>> + * =C2=A0 any mode of operation that initiates TX (beacons) on a ch=
annel
>> + * =C2=A0 where we would not have been able to do either before. As=
 an example
>> + * =C2=A0 if you are world roaming (regulatory domain set to world =
or if your
>> + * =C2=A0 driver is using a custom world roaming regulatory domain)=
 and while
>> + * =C2=A0 doing a passive scan on the 5 GHz band you find an AP the=
re (if not
>> + * =C2=A0 on a DFS channel) you will now be able to actively scan f=
or that AP
>> + * =C2=A0 or use AP mode on your card on that same channel. Note th=
at this will
>> + * =C2=A0 never be used for channels 1-11 on the 2 GHz band as they=
 are always
>> + * =C2=A0 enabled world wide. This beacon hint is only sent if your=
 device had
>> + * =C2=A0 either disabled active scanning or beaconing on a channel=
=2E We send to
>> + * =C2=A0 userspace the wiphy on which we removed a restriction fro=
m
>> + * =C2=A0 (%NL80211_ATTR_WIPHY) and the channel on which this occur=
red
>> + * =C2=A0 before (%NL80211_ATTR_FREQ_BEFORE) and after (%NL80211_AT=
TR_FREQ_AFTER)
>> + * =C2=A0 the beacon hint was processed.
>
>
> I wonder -- are there other reasons we may ever update the regdomain?=
 I
> could imagine the CMD being REG_UPDATE with an ATTR_REASON or so? Or
> just using REG_CHANGE with NL80211_REGDOM_TYPE_WORLD _and_ the new
> channel change attributes?

I don't follow what you were saying.

=46YI -- we only call this when world roaming.

>> +static int nl80211_put_beacon_hint_channel(void *hdr,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
struct sk_buff *msg,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
enum nl80211_attrs attribute,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
struct ieee80211_channel *chan)
>> +{
>> + =C2=A0 =C2=A0 struct nlattr *nl_freq;
>> +
>> + =C2=A0 =C2=A0 nl_freq =3D nla_nest_start(msg, attribute);
>> + =C2=A0 =C2=A0 if (!nl_freq)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nla_put_failure;
>> +
>> + =C2=A0 =C2=A0 NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chan->cent=
er_freq);
>> +
>> + =C2=A0 =C2=A0 if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NLA_PUT_FLAG(msg, NL8021=
1_FREQUENCY_ATTR_PASSIVE_SCAN);
>> + =C2=A0 =C2=A0 if (chan->flags & IEEE80211_CHAN_NO_IBSS)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NLA_PUT_FLAG(msg, NL8021=
1_FREQUENCY_ATTR_NO_IBSS);
>> +
>> + =C2=A0 =C2=A0 nla_nest_end(msg, nl_freq);
>> +
>> + =C2=A0 =C2=A0 return 0;
>
> I think you should send all possible channel attributes here -- pleas=
e
> refactor the code and extract the bit that sends a channel from
> nl80211_send_wiphy(), this bit:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FR=
EQ,...)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0..
> =C2=A0 =C2=A0 =C2=A0 =C2=A0NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MA=
X_TX_POWER,...)
>
> put it into a new function that takes a msg and channel pointer and c=
all
> it twice.

Heh.. sure.

> Does the relaxing we do on receiving beacons only apply to a single
> wiphy though?

We do it per wiphy if the wiphy is world roaming.

>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0* Since we are applying the beacon hint to a w=
iphy we know its
>> + =C2=A0 =C2=A0 =C2=A0* wiphy_idx is valid
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(w=
iphy));
>
> You're sending out the wiphy here.

Hm? We're sending its wiphy_idx here.

> And I just realised there's a bug in the existing code:
>
>> @@ -1070,18 +1062,26 @@ static void handle_reg_beacon(struct wiphy *=
wiphy,
>> =C2=A0 =C2=A0 =C2=A0 if (likely(chan->center_freq !=3D reg_beacon->c=
han.center_freq))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>>
>> + =C2=A0 =C2=A0 if (chan->beacon_found)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> +
>> + =C2=A0 =C2=A0 chan->beacon_found =3D true;
>> +
>> + =C2=A0 =C2=A0 chan_before.center_freq =3D chan->center_freq;
>> + =C2=A0 =C2=A0 chan_before.flags =3D chan->flags;
>> +
>> =C2=A0 =C2=A0 =C2=A0 if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) =
{
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chan->flags &=3D ~I=
EEE80211_CHAN_PASSIVE_SCAN;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REG_DEBUG_BEACON_FLAG("a=
ctive scanning");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 channel_changed =3D true=
;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chan->flags &=3D ~I=
EEE80211_CHAN_NO_IBSS;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REG_DEBUG_BEACON_FLAG("b=
eaconing");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 channel_changed =3D true=
;
>> =C2=A0 =C2=A0 =C2=A0 }
>
> This is incorrect, it has to be like this:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((chan->flags & FLAG) && !(chan->orig_f=
lags & FLAG)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chan->flags &=3D=
 ~FLAG;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0channel_change=
d =3D true;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> to take into account the flags the _driver_ had already set on the
> channel. This is important for Intel hardware -- if you lift the IBSS
> restriction on a channel that iwlwifi thinks should not use IBSS then
> the firmware will hate you if you try to use it anyway. Now, I think
> iwlwifi isn't world-roaming in that sense, but it should still be fix=
ed!

Ew, sure it can go in as a separate patch.

> Does this mean though you're sending one event per wiphy? Just
> wondering, it's probably acceptable.

Indeed as this flags won't change for for all wiphys, only for wiphys
for which the regulatory beacon hint had an effect on a change of a
channel. This will also be sent for each channel changed on the wiphy.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
