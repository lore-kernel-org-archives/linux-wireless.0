Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2LJJ3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 04:29:33 -0500
Message-ID: <1355131788.9857.1.camel@jlt4.sipsolutions.net> (sfid-20121210_102940_332564_5C53F8B8)
Subject: Re: [RFC PATCH] af_packet: don't to defrag shared skb
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: eric@regit.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 10 Dec 2012 10:29:48 +0100
In-Reply-To: <1354919017.9124.33.camel@jlt4.sipsolutions.net> (sfid-20121207_232321_820322_B0AAB1D2)
References: <1354906561-4695-1-git-send-email-eric@regit.org>
	 <20121207.153134.25835204617509469.davem@davemloft.net>
	 <1354915824.9124.11.camel@jlt4.sipsolutions.net>
	 (sfid-20121207_223020_561049_DB965D43) <1354916502.9124.18.camel@jlt4.sipsolutions.net>
	 (sfid-20121207_224129_500056_6617D80D) <1354918363.9124.29.camel@jlt4.sipsolutions.net>
	 (sfid-20121207_231231_221604_E7B34625) <1354919017.9124.33.camel@jlt4.sipsolutions.net>
	 (sfid-20121207_232321_820322_B0AAB1D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 23:23 +0100, Johannes Berg wrote:
> Oh I should say ... IP is like black magic to me ;-)
> 
> > -	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> > +	if (!skb_copy_bits(skb, 0, &iph, sizeof(iph)))
> >  		return skb;
> >  
> > -	iph = ip_hdr(skb);
> > -	if (iph->ihl < 5 || iph->version != 4)
> > +	if (iph.ihl < 5 || iph.version != 4)
> >  		return skb;
> > -	if (!pskb_may_pull(skb, iph->ihl*4))
> > -		return skb;
> > -	iph = ip_hdr(skb);
> > -	len = ntohs(iph->tot_len);
> > -	if (skb->len < len || len < (iph->ihl * 4))
> > +
> > +	len = ntohs(iph.tot_len);
> > +	if (skb->len < len || len < (iph.ihl * 4))
> >  		return skb;
> >  
> > -	if (ip_is_fragment(ip_hdr(skb))) {
> > +	if (ip_is_fragment(&iph)) {
> >  		skb = skb_share_check(skb, GFP_ATOMIC);
> >  		if (skb) {
> > +			if (!pskb_may_pull(skb, iph.ihl*4))
> > +				return skb;
> 
> I moved this here but I have no idea what it does.

Well, ok, looking further it does seem kinda obvious -- ip_defrag()
assumes the IP header is (fully?) present in the skb header, so that's
what this does.

Eric (Leblond), could you test this patch?

johannes

