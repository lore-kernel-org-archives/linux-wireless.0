Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51443 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3JQJl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 05:41:57 -0400
Received: by mail-ie0-f178.google.com with SMTP id to1so4639476ieb.9
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 02:41:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381995881-16935-1-git-send-email-johannes@sipsolutions.net>
References: <1381995881-16935-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 17 Oct 2013 11:41:56 +0200
Message-ID: <CAB3XZEff+Xguf_Bk7p4S2N3j03dT1tB0u1u8enP4cd8NtD2jnA@mail.gmail.com> (sfid-20131017_114241_308372_54F46914)
Subject: Re: [PATCH 3.12] mac80211: disable WMM with invalid parameters
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@meshcoding.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 17, 2013 at 10:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Some APs (notably a Sitecom WL-153 v1 with firmware 1.45) are sending
> invalid WMM parameters setting AIFSN, ECWmin and ECWmax to zero. The
> spec mandates that the value of AIFSN is at least 2, and some cards
> (e.g. Intel with the iwldvm driver) can't transmit when the invalid
> QoS parameters are actually uploaded to the firmware.
>
> Since there's little chance of being able to guess the values that
> the AP actually meant, disable WMM if such an invalid case is found.
> Since ECWmin/ECWmax are allowed to be zero, only verify AIFSN >= 2
> and ECWmin <= ECWmax.
>
> Reported-by: Antonio Quartulli <antonio@meshcoding.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> @@ -4192,9 +4231,36 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>         }
>
>         /* prepare assoc data */
> -
> +
>         ifmgd->beacon_crc_valid = false;
>
> +       assoc_data->wmm = bss->wmm_used &&
> +                         (local->hw.queues >= IEEE80211_NUM_ACS);
> +       if (assoc_data->wmm) {
> +               /* try to check validity of WMM params IE */
> +               const struct cfg80211_bss_ies *ies;
> +               const u8 *wp, *start;
> +               int len;
> +
> +               rcu_read_lock();
> +               ies = rcu_dereference(req->bss->ies);
> +               start = ies->data;
> +               len = ies->len;
> +
> +               do {
> +                       wp = cfg80211_find_vendor_ie(0x0050F2, 2, start, len);
> +                       start = wp;
> +                       len -= wp[1];
you might NULL deref here.
but i don't really see how this calculation makes sense anyway (you
should probably increase start and take care of the  ie's id+len (i.e.
wp[1] + 2) as well)?

Eliad.
