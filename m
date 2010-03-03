Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:36318 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab0CCBLL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 20:11:11 -0500
From: Bruno Randolf <br1@einfach.org>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH v2] ath5k: fix injection in monitor mode
Date: Wed, 3 Mar 2010 10:10:49 +0900
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, netrolller.3d@gmail.com,
	benoit.papillault@free.fr
References: <20100302025158.9527.43764.stgit@void> <20100302094238.GA24391@jm.kir.nu>
In-Reply-To: <20100302094238.GA24391@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003031010.49887.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 March 2010 18:42:38 Jouni Malinen wrote:
> On Tue, Mar 02, 2010 at 11:51:58AM +0900, Bruno Randolf wrote:
> > injected frames have to use AR5K_PKT_TYPE_NORMAL, otherwise the hardware
> > thinks it can mess with the contents of the frame - e.g. update the TSF
> > of an injected beacon. injected frames should be sent as they are
> > provided.
> 
> Why would we never want the hardware to update fields in injected
> frames? Unless I missed something, this seems to break hostapd use cases
> where the hardware is indeed expected to update the timestamp in Probe
> Response frames and set up seq# and duration etc. as appropriate for the
> frames (the latter may be driver/mac80211 work; the timestamp needs to
> come from hardware/firmware).

ok, i see.

> If we want to have an option to prevent hardware from touching the frame
> payload, that really should be an option (a radiotap and TX control
> flags, etc.), not default functionality for monitor interface. The use
> case for this seems to be some kind of testing purpose and that should
> not really break more common functionality.

yes, we use it for testing IBSS mode (merging, TSF updates) by injecting 
custom beacons. i guess other packet injectors would also assume that their 
packets go out untouched.

so what would be a way to support that properly?
what about a monitor mode flag?

bruno
