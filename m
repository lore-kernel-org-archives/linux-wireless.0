Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1844 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYLJEyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 23:54:16 -0500
Date: Tue, 9 Dec 2008 23:54:04 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k: fix endianness of bitwise ops when installing mic
Message-ID: <20081210045404.GB11899@hash.localnet> (sfid-20081210_055421_623492_17B7245C)
References: <20081210040538.GA11810@hash.localnet> <493F45C9.6010703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <493F45C9.6010703@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2008 at 10:30:01PM -0600, Larry Finger wrote:
> >  			key_v[0] = rxmic[0];
> > -			key_v[1] = (txmic[0] >> 16) & 0xffff;
> > +			key_v[1] = cpu_to_le32(le32_to_cpu(txmic[0]) >> 16);
> 
> Is it certain that txmic[0] will not sign extend with the >> 16 operation? Is
> that why you dropped the mask with 0xffff?

Yeah, I added the mask in the first place, but dropped it here because 
txmic is an __le32, and as far as I can tell all __le types are also 
unsigned, so it shouldn't sign extend.

I'm not a language lawyer though so if anyone knows better, chime in
(I just wrote a simple C program to convince myself).

-- 
Bob Copeland %% www.bobcopeland.com

