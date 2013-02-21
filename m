Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36638 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3BUFmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 00:42:00 -0500
Message-ID: <5125B39F.3010200@candelatech.com> (sfid-20130221_064208_622948_FCB333A5)
Date: Wed, 20 Feb 2013 21:41:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL> <511BC243.8010409@candelatech.com> <20770.57339.20017.225929@gargle.gargle.HOWL> <51255360.6060603@candelatech.com> <51257304.10109@candelatech.com> <20773.31380.740958.31338@gargle.gargle.HOWL>
In-Reply-To: <20773.31380.740958.31338@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 05:38 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> For instance, in this case, why do we have pending frames, the axq-stopped,
>> and no axq depth?  Is that an invalid state to begin with?  Once
>> it gets in the hung state, those numbers never change.  I'd assume
>> something should be poking more packets out of the pending frames
>> down into the axq logic?
>
> Something is broken in the xmit path, definitely.

Ok, so here's a question:  In the ath_tx_complete method,
the pending_frames counter is only decremented if txq == c->tx.txq_map[q].

Maybe it should always be decremented?

What kinds of things could cause txq to not equal the txq-map[q]?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

