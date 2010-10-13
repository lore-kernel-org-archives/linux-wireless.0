Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0JMT44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 15:56:56 -0400
Received: by iwn42 with SMTP id 42so1239iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 12:56:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB5E0A8.5020502@candelatech.com>
References: <4CAE1DFB.303@candelatech.com>
	<1286479642.20974.32.camel@jlt3.sipsolutions.net>
	<AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
	<AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
	<AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
	<4CB378CD.1080800@candelatech.com>
	<AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
	<4CB3D598.7050904@candelatech.com>
	<AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
	<4CB4AA89.1070009@candelatech.com>
	<20101013053141.GA15798@vasanth-laptop>
	<4CB5E0A8.5020502@candelatech.com>
Date: Wed, 13 Oct 2010 21:56:56 +0200
Message-ID: <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Greear <greearb@candelatech.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

First of all keep up the good work. :)

On Wed, Oct 13, 2010 at 6:39 PM, Ben Greear <greearb@candelatech.com> wrote:
[snip]
> Either way, it seems safer to null out the bf_ampdu field after
> the memory is consumed..it could prevent some tricky bugs later.

I think this is a good idea. But it probably wont be enough to null
out bf_mpdu. You also need to look at bf_buf_addr (which if I
understand correctly is the physical address the DMA engine will
actually write RXed frames to) and bf_dmacontext (which seems in most
cases to hold an identical address and may in fact be where the DMA
engine will really write the frame).

/Björn
