Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23804 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933935AbXC0CR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 22:17:58 -0400
Subject: Re: [PATCH 4/5] mac80211: fix iwlist wlanX key behavior
From: Hong Liu <hong.liu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070323192815.6082e716@griffin.suse.cz>
References: <1174015697.3408.39.camel@devlinux-hong>
	 <20070323192815.6082e716@griffin.suse.cz>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 10:07:10 +0800
Message-Id: <1174961230.3664.17.camel@napa-sdv1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

return correct key info in SIOCGIWRANGE, iwconfig will use this info to
further query the key info by SIOCGIWENCODE.



Signed-off-by: Hong Liu <hong.liu@intel.com>

---

 net/mac80211/ieee80211_ioctl.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

85a09073975e027e2b613396c0bb1b31f72e8fc2
diff --git a/net/mac80211/ieee80211_ioctl.c
b/net/mac80211/ieee80211_ioctl.c
index 46fd125..839c565 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1595,6 +1595,11 @@ static int ieee80211_ioctl_giwrange(stru
        range->min_frag = 256;
        range->max_frag = 2346;

+       range->encoding_size[0] = 5;
+       range->encoding_size[1] = 13;
+       range->num_encoding_sizes = 2;
+       range->max_encoding_tokens = NUM_DEFAULT_KEYS;
+
        range->max_qual.qual = local->hw.max_signal;
        range->max_qual.level = local->hw.max_rssi;
        range->max_qual.noise = local->hw.max_noise;
--
1.3.3


On Fri, 2007-03-23 at 19:28 +0100, Jiri Benc wrote:
> On Fri, 16 Mar 2007 11:28:21 +0800, Hong Liu wrote:
> > Signed-off-by: Hong Liu <hong.liu@intel.com>
> 
> Please add a description.
> 
> Thanks,
> 
>  Jiri
> 
