Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3563 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab1JXMuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:50:37 -0400
Message-ID: <4EA55F13.5020300@broadcom.com> (sfid-20111024_145049_926644_93A7AEEA)
Date: Mon, 24 Oct 2011 14:50:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111017@schottelius.org>
cc: "Eric Dumazet" <eric.dumazet@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org> <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org> <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org> <4E9FBFA7.4040502@broadcom.com>
 <20111022015945.GC26186@ethz.ch> <4EA3E6AD.4030701@broadcom.com>
 <20111023105305.GA2489@schottelius.org>
 <20111023194823.GB2489@schottelius.org>
In-Reply-To: <20111023194823.GB2489@schottelius.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2011 09:48 PM, Nico Schottelius wrote:
> Update, just triggered it after a suspend/resume cycle:
> 
> This changes every some seconds right now, because the connection
> is established/shutdown and thus dhcpcd retries to get the ip address
> every few seconds.
> 
> I've restarted the AP, but the situation stays the same.
> 
> The other devices in the network work fine, so it's really my system
> that behaves "funny".
> 
> After that I've reloaded brcmsmac at 84262.797365, after which
> the connection time lasted longer, but was also interrupted some
> time later.
> 
> dmesg attached again.
> 
> Cheers,
> 
> Nico
> 

I tried to make sense of the dmesg log you sent me. Not sure what is
happening so could do the following:

1. Determine wpa_supplicant version using -v option.
2. Add '-ddt' option in DBus service file:
	wpa_supplicant >= 0.7: fi.w1.wpa_supplicant1.service
	wpa_supplicant < 0.7:  fi.epitest.hostap.WPASupplicant.service
   (located in /usr/share/dbus-1/system-services/).
3. Reproduce the problem and sent /var/log/syslog.

Thanks
AvS

