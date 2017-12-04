Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdLDOrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 09:47:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [PATCH 02/10] qtnfmac: pass complete channel data between driver and firmware
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
        <20171113102815.11254-3-sergey.matyukevich.os@quantenna.com>
Date: Mon, 04 Dec 2017 16:46:59 +0200
In-Reply-To: <20171113102815.11254-3-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Mon, 13 Nov 2017 13:28:07 +0300")
Message-ID: <87efoalfdo.fsf@purkki.adurom.net> (sfid-20171204_154707_749238_ABAD6607)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Center frequency is not enough to describe the channel in HT and VHT
> modes. For 40MHz and 80MHz channels both primary channel and center
> frequency should be specified in order to qualify channel completely.
> This change adds primary channel info into qlink_chandef structure.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[...]

> +/**
>   * struct qlink_chandef - qlink channel definition
>   *
> + * @chan: primary channel definition
>   * @center_freq1: center frequency of first segment
>   * @center_freq2: center frequency of second segment (80+80 only)
>   * @width: channel width, one of @enum qlink_channel_width
>   */
>  struct qlink_chandef {
> +	struct qlink_channel chan;
>  	__le16 center_freq1;
>  	__le16 center_freq2;
>  	u8 width;
> -	u8 rsvd[3];
> +	u8 rsvd;
>  } __packed;

Doesn't this break backwards compatibility with the older firmware? The
basic princinple is that old firmware images continue to work with newer
driver (or there will be a firmware image with new name, eg. fw-2.bin).
You can check how iwlwifi does that.

As this is a new driver I guess it doesn't matter that much to break it,
but please keep this in mind in the future.

-- 
Kalle Valo
