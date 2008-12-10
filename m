Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:57517 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLJOsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 09:48:51 -0500
Received: by wf-out-1314.google.com with SMTP id 27so210465wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 06:48:50 -0800 (PST)
Message-ID: <b6c5339f0812100648i4c6c6fdar1dcd7590e18efec3@mail.gmail.com> (sfid-20081210_154855_366262_0EAB9307)
Date: Wed, 10 Dec 2008 09:48:50 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [RFC]: atk5k: fix FCS corruption for ACKs
Cc: "Patrick McHardy" <kaber@trash.net>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	mickflemm@gmail.com, mcgrof@gmail.com
In-Reply-To: <18751.51078.25636.672867@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <493F4DC5.9090801@trash.net> <20081210132440.GA12873@hash.localnet>
	 <18751.51078.25636.672867@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 8:43 AM, Sujith <m.sujith@gmail.com> wrote:
>>    957          /* remove FCS before passing up to protocol stack */
>>    958          skb_trim(skb, (skb->len - FCS_LEN));
>>
>
> I remember removing this piece of code...

Hmm, you're right.  I must've been looking at 2.6.27.  Sorry for the noise.

The padding still gets removed regardless of whether there is a payload;
does that truncate the FCS for ACK/CTS frames on ath9k?

>>    952          if (hdrlen & 3) {
>>    953                  padsize = hdrlen % 4;

While we're at it, (for ath5k also) -- hdrlen % 4 can just be hdrlen & 3
again.

-- 
Bob Copeland %% www.bobcopeland.com
