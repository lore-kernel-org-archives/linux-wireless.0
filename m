Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47047 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab0BLIF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 03:05:26 -0500
Received: by pwj8 with SMTP id 8so162697pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2010 00:05:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265961128-21301-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1265961128-21301-1-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Feb 2010 23:57:00 -0800
Message-ID: <43e72e891002112357k4b261c38x5f4d0fdc598bff3a@mail.gmail.com>
Subject: Re: [PATCH 1/1] mac80211: fix handling of null-rate control in
	rate_control_get_rate
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 11, 2010 at 11:52 PM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> For hardware with IEEE80211_HW_HAS_RATE_CONTROL the rate controller is not
> initialized. However, calling functions such as ieee80211_beacon_get result
> in the rate_control_get_rate function getting called, which is accessing
> (in this case uninitialized) rate control structures unconditionally.
>
> Fix by exiting the function before setting the rates for HW with
> IEEE80211_HW_HAS_RATE_CONTROL set. The initialization of the ieee80211_tx_info
> struct is intentionally still executed.
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

I meant adding it on the commit log, below the Reviewed-by line.

  Luis
