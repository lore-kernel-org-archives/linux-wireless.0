Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:45876 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYGIWRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 18:17:44 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1901919waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 15:17:43 -0700 (PDT)
Message-ID: <1ba2fa240807091517y40f6ab8cscc352bfdaa0d715@mail.gmail.com> (sfid-20080710_001747_475318_2D821C3C)
Date: Thu, 10 Jul 2008 01:17:43 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi workaround for mac80211 sequence number bug
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunksi" <ron.rindjunski@intel.com>
In-Reply-To: <1215641485.3246.72.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215641485.3246.72.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 1:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Ok, so I'm frustrated. I spent a few hours today chasing docs, trying to
> understand sequence numbering from the specs, how we implement it in
> mac80211 for TX and RX, how hardware/firmware implements it. Finally, I
> figure out that mac80211 is buggy, and come up with a buggy (now I know)
> patch.
>
> Then, now, I find out that iwlwifi contains a workaround for the
> mac80211 sequence numbering, so you've known all along!
>
> Why don't you tell anyone about the problems you find? It can't be that
> hard. Are there any other lurking issues like that?
>
> Here's the code from iwlwifi:
>
>        if (ieee80211_is_data_qos(fc)) {
>                qc = ieee80211_get_qos_ctl(hdr);
>                tid = qc[0] & 0xf;
>                seq_number = priv->stations[sta_id].tid[tid].seq_number &
>                                IEEE80211_SCTL_SEQ;
>                hdr->seq_ctrl = cpu_to_le16(seq_number) |
>                        (hdr->seq_ctrl &
>                                __constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
>                seq_number += 0x10;
>                /* aggregation is on for this <sta,tid> */
>                if (info->flags & IEEE80211_TX_CTL_AMPDU)
>                        txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
>                priv->stations[sta_id].tid[tid].tfds_in_queue++;
>        }
>
> We can implement that trivially in mac80211 and make it do the right
> thing for all drivers instead of having iwlwifi work around the bug in
> mac80211.
>
> Additionally, we can then remove the ssn argument to the ampdu_action
> callback.
>
This is not a bug in mac.
The sequence number can be committed only if the packet is not dropped
somewhere in the driver. See lower in the function.. There are plenty
of  places on the TX path when packet can be dropped this it's last
station.  There is no reason to pushing this into mac
Tomas



> johannes
>
