Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53545 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbXLLKug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 05:50:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 ethtool support
Date: Wed, 12 Dec 2007 11:48:46 +0100
Cc: linux-wireless@vger.kernel.org
References: <1197361048.3170.381.camel@debian.sh.intel.com> <200712111350.25522.mb@bu3sch.de> <1197421988.3170.405.camel@debian.sh.intel.com>
In-Reply-To: <1197421988.3170.405.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712121148.48716.mb@bu3sch.de> (sfid-20071212_105038_901676_D5ECF8ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 02:13:08 Zhu Yi wrote:
> 
> On Tue, 2007-12-11 at 13:50 +0100, Michael Buesch wrote:
> > On Tuesday 11 December 2007 09:17:28 Zhu Yi wrote:
> > > I want to add ethtool .get_eeprom and .get_eeprom_len support for
> > > iwlwifi. But it seems mac80211 hides the netdev structure from the
> > > driver. What's the suggested way for doing so (i.e dump EEPROM) for
> > > mac80211 devices?
> > 
> > In ssb we simply create a sysfs file for this.
> 
> Yeah, we can do this also. But the users want a standard way, especially
> when there is already such kernel interface and user space tools ready
> there. Any chance mac80211 supports ethtool or something similar?

You could write a patch.
Add a callback to mac80211 that mac80211 uses to register the eeprom
ethtool interface.

-- 
Greetings Michael.
