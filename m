Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37851 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYLJQvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 11:51:49 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228922997.15837.6.camel@johannes.berg>
References: <20081210150935.GA10927@srcf.ucam.org>
	 (sfid-20081210_160955_698729_A777A57C)  <1228922997.15837.6.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 17:51:38 +0100
Message-Id: <1228927898.19553.164.camel@violet.holtmann.net> (sfid-20081210_175153_795919_88125CBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > The final change is that I removed the code for changing the wireless 
> > state in response to the txpower configuration in mac80211. Right now, I 
> > can't see any way for this to work correctly - if the user disables the 
> > radio via rfkill, mac80211 doesn't flag the radio as disabled. As a 
> > result, the next time the configuration callback is called, b43 
> > reenables the radio again, even though the user has explicitly disabled 
> > it. I don't think any of the other drivers handle this case, so I'm not 
> > really sure what the best way to handle this in future is. The current 
> > situation certainly seems broken.
> 
> We're going to have to integrate rfkill with mac80211, but nobody cares.

if you figured out on how to do it the best way, then let me know,
because I have to do the same thing for Bluetooth.

Regards

Marcel


