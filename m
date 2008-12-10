Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:18546 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYLJNpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 08:45:43 -0500
Received: by rv-out-0506.google.com with SMTP id k40so415289rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 05:45:42 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18751.51078.25636.672867@localhost.localdomain> (sfid-20081210_144546_769647_9959CD26)
Date: Wed, 10 Dec 2008 19:13:34 +0530
To: Bob Copeland <me@bobcopeland.com>
Cc: Patrick McHardy <kaber@trash.net>, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, mickflemm@gmail.com,
	mcgrof@gmail.com
Subject: Re: [RFC]: atk5k: fix FCS corruption for ACKs
In-Reply-To: <20081210132440.GA12873@hash.localnet>
References: <493F4DC5.9090801@trash.net>
	<20081210132440.GA12873@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
>    951          /* see if any padding is done by the hw and remove it */
>    952          if (hdrlen & 3) {
>    953                  padsize = hdrlen % 4;
>    954                  memmove(skb->data + padsize, skb->data, hdrlen);
>    955                  skb_pull(skb, padsize);
>    956          }
> 
>    957          /* remove FCS before passing up to protocol stack */
>    958          skb_trim(skb, (skb->len - FCS_LEN));
> 

I remember removing this piece of code...

Sujith
