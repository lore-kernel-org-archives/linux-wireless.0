Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:52390 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752686AbdFPMmx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 08:42:53 -0400
Message-ID: <1497616969.10546.11.camel@perches.com> (sfid-20170616_144256_252836_AF59FF29)
Subject: Re: [RFC] networking: add and use skb_put_u8()
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 16 Jun 2017 05:42:49 -0700
In-Reply-To: <1497614684.10546.9.camel@perches.com>
References: <20170616090300.13805-1-johannes@sipsolutions.net>
         <b7ba5145-b4f0-0f86-e93d-ad8700483ff2@broadcom.com>
         (sfid-20170616_121658_816680_06914E8C) <1497608566.2622.7.camel@sipsolutions.net>
         <1497614684.10546.9.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-16 at 05:04 -0700, Joe Perches wrote:
> Perhaps
> 
> 	skb_put_data(skb, &c, sizeof(c))
> 
> as that avoids api expansion.

Hmm.  Perhaps not.

That wouldn't work very well for constants
when some variant like skb_putchar/skb_put_u8
works perfectly.

I still think skb_putchar is nicer naming,
but perhaps the skb_put_u<size> is more
amenable to use with constants.
