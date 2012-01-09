Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10512 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab2AIBhm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 20:37:42 -0500
Subject: Re: [PATCH RFC] iwlwifi: add basic runtime PM support
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, ilw@linux.intel.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4F0A3C62.6010403@intel.com>
References: <4F065F59.2070107@intel.com>
	 <1325843269.3330.4.camel@jlt3.sipsolutions.net>
	 <4F0A3C62.6010403@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Jan 2012 16:34:11 -0800
Message-ID: <1326069251.13074.360.camel@wwguy-huron> (sfid-20120109_023751_014283_49868169)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-09 at 09:01 +0800, Yan, Zheng wrote:
> On 01/06/2012 05:47 PM, Johannes Berg wrote:
> > [add linux-wireless]
> > 
> > On Fri, 2012-01-06 at 10:41 +0800, Yan, Zheng wrote:
> >> This simple patch adds open/close based runtime PM support to the iwlwifi driver.
> >> Namely, make the driver suspend the device after shutting down the interface and
> >> resume the device when activating the interface. In my test, suspending the device
> >> can save about 0.4 watt power. The shortcoming is that the device no longer generate
> >> rfkill changes interrupt.
> > 
> > NACK due to that last sentence. There's no way we can live with that in
> > the general case -- and your patch isn't even configurable afaict. And
> > I'm sure polling the rfkill flag would use just as much energy.
> > 
> It's configurable, runtime PM is disabled by default.

Somehow I miss it, how you configure it?

> 
> > There might be some value in this in a system that doesn't have a hard
> > rfkill line, but that means this needs to be configurable since the
> > device can't know whether there's a button or not [1].
> > 
> The patch targets system that only use software rfkill

How you control that?

Wey
> 


