Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:60094 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaBVVJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 16:09:07 -0500
Received: by mail-la0-f45.google.com with SMTP id b8so3829694lan.18
        for <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 13:09:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A033385CFB@HASMSX106.ger.corp.intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com>
 <1392896671-4288-6-git-send-email-ilan.peer@intel.com> <CAB=NE6Vo2WsVc7zwpB3xnRre1MWL2FeQLvqMsheRFXG5hOxwTw@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A033385CFB@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 22 Feb 2014 13:08:44 -0800
Message-ID: <CAB=NE6XZ3y_Nf0-9KpJdMjGMDmUTSvsC8jgGBV2iGpaNtAkSGw@mail.gmail.com> (sfid-20140222_220911_807307_CFA27B43)
Subject: Re: [PATCH v5 5/5] cfg80211: Enable GO operation on indoor channels
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 22, 2014 at 11:54 AM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> >  static bool cfg80211_go_permissive_chan(struct
>> cfg80211_registered_device *rdev,
>> >                                         struct ieee80211_channel
>> > *chan) @@ -621,8 +623,14 @@ static bool
>> cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
>> >         ASSERT_RTNL();
>> >
>> >         if (!config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
>> > -           !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR)
>> ||
>> > -           !(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
>> > +           !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
>> > +               return false;
>> > +
>> > +       if (regulatory_indoor_allowed() &&
>> > +           (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
>> > +               return true;
>> > +
>> > +       if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
>> >                 return false;
>>
>> Shouldn't this check go before the indoor one?
>>
>
> I do not think so, as this relaxations is orthogonal to the GO concurrent one. It means that If a channel is enabled but only under indoor and indoor operation is hinted the relaxation removes the NO_IR restriction if such exists (without the relaxation indoor operation would be  allowed but not  for GO).

Ah yes, the first check remains as this then though:

if (!config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
   !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
             return false;

That seems wrong for the general case.

  Luis
