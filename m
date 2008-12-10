Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50469 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbYLJRbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:31:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] b43: rework rfkill code
Date: Wed, 10 Dec 2008 18:31:12 +0100
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
References: <20081210150935.GA10927@srcf.ucam.org> <1228929529.15837.34.camel@johannes.berg> <1228929820.15837.40.camel@johannes.berg>
In-Reply-To: <1228929820.15837.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812101831.13526.mb@bu3sch.de> (sfid-20081210_183142_970462_CAD53DD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 18:23:40 Johannes Berg wrote:
> Then there's user_claim_unsupported which is set by all drivers but
> rt2x00, probably because they have hardware kill switches and thus they
> have to set it even if it's not strictly true, because of the lacking
> separation between these things (that I pointed out)

I introduced it when I ported b43 to rfkill.
Well, a lot of semantical changes were made _after_ that.
When I added it there only were two rfkill states and b43 handled these wrt the
actual hardware state (and I still think that's the right thing to do. The sw-state intermix
is confusing).
So when I added the flag it meant:
user_claim_unsupported = True means user cannot change the hardware kill state.
So basically it means the device has two states. One software state and one hardware
state.
However, I don't know what the semantics for the flag are today. Lots of code changed.

-- 
Greetings, Michael.
