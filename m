Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58812 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbeAYJWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 04:22:47 -0500
Message-ID: <1516872160.2189.1.camel@sipsolutions.net> (sfid-20180125_102252_151716_714ECB0A)
Subject: Re: [mac80211-next:master 3/5] net//wireless/wext-compat.c:1351:9:
 warning: function returns address of local variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Pkshih <pkshih@realtek.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Date: Thu, 25 Jan 2018 10:22:40 +0100
In-Reply-To: <1516851660.3774.13.camel@realtek.com> (sfid-20180125_044130_173566_885F00F7)
References: <201801222115.gqohMHIk%fengguang.wu@intel.com>
         <1516851660.3774.13.camel@realtek.com>
         (sfid-20180125_044130_173566_885F00F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-25 at 03:41 +0000, Pkshih wrote:
> 
> In commit c179e9151, you remove 'static' from struct, but function return the
> address of local variable as kbuild robot mentioned. It is a problem, but
> my prior experiment looks fine. Hence, I check the callers of get_wireless_stats(),
> and found they use the address that points to stack immediately, so content of
> stack wasn't broken luckily.
> 
> So, please recall the 'static' of 'struct iw_statistics wstats'.

Yeah, that was garbage. I dropped the patch already.

johannes
