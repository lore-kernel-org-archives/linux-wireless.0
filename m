Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1E3JlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 05:41:02 -0400
Date: Mon, 30 May 2011 11:40:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwlagn: use cts-to-self protection on 5000 adapters
 series
Message-ID: <20110530094031.GA2417@redhat.com> (sfid-20110530_114106_555894_2B3B7FC4)
References: <20110526151422.GA2382@redhat.com>
 <1306421442.14995.325.camel@wwguy-huron>
 <BANLkTimoDkE0Cad4cYm2n2B83RxU3GC5zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTimoDkE0Cad4cYm2n2B83RxU3GC5zQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 08:20:58AM -0700, Daniel Halperin wrote:
> On Thu, May 26, 2011 at 7:50 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > On Thu, 2011-05-26 at 08:14 -0700, Stanislaw Gruszka wrote:
> >> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
> >> index b12c72d..23fa93d 100644
> >> --- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
> >> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
> >> @@ -163,17 +163,9 @@ static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
> >>                                    __le16 fc, __le32 *tx_flags)
> >>  {
> >>       if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
> >> -         info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
> >> +         info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT ||
> >> +         info->flags & IEEE80211_TX_CTL_AMPDU)
> >>               *tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
> >> -             return;
> >> -     }
> >> -
> >> -     if (priv->cfg->ht_params &&
> >> -         priv->cfg->ht_params->use_rts_for_aggregation &&
> >> -         info->flags & IEEE80211_TX_CTL_AMPDU) {
> >> -             *tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
> >> -             return;
> >> -     }
> >>  }
> 
> Shouldn't there be a new "use_cts_for_aggregation" flag and one that
> dominates (looks like use_rts in your setup), rather than this?

Not sure if I understand. Rts-cts and cts-to-self are mutual exclusive
at present, so if use_rts_for_aggregations = 0 mean that cts-to-self
protection must be used. Perhaps we should introduce 4-way module
option like: FORCE_RTS_CTS, FORCE_CTS_TO_SELF, FORCE_NO_PROTECTION,
DEFAULT (HW depend) just for doing experiments.

> I'm
> still a bit confused as to why CTS-to-self should help (as opposed to
> masking some other bug).

I have no idea too, and indeed this could mask some (firmware?) bug.
I think I can explain slight better performance on 6000 - when we
use rts-cts two additional frames must be used when starting BA session,
with cts-to-self only one frame.

Anyway 11n on iwlwifi still need some more investigation and fixing.

Stanislaw
