Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33685 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab0DVQhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 12:37:06 -0400
Received: by pwj9 with SMTP id 9so6143563pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 09:37:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271921268-7512-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1271921268-7512-1-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 22 Apr 2010 09:28:58 -0700
Message-ID: <v2k43e72e891004220928lb5acefbch8397c6a9a56047b5@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix sta->last_tx_rate setting with no-op rate
	control devices
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 22, 2010 at 12:27 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> The sta->last_tx_rate is traditionally updated just before transmitting a
> frame based on information from the rate control algorithm. However, for
> hardware drivers with IEEE80211_HW_HAS_RATE_CONTROL this is not performed,
> as the rate control algorithm is not executed, and because the used rate is
> not known before the frame has actually been transmitted.
>
> This causes atleast a fixed 1Mb/s to be reported to user space. A few other
> instances of code also rely on this information.
>
> Fix this by setting the sta->last_tx_rate in tx_status handling. There, look
> for last rates entry set by the driver, and use that as value for
> sta->last_tx_rate.
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

But the actual rate used is not known, or is it? In those cases would
it not be better to inform userspace that the information is not
available?

  Luis
