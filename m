Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39932 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755140AbXEJL2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 07:28:00 -0400
Date: Thu, 10 May 2007 13:27:56 +0200
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070510132756.2ca660a0@midnight.suse.cz>
In-Reply-To: <464253CE.2030504@linux.intel.com>
References: <464253CE.2030504@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 09 May 2007 16:05:50 -0700 James Ketrenos wrote:
> ieee80211_init_rate_ctrl_alg is the only function that can select the
> rate control algorithm by name, and that symbol is not set as
> EXPORT_SYMBOL.

That's true and it's not going to be exported.

> Currently the stack picks the first one it finds and I can't find a way
> for the driver or the user to override this behavior (esp. if the rate
> control algorithm is compiled as a built-in)

It was possible to change the rate control algorithm through sysfs,
unfortunately this ability was removed during the conversion to
debugfs. It will be made possible again through nl80211.

> Adding EXPORT_SYMBOL for ieee80211_init_rate_ctrl_alg would allow the
> driver to request the algorithm known to work best with that hardware. 

A driver is not supposed to set rate control. Under no circumstances.
If you know about a bug in default rate control algorithm, fix it and
send a patch. Otherwise, fix your driver.

> we can change ieee80211_register_hw() to take a 'name' parameter
> specifying the rate control algorithm to use.  Drivers that don't care
> can pass NULL and the stack will do what it does now (pick the first
> algorithm registered with the stack)

NACK.

> Preference?

Write a patch for nl80211/cfg80211.

 Jiri

-- 
Jiri Benc
SUSE Labs
