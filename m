Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64321 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1AGUMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:12:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 12:11:49 -0800
Date: Fri, 7 Jan 2011 12:12:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH v2 3/3] ath9k: Keep track of stations for
 debugfs.
Message-ID: <20110107201204.GG21588@tux>
References: <1294375752-3946-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1294375752-3946-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 06, 2011 at 08:49:12PM -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The stations hold the ath_node, which holds the tid
> and other xmit logic structures.  In order to debug
> stuck xmit logic, we need a way to print out the tid
> state for the stations.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v1 -> v2:  Use linked list instead of array.  Protect with spinlock.

Again, see my comments about the # STAs limit. I think this can go in
as a cfg80211 driver limitation which can be exposed. If you want to go
over the supported number (known to work, safe, call it what you want)
then a kconfig option can be used.

  Luis
