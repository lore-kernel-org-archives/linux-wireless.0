Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaHRHXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 03:23:14 -0400
Message-ID: <53F1A9DE.7070701@linux.intel.com> (sfid-20140818_092317_500302_A7B43C9D)
Date: Mon, 18 Aug 2014 10:23:10 +0300
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: core: Reorder wiphy_register() notifications
 relevantly
References: <1407935091-28516-1-git-send-email-tomasz.bursztyka@linux.intel.com>	 (sfid-20140813_150457_552550_15CAEAC1) <1408107825.15705.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1408107825.15705.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Subject should say cfg80211.

Ok

>> >Currently it can send regulatory domain change notification before any
>> >NEW_WIPHY notification. Moreover, if rfill_register() fails, calling
>> >wiphy_unregister() will send a DEL_WIPHY though no NEW_WIPHY had been
>> >sent previously.
>> >
>> >Thus reordering so it properly notifies NEW_WIPHY before any other.
> This also isn't actually true - now rfkill is*after*  NEW_WIPHY.

I will prepare another patch.

> This code had a bunch of sequencing issues in the past - please look
> through the history and check that this doesn't re-introduce any of
> them.

Sure

Tomasz
