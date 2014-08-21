Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:60690 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751398AbaHUPfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 11:35:34 -0400
Message-ID: <1408635330.23250.47.camel@joe-AO725> (sfid-20140821_173538_156199_5E17A465)
Subject: Re: [PATCH] ath9k: Add debug information
From: Joe Perches <joe@perches.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Date: Thu, 21 Aug 2014 08:35:30 -0700
In-Reply-To: <1408633582-6378-1-git-send-email-sujith@msujith.org>
References: <1408633582-6378-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-08-21 at 20:36 +0530, Sujith Manoharan wrote:

> Add a few statements to debug channel context operation.
[]
> diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
> index 0ce9e40..da5b522 100644
> --- a/drivers/net/wireless/ath/ath9k/channel.c
> +++ b/drivers/net/wireless/ath/ath9k/channel.c
> @@ -16,6 +16,16 @@
>  
>  #include "ath9k.h"
>  
> +static const char *offchannel_state[] = {
> +	"ATH_OFFCHANNEL_IDLE",
> +	"ATH_OFFCHANNEL_PROBE_SEND",
> +	"ATH_OFFCHANNEL_PROBE_WAIT",
> +	"ATH_OFFCHANNEL_SUSPEND",
> +	"ATH_OFFCHANNEL_ROC_START",
> +	"ATH_OFFCHANNEL_ROC_WAIT",
> +	"ATH_OFFCHANNEL_ROC_DONE",
> +};

Perhaps:
static const char * const offchannel_state[] = {...

It is typically is an unsafe practice to
index an char * array with an enum.

It might be safer to use a lookup function
(and smaller when ath_dbg is not enabled)

Something like:

static const char *offchannel_state_string(enum ath_offchannel_state state)
{
#define case_rtn_string(val) case val: return #val
	switch (state) {
	case_rtn_string(ATH_OFFCHANNEL_IDLE);
	case_rtn_string(ATH_OFFCHANNEL_PROBE_SEND);
	case_rtn_string(ATH_OFFCHANNEL_PROBE_WAIT);
	case_rtn_string(ATH_OFFCHANNEL_SUSPEND);
	case_rtn_string(ATH_OFFCHANNEL_ROC_START);
	case_rtn_string(ATH_OFFCHANNEL_ROC_WAIT);
	case_rtn_string(ATH_OFFCHANNEL_ROC_DONE);
	default:
		return "unknown";
	}
}


