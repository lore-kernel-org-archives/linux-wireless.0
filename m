Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:60020 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaDXGL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 02:11:58 -0400
Date: Thu, 24 Apr 2014 16:11:37 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: John Tobias <john.tobias.ph@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
Message-ID: <20140424061137.GN1947@us.netrek.org> (sfid-20140424_081751_403311_87CF15DF)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
 <20140419003410.GB14606@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140419003410.GB14606@us.netrek.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 19, 2014 at 10:34:10AM +1000, James Cameron wrote:
> On Fri, Apr 18, 2014 at 12:16:07PM -0700, Bing Zhao wrote:
> > Hi James,
> > 
> > > > That "adapter->cmd_sent = false" was hoping the firmware is
> > > > still alive and can respond to a new command. The reality is
> > > > that the timeout usually indicates the firmware has already
> > > > hung. Sending another command won't recover it in this case.
> > > 
> > > I'm dealing with a firmware hang when more than 13 nodes are in
> > > an ad-hoc IBSS, and I've just found out isn't entirely a
> > > firmware hang; in that we can see beacons and probe responses
> > > from the card, using tcpdump and monitor mode.
> > > 
> > > I'm interested to know if the "firmware hangs" that you
> > > experiment with prevent autonomous RF TX, or if RF TX typically
> > > proceeds.
> > 
> > It depends. Even if firmware hangs the hardware is still alive.
> > So you could see beacons and probe responses from the card if
> > hardware has been programmed before firmware hangs.
> 
> Thanks.  I neglected to mention the time period; beacons and probe
> responses are seen for many minutes after the timeout report by the
> driver, and I have not yet tested for how long this lasts.  The
> probe responses are in reply to new probe requests.  It makes me
> think the card is working fine, apart from not communicating with
> the host.

Downgrading wireless firmware to 14.66.9.p80 has fixed this problem.

-- 
James Cameron
http://quozl.linux.org.au/
