Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:54256 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3LMRXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 12:23:38 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v9 0/5] CSA Beacon Count changes
Date: Fri, 13 Dec 2013 18:23:35 +0100
Cc: linux-wireless@vger.kernel.org, yeohchunyeow@gmail.com,
	yeohchunyeow@cozybit.com
References: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312131823.35206.sw@simonwunderlich.de> (sfid-20131213_182341_681266_BC75B9C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luca,

> Hi,
> 
> More changes, hopefully the last ones for this series. ;)
> 
> I have hacked wpa_supplicant to support CSA in IBSS, so I could test
> it too.  I created some ma80211_hwsim testcases on top of this.  The
> tests now pass, though I get some semi-random WARNs [1] when using 3
> stations.  It seems to be a race condition and it doesn't seem to be
> related to this series, so I think we should address it separately
> (Simon, hint! ;).
> 
> I have also created some basic BSS CSA test cases for mac80211_hwsim.
> The tests pass, except when I try count < 2, which is expected, since
> we did not implement the CSA action frame in BSS mode.
> 
> I'll upstream the BSS CSA test cases soon.  The IBSS test cases still
> need to be cleaned up (actually they're worthless without the IBSS CSA
> support in wpa_supplicant, which needs to be cleaned up).  If someone
> is interested in this, let me know and I can send them
> "without-warranty of any kind". ;)
> 
> Please review and test!

Patches look good to me and worked fine in my test environment. Everything as 
expected for CSA counts of 0, 1, 2 and 10, no warnings or weird behaviour. 
I've tested with two stations in IBSS mode using ath9k.

So, apart from that function name issue, feel free to add for Patch 1,2 and 5:

Acked-by/Tested-by: Simon Wunderlich <sw@simonwunderlich.de>

I'll try to reproduce the issue you were seeing when these testcases/wpa_s 
implementation are upstream (or patches are available). I didn't see the 
problem on a first glance, but the warning is not critical (basically the CSA 
will fail), so I guess it's OK to fix it soon[tm].

Thanks for your work!
   Simon
