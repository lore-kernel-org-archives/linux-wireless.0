Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:58013 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYFYQHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 12:07:12 -0400
Received: by ug-out-1314.google.com with SMTP id h2so126456ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 09:07:08 -0700 (PDT)
Message-ID: <f6ca9fed0806250907od5f5ff1m7469075e2a68e627@mail.gmail.com> (sfid-20080625_180717_043629_B5387F84)
Date: Wed, 25 Jun 2008 18:07:08 +0200
From: drago01 <drago01@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
Cc: "Tomas Winkler" <tomas.winkler@intel.com>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1214409527.5881.21.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
	 <1214409527.5881.21.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 25, 2008 at 5:58 PM, Pavel Roskin <proski@gnu.org> wrote:
>
>> +                     time_diff = jiffies - bss->last_update > mid_range ?
>> +                             jiffies - bss->last_update :
>> +                             bss->last_update - jiffies;
>
> That's pretty hairy.  Do we really lack a function to calculate time
> difference?

what about elapsed_jiffies() in iwl-helpers.h ?...
should be moved to a generic place (include/linux/jiffies.h) so that
other users can access it.
