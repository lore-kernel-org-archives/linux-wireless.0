Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42039 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2BIXGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 18:06:23 -0500
Received: by yenm8 with SMTP id m8so1218528yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 15:06:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327581484-22047-7-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-7-git-send-email-victorg@ti.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 15:06:00 -0800
Message-ID: <CAB=NE6XznrwGRXWKqHaiYqZ0f_e6OkYxK1Ft7ZqeLVy_yF0EKQ@mail.gmail.com> (sfid-20120210_000626_403913_9A115E74)
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 4:38 AM, Victor Goldenshtein <victorg@ti.com> wrote:
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d08b808..b0f4e67 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -841,12 +841,16 @@ struct ieee80211_conf {
>  *     the driver passed into mac80211.
>  * @block_tx: Indicates whether transmission must be blocked before the
>  *     scheduled channel switch, as indicated by the AP.
> + * @post_switch_block_tx: Indicates whether transmission must be blocked after
> + *     the scheduled channel switch, this should be set if the target channel
> + *     is DFS channel.

Here you say that post_switch_block_tx is required for DFS channels
but yet you do not check for this. You should instead clarify that
this is required on the nl80211.h command, and also add the sanity
check there.

  Luis
