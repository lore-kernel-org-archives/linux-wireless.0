Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34216 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZCZECJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 00:02:09 -0400
Message-ID: <20090326000207.2tv3ky8vhwck04og-cebfxv@webmail.spamcop.net> (sfid-20090326_050222_739279_EDBCE9EE)
Date: Thu, 26 Mar 2009 00:02:07 -0400
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [BISECTED] AR5414 fails to scan after "ath5k:
	Update reset code"
References: <1238020625.15025.15.camel@mj>
	<40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com>
In-Reply-To: <40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Nick Kossifidis <mickflemm@gmail.com>:

> That's weird, I've tested this with my 5413 and it works just fine. It
> seems that 5424 (pci-e version of 5413) still has some issues. Have
> you tried monitor mode ?

The monitor mode is fine.

I also looked at the probe requests and probe responses and could not  
find any differences before and after the patch.  The requests are  
sent, the AP answers with responses.  The signal strength of the probe  
requests is the same.  But the scan command returns nothing.

So I'm not even sure if the problem is with transmitting or receiving.  
  My guess is that the problem is with receiving after transmitting.   
That's the simplest remaining explanation.  Or maybe it's a problem  
with receiving after changing the channel.

I'll try to reduce the patch to the minimum.

-- 
Regards,
Pavel Roskin
