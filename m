Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47805 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733AbYFWQYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 12:24:52 -0400
Date: Mon, 23 Jun 2008 13:24:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Fabien Crespel <fabien@crespel.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Dmitry Torokhov <dtor@mail.ru>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 11/12] rfkill: do not allow userspace to override ALL
	RADIOS OFF
Message-ID: <20080623162444.GA22039@khazad-dum.debian.net> (sfid-20080623_182457_764688_F203A593)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-12-git-send-email-hmh@hmh.eng.br> <485EAA82.30808@crespel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <485EAA82.30808@crespel.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 22 Jun 2008, Fabien Crespel wrote:
> Anyway, the whole current_state thing seems completely useless and a 
> source of problems in rfkill-input, since state comparison is already 
> done in rfkill, and rfkill-input is more than likely to become out of 
> sync with the real state.
>
> Therefore I propose this additional patch to remove current_state 
> completely from rfkill-input.

It would work fine from what I see.  And it will even be beneficial in the
long run, as it will cause rfkill-input to reapply a global state, fixing
any switches that diverged from it (and are lot BLOCKED, or "claimed", etc).
Right now, this is not very useful, but when we add a sysfs interface to
interact with the global states directly, it will be.

Please send me your signed-off line, I will respin the patch to fit exactly
before the EPO patch into the patchset (so that we don't have breakage in
any intermediate step of the patchset), and send it as a block.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
