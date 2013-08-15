Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53449 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab3HOGIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 02:08:17 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johan Almbladh <ja@anyfi.net>
Cc: johannes@sipsolutions.net, ordex@autistici.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mac80211: perform power save processing before decryption
References: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
	<1376486987-23224-1-git-send-email-ja@anyfi.net>
Date: Thu, 15 Aug 2013 09:08:15 +0300
In-Reply-To: <1376486987-23224-1-git-send-email-ja@anyfi.net> (Johan
	Almbladh's message of "Wed, 14 Aug 2013 15:29:46 +0200")
Message-ID: <877gfnwkog.fsf@purkki.adurom.net> (sfid-20130815_080826_434662_3DA71E1D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Almbladh <ja@anyfi.net> writes:

> This patch decouples the power save processing from the frame decryption
> by running the decrypt rx handler after sta_process. In the case where
> the decryption failed for some reason, the stack used to not process
> the PM and MOREDATA bits for that frame. The stack now always performs
> power save processing regardless of the decryption result. That means that
> encrypted data frames and NULLFUNC frames are now handled in the same way
> regarding power save processing, making the stack more robust.
>
> Tested-by: Johan Almbladh <ja@anyfi.net>
> Signed-off-by: Johan Almbladh <ja@anyfi.net>

The idea of the Tested-by is that someone else than the patch author has
also tested the patch, like a bug reporter etc. The patch author should
always tests his/her code, so adding Tested-by for the author is moot.

-- 
Kalle Valo
