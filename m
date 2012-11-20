Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45075 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2KTIiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:38:25 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5676504oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 00:38:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcramc=cNy9cGt9VzJQGWd+a4dtEZ89Ku_jXxwqMPQfqw@mail.gmail.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-9-git-send-email-eliad@wizery.com>
	<CA+XVXfcramc=cNy9cGt9VzJQGWd+a4dtEZ89Ku_jXxwqMPQfqw@mail.gmail.com>
Date: Tue, 20 Nov 2012 10:38:24 +0200
Message-ID: <CAB3XZEeM8E3V7nNk21tOrzEhV2g543bjixiEiNrid_YDEx-bmA@mail.gmail.com> (sfid-20121120_093828_323530_EC3C460B)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
From: Eliad Peller <eliad@wizery.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:23 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
>> Add some basic chanctx implementation.
>>
>> Only add debug prints, and save the vif's channel/band/type.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---

>> +static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
>> +                                       struct ieee80211_vif *vif,
>> +                                       struct ieee80211_chanctx_conf *ctx)
>> +{
>> +       struct wl1271 *wl = hw->priv;
>> +       struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
>> +       int channel = ieee80211_frequency_to_channel(
>> +               ctx->channel->center_freq);
>> +
>> +       wl1271_debug(DEBUG_MAC80211,
>> +                    "mac80211 assign chanctx (role %d) %d (type %d)",
>> +                    wlvif->role_id, channel, ctx->channel_type);
>> +
>> +       wlcore_tx_work_locked(wl);
>
> is this some kind of a lame attempt at a flush? :)
>
> why not use flush here if the channel was set - or better yet, flush
> stuff at wlcore_op_unassign_vif_chanctx, which is currently unused.
> we'll need the TODO there for the per-vif-flush. once everything is
> upstreamed (hw queues) it would be pretty trivial to implement.
>
ok, you convinced me. i'll do a flush on unassign instead. :)

> also not sure what happened to the rest of the stuff done on channel
> config - updating the rate_set according to band etc..
>
well, actually you have a pending patch to fix it, and i planned
sending it in the next patchset. but since you already asked about it
i'll just squash it into this patch (and add your SOB). :)

Eliad.
