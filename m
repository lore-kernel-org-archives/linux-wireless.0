Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:46046 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYDIR2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 13:28:15 -0400
Received: by fk-out-0910.google.com with SMTP id 19so3416366fkr.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2008 10:28:14 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: hostapd hangs on rt2500pci, leaving the nic in an unstable state
Date: Wed, 9 Apr 2008 19:32:08 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1207412527.6965.21.camel@Bas> <200804061708.51044.IvDoorn@gmail.com> <1207590445.3028.2.camel@Bas>
In-Reply-To: <1207590445.3028.2.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804091932.09459.IvDoorn@gmail.com> (sfid-20080409_182820_918247_4672B270)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 April 2008, Bas Hulsken wrote:
> Hi
> 
> > Could you try editing rt2500pci.c
> > and in rt2500pci_interrupt() change:
> > 
> > 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
> > 		rt2x00lib_beacondone(rt2x00dev);
> > 
> > to
> > 
> > 	//if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
> > 	//	rt2x00lib_beacondone(rt2x00dev);
> 
> did that, also applied Johannes' "fix STA AID bug" patch, but no change
> in behaviour, still the same hang in hostapd.

Does the patch by Daniel Wagner:
	rt61pci: rt61pci_beacon_update do not free skb twice
which was send to the linux-wireless mailing list today help?

Ivo


