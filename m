Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:37257 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3CHV6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 16:58:37 -0500
Received: from fea.lerya.net (fea.lerya.net [10.9.0.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.lerya.net (Postfix) with ESMTPS id ED613804B9
	for <linux-wireless@vger.kernel.org>; Fri,  8 Mar 2013 22:58:34 +0100 (CET)
Date: Fri, 8 Mar 2013 22:58:33 +0100
From: Vincent Brillault <gentoo@lerya.net>
To: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130308215833.GA2829@Fea.lerya.net> (sfid-20130308_225841_187782_2847D4B9)
References: <20130307192920.GB8668@Fea.lerya.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130307192920.GB8668@Fea.lerya.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

I forgot to mention that those warning from mac80211 (the associated
comments in the code are 'RC is busted' or 'uh huh?') seems to somehow
disable completely the rate control: 'iw wlan0 link' gives 'tx bitrate:'
with nothing after. Furthermore, I loose the network from time to time
on reason 7. I went back to kernel 3.8.0: if there is enough traffic
continuously, the link is stable but I loose it randomly when there is
no traffic.

I made more debug on the 3.8.0 kernel, the first warning correspond to
the following test:
(info->control.rates[i].idx) 15 >= (sband->n_bitrates) 12

Please tell me what test I can make to find the source of this problem.

Thanks in advance,
Vincent Brillault
