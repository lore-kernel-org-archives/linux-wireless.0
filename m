Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:38394 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab2DYGeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:34:22 -0400
Date: Wed, 25 Apr 2012 09:08:53 +0300
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Strange problem with ath9k and ASUS N66U AP.
Message-ID: <20120425060853.GA3324@w1.fi> (sfid-20120425_083425_402120_BBCAE1A6)
References: <4F972E3F.4020609@candelatech.com>
 <4F97449F.5040505@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F97449F.5040505@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2012 at 05:26:07PM -0700, Ben Greear wrote:
> On 04/24/2012 03:50 PM, Ben Greear wrote:
> > I am trying some ath9k virtual clients against an ASUS N66U.

> > Here is part of the N66U wifi log showing that it
> > thinks sta11 is not authorized:
> >
> > 00:95:95:00:00:0C  associated
> > 00:95:95:00:00:0D  associated authorized

> Here's a better log.  Makes me think supplicant might be at fault???

Looks more like an AP bug to me..

> sta8 failed, sta9 works fine.  The difference appears to be the extra
> RX EAPOL packet that sta8 receives...

> 1335313181.999422: sta8: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
> 1335313181.999465: sta8: WPA: Sending EAPOL-Key 4/4

> 1335313182.063695: sta8: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
> 1335313182.063745: sta8: WPA: Sending EAPOL-Key 4/4

Either the AP did not receive the first EAPOL-Key 4/4 or processed it
only after retransmitting 3/4. Supplicant side will need to to reply to
retransmitted 3/4 to complete the 4-way handshake. If the AP received
either of these 4/4 messages, it should be fine with the result. If it
didn't receive either, it should disconnect the station. It does not
look like either of those happened.

-- 
Jouni Malinen                                            PGP id EFC895FA
