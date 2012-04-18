Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2DRCX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 22:23:56 -0400
Message-ID: <1334715794.3725.39.camel@jlt3.sipsolutions.net> (sfid-20120418_042401_277180_5341642F)
Subject: Re: [PATCH] iwlwifi: Fix compile when CONFIG_IWLWIFI_DEBUG is not
 defined
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, ilw@linux.intel.com,
	wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 19:23:14 -0700
In-Reply-To: <4f8dfa7b.3JI0H3iulrLPUzPs%Larry.Finger@lwfinger.net> (sfid-20120418_011958_143805_CDD81257)
References: <4f8dfa7b.3JI0H3iulrLPUzPs%Larry.Finger@lwfinger.net>
	 (sfid-20120418_011958_143805_CDD81257)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 18:19 -0500, Larry Finger wrote:
> If CONFIG_IWLWIFI_DEBUG is not defined, the following error results when
> compiling iwlwifi:
> 
>   CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-tt.o
> In file included from drivers/net/wireless/iwlwifi/iwl-agn-tt.c:40:0:
> drivers/net/wireless/iwlwifi/iwl-core.h:97:19: error: static declaration of ‘iwl_alloc_traffic_mem’ follows non-static declaration
> drivers/net/wireless/iwlwifi/iwl-agn.h:513:5: note: previous declaration of ‘iwl_alloc_traffic_mem’ was here
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-agn-tt.o] Error 1
> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Totally fine with me. We have a pending patch to completely remove that
functionality though :-)

johannes

