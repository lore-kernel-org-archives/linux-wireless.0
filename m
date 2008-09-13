Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50890 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYIMMk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 08:40:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] p54: Fix sparse warnings
Date: Sat, 13 Sep 2008 14:40:01 +0200
Cc: John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
References: <48cab1e3.m0lac7LoL3DFxIu6%Larry.Finger@lwfinger.net> <200809122036.03553.mb@bu3sch.de> <48CABA84.2060404@lwfinger.net>
In-Reply-To: <48CABA84.2060404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809131440.01505.mb@bu3sch.de> (sfid-20080913_144049_117616_E30E3F07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 12 September 2008 20:52:52 Larry Finger wrote:
> Michael Buesch wrote:
> > On Friday 12 September 2008 20:16:03 Larry Finger wrote:
> >>  struct bootrec {
> >>  	__le32 code;
> >>  	__le32 len;
> >> -	u32 data[0];
> >> +	/* Most references to the data section that follows are for u32
> >> +	 * quantities; however, one is for an le16 quantity. The union
> >> +	 * below avoids a cast and makes the usage clearer. */
> >> +	union {
> >> +		u32 data[0];
> >> +		__le16 data16[0];
> >> +	};
> >>  } __attribute__((packed));
> > 
> > I suggest you change
> > 	u32 data[0];
> > to
> > 	__le32 data_le32[0];
> > and also add
> > 	__be32 data_be32[0];
> > to the union. This avoids another few casts.
> > (Maybe you don't even need the __le32 variant. I didn't check all the code).
> 
> No, it won't avoid any casts. The program uses the data area 7 times 
> in native-cpu order, once as be32, and once in little-endian order 

Is the native use correct? Smells fishy.

-- 
Greetings Michael.
