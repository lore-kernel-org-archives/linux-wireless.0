Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iggypop2.siwnet.net ([81.216.65.12]:54653 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbXJOLmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 07:42:21 -0400
Message-ID: <35945.80.169.182.16.1192448277.squirrel@www.dactylis.com> (sfid-20071015_124224_970564_04299951)
In-Reply-To: <1192437157.3349.7.camel@johannes.berg>
References: <fdqhn4$qab$1@sea.gmane.org>
    <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
    <1192094159.4770.21.camel@johannes.berg>
    <200710112005.56101.IvDoorn@gmail.com>
    <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
    <1192216713.4770.58.camel@johannes.berg>
    <1192217047.4770.61.camel@johannes.berg>
    <56412.80.169.182.16.1192431887.squirrel@www.dactylis.com>
    <1192437157.3349.7.camel@johannes.berg>
Date: Mon, 15 Oct 2007 13:37:57 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
From: "Marcus Better" <marcus@better.se>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2007-10-15 at 09:04 +0200, Marcus Better wrote:
>> The new patch doesn't seem to solve the problem either. I get the same
>> association failure as before.

Update: on my second recompile (after adding the printks) it started
working. I'm not sure why it failed the first time.

However there is a huge performance regression. "tptest" shows a TCP
throughput of under 300 kbit for the driver version 2.0.9 (current
wireless-2.6), compared to 7 Mbit for version 2.0.7 (with kernel
2.6.23-rc3). The UDP speed was also affected but not as much, down from
around 5-10 Mbit to 1 Mbit.

> Can you add back your printk patch and check what type 'channel' was and
> maybe print channel->channel?

With the printks below I get the following:

Oct 15 13:14:43 better kernel: selected mode 2
Oct 15 13:14:43 better kernel: selected channel 8

Thanks,

Marcus

--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -314,6 +314,8 @@ int ieee80211_set_channel(struct ieee80211_local
*local, int
        }

        if (set) {
+               printk(KERN_DEBUG "selected mode %d\n",
local->oper_hw_mode->mod
+               printk(KERN_DEBUG "selected channel %d\n",
local->oper_channel->
                if (local->sta_scanning)
                        ret = 0;
                else


