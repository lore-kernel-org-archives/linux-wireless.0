Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17441 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3H1EXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 00:23:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ath10k: synchronize tx/rx reporting to mac80211
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 28 Aug 2013 07:23:27 +0300
In-Reply-To: <1377507205-5386-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 26 Aug 2013 10:53:22 +0200")
Message-ID: <87txiajveo.fsf@kamboji.qca.qualcomm.com> (sfid-20130828_062336_072424_E14D7EE7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> According to mac80211 docs tx and rx reporting
> routines must not run concurrently unless they are
> _irqsafe variants.
>
> This doesn't fix any visible bug but is apparently
> the right thing to do as per the documentation.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I had a quick chat with Johannes and Sujith about this. The concurrency
requirements are for the STA PS race in AP mode (see
ieee80211_handle_filtered_frame()).

I think we should drop this frame, revisit later and properly analyse
how to fix the race. But it would be good add this to the todo list:

http://wireless.kernel.org/en/users/Drivers/ath10k#TODO

-- 
Kalle Valo
