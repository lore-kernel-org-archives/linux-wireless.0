Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53061 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaJTK0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:26:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.58249.490532.207564@gargle.gargle.HOWL> (sfid-20141020_122629_033759_85FDFBFF)
Date: Mon, 20 Oct 2014 15:57:21 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
In-Reply-To: <1413798712.10246.14.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
	<21572.55536.308167.684155@gargle.gargle.HOWL>
	<1413798712.10246.14.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> But the driver can/should just do it when the interface is removed from
> it? Otherwise it has no valid way to run/continue the scan anyway?

cancel_hw_scan() is called before remove_interface() and if the
interface is removed in cfg80211 before __cfg80211_scan_done() gets
a chance to run, then this warning is hit.

a617302c531eaf497ccd02a61d380efc119ba999 mentions that the work item
cannot be flushed and prevents a use-after-free crash.

Sujith
