Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40628 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2KTLrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:47:03 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5793155oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:47:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353411746.9399.14.camel@jlt4.sipsolutions.net>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-9-git-send-email-eliad@wizery.com>
	<1353411746.9399.14.camel@jlt4.sipsolutions.net>
Date: Tue, 20 Nov 2012 13:47:02 +0200
Message-ID: <CAB3XZEeDuAr3Vy2K4TMGHGOpSBW5a_f8-A6SiFGL6XwykTs7hg@mail.gmail.com> (sfid-20121120_124707_605614_227D9DA3)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 1:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>
>> +static int wlcore_op_add_chanctx(struct ieee80211_hw *hw,
>> +                              struct ieee80211_chanctx_conf *ctx)
>> +{
>> +     wl1271_debug(DEBUG_MAC80211, "mac80211 add chanctx %d (type %d)",
>> +                  ieee80211_frequency_to_channel(ctx->channel->center_freq),
>> +                  ctx->channel_type);
>
> Ok so I just realized there's another small issue with this patch/these
> patches -- my VHT changes, which I'm planning to merge soon, will change
> the chanctx_conf structure contents, which might then be tricky with git
> tree handling?
>
> I'm not too worried about that, but might be something to keep in mind.
> Right now my changes are easy because they only affect hwsim as the only
> driver using channel contexts.
>
yeah, we don't do anything fancy with the chanctx, so i guess the
merge should be fairly easy.
thanks for the heads up. we'll keep it in mind.

Eliad.
