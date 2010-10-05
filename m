Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0JEWgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 18:36:51 -0400
Received: by iwn5 with SMTP id 5so8871365iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 15:36:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101005095526.3083.82322.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095526.3083.82322.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 15:36:30 -0700
Message-ID: <AANLkTim62JuNJMHNB=-_mTXyXVr84cqptrqnD8QgtT7F@mail.gmail.com>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 2:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> This adds three new values to the survey results:
>
>  * BUSY - percentage of time the channel was busy
>  * BUSY_TX - percentage of time spent transmitting frames
>  * BUSY_RX - percentage of time spent receiving frames
>
> They are defined to be a percentage of time, normalized to 255. That way they
> match the Channel Utilization of the BSS Load IE of 802.11-2007, chapter
> 7.3.2.28, in case we want to use that later.
>
> I admit that these three values are ath[59]k centric - it's what is available
> there, and i don't know if other chipsets have similar information.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  include/linux/nl80211.h |   10 ++++++++++
>  include/net/cfg80211.h  |    6 ++++++
>  net/wireless/nl80211.c  |    9 +++++++++
>  3 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index f0518b0..2cc74a2 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1400,6 +1400,13 @@ enum nl80211_reg_rule_flags {
>  * @__NL80211_SURVEY_INFO_INVALID: attribute number 0 is reserved
>  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
>  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
> + * @NL80211_SURVEY_INFO_BUSY: channel busy ratio (u8, percentage of time,
> + *     normalized to 255 so it matches Channel Utilization of the BSS Load IE
> + *     of 802.11-2007 chapter 7.3.2.28)

Neat, so this could be used to help with roaming it seems.. Now as you
noted this is defined pretty specifically on 802.11-2007 chapter
7.3.2.28.

> + * @NL80211_SURVEY_INFO_BUSY_TX: percentage of time spent transmitting frames
> + *     (u8, percent 0-255, see above)

But here you say look above, can you be more specific how this relates
to 802.11-2007 chapter 7.3.2.28 ?

> + * @NL80211_SURVEY_INFO_BUSY_RX: percentage of time spent receiving frames
> + *     (u8, percent 0-255, see above)

Same here.

  Luis
