Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33717 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIWNoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 09:44:23 -0400
Received: by mail-ob0-f169.google.com with SMTP id uy5so2231287obc.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 06:44:23 -0700 (PDT)
Date: Tue, 23 Sep 2014 08:44:19 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
Message-ID: <20140923134419.GA19016@ubuntu-hedt> (sfid-20140923_154431_534795_213A76CF)
References: <53FC1789.6020407@msgid.tls.msk.ru>
 <53FCA001.6090404@broadcom.com>
 <53FCB2A3.1050605@msgid.tls.msk.ru>
 <53FCFE1A.3060508@broadcom.com>
 <53FDACD1.8090805@msgid.tls.msk.ru>
 <53FDF8EB.4050905@broadcom.com>
 <54169D4F.2090607@broadcom.com>
 <541EEF17.7020806@msgid.tls.msk.ru>
 <542145B1.4030202@msgid.tls.msk.ru>
 <54216BF1.3060500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54216BF1.3060500@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2014 at 02:47:45PM +0200, Arend van Spriel wrote:
> On 09/23/14 12:04, Michael Tokarev wrote:
> >21.09.2014 19:30, Michael Tokarev wrote:
> >>Namely, after resume, the card does not work. ARP works, ping and
> >>DNS sometimes/somewhat work, inital TCP connection establisment
> >>works, but eg http download does not work, it stalls almost
> >>immediately.
> >
> >It does not work at all anymore again.  Not only after resume but also
> >after could power up, it stalls right at start of wget for example.
> >
> >>http://www.corpit.ru/mjt/tmp/brcmsmac-4313-trace-20140921.dat.gz -- this
> >>is a trace collected after resuming from suspend-to-disk
> >
> >And here -- http://www.corpit.ru/mjt/tmp/brcmsmac-4313-trace-20140923.dat.gz
> >is another trace, after insmod brcmutils&  brcmsmac, starting trace-cmd record
> >(with network-manager running in the background), and running a wget on
> >http://ip-add-ress-of-the-access-point/somefile (which immediately stalls,
> >showing minimal progress once in a while only).
> 
> Well. This log and the one from a few days ago only show me
> interrupt status changes, which does not tell me a lot. I do see
> that the hardware signals transmit completions, but it is far less
> informative then I hoped it would be. Maybe I am missing some debug
> configuration here?
> 
> Seth, would you know?

Well, there are a few different trace events defined for brcmsmac. This
would enable the full set:

 $ trace-cmd record -e brcmsmac -e brcmsmac_tx -e brcmsmac_msg

It's been quite some time since I used them, but I think brcmsmac_tx is
quite noisy so you may only want to enable that if you already suspect a
tx problem. I always find it useful to enable the mac80211 and
mac80211_msg events too when debugging wireless, and I often enable
cfg80211 events as well (none of these are especially verbose).

Of course all of this depends on having the right config options
selected. Looks like the relevant options are CONFIG_BRCM_TRACING and
CONFIG_MAC80211_MESSAGE_TRACING.

Seth

