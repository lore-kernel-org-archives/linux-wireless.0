Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1DZFCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 01:02:52 -0400
Received: by iyb14 with SMTP id 14so224919iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 22:02:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303125749-31967-2-git-send-email-arik@wizery.com>
References: <1303125749-31967-1-git-send-email-arik@wizery.com> <1303125749-31967-2-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 26 Apr 2011 08:02:37 +0300
Message-ID: <BANLkTi=pqZaa=Bz65173YP=1anzxL6upow@mail.gmail.com> (sfid-20110426_070302_330051_9A1A4370)
Subject: Re: [PATCH 2/2] wl12xx: support FW TX inactivity triggers
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2011 at 14:22, Arik Nemtsov <arik@wizery.com> wrote:
> In AP mode register for the MAX_TX_RETRY and INACTIVE_STA events.
> Both are reported to the upper layers as a TX failure in the offending
> stations.
>
> In STA mode we register only for the MAX_TX_RETRY event. A TX failure is
> interpreted as a loss of connection.
>
> Support for IEEE80211_HW_REPORTS_TX_ACK_STATUS has been removed to avoid
> the inherent race condition of a mac80211 TX failure counter in addition
> to the FW counter.
>
> This patch depends on "mac80211: allow low level drivers to report packet
> loss"
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

It seems there's a bug in this patch. I'll send a v2 shortly. Please
hold off on the review for now.

Thanks,
Arik
