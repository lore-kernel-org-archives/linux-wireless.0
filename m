Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:58546 "EHLO
	mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbbCWLkf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 07:40:35 -0400
Subject: Re: [PATCH 2/2] mwifiex: recover from skb allocation failures during RX
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: James Cameron <quozl@laptop.org>
In-Reply-To: <1427120456-6247-2-git-send-email-patila@marvell.com>
Date: Mon, 23 Mar 2015 22:11:48 +1100
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>
Message-Id: <2CA8FB7A-525E-40BB-96BD-6D25C150160D@laptop.org> (sfid-20150323_124038_730001_E6787A05)
References: <1427120456-6247-1-git-send-email-patila@marvell.com> <1427120456-6247-2-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 24/03/2015, at 1:20 AM, Avinash Patil wrote:

> From: Zhaoyang Liu <liuzy@marvell.com>
> 
> This patch adds recovery mechanism for SDIO RX during SKB allocation
> failures.
> For allocation failures during multiport aggregation, we skip and drop RX
> packets.
> For single port read case, we will use preallocated card->mpa_rx.buf to
> complete cmd53 read.

Thanks.

Dropping RX data packets is considered safe, as the peer will retry; but does your patch drop events or command responses?  

Last year, I tried something similar, and I found that the driver would be confused if command responses were dropped.

--
James Cameron

