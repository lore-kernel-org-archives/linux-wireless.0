Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:32927 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbCNRsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 13:48:18 -0400
Received: by ignm3 with SMTP id m3so8659871ign.0
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2015 10:48:18 -0700 (PDT)
Date: Sat, 14 Mar 2015 13:48:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim and tx-rates.
Message-ID: <20150314174813.GA6772@localhost> (sfid-20150314_184839_850405_950BD802)
References: <5500AEAB.8010605@candelatech.com>
 <5500B417.9070307@broadcom.com>
 <5500BC5A.9040809@candelatech.com>
 <20150314104742.GA13495@localhost>
 <55045E56.1050904@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55045E56.1050904@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2015 at 09:14:14AM -0700, Ben Greear wrote:
> It can change with every packet based on rate-control logic, right?

You said you wanted to go from index to bitrate -- the index changes,
but not the rate<->index mapping.

> And, it seems unlikely to me that an extra 16 bytes or so would make a
> great deal of difference.  Using hash tables instead of linear walks
> and other things would likely improve performance more?

Last time I tested with perf, memcpy dominated everything -- I've been
thinking about having a mode where just headers are sent to userspace
to avoid some of that.

-- 
Bob Copeland %% http://bobcopeland.com/
