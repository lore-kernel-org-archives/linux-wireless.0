Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3KKIyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 03:54:15 -0500
Message-ID: <1384160048.14334.3.camel@jlt4.sipsolutions.net> (sfid-20131111_095445_219777_31E84391)
Subject: Re: interested in py80211?
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 11 Nov 2013 09:54:08 +0100
In-Reply-To: <52809874.6080908@broadcom.com>
References: <51D49027.9010803@broadcom.com>
	 ( sfid-20130703_225725_898124_EAB997AB) <1373616129.8205.2.camel@jlt4.sipsolutions.net>
	 <52809874.6080908@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 09:42 +0100, Arend van Spriel wrote:

> It has been a while that I touched this topic. It is a spare-time 
> project and that is somewhat limited. Since then I added genl support to 
> libnl python API. I want to extract part of py80211 from nl80211.[ch] 
> files. The easy part were the attribute ids and enum values from 
> nl80211.h. The hurdle I want to leap know is extracting message layout 
> information from nl80211.c. Do the struct nla_policy definitions hold 
> all the information or would it be better to get it from the .doit 
> callbacks.

Well, you probably can't get it in a scripted fashion from the doit
callbacks. The policy certainly has the first level information, but as
soon as you have nested information it will no longer work. The policy
also doesn't always cover data fram the kernel (i.e. kernel->userspace
encoding) since the kernel doesn't have to verify that.

johannes

