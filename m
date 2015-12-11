Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33312 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbbLKNtH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 08:49:07 -0500
Message-ID: <1449841741.2324.2.camel@sipsolutions.net> (sfid-20151211_144932_338094_66BA094A)
Subject: Re: [linux-next] iwl_mvm_get_key_sta_id() suspicious RCU usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Fri, 11 Dec 2015 14:49:01 +0100
In-Reply-To: <20151211134418.GA29351@swordfish> (sfid-20151211_144614_821713_0C346E06)
References: <20151211134418.GA29351@swordfish>
	 (sfid-20151211_144614_821713_0C346E06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-12-11 at 22:44 +0900, Sergey Senozhatsky wrote:

> [ 6385.246300] drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1226
> suspicious rcu_dereference_protected() usage!
> 

Funny, Laura Abbott also reported this bug earlier today :)

I've sent out a fix, you can see it here:
https://patchwork.ozlabs.org/patch/555587/

johannes
