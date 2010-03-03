Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:54231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0CCTIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 14:08:53 -0500
Received: by fg-out-1718.google.com with SMTP id l26so405865fgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 11:08:51 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: iwl4965: 11a channels disabled in current wireless-testing
Date: Wed, 3 Mar 2010 20:08:47 +0100
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK>
In-Reply-To: <1267640304.15761.121.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003032008.47379.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 03 März 2010 schrieb reinette chatre:
> Hi Helmut,
> 
> On Tue, 2010-03-02 at 11:47 -0800, Helmut Schaa wrote:
> > That's the only regulatory event I get:
> > 
> > 1267558985.672513: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
> > 
> > When I set the reg domain to DE via iw I get:
> > 
> > 1267559015.166161: regulatory domain change: set to DE by a user request
> > 
> > However all previously disabled channels are still disabled.
> > Reloading iwlagn afterwards gives the following again:
> > 
> > 1267559087.050649: regulatory domain change: set to DE by a user request
> > 
> > And afterwards the 11a channels and 12+13bg are enabled (passive scanning
> > only, but that is fine) again.
> > 
> > I have no clue what's happening here.
> 
> Me neither. 
> 
> I too have a 4965 and its channels appear fine under the world
> regulatory domain. Specifically:
> 
> $ iw reg get
> country 00:
> 	(2402 - 2472 @ 40), (3, 20)
> 	(2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
> 	(2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
> 	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> 	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS

Oops, that's what I get:

country 00:
        (2402 - 2472 @ 40), (3, 20)

Luis, is the world reg domain encoded in cfg80211 or in the regdb? Maybe
the regdb is too old or something like that?

Thanks,
Helmut
