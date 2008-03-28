Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbYC1GRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 02:17:46 -0400
Date: Thu, 27 Mar 2008 23:16:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [PATCH 13/18] mac80211: mesh statistics and config through
 debugfs
Message-Id: <20080327231639.fd1264b9.akpm@linux-foundation.org> (sfid-20080328_061751_083154_B541869D)
In-Reply-To: <20080223142015.478371000@sipsolutions.net>
References: <20080223141703.194775000@sipsolutions.net>
	<20080223142015.478371000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 23 Feb 2008 15:17:16 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:

> 
> This patch contains the debugfs code for mesh statistics and configuration
> parameters. Please note that generic support for r/w debugfs attributes has been
> added.

y'know, we have carefully developed all this lovely runtime self-checking
code in the kernel which can catch all sorts of common errors and yet it's
a continual struggle to get kernel developers *of all people* to actually
TURN THE DAMN THINGS ON.

So.  I would ask everyone who "tested" this patch to

- read Documentation/SubmitChecklist

- suitable modify your .config

- SAVE A COPY OF THE THING!!!!!

- then fix the obvious, trivial, instantly-detectable, very-deadlockable
  bug in this patch.  There is just no longer any excuse for this:

+	read_lock(&dev_base_lock);
+	if (copy_from_user(buf, userbuf, buf_size))


Thanks.



There's also a question regarding review quality - I spotted that bug the
instant I looked at the patch.   It's not exactly subtle.
