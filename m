Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46105 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaCRIgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 04:36:39 -0400
Received: by mail-ob0-f178.google.com with SMTP id wp18so6767136obc.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 01:36:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395130437.15856.13.camel@dubbel>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
	<1394547394-3910-4-git-send-email-luciano.coelho@intel.com>
	<CA+BoTQ=i2yDeVQaaF3aWfKG+dcHCn9Gg_AZ+rSNDsmaE88o7Rw@mail.gmail.com>
	<1395130437.15856.13.camel@dubbel>
Date: Tue, 18 Mar 2014 09:36:38 +0100
Message-ID: <CA+BoTQn5dB8-4U0X+_GX_J7rDctTpCWg8ydjSQbrEjMB28NKEA@mail.gmail.com> (sfid-20140318_093650_564143_D246565A)
Subject: Re: [PATCH v10 3/5] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2014 09:13, Coelho, Luciano <luciano.coelho@intel.com> wrote:
> On Fri, 2014-03-14 at 09:40 +0100, Michal Kazior wrote:
>> On 11 March 2014 15:16, Luciano Coelho <luciano.coelho@intel.com> wrote:

[...]

>> > +       list_for_each_entry(ctx, &local->chanctx_list, list) {
>> > +               if (ctx->conf.radar_enabled)
>> > +                       radar_detect |= BIT(ctx->conf.def.width);
>>
>> Is this really correct?
>
> I'm not sure anymore. :)
>
>
>> The original behaviour was to:
>>
>>  for each wdev:
>>    get_chan_state(..., &radar_width)
>>
>> where get_chan_state() ORs BIT(width) accordingly to iftype, etc.
>>
>> For 2 APs with different operational widths (e.g. 20 and 40) this means:
>>
>> a) old code: width_detect = BIT(WIDTH_20) | BIT(WIDTH_40)
>> b) new code: width_detect = BIT(chanctx->width) which is BIT(WIDTH_40)
>>
>> I think radar_detect should be computed:
>>
>>  radar_detect = 0 // **
>>  for each vif:
>>   if vif.ctx == ctx && vif.radar_required:
>>    radar_detect = BIT(vif.bss.width)
>>
>> ** you could argue to initialize with BIT(ctx->width), but all things
>> seem to use ieee80211_vif_use_channel() (including CAC/radar
>> detection) so bss_conf.chandef.width should be set correctly and
>> iteration alone should suffice.
>
> But does this really make sense? This was more or less the idea I had
> when I changed the cfg80211_chandef_dfs_required() to return a bit mask
> (which I later reverted).
>
> I think the current behavior may be wrong.  In the old
> cfg80211_can_use_iftype_chan() we match *any* of the bits in
> radar_detect with the bits supported in the interface combinations.  So,
> in your example, we would accept the combination even if the driver did
> not support WIDTH_40 (because it would match WIDTH_20).  If the context
> is set to WIDTH_40, don't we have to make sure the driver can detect
> radars on that width?

Fair point, but current behaviour of cfg80211_can_use_iftype_chan()
doesn't seem like a correct one to me. It shouldn't match any but
*all* of the radar_detect bits, no?


Michał
