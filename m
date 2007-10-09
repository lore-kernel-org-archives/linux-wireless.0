Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:61190 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXJIOL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 10:11:29 -0400
Received: by ug-out-1314.google.com with SMTP id z38so100712ugc
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2007 07:11:26 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] Mode selection in mac80211
Date: Tue, 9 Oct 2007 16:27:44 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200710052319.10600.linux@baker-net.org.uk> <200710082308.38260.IvDoorn@gmail.com> <1191921642.4013.13.camel@johannes.berg>
In-Reply-To: <1191921642.4013.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710091627.44276.IvDoorn@gmail.com> (sfid-20071009_151134_412802_735A6B53)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 October 2007, Johannes Berg wrote:
> On Mon, 2007-10-08 at 23:08 +0200, Ivo van Doorn wrote:
> 
> > The only difference currently in rt2x00 is for rt2500usb. The initialization
> > of the IFS and EIFS register is different.
> 
> Ok so that's something we have to do in G-mode-compatible-with-B as
> well.

Well it might not even be needed at all.
The IFS is also passed on as argument by mac80211 when it configures the
TX rings. The EIFS register is something different, all other Ralink devices
have only 1 value for the EIFS. I am not even sure how the device will react
when the same value is set for rt2500usb.

> > And is mac80211 doing that correctly at this time?
> 
> I'm not entirely sure. Are you setting the IFS/EIFS from any other
> place? :) I don't think it is doing that correctly.

Well in the drivers the following is done:
rt2500pci:
	- config_duration() sets EIFS in the register
	- write_tx_desc() sets IFS in the package descriptor
rt2500usb:
	- config_phymode() sets EIFS and IFS in the registers.
	- write_tx_desc() sets IFS in the package descriptor

Note that both config_duration() and config_phymode() are called by rt2x00lib
when mac80211 uses the config() callback function.

Note that the fact that the IFS is set twice for rt2500usb might suggest the
documentation for the register is incorrect and perhaps the purpose of the
register is completely different.

I guess it requires some experimentation to see if initializing those
2 registers differently has any effect. (And if it doesn't, then rt2500usb doesn't
require to know whether it is operating in B or G mode at all).

Ivo
