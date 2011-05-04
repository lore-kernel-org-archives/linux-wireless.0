Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36247 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab1EDQQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:16:50 -0400
Received: by yia27 with SMTP id 27so448459yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 09:16:49 -0700 (PDT)
Subject: Re: [PATCH 13/13] ath9k: fix beaconing for mesh interfaces
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: Felix Fietkau <nbd@openwrt.org>
Cc: Javier Cardona <javier@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
In-Reply-To: <4DC165D7.50403@openwrt.org>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
	 <1304467039-7730-14-git-send-email-javier@cozybit.com>
	 <4DC165D7.50403@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 12:16:44 -0400
Message-ID: <1304525804.4522.21.camel@mythtv.ewol.com> (sfid-20110504_181652_517597_405CB5CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-04 at 16:42 +0200, Felix Fietkau wrote:
> On 2011-05-04 1:57 AM, Javier Cardona wrote:
> > Mesh beaconing on ath9k was broken by this commit:
> >
> > commit 4801416c76a3a355076d6d371c00270dfe332e1c
> > Author: Ben Greear<greearb@candelatech.com>
> > Date:   Sat Jan 15 19:13:48 2011 +0000
> >
> > This patch assigns the right opmode when the device is used in mesh
> > mode.
> >
> > Reported-by: Fabrice Deyber fabricedeyber@agilemesh.com
> > Signed-off-by: Javier Cardona<javier@cozybit.com>
> Any idea why exactly ath9k needs to use this opmode? If I understand the 
> specs correctly, 802.11s does not use distributed beacons like ad-hoc 
> mode, so theoretically it should be fine with using the AP iftype.
> If beacons don't work at all in this opmode for 802.11s then this patch 
> may just be covering up an underlying bug rather than fixing the real issue.
> 
> - Felix
> --
I'd tend to agree. I think the problem is in ath9k_allow_beacon_config
with the test about not configuring station vif's when in AP mode. I
think it's too restrictive. 

Maybe something like:

         * Can not configure station vif's beacon config
         * while on AP opmode
         */
        if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
-           (vif->type != NL80211_IFTYPE_AP)) {
+           ((vif->type == NL80211_IFTYPE_STATION) ||
+            (vif->type == NL80211_IFTYPE_ADHOC))) {

Steve


