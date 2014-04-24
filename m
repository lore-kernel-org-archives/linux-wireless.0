Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39638 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbaDXH21 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 03:28:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: John Tobias <john.tobias.ph@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Date: Thu, 24 Apr 2014 00:28:02 -0700
Subject: RE: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout
 handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F70A2AB63@SC-VEXCH1.marvell.com> (sfid-20140424_092831_928679_360A4A2C)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
 <20140419003410.GB14606@us.netrek.org> <20140424061137.GN1947@us.netrek.org>
In-Reply-To: <20140424061137.GN1947@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > > I'm interested to know if the "firmware hangs" that you experiment
> > > > with prevent autonomous RF TX, or if RF TX typically proceeds.
> > >
> > > It depends. Even if firmware hangs the hardware is still alive.
> > > So you could see beacons and probe responses from the card if
> > > hardware has been programmed before firmware hangs.
> >
> > Thanks.  I neglected to mention the time period; beacons and probe
> > responses are seen for many minutes after the timeout report by the
> > driver, and I have not yet tested for how long this lasts.  The probe
> > responses are in reply to new probe requests.  It makes me think the
> > card is working fine, apart from not communicating with the host.
> 
> Downgrading wireless firmware to 14.66.9.p80 has fixed this problem.

Wow! It means that p96 firmware had introduced the problem.

Thanks,
Bing

