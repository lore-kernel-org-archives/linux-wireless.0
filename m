Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:54868 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZBFTVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 14:21:09 -0500
Received: by fk-out-0910.google.com with SMTP id f33so799093fkf.5
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2009 11:21:08 -0800 (PST)
To: "Alina Friedrichsen" <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: Remove TSF atomic requirement from the documentation
References: <20090205165834.63840@gmx.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 06 Feb 2009 21:21:05 +0200
In-Reply-To: <20090205165834.63840@gmx.net> (Alina Friedrichsen's message of "Thu\, 05 Feb 2009 17\:58\:34 +0100")
Message-ID: <87fxirpe1q.fsf@litku.valot.fi> (sfid-20090206_202114_451514_B48E1D79)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Alina Friedrichsen" <x-alina@gmx.net> writes:

> The atomic requirement for the TSF callbacks is outdated. get_tsf() is
> only called by ieee80211_rx_bss_info() which is indirectly called by
> the work queue ieee80211_sta_work(). In the same context are called
> several other non-atomic functions, too. And the atomic requirement
> causes problems for drivers of USB wifi cards.

Atomicity requirement also creates problems for SPI based devices, not
only USB. So I strongly support for removing the requirement.

Unfortunately I don't have time to review this, though. Sorry.

-- 
Kalle Valo
