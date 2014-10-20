Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59747 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaJTJlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:41:03 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.55536.308167.684155@gargle.gargle.HOWL> (sfid-20141020_114114_947318_28D77153)
Date: Mon, 20 Oct 2014 15:12:08 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
In-Reply-To: <1413797588.10246.3.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Those commits say they *fix* the race though, so in case I was wrong you
> should report the sequence of events so we can look at fixing it
> properly?

The commits fix both the issues (use-after-free, new scan) correctly,
so I don't see a race ? If the driver is slow in notifying scan completion
and the interface is removed in the meantime, this warning is hit.

Sujith
