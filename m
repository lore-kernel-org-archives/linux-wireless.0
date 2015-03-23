Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49495 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbbCWOk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 10:40:27 -0400
Date: Mon, 23 Mar 2015 17:40:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80111: Add BIP-GMAC-128 and BIP-GMAC-256 ciphers
Message-ID: <20150323144032.GK10964@mwanda> (sfid-20150323_154030_685483_2F00DA36)
References: <20150319125314.GA15250@mwanda>
 <20150323132409.GA20999@jouni.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150323132409.GA20999@jouni.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2015 at 03:24:09PM +0200, Jouni Malinen wrote:
> > This function should be a list of commands in a row with tiny detours
> > for exceptions and error handling.  It messes everyone up if the success
> > path is hidden somewhere in the middle and it leads to bugs like this.
> 
> I'm not sure that would be behind this specific bug, 

It is though.

1) The code here:

	err = crypto_aead_setkey(tfm, key, key_len);
	if (!err)
		return tfm;

   That looks like normal error handling code so your mind glosses over
   it.  Reviewers are human and this is a blind spot.

2) If you do it in normal kernel style then the return would have been
   at level 1 indent so the static checkers would have complained about
   the unreachable code.  This was caught with a static checker anyway,
   I suppose, but that static check has a lot more false positives so
   I'm not sure I can release it.

3) This code is just confusing.  The error and the success paths are
   twisted together.  After the first allocation then the exclusive
   parts of the success path move from indent level 1 to indent level 2.
   Confusing code is more likely to have bugs.

regards,
dan carpenter

