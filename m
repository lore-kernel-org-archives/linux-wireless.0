Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49954 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427Ab1CYDdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 23:33:15 -0400
Received: by pvg12 with SMTP id 12so88246pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 20:33:15 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19852.3238.455471.399990@gargle.gargle.HOWL>
Date: Fri, 25 Mar 2011 09:01:50 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, Jouni.Malinen@atheros.com
Subject: Re: [PATCH 1/3] ath9k: fix beacon timer handling issues
In-Reply-To: <4D8C0512.5010608@openwrt.org>
References: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
	<19852.783.629604.122760@gargle.gargle.HOWL>
	<4D8C0512.5010608@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> The HW TSF reset was still issued before the code would activate the
> timers (with the write to AR_TIMER_MODE), so I don't think this changes
> the behaviour of the timers.
> Since the timers are scheduled for absolute TSF32 values and (in case of
> a reset being issued) always set to TU_TO_USEC(intval / ATH_BCBUF), that
> leaves enough time for the timers to settle in after the TSF reset, so I
> don't expect any race conditions there.

Hm, alright.

Sujith
