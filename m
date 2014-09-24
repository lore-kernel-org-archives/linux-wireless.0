Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56428 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaIXHvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 03:51:40 -0400
Received: by mail-wi0-f172.google.com with SMTP id em10so6335928wid.5
        for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 00:51:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411518383-32634-2-git-send-email-greearb@candelatech.com>
References: <1411518383-32634-1-git-send-email-greearb@candelatech.com>
	<1411518383-32634-2-git-send-email-greearb@candelatech.com>
Date: Wed, 24 Sep 2014 09:51:39 +0200
Message-ID: <CA+BoTQ=fS30xz9KcdBJcioNers6PovOFEeqPCCSFn52HkscXug@mail.gmail.com> (sfid-20140924_095144_592684_48F07179)
Subject: Re: [RFC 2/2] ath10k: re-config ht_caps when chainmask is modified.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 September 2014 02:26,  <greearb@candelatech.com> wrote:
[...]
> +static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar,
> +                                                         bool use_cfg_chains)
>  {
>         struct ieee80211_sta_vht_cap vht_cap = {0};
>         u16 mcs_map;
>         int i;
> +       int nrf = ar->num_rf_chains;
> +
> +       if (use_cfg_chains && ar->cfg_tx_chainmask)
> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);

Is use_cfg_chains really necessary here? Is setting tx/rx chainmask to
0x0 make any sense at all? Shouldn't we deny it or make it fallback to
the supported tx/rx chainmask values?


Michał
