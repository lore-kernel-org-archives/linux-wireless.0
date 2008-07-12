Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:7395 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYGLVe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 17:34:27 -0400
Received: by rv-out-0506.google.com with SMTP id k40so4945943rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2008 14:34:24 -0700 (PDT)
Message-ID: <1ba2fa240807121434l21756164h685ac48825b48f1d@mail.gmail.com> (sfid-20080712_233431_556534_15CA94EE)
Date: Sun, 13 Jul 2008 00:34:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Bruno Randolf" <br1@einfach.org>
Subject: Re: [PATCH 1/1] iwlwif: remove compilation warnings iwl_add_radiotap
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807121457.06795.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com>
	 <1215697922.3483.18.camel@johannes.berg>
	 <1ba2fa240807100747g285b5ff0of81bf619ad9ee3b9@mail.gmail.com>
	 <200807121457.06795.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 12, 2008 at 3:57 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Thursday 10 July 2008 16:47:57 Tomas Winkler wrote:
>> On Thu, Jul 10, 2008 at 4:52 PM, Johannes Berg
>>
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2008-07-10 at 15:25 +0300, Tomas Winkler wrote:
>> >> > what about using the generic function to add the radiotap header from
>> >> > mac80211? it should be flexible enough to handle all devices by now.
>> >>
>> >> Why not go ahead.
>> >
>> > I always thought you were adding 11n stuff, but if that's not the case
>> > (and we may make mac80211 do that at some point) then that'd be a nice
>> > code removal.
>>
>> I have never really looked into radio tap so I don't want to make any
>> statements here. If the 11n part can be done in mac80211 why not.
>
> hi!
>
> i'm currently working on a patch removing iwl's own radiotap header. while
> doing that i noticed, that we currently don't have a field in
> ieee80211_rx_status for the modulation used. for example iwl knows if the
> frame was demodulated using CCK (RX_RES_PHY_FLAGS_MOD_CCK_MSK), thus it's
> able to differentiate between B and G modes. in mac80211 we can't do that
> right now.
>
> i guess we could deduct the modulation from the rate
>
> 1, 2, 5.5, 11   -> CCK
> everything else -> OFDM
>
> but i'm not sure if this is always true. is there any hardware that also does
> PBCC? also what about CCK-OFDM modes (b/g interoperability), do we have any
> way to identify these?
>
> what do you think, should we explicitly make a modulation field in rx_status
> or should we implicitly deduct the modulation from the rates?

I believe you can safely assume  CCK from rate in WiFi. Both PBCC and
CCK/OFDM are optional by the spec meaning nobody really going to
implement. I suggest to focus on the main pass and deal with the
corner cases only if needed.
Tomas

>
> bruno
>
