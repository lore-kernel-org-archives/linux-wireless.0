Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42480 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaJEPGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2014 11:06:22 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21553.24219.336858.538019@gargle.gargle.HOWL> (sfid-20141005_170635_311805_023065D6)
Date: Sun, 5 Oct 2014 20:37:07 +0530
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when flushing
In-Reply-To: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
> When mac80211 wants to ensure that a frame is sent, it calls
> the flush() callback. Until now, iwldvm implemented this by
> waiting that all the frames are sent (ACKed or timeout).
> In case of weak signal, this can take a significant amount
> of time, delaying the next connection (in case of roaming).

ath9k does pretty much the same - just wait for pending
frames to be completed.

mac80211 doesn't seem to set 'drop' anywhere when calling flush(),
so ath9k ends up waiting for frame completion in all cases too.
Maybe this might cause inordinate delays in low-signal connections
with ath9k too...

Sujith
