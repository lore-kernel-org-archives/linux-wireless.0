Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:38463 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZHLS1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:27:17 -0400
Received: by fxm28 with SMTP id 28so178058fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:27:17 -0700 (PDT)
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwl3945: fix compilation error in iwl3945_pass_packet_to_mac80211()
References: <20090812110727.4963.99515.stgit@tikku>
	<1250091440.30019.5928.camel@rc-desk>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 12 Aug 2009 21:27:13 +0300
In-Reply-To: <1250091440.30019.5928.camel@rc-desk> (reinette chatre's message of "Wed\, 12 Aug 2009 08\:37\:20 -0700")
Message-ID: <87ocqkkhvi.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> On Wed, 2009-08-12 at 04:07 -0700, Kalle Valo wrote:
>> Commit "iwlwifi: Traffic type and counter for debugFs" broke iwl3945 in
>> a case when CONFIG_IWLWIFI_LEDS is disabled:
>> 
>> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)
>> 
>> Fix it by removing the ifdef check for hdr variable.

[...]

> We have an identical patch pending. I assumed most people compile with
> led support and thus did not rush to get it in.

I don't remember why I have leds disabled. Most probably some problem a
long time ago and I never bothered to turn it back on.

> Now that it is a problem for more people I think this one should go
> in.

I agree that this should go in. Compilation errors are always annoying.

-- 
Kalle Valo
