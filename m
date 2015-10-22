Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33264 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbbJVC0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 22:26:49 -0400
Message-ID: <1445480807.22974.91.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20151022_042657_320564_AB8ADF0F)
Subject: Re: [RFC v3 1/2] iwlwifi: pcie: allow to build an A-MSDU using TSO
 core
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"ido@wizery.com" <ido@wizery.com>
Date: Wed, 21 Oct 2015 19:26:47 -0700
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AB280@hasmsx107.ger.corp.intel.com>
References: <1445452464-19525-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1445452464-19525-2-git-send-email-emmanuel.grumbach@intel.com>
	 <1445470211.22974.86.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8AB280@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-22 at 00:14 +0000, Grumbach, Emmanuel wrote:

> 
> Well. I guess I should at least check, but even with very small MSS, our
> device supports up to 20 pointers for the same 802.11 packet: 2 are for
> metadata. So basically, so leaves me only 18 pointers. for each MSS I
> need at least 2 (one for the headers and one for the payload), so I will
> have at most 9 of these for one packet, even with a tiny MSS.
> 

I did not see in your patch where you made the checks about 18 segs in a
TSO packet ?

> I agree that all this should be added to the code in a comment.
> Speaking of which...
> int tso_count_descs(struct sk_buff *skb)
> {
>         /* The Marvell Way */
>         return skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags;
> }
> 
> What if there is some payload in the header?
> To me it sounds safer to return:
> 
> skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags + 1;
> 
> or maybe to test if there is some payload in the header and then add 1?
> If there is payload in the header, it should be considered as another
> frag, shouldn't it?

Minimal count is gso_segs (one per MSS)

Then you have to add extra for the cases we have a mss spanning a frag
in skb.

Thats a max of (skb_shinfo(skb)->nr_frags - 1) + (data_in_head() ? 1 :
0);

So I believe formula would be correct.


