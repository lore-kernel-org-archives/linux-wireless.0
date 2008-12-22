Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:30604 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYLVUa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 15:30:58 -0500
Received: by yw-out-2324.google.com with SMTP id 9so766730ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 12:30:56 -0800 (PST)
Message-ID: <43e72e890812221230y11fcf0b8pf018f5ff332a733d@mail.gmail.com> (sfid-20081222_213102_392206_CC040885)
Date: Mon, 22 Dec 2008 12:30:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 00/18] ath9k: first series for regulatory cleanup
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
In-Reply-To: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 10:20 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This is the first series of general cleanup to get us into
> abandon our complex internal regulatory infrastructure. This is
> quite a lot of work as we rely on our own internal "mode" stuff
> and our own ath9k_channel heavily.
>
> We start this work by ditching the mode stuff where we can
> and set a staging ground for us to abandon our own internal
> ath9k_channel. The values which we want to actually keep from
> ath9k_channel are the calibration data. Since it seems other
> drivers can make use of this we add a priv section to
> ieee80211_channel and start making use of this in ath9k.

John,

I will go back and try to redo this series without the channel->priv
addition as the calibration data is band specific so in reality there
should be no need to have a private section per channel for
calibration that I can see so far. Additionally as Johannes has
pointed out to me we should be able to index into our own tables for
whatever private data later once we have a static declaration of the
channels.

  Luis
