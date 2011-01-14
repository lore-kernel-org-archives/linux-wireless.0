Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39279 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046Ab1ANJMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 04:12:34 -0500
Date: Fri, 14 Jan 2011 11:12:26 +0200
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No beacons generated when you bring ath9k AP interface down
 and up.
Message-ID: <20110114091226.GA32344@jm.kir.nu>
References: <4D2FF7A4.3070106@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D2FF7A4.3070106@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 13, 2011 at 11:13:40PM -0800, Ben Greear wrote:
> If you have an ath9k AP interface running with hostapd, and you
> run:  ip link set vap0 down; ip link set vap0 up;
> then it will disable beaconing.

Yes. So what?

> I'm not sure where the problem actually lies:  Should ath9k
> start beaconing automatically on VAP interface add?  Is
> it up to hostapd to detect the ifdown/ifup and re-set everything
> up properly?  Or maybe it's just a very bad idea to bounce
> a VAP interface with 'ip link set'?

I would say it is up to whoever decided to set the interface down to
restart hostapd.. There is a proposed patch for hostapd to do this
automatically, but I'm yet to fully understand why one would set the
interface down in the first place.

-- 
Jouni Malinen                                            PGP id EFC895FA
