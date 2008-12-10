Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1305 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYLJNYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 08:24:45 -0500
Date: Wed, 10 Dec 2008 08:24:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	mickflemm@gmail.com, mcgrof@gmail.com
Subject: Re: [RFC]: atk5k: fix FCS corruption for ACKs
Message-ID: <20081210132440.GA12873@hash.localnet> (sfid-20081210_142450_421041_6465C830)
References: <493F4DC5.9090801@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <493F4DC5.9090801@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 06:04:05AM +0100, Patrick McHardy wrote:
> This might not be fully correct or not handle other cases where
> this can occur, but it doesn't seem too hackish and fixes the
> problem for me :)

> -		if (hdrlen & 3) {
> +		if (hdrlen & 3 && hdrlen != rs.rs_datalen - FCS_LEN) {
>  			pad = hdrlen % 4;
>  			memmove(skb->data + pad, skb->data, hdrlen);
>  			skb_pull(skb, pad);

It seems very plausible to me.  Though, why doesn't ath9k also have this
problem?  Luis, it looks like in that case ath9k could trim two extra
bytes if ath9k hw behaves the same.

main.c:

   951          /* see if any padding is done by the hw and remove it */
   952          if (hdrlen & 3) {
   953                  padsize = hdrlen % 4;
   954                  memmove(skb->data + padsize, skb->data, hdrlen);
   955                  skb_pull(skb, padsize);
   956          }

   957          /* remove FCS before passing up to protocol stack */
   958          skb_trim(skb, (skb->len - FCS_LEN));

-- 
Bob Copeland %% www.bobcopeland.com

