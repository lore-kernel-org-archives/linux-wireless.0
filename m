Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55865 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbbA3Tlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 14:41:31 -0500
Message-ID: <1422646885.1919.38.camel@sipsolutions.net> (sfid-20150130_204135_114218_0CDA8072)
Subject: Re: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2015 20:41:25 +0100
In-Reply-To: <54CBCFB6.2030003@broadcom.com> (sfid-20150130_193850_855908_3048A8D9)
References: <54C6A717.5050804@broadcom.com> <54CBCADA.4050801@broadcom.com>
	 <54CBCE5A.9080404@hauke-m.de> <54CBCFB6.2030003@broadcom.com>
	 (sfid-20150130_193850_855908_3048A8D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 19:38 +0100, Arend van Spriel wrote:
> On 01/30/15 19:32, Hauke Mehrtens wrote:
> > Or we just backport this version every time:
> >
> > struct net *get_net_ns_by_fd(int fd)
> > {
> > 	return ERR_PTR(-EINVAL);
> > }
> >
> 
> I was going for the easy way out over here. Either way is fine by me, 
> but is net namespace support can not be properly backported I would say 
> got for the version above.

I agree, I think we should go for the always-fail one.

johannes

