Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46163 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0IODDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:03:37 -0400
Date: Tue, 14 Sep 2010 17:03:16 -1000
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
Message-ID: <20100915030316.GB30253@jm.kir.nu>
References: <4C8EB03D.7070808@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C8EB03D.7070808@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 13, 2010 at 04:14:05PM -0700, Ben Greear wrote:
> This patch aims to decrease channel switching when there is at least one
> interface associated.  This should help multiple station interfaces co-exist
> on the same hardware, especially in WPA mode.

If I understood the change correctly, it would prevent running full
scans when in associated state. That does not sound reasonable behavior
and scanning should not cause an association to be lost. Did I miss
something or what exactly is this trying to do?

If you want to limit scans a single channel in some special use cases,
you should be able to do that in user space, too, at least for the
initial scan before connection. As a future optimization, we should
somehow be able to merge scan requests from multiple VIFs into a single
one, i.e., share the results from a single scan to multiple VIFs..


PS.

It would be easier to comment on the changes if you were to inline them
instead of attaching the file..

-- 
Jouni Malinen                                            PGP id EFC895FA
