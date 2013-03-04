Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3CDUMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:12:10 -0500
Message-ID: <1362427924.21028.42.camel@jlt4.sipsolutions.net> (sfid-20130304_211233_799503_2E402851)
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 04 Mar 2013 21:12:04 +0100
In-Reply-To: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com> (sfid-20130304_193023_644988_D3BD7FD9)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130304_193023_644988_D3BD7FD9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Currently it gets it from the sdata. This uses and updates the ad-hoc
> masks of the ieee80211_tx_rate_control instead of copying them.

Is there any need to update them?

The change for "mask" seems to make it less efficient since it could
otherwise be put into a register.

johannes

