Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbYCETfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 14:35:19 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 4/8] mac80211: RCU-ify STA info structure access
Date: Wed, 5 Mar 2008 11:25:17 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003D3BA48@orsmsx416.amr.corp.intel.com> (sfid-20080305_193525_140984_5A3DA2CC)
In-Reply-To: <1204709005.25502.38.camel@johannes.berg>
References: <20080222111644.183587000@sipsolutions.net> <20080222111749.689180000@sipsolutions.net> <D936D925018D154694D8A362EEB0892003CFB0E4@orsmsx416.amr.corp.intel.com> <1204709005.25502.38.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "John Linville" <linville@tuxdriver.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<linux-wireless@vger.kernel.org>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 05, 2008 1:23 AM, Johannes Berg  wrote:

>> This patch is causing some problems in the iwlwifi driver. Often when
>> one of these RCU locks are held the driver tries to send a command to
>> the device and waits for the response, or it does some other activity
>> requiring sleeping. This causes numerous BUG messages as seen below:
>> 
>> BUG: sleeping function called from invalid context at
>> /home/rchatre/wifi/repos.git/iwlwifi-2.6/kernel/mutex.c:209
> 
> 
>>  [<dca8e637>] iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
>>  [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
> 
> Ouch, sorry. Try this patch please.

This patch made those BUG messages disappear. Thank you very much.

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
