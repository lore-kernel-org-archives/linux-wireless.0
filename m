Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2FYIau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 04:30:50 -0400
Message-ID: <1340613038.4589.10.camel@jlt3.sipsolutions.net> (sfid-20120625_103054_521867_4C928EF2)
Subject: Re: iwlwifi: "GF was set with SGI:SISO"
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 10:30:38 +0200
In-Reply-To: <87lijfjkjk.fsf@nemi.mork.no> (sfid-20120622_195839_040723_F4125B6E)
References: <87lijfjkjk.fsf@nemi.mork.no>
	 (sfid-20120622_195839_040723_F4125B6E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 19:58 +0200, Bjørn Mork wrote:
> Hello,
> 
> I just started receiving these mysterious error messages on each
> transmitted packet:
> 
> 
> Jun 22 19:48:21 nemi kernel: [255522.415447] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
> Jun 22 19:48:21 nemi kernel: [255522.445200] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
> Jun 22 19:48:21 nemi kernel: [255522.448130] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
> Jun 22 19:48:21 nemi kernel: [255522.454865] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
> Jun 22 19:48:21 nemi kernel: [255522.474708] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
> Jun 22 19:48:21 nemi kernel: [255522.486878] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
> 
> which seems to originate from this code in
> drivers/net/wireless/iwlwifi/dvm/rs.c :
> 
>                 if (use_green) {
>                         rate_n_flags |= RATE_MCS_GF_MSK;
>                         if (is_siso(tbl->lq_type) && tbl->is_SGI) {
>                                 rate_n_flags &= ~RATE_MCS_SGI_MSK;
>                                 IWL_ERR(priv, "GF was set with SGI:SISO\n");
>                         }
>                 }
> 
> 
> 
> But I do fail to see what I as an user is expected to do about this...
> 
> Could the message be improved with some end user guidance?  And it
> should obviously be rate-limited.

There's nothing you can do about it, I'll just downgrade it -- see patch
below, also for an explanation.

> This is the first time I notice this issue, so I don't think it's very
> reproducible.

Too bad, I would've been interested in a command trace when this
happens, but it would have to be a fairly long-running trace before the
error message happens.

Were you in some special place when this happened? It has to be an 11n
AP that is greenfield capable, with no 11a/b/g stations connected to it.
Maybe some 11g client disconnected from the AP and then the messages
started showing up?

johannes


[PATCH] iwlwifi: turn down "GF was set with SGI:SISO" message

Single-stream SGI is incompatible with greenfield,
802.11-12 says:
  NOTE—Short GI is not used in HT-greenfield format
  with one spatial stream, in which case the HT-SIG
  is immediately followed by data. It is very
  difficult to parse the HT-SIG in time to demodulate
  these data with the correct GI length if the GI
  length is not known in advance.

The error indicates that somehow the RS algorithm
tried to select 1x1 with SGI while the station is
in greenfield mode, which shouldn't happen, but
there's no need to flood the log with the message
either.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 6fddd27..39d26f2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -598,7 +598,8 @@ static u32 rate_n_flags_from_tbl(struct iwl_priv *priv,
 			rate_n_flags |= RATE_MCS_GF_MSK;
 			if (is_siso(tbl->lq_type) && tbl->is_SGI) {
 				rate_n_flags &= ~RATE_MCS_SGI_MSK;
-				IWL_ERR(priv, "GF was set with SGI:SISO\n");
+				IWL_DEBUG_RATE(priv,
+					       "GF was set with SGI:SISO\n");
 			}
 		}
 	}
-- 
1.7.10



