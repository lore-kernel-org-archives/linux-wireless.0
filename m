Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:7956 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422678AbXBUQxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:53:13 -0500
Received: by nf-out-0910.google.com with SMTP id o25so256840nfa
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2007 08:53:12 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 2/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:52:34 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.47410.IvDoorn@gmail.com> <200702211744.24034.IvDoorn@gmail.com> <200702211751.27245.mb@bu3sch.de>
In-Reply-To: <200702211751.27245.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211752.34498.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > On further inspection not even that. :P
> > The outcome of that switch is stored in the antenna variable, which is used with
> > 
> > 	bcm43xx_mgmtframe_txantenna(dev, antenna);
> > 	bcm43xx_set_rx_antenna(dev, antenna);
> > 
> > So I guess that needs to be fixed to create a switch statement for
> > the RX antenna and one for the TX antenna?
> 
> Ah, yeah. I didn't have the complete code for this in my head. :)
> 
> I'd rather like to have a helper function
> int bcm43xx_antenna_from_ieee80211(u8 antenna)
> which includes the switch statement and use it twice in the
> config callback. Wanna do that?

No problem, I will resend this patch with that helper function added.

Ivo
