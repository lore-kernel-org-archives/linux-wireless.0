Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-66-92-28.washdc.fios.verizon.net ([72.66.92.28]:4949
	"EHLO mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZCMAa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 20:30:28 -0400
Date: Thu, 12 Mar 2009 20:30:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Thanks for TX power patch
Message-ID: <20090313003008.GA4188@hash.localnet> (sfid-20090313_013031_313826_6BC24FCD)
References: <1236728344.26432.26.camel@maxim-laptop> <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com> <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 10:14:09AM -0400, Bob Copeland wrote:
> 
> kfree(pd) looks wrong, because pd_curves is the kzalloc()ed part, not
> the array elements themselves.  But I tried removing that and freeing
> the pd_curves array outside of the loop and got more slab debugging
> poop.  So, I punt for now.

This seems to fix it for me...

diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath5k/eeprom.c
index f992b1b..0b062f6 100644
--- a/drivers/net/wireless/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath5k/eeprom.c
@@ -1559,17 +1559,20 @@ ath5k_eeprom_free_pcal_info(struct ath5k_hw *ah, int mode)
 	}
 
 	for (pier = 0; pier < ee->ee_n_piers[mode]; pier++) {
+		if (!chinfo[pier].pd_curves)
+			continue;
+
 		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
-			struct ath5k_pdgain_info *pd = &chinfo->pd_curves[pdg];
+			struct ath5k_pdgain_info *pd =
+				&chinfo[pier].pd_curves[pdg];
 
 			if (pd != NULL) {
 				kfree(pd->pd_step);
 				kfree(pd->pd_pwr);
-				kfree(pd);
 			}
 		}
+		kfree(chinfo[pier].pd_curves);
 	}
-
 	return 0;
 }
 

-- 
Bob Copeland %% www.bobcopeland.com

