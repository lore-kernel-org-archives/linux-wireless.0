Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64497 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1A0FwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 00:52:03 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 21:51:43 -0800
Date: Thu, 27 Jan 2011 11:21:05 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
Message-ID: <20110127055105.GA23779@vasanth-laptop>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6> <201101261138.53169.br1@einfach.org> <20110126093700.GA11832@jm.kir.nu> <201101261936.02831.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201101261936.02831.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 04:06:02PM +0530, Bruno Randolf wrote:
> On Wed January 26 2011 18:37:00 Jouni Malinen wrote:
> > On Wed, Jan 26, 2011 at 11:38:53AM +0900, Bruno Randolf wrote:
> > > Even without my patch, WEP does not work with multiple vifs.
> > 
> > Are you sure about that? 
> 
> Yes, I'm sure. Please test it yourself, if you don't believe me. :)
> I'm using ath5k, not ath9k, BTW.

Using a key cache entry without seeing it's availability would
certainly break multi vif operation with WEP in at least one
interface. Did you test the following

1. Associate sta vif1 with TKIP and
2. Bring up ap vif2 with WEP and configure the key at index 1.

With your patch, the AP wep key would probably override the GTK of STA
interface. 

Vasanth
