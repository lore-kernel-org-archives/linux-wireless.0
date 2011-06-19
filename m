Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1FSIHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 04:07:38 -0400
Subject: Re: [PATCH 01/18] iwlagn: usersapce application decide the size of
 trace buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1307802352-16398-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165547_476196_E1FC1744)
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1307802352-16398-2-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110611_165547_476196_E1FC1744)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:07:32 +0200
Message-ID: <1308470852.4145.2.camel@jlt3.sipsolutions.net> (sfid-20110619_100742_388436_AE85CB73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-06-11 at 07:25 -0700, Wey-Yi Guy wrote:

> +++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
> @@ -167,6 +167,7 @@ enum iwl_tm_attr_t {
>  	 */
>  	IWL_TM_ATTR_TRACE_ADDR,
>  	IWL_TM_ATTR_TRACE_DATA,
> +	IWL_TM_ATTR_TRACE_SIZE,
>  
>  	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
>  	 * The mandatory fields are:

I know that currently there are no applications, but I really think we
need to be much more careful about this as it is quickly becoming ABI,
so you can't just insert attributes in the middle.

johannes

