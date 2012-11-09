Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2KIUQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:16:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWv0c-0003n7-8M
	for linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 21:16:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: VHT support, take 2
Date: Fri,  9 Nov 2012 21:17:26 +0100
Message-Id: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net> (sfid-20121109_211702_930840_209B43F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's a new version of the VHT patches, in case you're bored
over the weekend and want some exciting code to read! ;-)

I do need to test these, I had tested the previous set but not
after the mac80211 rework yet.

However, at this point I'm more interested in seeing whether
you all think this is sane at all or if I'm on crack?

What I intend to do next is this have a patch to parse the VHT
operation IE in mac80211 (or have a helper in cfg80211?) to
select the VHT channel configuration in MLME code.

I'm kinda hoping the posedge folks will come back with the
regulatory code so I don't have to worry about that ...
*hint hint* :-)

After that, I'll need to work on the remaining hostapd code,
that should just need channel configuration etc. now. Then I
think it just needs a good test run.

I'm not interested in VHT IBSS, so I'm not going to do anything
there, nor VHT mesh.

The other thing would be rate control, e.g. minstrel_vht, but
I'm not sure we can use minstrel at all, so I'll probalby not
work on minstrel myself.

johannes

