Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56465 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0FKOVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 10:21:11 -0400
Received: by gye5 with SMTP id 5so694794gye.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jun 2010 07:21:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276252913.3640.12.camel@jlt3.sipsolutions.net>
References: <20100611101221.26538.46913.stgit@tt-desk>
	<1276252913.3640.12.camel@jlt3.sipsolutions.net>
Date: Fri, 11 Jun 2010 10:21:10 -0400
Message-ID: <AANLkTilzHEhYgPyOnUtHk9HrOuSyyifwoI3hN6VUG1Xr@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while resetting
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 11, 2010 at 6:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:

> I have no idea how long a reset can take, but this means that all these
> tasklets will spin while your reset is running if they were scheduled.

It looks to me like tasklet_action() will bail out when the tasklet has a
positive t->count (which disable elevates) rather than spin.  What did I
miss?

-- 
Bob Copeland %% www.bobcopeland.com
