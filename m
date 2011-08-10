Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54753 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1HJAeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 20:34:21 -0400
Received: by ywf7 with SMTP id 7so377911ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 17:34:20 -0700 (PDT)
Date: Tue, 9 Aug 2011 19:34:14 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mike Ricketts <mike@earth.li>
Cc: 625953@bugs.debian.org, Geoff Simmons <gsimmons@gsimmons.org>,
	linux-wireless@vger.kernel.org
Subject: Re: hostap: connection drops after 10 minutes
Message-ID: <20110810003413.GA5398@elie.gateway.2wire.net> (sfid-20110810_023425_511711_151C10B8)
References: <20110507103107.3576.18188.reportbug@wibble.chf>
 <20110507142643.GC2616@chmmr.gsimmons.org>
 <Pine.LNX.4.64.1105091949450.32120@heaven.on.earth.li>
 <20110509210324.GM2268@decadent.org.uk>
 <Pine.LNX.4.64.1105100821330.32120@heaven.on.earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.1105100821330.32120@heaven.on.earth.li>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mike,

Mike Ricketts wrote:

> Looking through the dmesg log, there is  something very odd going on, in
> that the hostap driver appears to have  created both a wlan0 and a wifi0.

Not sure what that is about.  But it seems harmless for the moment
(please feel free to file a separate bug about it if it causes
problems, or to ask upstream at <http://hostap.epitest.fi/> if
curious).

> I tried configuring wifi0-eth0 instead of eth0, and things improved - it
> seemed to work for about 10 minutes, before dropping out again.  At the
> point it dropped, these errors were logged:
[...]
> wifi0-eth0: Deauthenticate all stations
> wifi0-eth0: invalid skb->cb magic (0x00000000, expected 0xf08a36a2)
> wifi0-eth0: invalid skb->cb magic (0x00000000, expected 0xf08a36a2)
[...]
> wifi0-eth0: invalid skb->cb magic (0x00000000, expected 0xf08a36a2)
> wifi0-eth0: STA 88:9f:fa:ff:9e:3c did not ACK activity poll frame
> wifi0-eth0: sending disassociation info to STA 88:9f:fa:ff:9e:3c(last=271152, jiffies=346490)
> wifi0-eth0: sending deauthentication info to STA 88:9f:fa:ff:9e:3c(last=271152, jiffies=346740)
> wifi0-eth0: Could not find STA 88:9f:fa:ff:9e:3c for this TX error (@346745)

Hm.  There have been some hostap fixes recently, though they are not
likely to have affected this.  Could you test version 3.0.0-1 from
Debian unstable and if it fails, report it at
<http://hostap.epitest.fi/bugz/>, product "Host AP driver" and send
the bug number to 625953@bugs.debian.org for tracking?

Thanks and hope that helps,
Jonathan
