Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3KLUK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 15:10:29 -0500
Message-ID: <1384287024.14301.11.camel@jlt4.sipsolutions.net> (sfid-20131112_211032_964437_735F8F31)
Subject: Re: Association often fails first time when roaming with 802.11r.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 12 Nov 2013 21:10:24 +0100
In-Reply-To: <52828A27.1040103@candelatech.com>
References: <52828324.3060105@candelatech.com>
	 <1384285594.14301.10.camel@jlt4.sipsolutions.net>
	 <52828A27.1040103@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 12:05 -0800, Ben Greear wrote:
> A more correct roam also takes about 150ms, but at least not because of the
> error in my previous email.  Seems it takes it 100+ms to go if-up after
> the assoc-request is sent.  I'll go dig into that further.

The interface is already up (has to be to authenticate), the event you
get at that point (just after the ~110ms delay) is for LOWER_UP really -
which means carrier_on() in the kernel I believe. At that point you'd
need kernel level tracing or messages to investigate.

Maybe something is waiting for a beacon there?

johannes

