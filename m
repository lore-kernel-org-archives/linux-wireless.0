Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3839 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2CUIV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 04:21:28 -0400
Message-ID: <4F698F7E.9030906@broadcom.com> (sfid-20120321_092134_732469_4BB9D487)
Date: Wed, 21 Mar 2012 09:21:18 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jean-Philippe MENGUAL" <mengualjeanphi@free.fr>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Is there a patch for a bug?
References: <1332265928.7247.1.camel@HP>
In-Reply-To: <1332265928.7247.1.camel@HP>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 06:52 PM, Jean-Philippe MENGUAL wrote:
> Hi,
>
>          I use the 2.6.32 kernel on a Debian system. I use the module
>          mac80211 for my Wifi card. But in more and more numerous cases,
>          I cannot get an IP with dhclient. It fails. While it searches
>          for one, I get:
>          wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 366/186
>
>          Is it a bug in the module? I found some info but not about some
>          patch or fix. Is there a fix in the recent kernel? What release
>          should I use? If no patch, is there some workaround?
>
>          Thanks,
>
>          Sincerely,
>
> Jean-Philippe MENGUAL
>

The message itself means that according to the driver we get a transmit 
packet that exceeds the WMM txop. This message itself does not prevent 
the packet from being transmitted. I have not seen the message lately in 
recent driver versions.

You can either try compat-wireless (see [1]), which should support 
2.6.32. Or you can try the latest 3.3 kernel.

btw. 9 out of 10 times not getting an IP with dhclient means a problem 
with security credentials/handshake/etc. So if the option above do not 
solve your problems, we have to dive into that.

Gr. AvS

[1] http://linuxwireless.org/en/users/Download

