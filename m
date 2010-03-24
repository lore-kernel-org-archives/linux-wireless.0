Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36026 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab0CXTVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 15:21:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Wed, 24 Mar 2010 20:21:39 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269377903.21181.8.camel@nayuki> <4BAA1EA3.9060803@lwfinger.net>
In-Reply-To: <4BAA1EA3.9060803@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003242021.39502.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 March 2010 15:16:03 Larry Finger wrote:
> I have modified ssb to supply a MAC address of 80:80:80:80:80:80, rather than

What about also setting the local-assignment bit for this temporary address?

> The one remaining problem is that the interface has already been renamed before
> 60-persistent-b43-mac.rules is processed. In my case, the interface is wlan13,
> not wlan0. After I manually modified 60-..., then the new address is applied.
> I'm still working on this problem.

Well, udev scripts are processed in alphabetical order. Can't you simply run
the persistent mac rules before the persistent ifname rules?

-- 
Greetings, Michael.
