Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3JALGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:06:39 -0400
Message-ID: <1380625596.14430.20.camel@jlt4.sipsolutions.net> (sfid-20131001_130642_969589_542ABF95)
Subject: Re: [PATCH 1/4] nl80211: allow CAC only if no operation is going on
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 01 Oct 2013 13:06:36 +0200
In-Reply-To: <1378230201-25446-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1378230201-25446-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 19:43 +0200, Simon Wunderlich wrote:
> A CAC should fail if it is triggered while the interface is already
> running.

Applied, though this is a bit questionable - it forces every driver
implementing this to have the same carrier semantics as mac80211. That
might very well be a good thing, but those semantics aren't really
documented.

johannes

