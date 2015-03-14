Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36389 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbCNKrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 06:47:46 -0400
Received: by igbue6 with SMTP id ue6so5910444igb.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2015 03:47:46 -0700 (PDT)
Date: Sat, 14 Mar 2015 06:47:42 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim and tx-rates.
Message-ID: <20150314104742.GA13495@localhost> (sfid-20150314_114934_861735_8751E543)
References: <5500AEAB.8010605@candelatech.com>
 <5500B417.9070307@broadcom.com>
 <5500BC5A.9040809@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5500BC5A.9040809@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2015 at 03:06:18PM -0700, Ben Greear wrote:
> I don't see a good way to tie that idx to an actual rate (which involves
> flags, nss, mcs values, etc).
> 
> Maybe I should also just send the info I care about, which is a 'bps' rate,
> channel-width indication, SGI, etc as separate netlink attributes....

My wmediumd fork (https://github.com/bcopeland/wmediumd) could benefit from
this as well -- right now it assumes you use OFDM rates only.

It probably makes sense to send the driver rate array as a separate
netlink message though instead of in-band with CMD_FRAME, since it doesn't
change per frame and amount of data sent over netlink in the datapath already
imposes a performance limit.

Is your simulator available somewhere?

-- 
Bob Copeland %% http://bobcopeland.com/
