Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61048 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaIXHo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 03:44:27 -0400
Received: by mail-wi0-f170.google.com with SMTP id fb4so5951227wid.5
        for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 00:44:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411507045-18973-3-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-3-git-send-email-greearb@candelatech.com>
Date: Wed, 24 Sep 2014 09:44:26 +0200
Message-ID: <CA+BoTQkK=6NfPN9e-3qN2Qaq2RLVdEwrp5x03_T=E2ZLcBeiaA@mail.gmail.com> (sfid-20140924_094431_467120_26800BBF)
Subject: Re: [PATCH v2 03/10] ath10k: support ethtool stats.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2014 23:17,  <greearb@candelatech.com> wrote:
[...]
> +void ath10k_get_et_stats(struct ieee80211_hw *hw,
> +                        struct ieee80211_vif *vif,
> +                        struct ethtool_stats *stats, u64 *data)
> +{
> +       struct ath10k *ar = hw->priv;
> +       int i = 0;
> +       struct ath10k_target_stats *fw_stats;
> +
> +       fw_stats = &ar->debug.target_stats;
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state == ATH10K_STATE_ON)
> +               ath10k_refresh_peer_stats(ar);
> +
> +       mutex_unlock(&ar->conf_mutex);

Just for correctness sake - it's probably a good idea to
mutex_unlock() at the end (i.e. after spin_unlock_bh()) to make sure
the stats are for this particular request. With your patch there's a
very slight chance that, e.g. fw_stats debug file is being read at the
same time and it updates fw stats between the above mutex_unlock() and
following spin_lock_bh().

> +       spin_lock_bh(&ar->data_lock);
> +       data[i++] = fw_stats->hw_reaped; /* ppdu reaped */
[...]
> +       spin_unlock_bh(&ar->data_lock);
> +
> +       WARN_ON(i != ATH10K_SSTATS_LEN);
> +}


Michał
