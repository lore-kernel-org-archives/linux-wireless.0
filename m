Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:58718 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbbAYKag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 05:30:36 -0500
Received: by mail-la0-f48.google.com with SMTP id pv20so3760260lab.7
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 02:30:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com> <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 25 Jan 2015 12:30:19 +0200
Message-ID: <CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com> (sfid-20150125_113039_436297_171135AB)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2015 at 2:35 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Add VHT80/VHT160 support for IBSS.
> Drivers could activate this feature by
> setting NL80211_FEATURE_VHT_IBSS flag.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
[...]
> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +                               const struct cfg80211_chan_def *chandef)
> +{
> +       struct ieee80211_vht_operation *vht_oper;
> +
> +       /* Build VHT Operation */
> +       *pos++ = WLAN_EID_VHT_OPERATION;
> +       *pos++ = sizeof(struct ieee80211_vht_operation);
> +
> +       vht_oper = (struct ieee80211_vht_operation *)pos;
> +
> +       vht_oper->center_freq_seg1_idx =
> +                       ieee80211_frequency_to_channel(chandef->center_freq1);
> +       vht_oper->center_freq_seg2_idx = 0;
> +       vht_oper->basic_mcs_set = vht_cap->vht_mcs.rx_mcs_map;
> +
> +       switch (chandef->width) {
> +       case NL80211_CHAN_WIDTH_80:
> +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
> +               break;
> +       case NL80211_CHAN_WIDTH_80P80:
> +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
> +               vht_oper->center_freq_seg2_idx =
> +                       ieee80211_frequency_to_channel(chandef->center_freq2);
> +               break;
> +       case NL80211_CHAN_WIDTH_160:
> +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
> +               break;
> +       default:
> +               return pos;
> +       }

Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
have no use for it in IBSS I can add it later.
Some peers (notably mac80211-based ones) might not use the info, but
others might..

Arik
