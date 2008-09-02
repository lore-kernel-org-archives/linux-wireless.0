Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:35096 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYIBNTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 09:19:10 -0400
Received: by nf-out-0910.google.com with SMTP id d3so334194nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 06:19:07 -0700 (PDT)
Date: Tue, 2 Sep 2008 16:18:58 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jan-Espen Pettersen <sigsegv@radiotube.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902131856.GC19172@google.com> (sfid-20080902_151918_277559_0BAB7733)
References: <20080901160658.GA11063@google.com> <1220319536.28282.128.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220319536.28282.128.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2008 at 09:38:56AM +0800, Zhu Yi wrote:
> On Mon, 2008-09-01 at 19:07 +0300, Michael S. Tsirkin wrote:
> > [16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
> > [16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX
> > (capab=0x411 status=0 aid=1)
> > [16482.918564] eth1: associated
> > [16492.920224] eth1: disassociating by local choice (reason=3)
> > [16492.920986] eth1: disassociating by local choice (reason=3)
> 
> It is exactly 10 seconds the local STA sends the deauth_leaving frame
> before associated everytime. I wonder if it is the timeout for some
> wireless config tools. NM?

Not network manager, I'm using wpa_supplicant.

> What did you do to make it reassociate after resume? If you are using
> some automatic config tools,

I think that resume scripts try to do is up the interface, and
network scripts run wpa supplicant (or rather, wpa_cli which talks to
wpa_supplicant).
Same thing happens if I run wpa_supplicant manually as well.

> can you try iwconfig manually instead?
> 
> Thanks,
> -yi

I could try, but I have wpa ...
-- 
MST
