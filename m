Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2EUT0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 15:26:45 -0400
Message-ID: <1337628372.11626.0.camel@jlt3.sipsolutions.net> (sfid-20120521_212649_165231_09AF5C14)
Subject: Re: [PATCH] CHROMIUMOS: mac80211: Increase retry attempts for
 nullfunc probes
From: Johannes Berg <johannes@sipsolutions.net>
To: Gary Morain <gmorain@chromium.org>
Cc: linux-wireless@vger.kernel.org, pstew@chromium.org
Date: Mon, 21 May 2012 21:26:12 +0200
In-Reply-To: <20120521190547.3E23A8061C@gary-pc2.mtv.corp.google.com> (sfid-20120521_211238_622219_A4B464A6)
References: <20120521190547.3E23A8061C@gary-pc2.mtv.corp.google.com>
	 (sfid-20120521_211238_622219_A4B464A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 13:49 -0700, Gary Morain wrote:
> When a nullfunc probe fails for lack of an ACK, it is retried
> almost immediately.  The current setting of 2 retries completes
> in about 4 ms.  If an AP is off-channel scanning, this is not
> enough time for the AP to return to the operating channel and
> ACK the nullfunc.  As a result, the client disconnects when the
> AP is still there and operating.

AP is off-channel, scanning? It can't be unless it's a GO and then you
have GO powersave, right?

> -static int max_nullfunc_tries = 2;
> +static int max_nullfunc_tries = 100;

100? That seems insanely high compared to the other one.

johannes

