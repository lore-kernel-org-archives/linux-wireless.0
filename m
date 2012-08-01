Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33900 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2HAT23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 15:28:29 -0400
Received: by ggnl2 with SMTP id l2so438334ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2012 12:28:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343834487-23737-8-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net> <1343834487-23737-8-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 1 Aug 2012 22:28:13 +0300
Message-ID: <CA+XVXfegwamdK3mzP5eiAUJM4eYrFRTXY4Mr2tKP7+VBYriF-w@mail.gmail.com> (sfid-20120801_212832_567935_B3991B62)
Subject: Re: [RFC 7/8] mac80211: support extended channel switch
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 6:21 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Support extended channel switch when the operating
> class is one of the global operating classes as
> defined in Annex E of 802.11-2012. If it isn't,
> disconnect from the AP instead.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[...]
> +static void
> +ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> +                                u8 new_chan_no, u8 count, u8 mode,
> +                                enum ieee80211_band new_band,
> +                                struct ieee80211_bss *bss, u64 timestamp)
>  {
>         struct cfg80211_bss *cbss =
>                 container_of((void *)bss, struct cfg80211_bss, priv);
>         struct ieee80211_channel *new_ch;
>         struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> -       int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
> -                                                     cbss->channel->band);
> +       int new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);

I'm not sure a channel switch between bands should be allowed. Case in
point - a device might have different HT capabilities between bands,
so different rates might need to be programmed to FW. This would
require a re-assoc..

Arik
