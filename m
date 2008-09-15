Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:43556 "EHLO
	viefep24-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbYIOTCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:02:49 -0400
Received: from gollum.odi.ch ([84.74.148.76]) by viefep24-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080915190246.HEFN891.viefep24-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Mon, 15 Sep 2008 21:02:46 +0200
Received: from [192.168.111.10] (mithril [192.168.111.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id 37AC8196FE0
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 21:02:45 +0200 (CEST)
Message-ID: <48CEB155.9070401@odi.ch> (sfid-20080915_210253_282790_9C190CF6)
Date: Mon, 15 Sep 2008 21:02:45 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] Don't destroy authentication	algorithm	before	authenticating.
References: <48CE8452.9080604@odi.ch>	 (sfid-20080915_175050_484202_3CD78757) <1221494039.3700.47.camel@johannes.berg>	 <48CE86B6.6080704@odi.ch>	 (sfid-20080915_180118_027162_C9C60EF5) <1221494673.3700.54.camel@johannes.berg>	 <48CE8FBE.2040000@odi.ch> <1221502509.3700.71.camel@johannes.berg>
In-Reply-To: <1221502509.3700.71.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The packet capture indicates that the packets are retransmitted
> indicating  that the AP isn't even acknowledging them, which in turn
> indicates it's not receiving them. This suggests there's something wrong
> with ath9k, are you positive it works with those mac80211 hacks?
> 
> johannes

You're very right. I just moved my laptop into the same room where the AP is. 
And guess what: auth and association works straight away. Apparently ath9k sets 
up the card so badly that the transmission power is extremely low! Also I 
couldn't set any other rate than 1M.

So, please forget about these 2 patches. They should not be necessary. Instead I 
will focus on debugging ath9k.

Cheers

Ortwin
