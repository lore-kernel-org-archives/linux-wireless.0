Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22881 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936308Ab0B0WOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 17:14:51 -0500
Message-ID: <20100227171450.5t7ns1l9ck80kgwo-cebfxv@webmail.spamcop.net>
Date: Sat, 27 Feb 2010 17:14:50 -0500
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Using asynchonous block cipher for CCMP
References: <1267249474.6278.23.camel@mj>
	<1267254188.3851.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1267254188.3851.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Johannes Berg <johannes@sipsolutions.net>:

> On Sat, 2010-02-27 at 00:44 -0500, Pavel Roskin wrote:
>> It turns out that mac80211 uses plain AES for CCMP.  However, it uses an
>> asynchronous block cipher "ecb(arc4)" for WEP and TKIP.
>>
>> I'd like to make CCMP use an asynchronous block cipher.  Has anyone
>> attempted that?  Are there any issues I should be aware of?
>
> Well the issue is going to be having to interrupt the flow there and
> then pick it back up after crypto. Or you can stick it after the entire
> flow and treat it like hw crypto in the card.

I should not have emphasized the "asynchronous" part.  It's possible  
to call a block cipher synchronously, and that's what the WEP code does:

crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);

That encrypts the whole packet at once.  The function returns when it's done.

The CCMP code, on the other hand, calls crypto_cipher_encrypt_one() in  
a loop for 16 byte long chunks.  That would be simply ineffective for  
some hardware accelerators.

OK, what really matters is that nobody has replied that it was  
attempted and didn't work :-)

-- 
Regards,
Pavel Roskin
