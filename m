Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:40785 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbXK0Den (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 22:34:43 -0500
Date: Mon, 26 Nov 2007 19:34:08 -0800
From: Jouni Malinen <j@w1.fi>
To: dragoran <drago01@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Message-ID: <20071127033408.GB5698@jm.kir.nu> (sfid-20071127_033447_334083_934C2CC5)
References: <47494851.4070504@gmail.com> <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com> <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2007 at 03:50:00PM +0100, dragoran wrote:
> btw would it make sense to ratelimit
> 
> "WEP decrypt failed (ICV)" messages?
> they are a bit annoying when connected to this network...
> 
> dmesg  | grep ICV | wc -l
> 3489
> 
> after some minutes.

While I fully agree that these messages should be rate limited, it is
somewhat surprising to see this large a number of reported ICV failures.
Does the ipw3945 not filter out FCS errors before passing the frame for
WEP decryption? Or is there something odd about this network/client
configuration that makes the client try to decrypt frames that are not
really for it?

I can think of one valid case (VLAN with separate broadcast domains
using the same BSS), all other cases seem like waste of CPU power since
I would have expected the frames to be filtered out before reaching WEP
decryption if this STA is not the correct destination for them.

-- 
Jouni Malinen                                            PGP id EFC895FA
