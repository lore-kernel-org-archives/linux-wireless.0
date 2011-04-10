Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20751 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab1DJPte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 11:49:34 -0400
Subject: Re: [PATCH 03/16] iwlagn: fix radar frame rejection
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Tamrazian, GarenX" <garenx.tamrazian@intel.com>
In-Reply-To: <1302423305.3519.3.camel@jlt3.sipsolutions.net>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1302276636-12802-4-git-send-email-wey-yi.w.guy@intel.com>
	 <1302423305.3519.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 08:29:37 -0700
Message-ID: <1302449377.14995.128.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-10 at 01:15 -0700, Johannes Berg wrote:
> On Fri, 2011-04-08 at 08:30 -0700, Wey-Yi Guy wrote:
> > From: Garen Tamrazian <garenx.tamrazian@intel.com>
> > 
> > The microcode may sometimes reject TX frames when
> > on a radar channel even after we associated as it
> > clears information during association and needs to
> > receive a new beacon before allowing that channel
> > again. This manifests itself as a TX status value
> > of TX_STATUS_FAIL_PASSIVE_NO_RX. So in this case,
> > stop the corresponding queue and give the frame
> > back to mac80211 for retransmission. We start the
> > queue again when a beacon from the AP is received
> > which will make the regulatory enforcement in the
> > device allow transmitting again.
> 
> It'd be nice to have this in .39 as well

Agree, John, would you like me to re-submit

Wey

