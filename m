Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:63949 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZEDXuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 19:50:46 -0400
Received: by wf-out-1314.google.com with SMTP id 26so3456566wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 16:50:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090430094100.GA23131@jm.kir.nu>
References: <20090430094100.GA23131@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 May 2009 16:50:32 -0700
Message-ID: <43e72e890905041650l72dad492q8d1380c1a489a3e4@mail.gmail.com>
Subject: Re: [RFC] mac80211: Add a timeout for frames in the RX reorder buffer
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 30, 2009 at 2:41 AM, Jouni Malinen <j@w1.fi> wrote:
> This patch allows skbs to be released from the RX reorder buffer in
> case they have been there for an unexpectedly long time without us
> having received the missing frames before them. Previously, these
> frames were only released when the reorder window moved and that could
> take very long time unless new frames were received constantly (e.g.,
> TCP connections could be killed more or less indefinitely).
>
> This situation should not happen very frequently, but it looks like
> there are some scenarious that trigger for some reason. As such, this
> should be considered mostly a workaround to speed up recovery from
> unexpected siutation that could result in connections hanging for long
> periods of time.
>
> The changes here will only check for timeout situation when adding new
> RX frames to the reorder buffer. It does not handle all possible
> cases, but seems to help for most cases that could result from common
> network usage (e.g., TCP retrying at least couple of times). For more
> completely coverage, a timer could be used to periodically check
> whether there are any frames remaining in the reorder buffer if no new
> frames are received.
>
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Been testing this for a while and it helps. How about splitting the
add of ieee80211_release_reorder_frame() as a helper into a separate
patch to make the work around clearer smaller and clearer?

  Luis
