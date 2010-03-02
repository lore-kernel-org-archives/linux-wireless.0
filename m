Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56335 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0CBTrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 14:47:15 -0500
Received: by bwz1 with SMTP id 1so25614bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 11:47:14 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: iwl4965: 11a channels disabled in current wireless-testing
Date: Tue, 2 Mar 2010 20:47:09 +0100
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003011927.53208.helmut.schaa@googlemail.com> <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
In-Reply-To: <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003022047.10196.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag 01 März 2010 schrieb Luis R. Rodriguez:
> You can try to register to nl80211 events after loading cfg80211:
> 
> iw event -t
> 
> Then load iwlagn and see if you pick anything up. Might want to enable
> CFG80211_REG_DEBUG.

That's the only regulatory event I get:

1267558985.672513: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request

When I set the reg domain to DE via iw I get:

1267559015.166161: regulatory domain change: set to DE by a user request

However all previously disabled channels are still disabled.
Reloading iwlagn afterwards gives the following again:

1267559087.050649: regulatory domain change: set to DE by a user request

And afterwards the 11a channels and 12+13bg are enabled (passive scanning
only, but that is fine) again.

I have no clue what's happening here.

Helmut
