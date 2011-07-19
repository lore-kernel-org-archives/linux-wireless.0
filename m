Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr14.hinet.net ([168.95.4.114]:44937 "EHLO msr14.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1GSQTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 12:19:44 -0400
Date: Wed, 20 Jul 2011 00:16:56 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefan Assmann <sassmann@redhat.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
Message-ID: <20110719161656.GA7099@internetdog.org> (sfid-20110719_181948_054950_FC8F4059)
Reply-To: ali@internetdog.org
References: <4E2051F3.20103@redhat.com>
 <4E205984.5040803@lwfinger.net>
 <4E23E56C.9000202@redhat.com>
 <20110718082709.GA8390@internetdog.org>
 <4E23F2E0.3050200@redhat.com>
 <4E2448D2.50502@lwfinger.net>
 <4E244AC6.2030306@redhat.com>
 <4E2454EC.1050900@lwfinger.net>
 <4E25858D.9010407@redhat.com>
 <4E25AB9F.8010607@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E25AB9F.8010607@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2011 at 11:06:55AM -0500, Larry Finger wrote:
> On 07/19/2011 08:24 AM, Stefan Assmann wrote:
> >
> >So far I can say that with scan_ssid=1 after rebooting the AP the
> >connection is properly re-established. Looks promising.
> 
> Your results make sense. The driver is fairly passive in all this.
> It gets TX requests from the MAC layer, and passes received data
> back up to that layer. It seems likely that the MAC layer built into
> r8712u is not keeping track of missing responses, or it is not
> probing the AP. In either case, it would not be productive to devote
> any effort to fixing that part when either using NetworkManager or
> setting scan_ssid for wpa_supplicant establishes periodic scans.
> When these fail to get response from the AP, the softmac code will
> respond, as you see.
> 
> The ultimate fix will be to convert to the driver to use mac80211,

Just what I've been thinking lately. I didn't think it very worthwhile
to invest too much into fixing the miscellany.

regards,
ali

> which is a much better MAC layer. That is on my TODO list, but it
> has low priority.
> 
> Larry
