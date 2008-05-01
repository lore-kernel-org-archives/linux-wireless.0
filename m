Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13926 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334AbYEAVbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 17:31:05 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: reduce command retry time
Date: Thu, 1 May 2008 23:30:57 +0200
Cc: David Woodhouse <dwmw2@redhat.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200804301644.29927.hs4233@mail.mn-solutions.de> <1209587692.16194.22.camel@localhost.localdomain> <1209588196.25560.443.camel@pmac.infradead.org>
In-Reply-To: <1209588196.25560.443.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805012330.57750.hs4233@mail.mn-solutions.de> (sfid-20080501_233049_432049_83A2CCFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think I've seen it take a few of the 5-second timeouts.

Do you you know for which commands this has been?


> I wouldn't like to decrease the maximum so drastically.

How far would you go?

Or: maybe there is another way to make "pccardctl eject"
work reasonably fast in the case of a retrying command. Any
idea?

BTW, it's easy to force this kind of error, in cmdresp.c:

if (resp->seqnum==5) {
   lbs_deb_cmd("forced FAIL\n");
   spin_unlock_irqrestore(&priv->driver_lock, flags);
   ret = -1;
   goto out;
}


> Also, that del_timer_sync() happens in the module unload path, doesn't
> it? I'd want to see why you think it isn't needed.

I thought that del_timer_sync() waits until the timer has been executed? If yes, then that's the wrong thing here, I want to unload quickly. Makes no sense to wait till the command_timer finally fires and re-sends the failed command.
