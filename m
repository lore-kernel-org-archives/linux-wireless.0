Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:7442 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZBEBrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 20:47:53 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2842764rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 17:47:52 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18826.17627.640343.868796@gargle.gargle.HOWL> (sfid-20090205_024800_774022_3BEBABC1)
Date: Thu, 5 Feb 2009 07:16:03 +0530
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Kishore Ramachandran <kishore@winlab.rutgers.edu>,
	johannes@sipsolutions.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Setting 11n MCS TX bitrate
In-Reply-To: <20090204222203.GJ5581@tesla>
References: <604f6e750902041408k7335234bs565e8fe6868f0f54@mail.gmail.com>
	<20090204222203.GJ5581@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> 
> Not yet, but please feel free to give a shot at hacking it up. It would require
> a new cfg80211 command but keep in mind the way I believe we want this is to
> use the 802.11 MLME SAP interface for this.
> 
> Right now ath9k also does not report the right MCS index through iw
> though. It seems this is due to the way our RC works... anyway this
> could use some love too. Sujith may be working on this, not sure,
> sujith?
> 
> In the end it would be nice to see minstrel be used anyway so a good
> milestone is to allow ath9k select minstrel or let it use its own RC.
> By then things will start looking better I think.
> 

Yeah, fixed rate for 11n won't work with ath9k right now.
And I'll take a look and see if we can have atleast a MCS to internal index
conversion hack - until the tables are shrunk properly.

But for now, you can do something like 'cat /debug/ath9k/*/rcstat' to see
what rates are being used.

Sujith
-- 
http://sujith-m.blogspot.com
