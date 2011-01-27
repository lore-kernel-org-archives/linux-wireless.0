Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:21573 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753755Ab1A0JTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:19:43 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0300419980
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 18:19:41 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
Date: Thu, 27 Jan 2011 18:19:31 +0900
Cc: Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6> <201101261936.02831.br1@einfach.org> <20110127055105.GA23779@vasanth-laptop>
In-Reply-To: <20110127055105.GA23779@vasanth-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101271819.31727.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu January 27 2011 14:51:05 Vasanthakumar Thiagarajan wrote:
> On Wed, Jan 26, 2011 at 04:06:02PM +0530, Bruno Randolf wrote:
> > On Wed January 26 2011 18:37:00 Jouni Malinen wrote:
> > > On Wed, Jan 26, 2011 at 11:38:53AM +0900, Bruno Randolf wrote:
> > > > Even without my patch, WEP does not work with multiple vifs.
> > > 
> > > Are you sure about that?
> > 
> > Yes, I'm sure. Please test it yourself, if you don't believe me. :)
> > I'm using ath5k, not ath9k, BTW.
> 
> Using a key cache entry without seeing it's availability would
> certainly break multi vif operation with WEP in at least one
> interface. Did you test the following
> 
> 1. Associate sta vif1 with TKIP and
> 2. Bring up ap vif2 with WEP and configure the key at index 1.
> 
> With your patch, the AP wep key would probably override the GTK of STA
> interface.

Ok, right. I have to admit that i did not think about this case and just about 
multiple AP interfaces. So please just drop my patch for now.

bruno
