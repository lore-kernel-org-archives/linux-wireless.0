Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39157 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756204AbZFGM5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:57:16 -0400
Date: Sun, 7 Jun 2009 09:57:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: alan-jenkins@tuffmail.co.uk
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090607125715.GC3340@khazad-dum.debian.net>
References: <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <1243930703.3192.59.camel@localhost.localdomain> <20090603040315.GA10464@khazad-dum.debian.net> <1244008652.4145.7.camel@localhost.localdomain> <20090603213340.GB22809@khazad-dum.debian.net> <1244088806.4145.24.camel@localhost.localdomain> <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Jun 2009, Alan Jenkins wrote:
>  1) remove rfkill_set_global_sw_state()
>  2) rfkill devices with NVS can e.g. call rfkill_has_nvs() before
> registration, setting a flag.
>  3) the "has NVS" flag is reported by /dev/rfkill, (at least in ADD
> events, tho it may as well be set in all events)
>  4) rfkill-input preserves existing behaviour - *if enabled* - by
> initializing the global state from individual devices which have NVS.
> (As before, each _type_ of rfkill device has its own global state).
>  5) rfkill devices with NVS will have their current state preserved,
> so long as the global state has not yet been set (by userspace or by
> rfkill-input).  Of course userspace can change the state in response
> to the device being added.

I can agree to that, it will avoid the regression I have been
complaining about, and seems to address the major complaints against
what we have now...

I think it should probably be enhanced (it doesn't have to be enhanced
_now_, however) to let the core call back into NVS-providing drivers to
checkpoint NVS state.  But that's not something I feel strongly about.

Otherwise, the driver will checkpoint to NVS whatever is the state of
its rfkill device, which could have been changed outside of the global
scope.  While that's exacly what we do right now, it is arguably not the
best way to go about it (i.e. it is broken).

> Comments?

Let's do it :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
