Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54617 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaE2KkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 06:40:02 -0400
Received: by mail-qg0-f44.google.com with SMTP id i50so344980qgf.17
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 03:40:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140529093301.GA13680@qca.qualcomm.com>
References: <1401346141-9888-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CAGRGNgWo8AvT=hUmhR2AKr6xksw5CFFApj3eEX1nd+J=RrENpw@mail.gmail.com> <20140529093301.GA13680@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 29 May 2014 20:39:41 +1000
Message-ID: <CAGRGNgVEakvGG74PCOa10EvxrEad4WhqPsa3ZA7g+7cOw=DxvQ@mail.gmail.com> (sfid-20140529_124008_040052_A8FA7F3A)
Subject: Re: [PATCH] ath9k: Fix interface combinations for multi-channel concurrency
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

On Thu, May 29, 2014 at 7:33 PM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> On Thu, May 29, 2014 at 05:18:54PM +1000, Julian Calaby wrote:
>> Hi Rajkumar,
>>
>> On Thu, May 29, 2014 at 4:49 PM, Rajkumar Manoharan
>> <rmanohar@qti.qualcomm.com> wrote:
>> > Currently mac80211 does not support WDS and DFS with channel context
>> > drivers. So advertise these features only when the driver is not
>> > supporting channel context and modparam "use_chanctx" is introduced
>> > for preparing channel context support in ath9k.
>> >
>> > @@ -722,12 +736,15 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>> >                         BIT(NL80211_IFTYPE_P2P_GO) |
>> >                         BIT(NL80211_IFTYPE_P2P_CLIENT) |
>> >                         BIT(NL80211_IFTYPE_AP) |
>> > -                       BIT(NL80211_IFTYPE_WDS) |
>> >                         BIT(NL80211_IFTYPE_STATION) |
>> >                         BIT(NL80211_IFTYPE_ADHOC) |
>> >                         BIT(NL80211_IFTYPE_MESH_POINT);
>> >                 hw->wiphy->iface_combinations = if_comb;
>> > -               hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
>> > +               if (!ath9k_use_chanctx) {
>> > +                       hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
>> > +                       hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
>> > +               } else
>> > +                       hw->wiphy->n_iface_combinations = 1;
>>
>> Is that right?
>>
> Julian,
>
> Right now mcc support is not implemented in ath9k and am working on that.
> Once all channel context callbacks are added, iface_combinations will
> refer to right interface set.

I was referring to the n_iface_combinations = 1 line which doesn't
seem to match the size of if_comb.

Of course there's probably something subtle I'm missing =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
