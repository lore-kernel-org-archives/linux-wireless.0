Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50719 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbbC3IxN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:53:13 -0400
From: Avinash Patil <patila@marvell.com>
To: James Cameron <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Zhaoyang Liu <liuzy@marvell.com>
Date: Mon, 30 Mar 2015 01:52:49 -0700
Subject: RE: [PATCH 2/2] mwifiex: recover from skb allocation failures
 during RX
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC689F4C7999@SC-VEXCH2.marvell.com> (sfid-20150330_105317_514921_C3DE85C3)
References: <1427120456-6247-1-git-send-email-patila@marvell.com>
 <1427120456-6247-2-git-send-email-patila@marvell.com>
 <2CA8FB7A-525E-40BB-96BD-6D25C150160D@laptop.org>
In-Reply-To: <2CA8FB7A-525E-40BB-96BD-6D25C150160D@laptop.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> -----Original Message-----
> From: James Cameron [mailto:quozl@laptop.org]
> Sent: Monday, March 23, 2015 4:42 PM
> To: Avinash Patil
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Zhaoyang Liu
> Subject: Re: [PATCH 2/2] mwifiex: recover from skb allocation failures during
> RX
> 
> 
> On 24/03/2015, at 1:20 AM, Avinash Patil wrote:
> 
> > From: Zhaoyang Liu <liuzy@marvell.com>
> >
> > This patch adds recovery mechanism for SDIO RX during SKB allocation
> > failures.
> > For allocation failures during multiport aggregation, we skip and drop
> > RX packets.
> > For single port read case, we will use preallocated card->mpa_rx.buf
> > to complete cmd53 read.
> 
> Thanks.
> 
> Dropping RX data packets is considered safe, as the peer will retry; but does
> your patch drop events or command responses?
> 
> Last year, I tried something similar, and I found that the driver would be
> confused if command responses were dropped.

RX packets only would be dropped after SKB allocation failures.
Command response/events continue to have same handling as earlier.

> --
> James Cameron

-Avinash
