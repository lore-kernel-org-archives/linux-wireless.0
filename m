Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:63081 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZGAUnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 16:43:43 -0400
Message-ID: <4A4BCA87.8020805@lwfinger.net>
Date: Wed, 01 Jul 2009 15:43:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Build error in 2.6.31-rc1-wl
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building the above kernel based on a fress pull of
wireless-testing, I get the following build error:

  CC      net/core/skbuff.o
net/core/skbuff.c: In function ‘__copy_skb_header’:
net/core/skbuff.c:563: error: ‘struct sk_buff’ has no member named
‘do_not_encrypt’
net/core/skbuff.c:563: error: ‘const struct sk_buff’ has no member
named ‘do_not_encrypt’
make[2]: *** [net/core/skbuff.o] Error 1

The code that errors is

        new->vlan_tci           = old->vlan_tci;
#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
        new->do_not_encrypt     = old->do_not_encrypt;
#endif

        skb_copy_secmark(new, old);
}

Larry
