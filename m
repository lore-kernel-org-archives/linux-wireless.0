Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53041 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJQBbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 21:31:15 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21568.29077.518022.812356@gargle.gargle.HOWL> (sfid-20141017_033128_096362_B8AFEFAF)
Date: Fri, 17 Oct 2014 07:02:05 +0530
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
In-Reply-To: <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
> It is not really my business, but how come this happen with ath9k?
> The scan should be cancelled before the interface is removed. You mean
> that the scan cancellation is
> asynchronous and the notification of the cancellation termination can
> come after the cfg80211 has removed
> the interface?

Yes, the scan cancellation is initiated on interface removal,
but it's async. These commits explain the race:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/wireless/core.c?id=a617302c531eaf497ccd02a61d380efc119ba999
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/wireless/core.c?id=f9d15d162b3acf28f85b3ac05c4883e5ed588d28

We see it often with ath9k on a low-powered board, with
a 'state manager' that plays with the interfaces.

Sujith
