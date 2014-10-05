Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47873 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaJEPfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2014 11:35:22 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFT] iwlwifi: dvm: drop non VO frames when flushing
Date: Sun, 5 Oct 2014 15:35:02 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B53BCEA@hasmsx107.ger.corp.intel.com> (sfid-20141005_173527_069746_8BD8C7D9)
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
 <21553.24219.336858.538019@gargle.gargle.HOWL>
In-Reply-To: <21553.24219.336858.538019@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Emmanuel Grumbach wrote:
> > When mac80211 wants to ensure that a frame is sent, it calls the
> > flush() callback. Until now, iwldvm implemented this by waiting that
> > all the frames are sent (ACKed or timeout).
> > In case of weak signal, this can take a significant amount of time,
> > delaying the next connection (in case of roaming).
> 
> ath9k does pretty much the same - just wait for pending frames to be
> completed.
> 
> mac80211 doesn't seem to set 'drop' anywhere when calling flush(), so ath9k
> ends up waiting for frame completion in all cases too.
> Maybe this might cause inordinate delays in low-signal connections with
> ath9k too...
> 

I can't really tell... I guess it depends on the firmware / hardware. On these devices (dvm),
the firmware would take a very long time to send / drop the packets. I guess it is a bug, and
users have been suffering from this for a very long time. Thing is that I was educated by the
"Thee shall not drop packets" mantra. But it appears that sometimes, it is very healthy to
drop packets to solve the traffic jam. Here, I just drop the packets besides the VO queue
to allow the roaming mgmt frames to reach their goal (I rely on the fact that the VO queue
will not be too large...). TCP will retry these packets when the link will be much better after
roaming.
Users in bugzilla said that it improved dramatically the overall behavior.
