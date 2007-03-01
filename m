Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:53147 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192AbXCAPWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 10:22:23 -0500
Received: by nf-out-0910.google.com with SMTP id o25so913495nfa
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2007 07:22:22 -0800 (PST)
To: Andy Green <andy@warmcat.com>
Subject: Re: Question about packet injection
Date: Thu, 1 Mar 2007 16:22:17 +0100
Cc: linux-wireless@vger.kernel.org
References: <45E41A9E.2020908@warmcat.com> <45E497A1.90400@warmcat.com> <45E6ED0B.20100@warmcat.com>
In-Reply-To: <45E6ED0B.20100@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703011622.17602.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 March 2007 16:11, Andy Green wrote:
> Hi folks -
> 
> As suggested here I migrated my daemon to using a per-physical device 
> monitor mode interface it creates and destroys from usermode, together 
> with libpcap for filtering and receiving broadcasts and that seems to be 
> working okay.  So that is half the battle to get the broadcast system 
> working with mac80211 out of the box without patches.
> 
> However, if I inject a captured packet - with a PRISM header prepended - 
> down the Monitor mode interface using pcap_inject(), I see it appear on 
> the libpcap captured output okay, but it does not go out on the air AFAICT.
> 
> Is this in fact the correct way to try to inject a packet with fine 
> control over its encryption and rate?  If so is it expected to currently 
> work on iwlwifi 0.0.8 or rt2x00 (rt73usb) from CVS 2008-02-14?

Note that rt73usb is currently broken, I know that RX isn't working
because scanning fails. Chances are quite high that TX is failing too.
I am still looking into that issue, but it might be the reason why
packet injection is failing for you.

Ivo
