Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:56000 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992923AbXDDPWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 11:22:47 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HZ7Hh-0005KF-OV
	for linux-wireless@vger.kernel.org; Wed, 04 Apr 2007 11:20:29 -0400
Subject: Re: Orinoco, mac80211 and wpa2
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Jan Dittmer <jdi@l4x.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1175697737.2656.3.camel@localhost.localdomain>
References: <4613A4A9.1060902@l4x.org>
	 <1175697737.2656.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 11:22:38 -0400
Message-Id: <1175700158.5322.9.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-04-04 at 10:42 -0400, Dan Williams wrote:

> In your case, some cards supported by the orinoco drivers _do_ have WPA
> capability with a firmware upgrade and by using the 'hostap' drivers.
> I'd try blacklisting the orinoco and see if the 'hostap' driver supports
> your card.

I think that Sony laptops have real Lucent Orinoco card, e.g.:
https://launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/66696/comments/11

Porting Orinoco driver to mac80211 would be a fun project, and I don't
think it's impossible.  It should be possible to dumb down the card,
turn off scanning and authentication and send raw packets.

I'm not sure if the firmware support would be needed, but Lucent 9.xx
firmware has WPA support.  Since it's RAM loadable, the firmware loading
will need to be added.  Fortunately, the implementation already exists
in the now defunct HermesAP project.

I have way too much stuff on my plate to even attempt it myself, but I
would not discourage others.

-- 
Regards,
Pavel Roskin

