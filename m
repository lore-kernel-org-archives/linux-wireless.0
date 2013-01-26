Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48283 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3AZLM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 06:12:29 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so769173wgb.12
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 03:12:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359165160-8102-1-git-send-email-thomas@cozybit.com>
References: <1359165160-8102-1-git-send-email-thomas@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sat, 26 Jan 2013 03:12:08 -0800
Message-ID: <CAG6hwVPU8v5+xdYutCb2e_zDvVk5uhUYxVS_EySwN5E6iVauoQ@mail.gmail.com> (sfid-20130126_121233_259966_1EF92914)
Subject: Re: [PATCH] mac80211: dynamic short slot time for MBSSs
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 5:52 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
...
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +               if (sdata != sta->sdata ||
> +                   sta->plink_state != NL80211_PLINK_ESTAB)
> +                       continue;
> +
> +               rates = sta->sta.supp_rates[band];
> +               for_each_set_bit(i, (unsigned long *)&rates,
> +                                sizeof(rates) * BITS_PER_BYTE) {
> +                       if (bitrates[i].flags & IEEE80211_RATE_ERP_G) {
> +                               short_slot = true;
> +                               break;
> +                       }
> +               }
> +
> +               if (!short_slot)
> +                       break;

Grrr. Forgot to reset short_slot while iterating over peers. Will fix in a v2.

-- 
Thomas
