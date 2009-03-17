Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53806 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbZCQJJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 05:09:29 -0400
Date: Tue, 17 Mar 2009 11:09:22 +0200
From: Jouni Malinen <j@w1.fi>
To: Richard Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] fix wireless-regdb enforcement oddities
Message-ID: <20090317090922.GA2721@jm.kir.nu> (sfid-20090317_100932_510983_1DD20C90)
References: <49BEE56C.9050202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49BEE56C.9050202@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 07:49:00PM -0400, Richard Farina wrote:

> For the sake of sanity, I think that the way rules from wireless-regdb  
> are enforced needs to be changed. An example:
>
> country US:
>        (5170 - 5250 @ 40), (3, 17)
>        (5250 - 5330 @ 40), (3, 20), DFS
>
> In this case, you will see that I have removed all of the rules that I  
> do not intend to cite to lower the complexity of the ruleset.
>
> Take for example, channel 48, center frequency 5240.  A standard 20 mhz  
> mode will work as expected, as well as HT40-, however HT40+ cannot be  
> set because it would need to cross the rule boundary.  Each line of a  
> regulatory domain section is enforced by itself.  Channel 52 has a  
> similiar problem where 20 and HT40+ work but HT40- will not.

Channel 48 with HT40+ would not work regardless of the regulatory rules;
(48,52) is not one of the allowed HT40 channel pairs. You can use
(36,40), (44,48), (52,56), and (60,64), but not (40,44), (48,52),
(56,60). This is not really a regulatory limit but restriction stated in
IEEE 802.11n Annex J. And same applies to channel 52 with HT40-.

There may be some other examples where the processing of the ruleset
could be improved, but this particular example does not look like
something that would benefit much from a change here.

> As this specific example includes frequencies in the DFS range, you can  
> obviously see why no one has noticed this failing before.  The obviously  
> expected result is that if two rules abut and a channel is requested  
> that stradles them, it should take the most restrictive mix between the  
> two.  For instance, if I set channel 48 in HT40+ mode (and we have DFS  
> support) the rule would be enforced as (3, 17), DFS; while HT40- would  
> be enforced as the standard (3, 17).

If the channel pair (48,52) were allowed by IEEE 802.11n and we
supported DFS, yes, I would agree with this. However, neither of those
are the case at the moment (and I don't see the former changing in the
future either).

-- 
Jouni Malinen                                            PGP id EFC895FA
