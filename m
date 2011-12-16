Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63053 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1LPIpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 03:45:34 -0500
MIME-Version: 1.0
Date: Fri, 16 Dec 2011 09:45:33 +0100
Message-ID: <CAGXE3d_ouo4KzQA0-ysLz_RwcqoTc5Sg4V6BZZJP0TJewzNOxw@mail.gmail.com> (sfid-20111216_094542_791952_1F5DC9F2)
Subject: skb->priority usage in wireless frame classification
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: netdev@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Adding netdev]

Maybe someone from the netdev people can shed some light on this.
We've got the following code in net/wireless/util.c for frame classification
(cfg80211_classify8021d):

/* skb->priority values from 256->263 are magic values to
* directly indicate a specific 802.1d priority.  This is used
* to allow 802.1d priority to be passed directly in from VLAN
* tags, etc.
*/
if (skb->priority >= 256 && skb->priority <= 263)
                 return skb->priority - 256;

I was just thinking about making use of this for some internal mac80211
QoS handling. But is this code still valid? At least I haven't found anything
in the 802.1q code :(

Thanks,
Helmut
