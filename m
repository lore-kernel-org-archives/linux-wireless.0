Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50112 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2BJNE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 08:04:27 -0500
Message-ID: <1328879062.2443.16.camel@edumazet-laptop> (sfid-20120210_140433_386226_F4AE8BDC)
Subject: RE: [PATCH net-next] drivers/net: Remove boolean comparisons to
 true/false
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
	jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 10 Feb 2012 14:04:22 +0100
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E65@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E65@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le vendredi 10 février 2012 à 09:32 +0000, David Laight a écrit :

> The generated code is particularly horrid for boolean arithmetic.
> IIRC:
>    bool_var &= bool_var_1;
> typically requires a sequence of compare and branch instructions.
> 

I suggest you try to upgrade your old compiler and/or always check your
assertions before posting on netdev such claims.

	bool_var &= bool_var_1;

generates a single AND instruction, no compare, no branch.
It would be a failure from compiler optimizer if that was the case.

And (bool_var ? 1 : 0) or (!!bool_var) are NOP for a compiler as well.

(Only one movzbl instruction to convert a byte to a word if context
requires this)

Only difference for bool or unsigned int vars is type promotion, and
fact that compiler knows that 'bool' only can be 0 or 1, so allows more
optimisations than plain "unsigned int".

Really, bools are not evil if well used.


