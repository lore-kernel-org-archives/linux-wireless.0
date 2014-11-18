Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-hk1hn0124.outbound.protection.outlook.com ([134.170.140.124]:53843
	"EHLO APAC01-HK1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753680AbaKRJIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 04:08:06 -0500
From: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>
To: Bob Copeland <me@bobcopeland.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] mac80211: Send peering open frame again if beacon
 from listen state peer is received
Date: Tue, 18 Nov 2014 08:52:11 +0000
Message-ID: <2EB4F5C65A3B8E4E92660930F4EF6B5B06AB00@JPYOKXMS113.jp.sony.com> (sfid-20141118_100812_277483_353907E6)
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B069684@JPYOKXMS113.jp.sony.com>
 <20141117133418.GG11482@localhost>
In-Reply-To: <20141117133418.GG11482@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The subject doesn't really match what this does.  I would also describe
> the new kernel behavior in the commit log in addition to the motivation.
> 
> Maybe something like this:

Thank you for your comment. I will change the subject and the commit log.

> From a cursory glance I think this needs to be GFP_ATOMIC -- don't you get
> lockdep warnings?  (If not, make sure CONFIG_PROVE_LOCKING is enabled, and
> that you aren't hitting other lockdep warnings prior to this code running.)
> This code is in an RCU read critical section as far as I can tell.

Yes, this should be GFP_ATOMIC. I will change.

