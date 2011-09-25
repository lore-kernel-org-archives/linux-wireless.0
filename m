Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64075 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1IYI6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 04:58:48 -0400
Received: by gxk6 with SMTP id 6so3622741gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2011 01:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316790779-8955-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316790779-8955-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1316790779-8955-2-git-send-email-rmanohar@qca.qualcomm.com>
Date: Sun, 25 Sep 2011 11:58:47 +0300
Message-ID: <CAB3XZEf0A4fVCrLoCTGy+XndSW412rwTcUyL9tQ6YjoDsYonyA@mail.gmail.com> (sfid-20110925_105852_745930_0312FAB3)
Subject: Re: [PATCH 2/2] mac80211: Send the management frame at requested rate
From: Eliad Peller <eliad@wizery.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 23, 2011 at 6:12 PM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Whenever the scan request or tx_mgmt is requesting not to
> use CCK rate for managemet frames through
> NL80211_ATTR_TX_NO_CCK_RATE attribute, then mac80211 should
> select appropriate least non-CCK rate. This could help to
> send P2P probes and P2P action frames at non 11b rates
> without diabling 11b rates globally.
>
> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
[...]

> +static inline s8
> +rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
> +                         struct ieee80211_sta *sta)
> +{
> +       int i;
> +
> +       for (i = 0; i < sband->n_bitrates; i++) {
> +               struct ieee80211_rate *srate = &sband->bitrates[i];
> +               if ((srate->bitrate == 10) || (srate->bitrate == 20) ||
> +                   (srate->bitrate == 55) || (srate->bitrate == 110))
> +                       continue;
> +
> +               if ((i != sband->n_bitrates) &&
> +                   rate_supported(sta, sband->band, i))
> +                       return i;

the first condition seems redundant (according to the loop condition,
i < sband->n_bitrates)

Eliad.
