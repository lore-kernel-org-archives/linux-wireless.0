Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:45329 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbXLWEkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 23:40:06 -0500
Received: from ssnt2.quns.cam.ac.uk ([131.111.255.37]:60734 helo=neotoaster.lan)
	by ppsw-1.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.151]:25)
	with esmtpsa (PLAIN:ssnt2) (TLSv1:DHE-RSA-AES256-SHA:256)
	id 1J6Id8-00018U-5x (Exim 4.67) for linux-wireless@vger.kernel.org
	(return-path <ssnt2@hermes.cam.ac.uk>); Sun, 23 Dec 2007 04:40:03 +0000
From: Shawn Tan <ssnt2@eng.cam.ac.uk>
Reply-To: ssnt2@eng.cam.ac.uk
To: linux-wireless@vger.kernel.org
Subject: Re: B43 not working
Date: Sun, 23 Dec 2007 04:39:59 +0000
References: <200712230117.35920.ssnt2@eng.cam.ac.uk> <200712230408.37562.ssnt2@eng.cam.ac.uk> <20071223051405.4f3ceedd@morte>
In-Reply-To: <20071223051405.4f3ceedd@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712230439.59567.ssnt2@eng.cam.ac.uk> (sfid-20071223_044010_781833_7086084B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 23 December 2007 04:14:05 Stefano Brivio wrote:
> You shouldn't need to load the rc80211_simple module which came with
> Ubuntu. I think that the compat package comes with a rate control algorithm
> built into mac80211 itself, so please just try to unload the Ubuntu
> mac80211 and load the compat one. For sure Luis (the compat maintainer) has
> more clues on this, anyway.

Yes, that's what I did initially. (1) download latest compat-wireless archive 
from the website (2) make; make install (3) make unload; make load. And the 
result is what I got in the original message, i.e. b43 "failed to select rate 
control algorithm".

John suggested that I modprobe rc80211_simple, which tries to load the ubuntu 
rc80211 module that complains about symbol version problems. If I try loading 
rc80211 before I load b43, it loads, but then b43 suffers from the symbol 
problems instead.

Cheers.

-- 
with metta,
Shawn Tan

Centre for Advanced Photonics and Electronics
Department of Engineering, University of Cambridge
9 JJ Thomson Avenue, Cambridge CB3 0FA, UK.
