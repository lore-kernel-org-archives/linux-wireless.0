Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:43365 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbZDGNLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 09:11:08 -0400
Received: by qyk16 with SMTP id 16so4714087qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 06:11:07 -0700 (PDT)
Subject: Re: What is needed to inplement a AP support in a driver?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Rami Rosen <roszenrami@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b25312890904070225t44f72ecdsd87a29f7fed341b8@mail.gmail.com>
References: <1239062777.4705.30.camel@maxim-laptop>
	 <b25312890904070225t44f72ecdsd87a29f7fed341b8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 16:11:02 +0300
Message-Id: <1239109862.15015.17.camel@maxim-laptop> (sfid-20090407_151114_804825_AB71B9B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-07 at 12:25 +0300, Rami Rosen wrote:
> Hi,
> > Why iwl3945 still doesn't support AP mode?
> see also this patch, titled: "wlwifi: disable AP mode"
> 
> http://www.spinics.net/lists/linux-wireless/msg24688.html
> 
> Regards,
> Rami Rosen


Quoiting this patch:


> iwlwifi does not support AP mode in any way. For one, it doesn't even
> buffer multicast/broadcast frames properly. We didn't allow zd1211rw AP
> mode to be enabled without this, so iwlwifi shouldn't be allowed to
> advertise AP mode either.
This is interesting, this means it doesn't save frames when client is in power save mode?
IBSS doesn't have this?



> 
> 
> 
> It also doesn't work at all, it doesn't even answer to probe requests,
> I'm guessing the packet injection code was disabled again.
Packet injection (even fragmentation) works fine here.
Also, now hostapd responds to probes isn't it?
(I was said that now hostapd sends/recieves all managment frames)


> 
> 
> [  471.524478] iwlagn: ERROR: APs don't scan
> 
> this is a long-standing bug, of course APs scan to know their
> surroundings, not sure why this is there, it's also very pointless since
> I can remove it by enabling software scan...
Here, software scan fixes it, besides many device don't have hardware scan
> 
> 
> 
> [  487.507346] iwlagn: Microcode SW error detected.  Restarting 0x2000000.
This probably was fixed now, there were many reports about microcode errors.
> 


I just feel, that AP mode can be done, and it isn't that hard to enable it.


Best regards,
	Maxim Levitsky


