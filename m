Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toccata.ens-lyon.fr ([140.77.166.68]:43593 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbaHYViO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 17:38:14 -0400
Date: Mon, 25 Aug 2014 23:37:52 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
	Hugh Dickins <hughd@google.com>,
	Vincent Donnefort <vdonnefort@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
Message-ID: <20140825213752.GD3070@type.youpi.perso.aquilenet.fr> (sfid-20140825_233818_206317_4D8B842A)
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
 <10857.1408467967@turing-police.cc.vt.edu>
 <20140825211340.GA22168@kria>
 <20140825212324.GC3070@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20140825212324.GC3070@type.youpi.perso.aquilenet.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Samuel Thibault, le Mon 25 Aug 2014 23:23:24 +0200, a écrit :
> We could indeed have a loop if the user was making the VT::* leds use
> the vt-* trigger,

Actually, while there can be a loop, it wouldn't be possible to inject
events in it: a VT::* led only makes the corresponding vt-* trigger if
it got an event from its trigger, etc. So it's really a false positive,
the lock detector just can not know that it can not happen.

Samuel
