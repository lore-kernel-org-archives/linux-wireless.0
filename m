Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:41838 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0BLHr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 02:47:28 -0500
Received: by pxi14 with SMTP id 14so1451376pxi.20
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2010 23:47:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265960129-11072-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1265960129-11072-1-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Feb 2010 23:47:04 -0800
Message-ID: <43e72e891002112347y5d1dc68al500d914dbdf11eb3@mail.gmail.com>
Subject: Re: [PATCH 1/1] mac80211: fix handling of null-rate control in
	rate_control_get_rate
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 11, 2010 at 11:35 PM, Juuso Oikarinen
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

I think this has been a bug for a while so can you resend with Cc:
stable@kernel.org

  Luis
