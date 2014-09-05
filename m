Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59725 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaIEB36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 21:29:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21513.4640.105293.655789@gargle.gargle.HOWL> (sfid-20140905_033001_551429_064E06EF)
Date: Fri, 5 Sep 2014 07:00:08 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: I cannot disable RTS/CTS on ath9k.
In-Reply-To: <5408D509.7010000@candelatech.com>
References: <5408B698.6050606@candelatech.com>
	<CAHNKnsSLmWOeH7i-K1yFESgSU23FwfUv8oTZF-HkW53+8Yn_qg@mail.gmail.com>
	<5408D509.7010000@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Thanks, that must be this thread:
> 
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/84459
> 
> I think that explains much of my confusion.  I too would like a way to
> really disable RTS for testing.  On a mostly quiet channel, sending UDP
> frames one way, I still see lots of RTS/CTS, which must mean there are
> lots of retries (assuming Minstel-HT is cause of this).

The confusion arises from the command usage.

It should be "iw phy phyname set rts <rts threshold|no rts threshold>",
or something similar, because "rts off" actually removes the threshold,
it doesn't disable RTS/CTS.

Sujith
