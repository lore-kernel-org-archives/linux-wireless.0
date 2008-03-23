Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gondor.com ([212.117.64.182]:1793 "EHLO moria.gondor.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757100AbYCWX7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 19:59:50 -0400
Date: Mon, 24 Mar 2008 00:57:19 +0100
From: Jan Niehusmann <jan@gondor.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: trigger ieee80211_sta_work after opening
	interface
Message-ID: <20080323235718.GA5389@x61s.gondor.com> (sfid-20080323_235955_478592_0EFF1713)
References: <20080323192355.GA5773@x61s.gondor.com> <1206310595.16475.190.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206310595.16475.190.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 23, 2008 at 11:16:35PM +0100, Johannes Berg wrote:
> On Sun, 2008-03-23 at 20:23 +0100, Jan Niehusmann wrote:
> > To fix this behaviour, trigger execution of ieee80211_sta_work from
> > ieee80211_open when in STA or IBSS mode.
> 
> What happens with this patch when you haven't set any configuration
> items before bringing the interface up? We want it to do nothing, if
> that behaviour is kept the patch should be fine.

As far as I can tell (without knowing mac80211 very well), ifsta->state
should be IEEE80211_DISABLED on an unconfigured interface. With 
ifsta->state==IEEE80211_DISABLED, ieee80211_sta_work only does the
following:

	[...]
        while ((skb = skb_dequeue(&ifsta->skb_queue)))
                ieee80211_sta_rx_queued_mgmt(dev, skb);
	[...]
        if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
                if (ieee80211_sta_config_auth(dev, ifsta))
                        return;
                clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
        } else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
                return;

This looks quite safe, especially as ifsta->skb_queue should be empty
in DISABLED state (ieee80211_rx_h_mgmt doesn't enqueue packets unless
mode is STA or IBSS).

I also just tried it, calling 'ifconfig wlan0 up' on an otherwise
unconfigured interface didn't have any obvious effect.

BTW, after doing this, I noticed that setting essid first and the WEP
encryption key later didn't lead to associated state. Again, I had to
trigger association by calling 'iwconfig wlan0 essid ...' or 'iwconfig
wlan0 ap any' after setting the key. Is this behaviour expected?

Jan
