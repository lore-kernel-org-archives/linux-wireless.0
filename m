Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57890
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988AbXEZVNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 17:13:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
Date: Sat, 26 May 2007 23:13:35 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net> <200705262206.53388.mb@bu3sch.de> <4658A286.1050204@lwfinger.net>
In-Reply-To: <4658A286.1050204@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705262313.35300.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2007 23:11:34 Larry Finger wrote:
> Michael Buesch wrote:
> > On Saturday 26 May 2007 19:55:30 Larry Finger wrote:
> >> Michael Buesch wrote:
> >>> Ok, on which specification bits is this actually based? :)
> >>> txpower_bg still needs a rewrite, and I have a patch for that in
> >>> the pipeline, but it's still buggy due to missing specs stuff.
> >>>
> >> It is not in the V4 specifications that I have found, but the V3 (softmac) driver does this "fixup". 
> > 
> > I cannot find this in the sm driver. Can you give me a hint
> > where to search?
> > 
> >> With it, my 4311 connects with bcm43xx-mac80211. Without it, no connection.
> > 
> > Ok, nice.
> > 
> 
> My memory was faulty earlier, but it is coming back. V3 differs in that txctl1 (the equivalent of 
> tx_bias) is not initialized to 0xFF, but is given a value of 0-3 in bcm43xx_default_txctl1. I added 
> trace code that checked the value being written to radio register 0x52 and dumped the stack when the 
> value was still 0xFF. On that basis, I made it look like the code in bcm43xx_phy_initg when tx_bias 
> is 0xFF.
> 
> Would you prefer the equivalent of bcm43xx_default_txctl1? That wouldn't be difficult.

Ok, I have patches that are designed to fix this. But still not done.

> Are the txpower adjustment bugs a problem with the specs? Is there anything I can do?

I'm not sure what causes this, yet. It's either a bug in estimating
the current power or in calculating the new attenuation values.

-- 
Greetings Michael.
