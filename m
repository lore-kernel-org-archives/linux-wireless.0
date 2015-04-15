Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38653 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbbDOJCK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 05:02:10 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Wed, 15 Apr 2015 02:01:44 -0700
Subject: RE: [PATCH] mwifiex: increase number of probes for specific SSID
 scans
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFC138@SC-VEXCH1.marvell.com> (sfid-20150415_110215_682682_D608A456)
References: <1429022956-12016-1-git-send-email-akarwar@marvell.com>
 <20150414203724.GB32455@us.netrek.org>
In-Reply-To: <20150414203724.GB32455@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> 
> On Tue, Apr 14, 2015 at 07:49:16AM -0700, Amitkumar Karwar wrote:
> > It's been observed that device sometimes fails to find AP configured
> > in hidden SSID in busy environment. We will increase number of probes
> > for specific SSID scans for getting better results.
> 
> I don't like this.  It worries me.  What is the underlying cause?  If it
> is something other than collision, why?
> 

Idea was to have better chance of finding an AP configured with hidden SSID when environment is busy by sending multiple probe requests.

> In scenario of tens to a hundred laptops scanning for specific SSID for
> ad-hoc in the Sugar desktop environment, this patch may decrease free
> air time considerably.

You are right. Free air time will be decreased. We have discarded this approach considering its consequences. 

> 
> Should the number of probes be a choice of user space?
> 

Do you see any potential use case for multiple probe requests? 
I think, we should stick to current implementation of sending 1 probe request.

Regards,
Amitkumar
