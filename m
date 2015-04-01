Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57351 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbDAIoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 04:44:15 -0400
Message-ID: <1427877848.3428.1.camel@sipsolutions.net> (sfid-20150401_104420_365306_4EE1DF9B)
Subject: Re: [PATCH 7/7] mac80211: Count correctly interface types
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 01 Apr 2015 10:44:08 +0200
In-Reply-To: <551BADF5.3000409@broadcom.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
		 <1426143210-25635-7-git-send-email-emmanuel.grumbach@intel.com>
		 <CALhHN=qkEmUPEL2XBuuudmq6Rg-6s7jm0TOdRuQCetgSiKyrpg@mail.gmail.com>
		 (sfid-20150401_080606_876573_33E52A4C) <1427872324.2432.3.camel@sipsolutions.net>
	 <551BADF5.3000409@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-04-01 at 10:36 +0200, Arend van Spriel wrote:

> I think in latest wpa_s the P2P-Device is always created. There used to 
> be a driver_param to create it. Not sure if that driver_param could 
> still be used to avoid P2P-Device creation.

Yeah, I feared this was the case so I added Ilan :)

I think we need to fix that perhaps in some way? I'm pretty sure we
cannot have P2P-Device and IBSS at the same time properly in our device.

> The interface combinations look confusing to me. Why is there no IBSS or 
> monitor listed there?

Only "real" combinations are listed - anything that's in the "Supported
interface modes" is, by default, only supported with a single virtual
interface. Real combinations (of >1 interface) are listed separately.

johannes

