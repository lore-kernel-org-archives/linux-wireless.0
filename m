Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:57338 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVMIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 07:08:16 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Karl Beldan <karl.beldan@gmail.com>
Subject: Re: [PATCH v3] mac80211_hwsim: claim CSA support for AP
Date: Fri, 22 Nov 2013 13:08:11 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com> <20131122104527.GD8527@magnum.frso.rivierawaves.com>
In-Reply-To: <20131122104527.GD8527@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311221308.11994.sw@simonwunderlich.de> (sfid-20131122_130819_737655_4CEAE04D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Karl,

> 
> Hmm, I thought the CSA code would make ieee80211_beacon_get_tim return
> NULL (or do something alike) after the last ieee80211_beacon_get_tim
> returned a beacon with a null CSA count until the config is done - but
> it seems it doesn't - in that case this change would be race prone.
> Did I miss something ?

No, you have to do the check yourself (as you appearently did). In ath9k I'm 
checking if the CSA finished before scheduling the next beacon. Can you do the 
same for hwsim? Where do you see the race?

Simon

P.S.: Please use my new e-mail address, the old one will go out of service by 
end of the year.
