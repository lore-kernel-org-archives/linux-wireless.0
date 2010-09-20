Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35297 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab0ITOTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 10:19:32 -0400
Received: by iwn5 with SMTP id 5so4307682iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 07:19:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284983140-30099-2-git-send-email-nbd@openwrt.org>
References: <1284983140-30099-1-git-send-email-nbd@openwrt.org> <1284983140-30099-2-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 20 Sep 2010 07:19:11 -0700
Message-ID: <AANLkTinRQsy3JZ5yr_9xjPhFA3Mez5ewV1V+R1dN3yen@mail.gmail.com>
Subject: Re: [PATCH 2/5] ath9k: fix an aggregation start related race condition
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 20, 2010 at 4:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> A new aggregation session start can be issued by mac80211, even when the
> cleanup of the previous session has not completed yet. Since the data structure
> for the session is not recreated, this could corrupt the block ack window
> and lock up the aggregation session. Fix this by delaying the new session
> until the old one has been cleaned up.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org

Any reason to not fix this in mac80211 instead?

  Luis
