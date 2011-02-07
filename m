Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1BGPf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:35:27 -0500
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Fry, Donald H" <donald.h.fry@intel.com>
Date: Mon, 7 Feb 2011 07:35:26 -0800
Subject: RE: [PATCH wireless-2.6.38] iwlagn: Re-enable RF_KILL interrupt
 when down
Message-ID: <E9954878DD1FB34FAE5187FB88C58A35013A610604@orsmsx506.amr.corp.intel.com>
References: <1297013385-9918-1-git-send-email-wey-yi.w.guy@intel.com>
 <20110207101123.GA2319@redhat.com>
In-Reply-To: <20110207101123.GA2319@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 09:29:45AM -0800, Wey-Yi Guy wrote:
> From: Don Fry <donald.h.fry@intel.com>
> 
> With commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 only one RF_KILL
> interrupt will be seen by the driver when the interface is down.
> 
> Re-enable the interrupt when it occurs to see all transitions.

What practical problem this fix? I'm asking, because my RF_KILL commit
went to stable, shouldn't this fix go to stable as well?

We seeing problem when we perform the following step:

1. Load the driver
2. Switch HW RF kill ON
3. Switch HW RF Kill OFF
4. Check the status with "rfkill list"

Repeat few time, the "Hard blocked" will stay "yes", at this point, the only way to fix is to unload the driver.

You are right, this patch should back port to stable since the commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 backport to stable.

Wey 
