Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:58102 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761242AbXLMNOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 08:14:31 -0500
Date: Thu, 13 Dec 2007 14:07:54 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Johannes Berg <johannes@sipsolutions.net>, jt@hpl.hp.com
Cc: Andrew Lunn <andrew@lunn.ch>, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH] wirelesstools: More user space validation of
	channel/frequency
Message-ID: <20071213130754.GE501@lunn.ch> (sfid-20071213_131446_145631_E8585C71)
References: <20071212153158.GB16947@lunn.ch> <1197481426.6558.138.camel@johannes.berg> <20071212180204.GP31218@lunn.ch> <1197482969.6558.149.camel@johannes.berg> <1197504975.6558.199.camel@johannes.berg> <20071213120904.GB501@lunn.ch> <1197549025.6558.253.camel@johannes.berg> <20071213125047.GD501@lunn.ch> <1197550398.6558.257.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197550398.6558.257.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 01:53:18PM +0100, Johannes Berg wrote:
> 
> > However this description does not match the implementation. The
> > implementation is that its a channel if e = 0. My "frequency" is > 1000,  
> > but it was still interpreted as a channel. Looking at the
> > implementation of iw_float2freq(), the description should be that a
> > value less than 1e9 is a channel. 
> > 
> > So there should really be a check in the user space tools which says
> > that values between 1000 and 1e9 are invalid. This would catch errors
> > like the one i made for both 2.4GHz and 5GHz.
> 
> Yeah, well, we all know wext sucks. You are of course right, but I think
> that nobody's motivated any more to fix things.

Well, here is a patch suggestion. If it got me, it will get others,
and i think this little patch will help. 

    Andrew

Signed-off-by Andrew Lunn <andrew@lunn.ch>
---
--- wireless_tools.30-clean/iwconfig.c	2007-09-18 01:38:08.000000000 +0200
+++ wireless_tools.30/iwconfig.c	2007-12-13 13:57:16.000000000 +0100
@@ -791,6 +791,13 @@
 	      if(unit[0] == 'k') freq *= KILO;
 	    }
 
+	  if (freq >= 1000.0 && freq < 1e9) {
+	    fprintf(stderr, "Invalid channel/frequency. \n");
+	    fprintf(stderr, "Channels must be < 1000. \n");
+	    fprintf(stderr, "Frequencies must be > 1GHz\n");
+	    return (IWERR_ARG_TYPE);
+	  }
+
 	  iw_float2freq(freq, &(wrq.u.freq));
 
 	  wrq.u.freq.flags = IW_FREQ_FIXED;


