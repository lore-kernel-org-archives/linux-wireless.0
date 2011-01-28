Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab1A1Q1V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:27:21 -0500
Date: Fri, 28 Jan 2011 17:27:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/8] iwlwifi: do not set tx power when channel is changing
Message-ID: <20110128162714.GD2452@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
 <1296230595.7388.4.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296230595.7388.4.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Jan 28, 2011 at 08:03:15AM -0800, wwguy wrote:
> On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> > Mac80211 can request for tx power and channel change in one ->config
> > call. If that happens, *_send_tx_power functions will try to setup tx
> > power for old channel, what can be not correct because we already change
> > the band. I.e  error  "Failed to get channel info for channel 140 [0]",
> > can be printed frequently when operating in software scanning mode.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
> >  drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
> >  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 ++---
> >  drivers/net/wireless/iwlwifi/iwl-core.c     |   13 ++++++++++---
> >  4 files changed, 14 insertions(+), 8 deletions(-)
> > 
> 
> Do you have a bugzilla bug being addressed by this patch?

No, I found this issue by myself testing, I don't know if
patch address any bugzilla report.

Stanislaw
