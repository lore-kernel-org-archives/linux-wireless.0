Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3KQJQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 04:16:33 -0500
Message-ID: <1384679792.14795.9.camel@jlt4.sipsolutions.net> (sfid-20131117_101638_208335_673BBC52)
Subject: Re: [Query] Update mac80211 BSS info from cfg8011_bss_inform_frame
 when hw_scan is enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 17 Nov 2013 10:16:32 +0100
In-Reply-To: <CABPxzYJAct6KtwqZY-DOgjf1wueSmeOU=iLku+gGeZ6ZVE6n9Q@mail.gmail.com> (sfid-20131115_205008_175326_68AE2C33)
References: <CABPxzYJAct6KtwqZY-DOgjf1wueSmeOU=iLku+gGeZ6ZVE6n9Q@mail.gmail.com>
	 (sfid-20131115_205008_175326_68AE2C33)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-16 at 01:19 +0530, Krishna Chaitanya wrote:

> In those scenarios, the rate control module minstrel_ht called from
> prep_connection throws a warning (in rate_control_send_low)
> because "supp_rates" is not set, since scan results are updated
>  through "cfg8011_bss_inform_frame" which doesn't call
> "ieee80211_bss_info_update'.
> 
> How do we handle such scenarios? Does the cfg80211 need to
> update the bss information in mac80211?

No. What are you smoking?

You're not supposed to even call cfg80211_bss_inform_frame() from a
mac80211-based driver. Just report the RX frame properly.

johannes

