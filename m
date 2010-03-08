Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0CHH5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 02:57:34 -0500
Subject: Re: Using asynchonous block cipher for CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100227171450.5t7ns1l9ck80kgwo-cebfxv@webmail.spamcop.net>
References: <1267249474.6278.23.camel@mj>
	 <1267254188.3851.1.camel@jlt3.sipsolutions.net>
	 <20100227171450.5t7ns1l9ck80kgwo-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 08:57:32 +0100
Message-ID: <1268035052.3819.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-02-27 at 17:14 -0500, Pavel Roskin wrote:

> I should not have emphasized the "asynchronous" part.  It's possible  
> to call a block cipher synchronously, and that's what the WEP code does:
> 
> crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
> 
> That encrypts the whole packet at once.  The function returns when it's done.
> 
> The CCMP code, on the other hand, calls crypto_cipher_encrypt_one() in  
> a loop for 16 byte long chunks.  That would be simply ineffective for  
> some hardware accelerators.

Ah. Well the problem is that CCM has the authentication rolled in, so
you'd have to find hw support for the entire loop that calls it, or find
an equivalent mode.

johannes

