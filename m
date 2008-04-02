Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:2956 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751703AbYDBDGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 23:06:52 -0400
From: bruno randolf <bruno@thinktube.com>
To: jt@hpl.hp.com
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Date: Wed, 2 Apr 2008 12:06:24 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	Ivan Seskar <Seskar@winlab.rutgers.edu>,
	Haris Kremo <harisk@winlab.rutgers.edu>
References: <20080326123042.11233.80949.stgit@localhost> <200803311532.44969.bruno@thinktube.com> <20080331174756.GA9882@bougret.hpl.hp.com>
In-Reply-To: <20080331174756.GA9882@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804021206.24626.bruno@thinktube.com> (sfid-20080402_040657_698599_D375B669)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 April 2008 02:47:56 Jean Tourrilhes wrote:
> > do you think it would be feasible
> > to require the drivers to normalize their RSSI to a range of 0-100,
> > so we would have at least some consistency between devices? (of
> > course their steps within this percentage would be different and it
> > would still be impossible to compare these values across different
> > devices).
>
> 	If the measurement is not linear or log, it does not make
> sense mandating the 0-100, because 50 won't be the mid-point. And we
> assume that devices are not consistent to start with...
> 	Anyway, to avoid quantisation errors, I prefer to defer
> normalisation to the end software. For example, if the app use a 64
> pixel window to show the RSSI, it wants a value 0-63, not 0-100.

ok, got it :) i will keep max_signal for this, then. it should be used for 
IEEE80211_HW_SIGNAL_UNSPEC and IEEE80211_HW_SIGNAL_DB. in the case of dBm i 
think we can always assume the same range.

cheers,
bruno
