Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbYFIJXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 05:23:44 -0400
Date: Mon, 9 Jun 2008 02:23:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CONFIG_IWL4965_HT=n in linux-next
Message-Id: <20080609022341.16060b71.akpm@linux-foundation.org> (sfid-20080609_112347_083546_09B48E0D)
In-Reply-To: <1ba2fa240806090220y4a21d3d2k84143e2a4ee0cb1a@mail.gmail.com>
References: <20080609015623.6bbc9d88.akpm@linux-foundation.org>
	<1ba2fa240806090220y4a21d3d2k84143e2a4ee0cb1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 9 Jun 2008 12:20:14 +0300 "Tomas Winkler" <tomasw@gmail.com> wrote:

> On Mon, Jun 9, 2008 at 11:56 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_siso_to_other':
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1439: error: 'struct iwl_priv' has no member named 'current_ht_config'
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1443: error: 'struct iwl_priv' has no member named 'current_ht_config'
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_mimo_to_other':
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1530: error: 'struct iwl_priv' has no member named 'current_ht_config'
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1534: error: 'struct iwl_priv' has no member named 'current_ht_config'
> 
> It's a known issue.

Sob.  Well please fix it urgently!  Poeple are trying to get work done
on top of linux-next.

> we are about to remove this conditional. Will
> happen till EOW.


I hacked around it:


From: Andrew Morton <akpm@linux-foundation.org>

Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-4965-rs.c~drivers-net-wireless-iwlwifi-iwl-4965-rsc-config_iwl4965_ht=n-hack drivers/net/wireless/iwlwifi/iwl-4965-rs.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c~drivers-net-wireless-iwlwifi-iwl-4965-rsc-config_iwl4965_ht=n-hack
+++ a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1435,6 +1435,7 @@ static int rs_move_siso_to_other(struct 
 			}
 			break;
 		case IWL_SISO_SWITCH_GI:
+#ifdef CONFIG_IWL4965_HT
 			if (!tbl->is_fat &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_20MHZ))
@@ -1443,7 +1444,7 @@ static int rs_move_siso_to_other(struct 
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_40MHZ))
 				break;
-
+#endif
 			IWL_DEBUG_RATE("LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
@@ -1526,6 +1527,7 @@ static int rs_move_mimo_to_other(struct 
 			break;
 
 		case IWL_MIMO_SWITCH_GI:
+#ifdef CONFIG_IWL4965_HT
 			if (!tbl->is_fat &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_20MHZ))
@@ -1533,6 +1535,7 @@ static int rs_move_mimo_to_other(struct 
 			if (tbl->is_fat &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_40MHZ))
+#endif
 				break;
 
 			IWL_DEBUG_RATE("LQ: MIMO toggle SGI/NGI\n");
_

