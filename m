Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:38982 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZFKLDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 07:03:24 -0400
Message-ID: <4A30E295.6050505@informatik.uni-kl.de>
Date: Thu, 11 Jun 2009 12:55:17 +0200
From: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Zhu Yi <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
	"m_wilhel@informatik.uni-kl.de" <m_wilhel@informatik.uni-kl.de>
Subject: Re: Sending netlink messages in mac80211 tx handler
References: <4A2EEA07.1050306@informatik.uni-kl.de>	 <1244596432.5034.27.camel@debian>  <4A30388F.1020701@informatik.uni-kl.de> <1244716215.4706.11.camel@johannes.local>
In-Reply-To: <1244716215.4706.11.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-06-11 at 00:49 +0200, Reiner Herrmann wrote:
> 
>>>>         nla_put_u32(skb, NL80211_ATTR_DISCOSEC_HELO, 42);
>>>>         genlmsg_end(skb, hdr);
>>>>         genlmsg_unicast(skb, get_daemon_pid());
> 
>> Thank you for your hint! I searched for hours and couldn't
>> find the problem. It's working great now.
> 
> Can I ask what you're trying to achieve? Having local modifications in
> nl80211 is a very bad thing.
> 
> johannes

I want to talk to userspace to do some complex calculations. As this
concerns mac80211 I thought the best way to do that is via nl80211,
whose task it is to provide easy communication between mac80211 and
userspace (like with hostapd and iw).


  Reiner
