Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab1BNMkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:40:40 -0500
Date: Mon, 14 Feb 2011 13:40:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] iwl3945: use software scanning by default
Message-ID: <20110214124022.GA14827@redhat.com>
References: <1297172211-17448-1-git-send-email-sgruszka@redhat.com>
 <1297685299.3785.32.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297685299.3785.32.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 01:08:19PM +0100, Johannes Berg wrote:
> On Tue, 2011-02-08 at 14:36 +0100, Stanislaw Gruszka wrote:
> > Looking for some more testing and opinions.
> > 
> > Patch fixes:
> > https://bugzilla.redhat.com/show_bug.cgi?id=671366
> > and probably some other "very poor performance" bugs reported
> > elsewhere.
> > 
> > Sometimes after hardware scanning device is unable to receive frames
> > at higher rate, what cause that very slow speed is observed by the users.
> 
> Is there any more information about this problem?

Only valuable data we have is on above bugzilla report:
- messages with IWL_DEBUG_SCAN and some other flags:
  https://bugzilla.redhat.com/attachment.cgi?id=476229
- wireshark capture:
  https://bugzilla.redhat.com/attachment.cgi?id=476614

There is lots of ubuntu users discussion here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/621265?comments=all 
Most important information there is that removing plcp check
and/or not using NetworkManager helps (both triggers scans).

Stanislaw

