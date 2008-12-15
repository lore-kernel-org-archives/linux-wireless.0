Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:53681 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYLORHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:07:53 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2743896wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 09:07:51 -0800 (PST)
Message-ID: <b6c5339f0812150907u62fc8c8cnb7f0e99dba8664a1@mail.gmail.com> (sfid-20081215_180757_164411_7AF96A36)
Date: Mon, 15 Dec 2008 12:07:51 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Benoit Papillault" <benoit.papillault@free.fr>
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side. TX side has been 100%
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 9:34 AM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> From: Benoit PAPILLAULT <benoit.papillault@free.fr>
>
> This patch is close to the original code except that
> ieee80211_get_hdrlen_from_skb() has been replaced by
> ath5k_hw_get_hdrlen_from_skb() which is specific to Atheros hardware. The same
> probably applies to ath9k as well.

I for one would rather still use ieee80211_get_hdrlen_from_skb(), and the
ath5k_pad_size() helper to calculate the pad size (=0 for small control
frames).  Was there any problem with the '> 24' check?

After all we're not computing the _header_ length, just the existence
of the pad (contents of which is meaningless so can't be counted as part
of the header).

-- 
Bob Copeland %% www.bobcopeland.com
