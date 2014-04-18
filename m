Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:41732 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaDRExc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 00:53:32 -0400
Date: Fri, 18 Apr 2014 14:46:19 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: John Tobias <john.tobias.ph@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
Message-ID: <20140418044619.GF24166@us.netrek.org> (sfid-20140418_065336_464233_BB9299CB)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 17, 2014 at 04:33:58PM -0700, Bing Zhao wrote:
> Hi John,
> 
> > Hi Bing,
> > 
> > Assuming the timeout happened due to a firmware bug. Does the
> > firmware able to recover after setting adapter->cmd_sent = false
> > and the firmware could accept a new commands without locking?.
> 
> That "adapter->cmd_sent = false" was hoping the firmware is still
> alive and can respond to a new command. The reality is that the
> timeout usually indicates the firmware has already hung. Sending
> another command won't recover it in this case.

I'm dealing with a firmware hang when more than 13 nodes are in an
ad-hoc IBSS, and I've just found out isn't entirely a firmware hang;
in that we can see beacons and probe responses from the card, using
tcpdump and monitor mode.

I'm interested to know if the "firmware hangs" that you experiment
with prevent autonomous RF TX, or if RF TX typically proceeds.

> I guess you are using SDIO chip. If your host controller supports
> MMC_POWER_OFF/UP, you can reset the chip with this approach:
> 
>         mmc_remove_host(host);
>         /* some delay */
>         mmc_add_host(host);

Thanks, adding that to my list of things to try, as I am using SDIO too.

-- 
James Cameron
http://quozl.linux.org.au/
