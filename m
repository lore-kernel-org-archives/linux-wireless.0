Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33461 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab1ESObZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 10:31:25 -0400
Date: Thu, 19 May 2011 10:18:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: unify edma and non-edma tx code, improve tx
 fifo handling
Message-ID: <20110519141858.GD2575@tuxdriver.com> (sfid-20110519_163128_610174_AEDC6751)
References: <1305719964-44292-1-git-send-email-nbd@openwrt.org>
 <20110518190733.GA2543@tuxdriver.com>
 <4DD4DC13.5020006@openwrt.org>
 <4DD52555.8020300@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4DD52555.8020300@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 19, 2011 at 09:12:37AM -0500, Larry Finger wrote:
> On 05/19/2011 04:00 AM, Felix Fietkau wrote:
> >On 2011-05-18 9:07 PM, John W. Linville wrote:
> >>CC [M] drivers/net/wireless/ath/ath9k/xmit.o
> >>drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_edma_tasklet’:
> >>drivers/net/wireless/ath/ath9k/xmit.c:2199:18: warning: ‘txq’ may be used
> >>uninitialized in this function
> >>
> >>Please don't add warnings, especially not valid ones... :-)
> >Odd, I wonder why my compiler didn't show me this warning when I worked on the
> >patch, need to check my CFLAGS :)
> 
> If you figure out the CFLAGS needed to show the warnings, please
> share that information with the list.

There really is an issue here -- it's like the gcc folks have added a
randomize function to change the warnings generated between different
versions (or even different compiles of the same version) of their
compiler...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
