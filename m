Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35416 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAFPIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:08:11 -0500
Received: by mail-wi0-f169.google.com with SMTP id j9so2856092wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 07:08:10 -0800 (PST)
Date: Mon, 6 Jan 2014 16:07:17 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state
 machine
Message-ID: <20140106150716.GA5358@magnum.frso.rivierawaves.com> (sfid-20140106_160815_689872_00E40AE2)
References: <529CF2D6.1080008@gmail.com>
 <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 02, 2013 at 10:59:24PM +0200, Emmanuel Grumbach wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> Rewrite the search cycle state machine to use a more data
> oriented approach where the different Tx columns (configs)
> limitations and next columns to search are reprsented in
> tables which are easy to change. This overhaul also includes
> several major fixes:
> 
> 1. Prevent going back to a specific Tx column in a search
> cycle if it was already explored.
> 
> 2. Avoid switching to a Tx column that doesn't have any chance
> if it performs perfectly to beat the current throughput we're
> getting.
> 
> These issues were degrading throughput as they were causing
> switching to "bad" Tx columns.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/rs.c |  921 +++++++++++++++------------------
>  drivers/net/wireless/iwlwifi/mvm/rs.h |   64 +--
>  2 files changed, 458 insertions(+), 527 deletions(-)
> 
> @@ -1772,7 +1712,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
[...]
> -	if (done_search && !lq_sta->stay_in_tbl) {
> +	if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
>  		/* If the "active" (non-search) mode was legacy,
[...]

Hi,

Trying -testing right now on my laptop and this commit broke aggregation.

I haven't looked at the code but this seemed to help :
-	if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
+       if (done_search && lq_sta->rs_state != RS_STATE_STAY_IN_COLUMN)


 
Karl
