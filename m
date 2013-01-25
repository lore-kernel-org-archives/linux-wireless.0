Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab3AYIDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 03:03:09 -0500
Date: Fri, 25 Jan 2013 09:03:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Timo Juonoja <timo.juonoja@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ubuntu 12.10 - iwl4965 problem?
Message-ID: <20130125080305.GA2264@redhat.com> (sfid-20130125_090335_401129_D6DFF426)
References: <CAKuDoO6q5HztQHEJE_9LRwVTDj4LhvoCb922dP_-dV3P27Q7FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKuDoO6q5HztQHEJE_9LRwVTDj4LhvoCb922dP_-dV3P27Q7FA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(CC linux-wireless mailing list)

On Fri, Jan 25, 2013 at 09:01:59AM +0200, Timo Juonoja wrote:
> I have problems on maintaining the wireless connection, when it is just in
> idle state. It works better when there are traffic ongoing, but
> occasionally there are same problems on those circumstances too. I'm using
> Ubuntu 12.10 and its default 3.5 kernel. Do you happen to know what is
> causing these problems? Is there some fixes in newer kernels related to
> iwl4965 and iwlegacy?

There are very few fixes on iwlegacy between 3.5 and current upstream,
none of them look to be related with the problem. But we have lot of
changes in mac80211, which can influence driver stability, so trying
latest upstream kernel is a good idea.
 
> Here are some logs from the system:
> Jan 24 22:46:55 logger kernel: [ 8287.820071] iwl4965 0000:05:00.0: Error
> sending C_ADD_STA: time out after 500ms.
> Jan 24 22:46:55 logger kernel: [ 8287.820499] ieee80211 phy0: failed to
> remove key (0, 00:23:f8:2f:e1:a2) from hardware (-110)
> Jan 24 22:46:55 logger kernel: [ 8287.872022] iwl4965 0000:05:00.0: Queue 4
> stuck for 2000 ms.

This is firmware crash. If this still happen on latest version (i.e. 3.7
or 3.8) let me know. I'll then ask you for verbose debug messages and
will try to find out what cause the firmware crash.

Stanislaw
