Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40813 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbZFCEDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 00:03:17 -0400
Date: Wed, 3 Jun 2009 01:03:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090603040315.GA10464@khazad-dum.debian.net>
References: <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk> <1243858256.5299.14.camel@johannes.local> <1243867620.3015.17.camel@localhost.localdomain> <4A23FD91.8020200@tuffmail.co.uk> <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <1243930703.3192.59.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243930703.3192.59.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 02 Jun 2009, Marcel Holtmann wrote:
> We just need to fix the platform drivers then. They should not set
> global states since that is not what they are controlling. They control

We should change things, yes.  So that the platform stores the global
state.  That was half-broken on the old core (the platform stored the
state of its own device, which could be out of sync with the global
state), but the part of it setting the global state is correct.

That needs a new in-kernel API to tie the core to platform drivers
capable of storing global states without causing problems when drivers
are unloaded, but it is not hard.

As for NVS events, they have a clear use case: to let rfkilld know which
global states it could leave alone the first time it loads, and which
ones have to be restored...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
