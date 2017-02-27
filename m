Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36642 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbdB0NzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 08:55:14 -0500
Message-ID: <1488202062.28431.7.camel@sipsolutions.net> (sfid-20170227_145520_137975_711270FF)
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 14:27:42 +0100
In-Reply-To: <20170223120211.22358-2-andrew.zaborowski@intel.com> (sfid-20170223_133157_932062_C356BD66)
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
         <20170223120211.22358-2-andrew.zaborowski@intel.com>
         (sfid-20170223_133157_932062_C356BD66)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Additionally I tried to add a HWSIM_ATTR_WIPHY to report the wiphy
> index directly without users going through wiphy name to index
> mapping, but get_wiphy_idx() is internal to cfg80211.  The index is
> exposed to userspace and is more useful than the name so I wonder if
> this function should be exported from cfg80211.

Do you really need the address?

I'd actually prefer to *only* have the wiphy index, and I don't really
see a problem with moving the wiphy_idx from struct
cfg80211_registered_device to struct wiphy.

johannes
