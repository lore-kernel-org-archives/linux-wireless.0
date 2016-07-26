Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35100 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbcGZDlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 23:41:52 -0400
Subject: Re: [PATCH v3 3/3] mac80211: mesh: fixed HT ies in beacon template
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
References: <20160713200755.26839-1-yanivma@ti.com>
 <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
Cc: Meirav Kama <meiravk@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <2a5bb9ed-c691-a053-2892-4f772d24330f@gmail.com> (sfid-20160726_054220_023924_DD686CE1)
Date: Tue, 26 Jul 2016 12:41:47 +0900
MIME-Version: 1.0
In-Reply-To: <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年07月22日 14:26, Masashi Honma wrote:
 > On 2016年07月14日 05:07, Yaniv Machani wrote:
 >> +
 >> +    /* if channel width is 20MHz - configure HT capab accordingly*/
 >> +    if (sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20) {
 >> +        cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 >> +        cap &= ~IEEE80211_HT_CAP_DSSSCCK40;
 >> +    }
 >
 > I have tested this part of your patch and this works for me.
 >
 > Previouly, "Supported Channel Width Set bit" in HT Capabilities element
 > was 1 even though disable_ht40=1 existed in wpa_supplicant.conf.
 > After appllication of patch, the bit was 0.
 >
 >

# I retransmit this because of mail delivery errors.

I forgot to mention I have used this patch to test.
http://lists.infradead.org/pipermail/hostap/2016-July/036029.html
