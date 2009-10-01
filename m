Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54360 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544AbZJAMk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 08:40:28 -0400
Date: Thu, 1 Oct 2009 15:40:16 +0300
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH]: nl80211: report age of scan results
Message-ID: <20091001124016.GA17158@jm.kir.nu>
References: <200909241055.51604.hs4233@mail.mn-solutions.de> <200909280914.48847.hs4233@mail.mn-solutions.de> <20090930212123.GA8616@jm.kir.nu> <200910010957.31558.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910010957.31558.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 01, 2009 at 09:57:31AM +0200, Holger Schurig wrote:
> Hmm, what would a scan-sequence help in the case when mac80211 updates
> a BSS because of a received beacon?

I have been most interested in knowing whether the result was after the
scan request or not; not necessarily receiving during the scan request
itself.

> scan trigger, seq 5:
>   find AP 'XXX', signal -50
>   find AP 'YYY', signal -60
> scan trigger, seq 6:
>   find AP 'ZZZ', signal -55
> normal operation:
>   beacon for 'YYY' comes in, signal -45
> scan-dump:
>   get 'XXX', signal -50, seq 5
>   get 'ZZZ', signal -55, seq 6
>   get 'YYY', signal -45, but with which seq?

seq 6 based on the earlier discussion. However, there would be an option
to increment the sequence number whenever a scan is terminated, i.e.,
the move to normal operation would move to seq 7 and 'YYY' would
actually show up with seq 7 here. The scan trigger command would return
the sequence number for that particular scan (6 for the second one), so
it would be possible to notice the difference between ZZZ and YYY.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
