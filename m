Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0JGT1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 15:27:24 -0400
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAE1DFB.303@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com>
	 <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
	 <4CAB5F3D.9060201@candelatech.com>
	 <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
	 <4CAB627F.8020804@candelatech.com>
	 <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
	 <4CAB64AD.4080105@candelatech.com>
	 <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
	 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
	 <1286475250.20974.22.camel@jlt3.sipsolutions.net>
	 <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
	 <4CAE13F6.2010003@candelatech.com>
	 <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
	 <4CAE1DFB.303@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 21:27:22 +0200
Message-ID: <1286479642.20974.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 12:22 -0700, Ben Greear wrote:

> After reboot, and re-run of the script,
> I saw this in the logs, and shortly after,
> the SLUB poison warning dumped to screen.
> 
> Maybe those DMA errors are serious?

> ath: Failed to stop TX DMA in 100 msec after killing last frame
> ath: Failed to stop TX DMA. Resetting hardware!

That's TX DMA, it can hardly result in invalid memory writes like the
ones you've been seeing.

I'm still convinced something is wrong with ath9k RX DMA, as you've seen
the contents of frames written to already freed memory regions. Since I
don't know anything about ath9k, you should probably not rely on me
though :-)

johannes

