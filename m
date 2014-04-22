Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbaDVUpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 16:45:54 -0400
Date: Tue, 22 Apr 2014 22:45:52 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Michael Leun <lkml20140418@newton.leun.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	arik@wizery.com, linux@eikelenboom.it
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140422204552.GR27882@wotan.suse.de> (sfid-20140422_224606_904925_CB27910D)
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com> <20140422180003.6438dbb7@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140422180003.6438dbb7@xenia.leun.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 06:00:03PM +0200, Michael Leun wrote:
> On Mon, 21 Apr 2014 20:39:33 -0700
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
> 
> 
> 
> > that'd be appreciated as an alternative. I'm also very curious to hear
> > no one else would have run into the same regression as you have.
> 
> I only see this on an Acer PTZ1825 with an ath9k wireless card, but
> that machine was not sold with that wlan card, so other people with the
> same model won't neccesarily see the same issue.

OK I see the issue and its clear now how this could have
gone through, the wiphy comes from the country IE and it
could have gone disappearing during suspend / hotplug, so
we do need to check for it again.

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f054137..4f375b6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1602,7 +1602,8 @@ __reg_process_hint_country_ie(struct wiphy *wiphy,
 			return REG_REQ_IGNORE;
 		return REG_REQ_ALREADY_SET;
 	} else {
-		if (wiphy->regulatory_flags & REGULATORY_COUNTRY_IE_IGNORE)
+		if (wiphy &&
+		    wiphy->regulatory_flags & REGULATORY_COUNTRY_IE_IGNORE)
 			return REG_REQ_IGNORE;
 	}
 
