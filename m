Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60762 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab0FKOqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 10:46:11 -0400
Received: by pwi1 with SMTP id 1so511944pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jun 2010 07:46:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilzHEhYgPyOnUtHk9HrOuSyyifwoI3hN6VUG1Xr@mail.gmail.com>
References: <20100611101221.26538.46913.stgit@tt-desk>
	<1276252913.3640.12.camel@jlt3.sipsolutions.net>
	<AANLkTilzHEhYgPyOnUtHk9HrOuSyyifwoI3hN6VUG1Xr@mail.gmail.com>
Date: Fri, 11 Jun 2010 10:38:15 -0400
Message-ID: <AANLkTik0Q2JM_DNaiLxc33Nn6dpI6uT52uG7b8-F4QjW@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while resetting
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 11, 2010 at 10:21 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Jun 11, 2010 at 6:41 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>
>> I have no idea how long a reset can take, but this means that all these
>> tasklets will spin while your reset is running if they were scheduled.
>
> It looks to me like tasklet_action() will bail out when the tasklet has a
> positive t->count (which disable elevates) rather than spin.  What did I
> miss?

As Johannes pointed out on irc, I missed that it re-raises the softirq.  doh!

-- 
Bob Copeland %% www.bobcopeland.com
