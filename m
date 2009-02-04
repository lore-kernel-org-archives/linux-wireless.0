Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15677 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZBDWWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 17:22:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 14:22:45 -0800
Date: Wed, 4 Feb 2009 14:22:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kishore Ramachandran <kishore@winlab.rutgers.edu>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Setting 11n MCS TX bitrate
Message-ID: <20090204222203.GJ5581@tesla> (sfid-20090204_232249_960349_5383251B)
References: <604f6e750902041408k7335234bs565e8fe6868f0f54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <604f6e750902041408k7335234bs565e8fe6868f0f54@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 02:08:02PM -0800, Kishore Ramachandran wrote:
> Hi,

Hey Kishore!

> I would like to configure D-Link DWA 645 (AR5416) PCMCIA card so that it uses a fixed 11n bit-rate. Based on earlier posts, I understand that iwconfig or wireless tools will only allow me to set 11a/b/g bit-rates.

This is correct.

> There does not seem to be a "set rate" option with iw yet. Is this in the works?

Not yet, but please feel free to give a shot at hacking it up. It would require
a new cfg80211 command but keep in mind the way I believe we want this is to
use the 802.11 MLME SAP interface for this.

Right now ath9k also does not report the right MCS index through iw
though. It seems this is due to the way our RC works... anyway this
could use some love too. Sujith may be working on this, not sure,
sujith?

In the end it would be nice to see minstrel be used anyway so a good
milestone is to allow ath9k select minstrel or let it use its own RC.
By then things will start looking better I think.

> I am using ath9k (compat-wireless-2009-01-19) on Ubuntu (kernel v2.6.27-11) with iw v0.9.9.

Nice, just one tip: may want to stick to using iw from git if you are doing
development, it keeps moving on and on.

  Luis
