Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:40624 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZK3RWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:22:50 -0500
Received: by iwn1 with SMTP id 1so2405404iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 09:22:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259600677.32171.25.camel@johannes.local>
References: <20091130153857.963079149@sipsolutions.net> <20091130154300.647360542@sipsolutions.net>
	<43e72e890911300854i69ddb18dxcd34d38f0d610004@mail.gmail.com>
	<1259600677.32171.25.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 30 Nov 2009 09:22:37 -0800
Message-ID: <43e72e890911300922t49cafcacu3396fe7907b21b6e@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: enable spatial multiplexing powersave
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 30, 2009 at 9:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> >        mutex_init(&ifmgd->mtx);
>> > +
>> > +       if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
>> > +               ifmgd->req_smps = NL80211_SMPS_AUTOMATIC;
>> > +       else
>> > +               ifmgd->req_smps = NL80211_SMPS_OFF;
>>
>> How about just checking the HT cap as well and if no HT cap has been
>> set warn as it would indicate a driver bug actually.
>
> You mean if it sets dynps w/o HT cap?

Yes

> We /could/ do that, but I don't
> really see a reason for it. We'd find out soon enough by a non-HT driver
> supporting SMPS etc.

OK.

>> > +               ieee80211_queue_work(&local->hw, &local->recalc_smps);
>>
>> OK from what I gather so far we just queue work if we received an ACK
>> from the action frame we sent. Since we tell the device to
>> ieee80211_stop_device() the device should have stopped RX'ing and that
>> *should* mean preventing processing future tx status reports. We'll
>> find out if that assumption is wrong.
>
> It's not about receiving -- only about transmitting.

Yes but this is not about a actual transmit but a tx status.

> But yeah, we'll
> find out. I have a patch pending that'll flush queues etc., that would
> make it completely impossible if implemented by the driver, but I don't
> think we need to worry about it.

What I mean is that technically a driver could have called even this
new tx flush and yet *after* that was called a tx status for a
*previously* transmitted frame could have come through hardware, which
is why I mentioned hw stop. hw stop would seem to be the only thing
ensuring we don't queue more work if we'd try to pm-suspend between
the point where we enabled smps and before the AP sent an ACK to us
for the action frame.

>> > @@ -209,6 +243,10 @@ void ieee80211_tx_status(struct ieee8021
>> >                rate_control_tx_status(local, sband, sta, skb);
>> >                if (ieee80211_vif_is_mesh(&sta->sdata->vif))
>> >                        ieee80211s_update_metric(local, sta, skb);
>> > +
>> > +               if (!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
>> > +                   (info->flags & IEEE80211_TX_STAT_ACK))
>> > +                       ieee80211_frame_acked(sta, skb);
>> >        }
>> >
>> >        rcu_read_unlock();
>>
>> Nice, should the nullfunc ack check be handled here as well?
>
> Well, it could, in theory. But I've now imposed a requirement that SMPS
> capable devices also implement status notifications properly, which may
> or may not be possible for all frames. In fact, we may need to change
> this in the future but for now I prefer this requirement -- but for HT
> only.

OK I see. Then the next question is can iwl3945 and iwlagn report tx
status for a nullfunc sent to an AP?

>> > +       if (!conf_is_ht(&local->hw.conf)) {
>> > +               /*
>> > +                * mac80211.h documents that this is only valid
>> > +                * when the channel is set to an HT type, and
>> > +                * that otherwise STATIC is used.
>> > +                */
>> > +               local->hw.conf.smps_mode = NL80211_SMPS_STATIC;
>>
>> Why wouldn't this just be SMPS_OFF ?
>
> Well, it doesn't matter either way. However, it was easier this way for
> iwlwifi because ultimately we want to turn off all but one chain if
> non-HT and/or static SMPS. So at least there it made sense to use STATIC
> here to avoid the extra check. But other drivers may or may not want to
> ignore it completely in the HT case. I've documented that it sets it to
> STATIC when a non-HT association is used just for more use. It could be
> anything really, or even an invalid value. Also remember that SMPS_OFF
> means all chains turned on.

Hm -- so hardware would *typically* leave all chains on even for
legacy mode of operation?

  Luis
