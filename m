Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62229 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3KTMxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 07:53:34 -0500
Received: from fb07-iapwap2.localnet ([134.176.19.122]) by mail.gmx.com
 (mrgmx003) with ESMTPSA (Nemesis) id 0M3j17-1VRixP35Jh-00rDie for
 <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 13:53:30 +0100
From: Marc Dietrich <marvin24@gmx.de>
To: users@rt2x00.serialmonkey.com
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 3.12] rt2800usb: slow down TX statuspolling
Date: Wed, 20 Nov 2013 13:53:29 +0100
Message-ID: <1413247.TRgdXSqTuO@fb07-iapwap2> (sfid-20131120_135343_570663_AC2F802E)
In-Reply-To: <526243C2.7090607@gmail.com>
References: <20131017100431.GA9603@redhat.com> <20131018094238.GA7506@redhat.com> <526243C2.7090607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 19. Oktober 2013, 10:33:06 schrieb Gertjan van Wingerde:
> On 10/18/13 11:42, Stanislaw Gruszka wrote:
> > On Thu, Oct 17, 2013 at 09:39:06AM -0500, Larry Finger wrote:
> >> I suggest getting rid of the magic numbers as long as you are making
> >> this change. A single define could handle the delay time for the two
> >> cases.
> > 
> > Thanks for sugestion Larry, though I do not see clear benefit of
> > introduce define since those magic numbers are just time values
> > expressed in nano seconds. Anyway patch with define added below.
> > John can pick it, if he thinks it is better.
> > 
> > Stanislaw
> > ---
> > From 813e0bde7340bad7d3401c6aa2a3f8635ec49597 Mon Sep 17 00:00:00 2001
> > From: Stanislaw Gruszka <sgruszka@redhat.com>
> > Date: Fri, 18 Oct 2013 11:36:54 +0200
> > Subject: [PATCH] rt2800usb: slow down TX status polling
> > 
> > Polling TX statuses too frequently has two negative effects. First is
> > randomly peek CPU usage, causing overall system functioning delays.
> > Second bad effect is that device is not able to fill TX statuses in
> > H/W register on some workloads and we get lot of timeouts like below:
> > 
> > ieee80211 phy4: rt2800usb_entry_txstatus_timeout: Warning - TX status
> > timeout for entry 7 in queue 2 ieee80211 phy4:
> > rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 7
> > in queue 2 ieee80211 phy4: rt2800usb_txdone: Warning - Got TX status for
> > an empty queue 2, dropping
> > 
> > This not only cause flood of messages in dmesg, but also bad throughput,
> > since rate scaling algorithm can not work optimally.
> > 
> > In the future, we should probably make polling interval be adjusted
> > automatically, but for now just increase values, this make mentioned
> > problems gone.
> > 
> > Resolve:
> > https://bugzilla.kernel.org/show_bug.cgi?id=62781
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> I don't care which version gets picked. In both cases:
> 
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

did this ever hit a stable queue? 

Marc

