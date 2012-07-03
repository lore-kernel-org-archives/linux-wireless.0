Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58401 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GCQFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:05:00 -0400
Received: by ghrr11 with SMTP id r11so5452734ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 09:04:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341304650-2593-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341304650-2593-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341304650-2593-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 3 Jul 2012 09:04:38 -0700
Message-ID: <CAB=NE6WqzHkyg94hif7hZ2EqE5EQgAX8QbexhGNoQcu27Mt2cA@mail.gmail.com> (sfid-20120703_180504_166537_7F68553B)
Subject: Re: [PATCH 1/2] {nl,cfg}80211: support high bitrates
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 1:37 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> User space tools should switch to new bitrate. Old one is deprecated and going to be
> removed in the future.

Removed?? No way. You can't make old userspace break.

> @@ -1638,12 +1638,16 @@ struct nl80211_sta_flag_update {
>   *
>   * These attribute types are used with %NL80211_STA_INFO_TXRATE
>   * when getting information about the bitrate of a station.
> + * Legacy bitrate represented with 16-bit value, while new
> + * "high throughput" bitrate uses 32-bit value. User space tools
> + * should use new bitrate.

Something a bit more clearer would say that we send both, and that
userspace should use the new one given that new technologies required
a higher data type. Also explaining what gets sent to userspace for
those high data bit rates on the old data type would help -- from what
I read in your patch we set those high bit rates to 0 on the old data
type.

>   *
>   * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
>   * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
>   * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
>   * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
>   * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
> + * @NL80211_RATE_INFO_BITRATE_HT: total bitrate (u32, 100kbit/s)

NL80211_RATE_INFO_BITRATE_HT seems misleading as likely we will also
use this for VHT, and whatever other fun acronym the industry comes up
with for bitrates for 802.11.

  Luis
