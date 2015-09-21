Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34831 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbIUHFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:05:55 -0400
Received: by wicge5 with SMTP id ge5so101935668wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 00:05:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1442389740-29053-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1442389740-29053-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 21 Sep 2015 09:05:54 +0200
Message-ID: <CA+BoTQ=FMCyHtn8BMZv_6awOuLhJNFe5RhB2eNpCQfyk+5Jhcw@mail.gmail.com> (sfid-20150921_090558_890152_9F761604)
Subject: Re: [PATCH] ath10k: fix ldpc param for fixed rate
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 September 2015 at 09:49, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> ldpc is not configured for fixed rates. This blocks auto rate vs fixed
> rate performance comparison. Since firmware is considering ldpc vdev
> param for fixed rate selection, it has to be configured to enable ldpc
> for fixed rates.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
[...]
> @@ -6041,6 +6049,7 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
>         band = def.chan->band;
>         ht_mcs_mask = mask->control[band].ht_mcs;
>         vht_mcs_mask = mask->control[band].vht_mcs;
> +       ldpc = !!(ar->ht_cap_info & WMI_HT_CAP_LDPC);

Is still really correct? LDPC must be supported on the Rx side of
destination stations hence I would assume you need to check whether
all stations associated are LDPC capable before enabling it (e.g. via
ieee80211_iterate_stations_atomic).


Michał
