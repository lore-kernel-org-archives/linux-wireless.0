Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546AbYHFU6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 16:58:38 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <4899FB91.8070501@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
	 <1217976491.2908.36.camel@dv>
	 <1218028414.16977.5.camel@localhost.localdomain>
	 <4899FB91.8070501@gmail.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 16:56:05 -0400
Message-Id: <1218056165.12240.0.camel@localhost.localdomain> (sfid-20080806_225854_274890_4C4BE979)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-08-06 at 20:29 +0100, Dave wrote:
> Dan Williams wrote:
> > On Tue, 2008-08-05 at 18:48 -0400, Pavel Roskin wrote:
> >> The userspace is welcome to keep a pool of all APs found by any scans,
> >> but I don't think drivers should do it.
> > 
> > Drivers need to keep a reasonably complete list of APs internally for
> > association anyway.  You don't want to have to do a full scan just to
> > associate if you have results from 10 seconds ago that are still valid.
> 
> This is not an issue for orinoco cards, as the firmware selects the AP to use independently of any driver scanning. The requirement to use ap_scan=2 means that wpa_supplicant doesn't need to look at the scan results either (except maybe to verify the configuration matches).

Well, since the driver supports SSID scanning, we can use ap_scan=1
anyway.  ap_scan=2 is actually pretty evil since it depends on WEXT
ordering and whatnot.

Dan

> > Furthermore, drivers need to keep cached results so that two processes
> > can request results of a scan after the scan is complete.
> 
> But this does apply to orinoco.
> 
> 
> Regards,
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

