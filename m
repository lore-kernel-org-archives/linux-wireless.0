Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59113 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaHVCZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 22:25:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21494.43519.504368.455733@gargle.gargle.HOWL> (sfid-20140822_042525_305421_BE72FB47)
Date: Fri, 22 Aug 2014 07:55:03 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Joe Perches <joe@perches.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: Add debug information
In-Reply-To: <1408635330.23250.47.camel@joe-AO725>
References: <1408633582-6378-1-git-send-email-sujith@msujith.org>
	<1408635330.23250.47.camel@joe-AO725>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches wrote:
> Perhaps:
> static const char * const offchannel_state[] = {...
> 
> It is typically is an unsafe practice to
> index an char * array with an enum.
> 
> It might be safer to use a lookup function
> (and smaller when ath_dbg is not enabled)
> 
> Something like:
> 
> static const char *offchannel_state_string(enum ath_offchannel_state state)
> {
> #define case_rtn_string(val) case val: return #val
> 	switch (state) {
> 	case_rtn_string(ATH_OFFCHANNEL_IDLE);
> 	case_rtn_string(ATH_OFFCHANNEL_PROBE_SEND);
> 	case_rtn_string(ATH_OFFCHANNEL_PROBE_WAIT);
> 	case_rtn_string(ATH_OFFCHANNEL_SUSPEND);
> 	case_rtn_string(ATH_OFFCHANNEL_ROC_START);
> 	case_rtn_string(ATH_OFFCHANNEL_ROC_WAIT);
> 	case_rtn_string(ATH_OFFCHANNEL_ROC_DONE);
> 	default:
> 		return "unknown";
> 	}
> }

This looks better, I'll send a v2. Thanks for the review.

Sujith
