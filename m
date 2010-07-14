Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0GNRgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 13:36:51 -0400
Subject: Re: commit 062bee448bd539580ef9f64efe50fdfe04eeb103 broke my
 iwlagn 5100
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Florian Klink <flokli@flokli.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1279128461.19725.34.camel@wwguy-ubuntu>
References: <1279100021.7275.24.camel@flokli-laptop>
	 <1279101655.3719.12.camel@jlt3.sipsolutions.net>
	 <e5d3a4df03d6582ddc18af249ed3a2f2@imap.flokli.de>
	 <1279121328.19725.27.camel@wwguy-ubuntu>
	 <2af581f49d0d7786326de05682b92382@imap.flokli.de>
	 <1279128461.19725.34.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 19:36:45 +0200
Message-ID: <1279129005.3723.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-14 at 10:27 -0700, Guy, Wey-Yi wrote:
> Johannes,
> 
> On Wed, 2010-07-14 at 09:36 -0700, Florian Klink wrote:
> > Hi,
> > 
> > I did a dmesg with 2.6.35-rc5 and debug=0x43fff.
> > You can get it here: http://pastebin.com/Q6eCdPZR
> 
> > 
> > 
> based on the log sent by Florian, I did not see bss_info_change with
> current BSSID from mac80211. any thought?
> 
> I am expected to see something like this,
> 
> [165796.572969] ieee80211 phy3: U iwl_bss_info_changed changes =
> 0xFD                                                                    
> [165796.572972] ieee80211 phy3: U iwl_bss_info_changed BSSID
> 00:25:9c:d0:9f:e1                                                           
> [165796.572976] ieee80211 phy3: U iwl_bss_info_changed ERP_PREAMBLE 1 

That'd only happen _after_ association, not before, and assoc fails
here.

johannes

