Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-c.mailcontrol.com ([168.143.177.190]:46782 "EHLO
	cluster-c.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXC1K1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 06:27:43 -0400
Received: from rly21c.srv.mailcontrol.com (localhost.localdomain [127.0.0.1])
	by rly21c.srv.mailcontrol.com (MailControl) with ESMTP id l2S9hVs6002600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2007 10:43:31 +0100
Received: from submission.mailcontrol.com (submission.mailcontrol.com [86.111.216.190])
	by rly21c.srv.mailcontrol.com (MailControl) id l2S9geiN000791
	for linux-wireless@vger.kernel.org; Wed, 28 Mar 2007 10:42:40 +0100
Message-ID: <460A3665.5090906@csr.com>
Date: Wed, 28 Mar 2007 10:33:25 +0100
From: Mark Powell <Mark.Powell@csr.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: WPA/RSN information in cfg80211?
References: <1175034846.5151.20.camel@johannes.berg>
In-Reply-To: <1175034846.5151.20.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Looking through wpa_supplicant and then through the kernel I notice that
> we currently in the kernel special-case some things in SIOCSIWAUTH, for
> example IW_AUTH_WPA_VERSION is ignored since we rely on the IE that wpa
> supplicant gave us.
>   
FWIW we currently use the value of IW_AUTH_WPA_VERSION to generate the
correct cipher suite selector when forming the set-key request for our
hard MAC device. We use other IW_AUTH settings too.
> ...
>
> I'm inclined to just require userspace to put both the IE and the
> individual settings into the relevant nl80211 messages, but then we
> might just as well piece the IE together from those settings, no?
>   
We certainly need the individual settings. It is nice that
wpa_supplicant generates the IE - it saved me writing the code - but
that's just being lazy. We still have to modify the IE anyway to add WMM
stuff.

Mark

-- 
Mark Powell                              mailto:Mark.Powell@csr.com
Group Leader, Host Drivers               Tel: +44 (0)1223 692000
CSR, Business Park, Cowley Road, Cambridge, CB24 0WZ, UK



To access the latest news from CSR copy this link into a web browser:  http://www.csr.com/email_sig.php

To get further information regarding CSR, please visit our Investor Relations page at http://ir.csr.com/csr/about/overview
