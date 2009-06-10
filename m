Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:53151 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbZFJW66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 18:58:58 -0400
Message-ID: <4A30388F.1020701@informatik.uni-kl.de>
Date: Thu, 11 Jun 2009 00:49:51 +0200
From: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
	"m_wilhel@informatik.uni-kl.de" <m_wilhel@informatik.uni-kl.de>
Subject: Re: Sending netlink messages in mac80211 tx handler
References: <4A2EEA07.1050306@informatik.uni-kl.de> <1244596432.5034.27.camel@debian>
In-Reply-To: <1244596432.5034.27.camel@debian>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
>>         void* hdr;
>>
>>         if(!skb)
>>                 goto out;
>>
>>         hdr = genlmsg_put(skb, 0, 0, &nl80211_fam, 0, NL80211_CMD_DISCOSEC);
>>         if(IS_ERR(hdr))
>>                 goto free_skb;
>>
>>         nla_put_u32(skb, NL80211_ATTR_DISCOSEC_HELO, 42);
>>         genlmsg_end(skb, hdr);
>>         genlmsg_unicast(skb, get_daemon_pid());
>>
>> free_skb:
>>         nlmsg_free(skb);
> 
> No need to free on the correct path. The skb is added to the
> receive_queue directly for Rx.
> 
> Thanks,
> -yi
> 

Thank you for your hint! I searched for hours and couldn't
find the problem. It's working great now.

Regards,
  Reiner
