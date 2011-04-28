Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51536 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1D1ITF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 04:19:05 -0400
Received: by iwn34 with SMTP id 34so2023007iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 01:19:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303849311-8817-1-git-send-email-arik@wizery.com>
References: <1303849311-8817-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 28 Apr 2011 11:18:49 +0300
Message-ID: <BANLkTi=mJE+M79-XOJsTPRu1zGodiiZ8bg@mail.gmail.com> (sfid-20110428_101911_736860_4B107BA3)
Subject: Re: [PATCH v2] wl12xx: support FW TX inactivity triggers
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 23:21, Arik Nemtsov <arik@wizery.com> wrote:
> In AP mode we register for the MAX_TX_RETRY and INACTIVE_STA events.
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
> This patch depends on "mac80211: allow low level driver to report packet
> loss"
>

Luca please don't take this one for now. It appears the FW sometimes
misfires the event in STA mode.
We'll need some more debugging.

Arik
