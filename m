Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:50997 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaB1MXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 07:23:25 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v3 0/3] mac802111: channel context reservation
Date: Fri, 28 Feb 2014 14:23:17 +0200
Message-Id: <1393590200-25309-1-git-send-email-luca@coelho.fi> (sfid-20140228_132329_316176_52D37688)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

In v3:

   * promoted to PATCH ;)
   * applied comments by Michał (see inlined in the patches);
   * removed the "add usage of CS channel reservation for STA" patch,
     since it's independent and is not ready;

This series is based on top of mac80211-next/master, without including
my combination check changes.  When the combination check patchset
gets applied, I can either send the "merge" of the two features as a
separate patchset or I can modify this patchset accordingly (though I
prefer the former, so I can do things in small steps ;).

--
Cheers,
Luca.

Luciano Coelho (3):
  mac80211: split ieee80211_vif_change_channel in two
  mac80211: implement chanctx reservation
  mac80211: allow reservation of a running chanctx

 include/net/mac80211.h     |   7 ++
 net/mac80211/chan.c        | 227 +++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |  20 +++-
 3 files changed, 236 insertions(+), 18 deletions(-)

-- 
1.8.5.3

