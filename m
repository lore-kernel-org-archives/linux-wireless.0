Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35266 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbbIADCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 23:02:33 -0400
Received: by iog7 with SMTP id 7so57163678iog.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 20:02:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150829222531.GA8604@localhost>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
	<CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com>
	<20150829222531.GA8604@localhost>
Date: Mon, 31 Aug 2015 23:02:32 -0400
Message-ID: <CAKf6xptqMZiqSyr3mOH_uotxa=JtHmtm2STBfDxdK5MBThaixA@mail.gmail.com> (sfid-20150901_050236_163027_B71FD46B)
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
From: Jason Andryuk <jandryuk@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 29, 2015 at 6:25 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Aug 29, 2015 at 01:11:03PM -0400, Jason Andryuk wrote:
>> Is there a reason to hide rawmode behind a modparam, or should the
>> modparam just be removed?  Just let the driver set
>> ATH10K_FLAG_RAW_MODE when ATH10K_FW_FEATURE_RAW_MODE_SUPPORT is
>> detected?
>
> Yes: you don't want to enable raw mode TX / RX decap in the normal
> case because it's fairly inefficient compared to "native" wifi mode,
> according to my understanding.  The latter doesn't support mesh framing
> however.
>
>> Does struct ieee80211_iface_limit need to be conditional on firmware
>> support as well or does interface_modes (below) gate use of
>> MESH_POINT?
>
> If you advertise a combination that isn't supported by interface modes,
> I believe you'll get a kernel warning when the wiphy is registered.
>
>>
>> > @@ -6998,7 +7020,8 @@ int ath10k_mac_register(struct ath10k *ar)
>> >
>> >         ar->hw->wiphy->interface_modes =
>> >                 BIT(NL80211_IFTYPE_STATION) |
>> > -               BIT(NL80211_IFTYPE_AP);
>> > +               BIT(NL80211_IFTYPE_AP) |
>> > +               BIT(NL80211_IFTYPE_MESH_POINT);
>>
>> Set BIT(NL80211_IFTYPE_MESH_POINT) conditionally if ATH10K_FLAG_RAW_MODE is set?
>
> Yes, this was discussed on the ath10k mailing list and I'll probably do
> it in a follow-up patch.  It is a little messy because it will involve
> casting away a const somewhere.

Great.  Glad you've already considered all these things.

-Jason
