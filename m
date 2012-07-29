Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64588 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2G2JDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 05:03:11 -0400
Received: by obbuo13 with SMTP id uo13so7124023obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 02:03:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343387816-9414-7-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	<1343387816-9414-7-git-send-email-johannes@sipsolutions.net>
Date: Sun, 29 Jul 2012 12:03:10 +0300
Message-ID: <CAB3XZEdKBXN9y2eUKyLe_6L-9AjZYksUJW9Q-JOBRBKXh5dATQ@mail.gmail.com> (sfid-20120729_110336_624045_7F4763EB)
Subject: Re: [RFC 06/20] mac80211: refactor set_channel_type
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2012 at 2:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
>
> Split functionality for further reuse.
>
> Will prevent code duplication when channel context
> channel_type merging is introduced.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

> +
> +bool ieee80211_set_channel_type(struct ieee80211_local *local,
> +                               struct ieee80211_sub_if_data *sdata,
> +                               enum nl80211_channel_type chantype)
> +{
> +       enum nl80211_channel_type superchan;
> +       enum nl80211_channel_type compatchan = NL80211_CHAN_NO_HT;
> +
no need to initialize compatchan.

> +       superchan = ieee80211_get_superchan(local, sdata);
> +       if (!ieee80211_channel_types_are_compatible(superchan, chantype,
> +                                                   &compatchan))
> +               return false;
> +

as it should be assigned here.

Eliad.
