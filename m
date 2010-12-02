Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57118 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab0LBTaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 14:30:11 -0500
Date: Thu, 2 Dec 2010 14:17:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, Stable <stable@kernel.org>,
	Kyungwan Nam <Kyungwan.Nam@atheros.com>
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
Message-ID: <20101202191705.GB2358@tuxdriver.com>
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
 <4CF6A8FD.6020508@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CF6A8FD.6020508@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 01, 2010 at 11:58:53AM -0800, Ben Greear wrote:
> On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
> >AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
> >this status for MIC failed frames is buggy.
> >
> >Due to this, MIC failure events for broadcast frames are not sent to
> >supplicant resulted in AP disconnecting the STA.
> >
> >Able to pass Wifi Test case 5.2.18 with this fix.
> 
> Please do not apply this yet.  As far as I can tell, either
> of these patches breaks multiple VIF scenarios.  I'm not
> sure exactly why, but I had to revert this to get any
> of my interfaces to associate.

I'm reverting v1 and ignoring v2 on the basis of this report.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
