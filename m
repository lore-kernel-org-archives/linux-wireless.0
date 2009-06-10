Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZFJBWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 21:22:31 -0400
Subject: Re: Sending netlink messages in mac80211 tx handler
From: Zhu Yi <yi.zhu@intel.com>
To: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
	"m_wilhel@informatik.uni-kl.de" <m_wilhel@informatik.uni-kl.de>
In-Reply-To: <4A2EEA07.1050306@informatik.uni-kl.de>
References: <4A2EEA07.1050306@informatik.uni-kl.de>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 09:13:52 +0800
Message-Id: <1244596432.5034.27.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-10 at 07:02 +0800, Reiner Herrmann wrote:
> Hi,
> 
> I want to register a TX handler for mac80211 and send a (generic)
> netlink message in it. But everytime the handler gets invoked and
> the message sent, the kernel crashes.
> 
> 
> A minimal version of the TX handler looks like that:
> 
> 
> static ieee80211_tx_result debug_noinline
> ieee80211_tx_h_test(struct ieee80211_tx_data *tx)
> {
>         struct sk_buff* skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);

I think you need GFP_ATOMIC here.

>         void* hdr;
> 
>         if(!skb)
>                 goto out;
> 
>         hdr = genlmsg_put(skb, 0, 0, &nl80211_fam, 0, NL80211_CMD_DISCOSEC);
>         if(IS_ERR(hdr))
>                 goto free_skb;
> 
>         nla_put_u32(skb, NL80211_ATTR_DISCOSEC_HELO, 42);
>         genlmsg_end(skb, hdr);
>         genlmsg_unicast(skb, get_daemon_pid());
> 
> free_skb:
>         nlmsg_free(skb);

No need to free on the correct path. The skb is added to the
receive_queue directly for Rx.

Thanks,
-yi

