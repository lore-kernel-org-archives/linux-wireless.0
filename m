Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:8589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbYDVRDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 13:03:47 -0400
Received: by wa-out-1112.google.com with SMTP id m16so4005053waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2008 10:03:46 -0700 (PDT)
Message-ID: <1ba2fa240804221003o25515740r71c3210d3c9ffb91@mail.gmail.com> (sfid-20080422_190449_448776_EBE38E9D)
Date: Tue, 22 Apr 2008 20:03:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: 11h IE conflicts with 11s
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found this conflict in information elements in curse of 11h implementation

enum ieee80211_eid {
WLAN_EID_MESH_CONFIG = 36,      /* Pending IEEE 802.11 ANA approval */
WLAN_EID_MESH_ID = 37,          /* Pending IEEE 802.11 ANA approval */

WLAN_EID_SUPPORTED_CHANNELS = 36,
WLAN_EID_CHANNEL_SWITCH = 37,
}

I finding it very unlikely that this IDs will be assigned to MESH IEs
as 11h is already approved.
Currently this makes the 11h implementation let say difficult....

Thanks
Tomas
