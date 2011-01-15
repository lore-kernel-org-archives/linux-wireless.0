Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59709 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab1AOLID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 06:08:03 -0500
Date: Sat, 15 Jan 2011 13:07:51 +0200
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>
Cc: sbrown@cortland.com, greearb@candelatech.com,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and
 beacons with multiple vifs.
Message-ID: <20110115110751.GA7035@jm.kir.nu>
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
 <AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
 <1295052936.2253.5.camel@mythtv.ewol.com>
 <AANLkTi=_qAB6aVEbsTBUfpVwTg4GbLsAYbyP0PA2n+NO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTi=_qAB6aVEbsTBUfpVwTg4GbLsAYbyP0PA2n+NO@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 15, 2011 at 02:20:00AM +0100, Björn Smedman wrote:
> 2011/1/15 Steve Brown <sbrown@cortland.com>:
> > For instance, an ap vif has a ~100ms interval and a mesh vif has a
> > ~1000ms interval. I don't see how to avoid a per vif interval.
> 
> I agree. We should fix ath9k so it works correctly even if beacon
> interval is different for different vifs (within some reasonable
> limits).

Yes, up to a limit. Handling something like 100 TU on one vif and 1000
TU on another is fine, but something like 100 TU and 103 TU would need
to be forced to use the same interval. I've been thinking of adding some
kind of mechanism for the driver to override Beacon interval in such
cases (which would need to go back all the way to user space to hostapd
in case of AP mode).

-- 
Jouni Malinen                                            PGP id EFC895FA
