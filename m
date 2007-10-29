Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:44219 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbXJ2Hye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 03:54:34 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1ImPSD-0004Y7-Sd
	for linux-wireless@vger.kernel.org; Mon, 29 Oct 2007 03:54:34 -0400
Subject: Re: iwl3945 lists supported rates backwards
From: Pavel Roskin <proski@gnu.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240710191714j645c8bfp87a2269b9c141c52@mail.gmail.com>
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <1ba2fa240710191714j645c8bfp87a2269b9c141c52@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 03:54:30 -0400
Message-Id: <1193644470.27622.15.camel@dv> (sfid-20071029_075437_696981_D0D7AD43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-10-20 at 02:14 +0200, Tomas Winkler wrote:
> I've sent a patch that fixes that few days ago.It should be in the
> latest version 1.1.18 ''Fix rate setting in probe request for HW sacn'
> I did test it only with 4965 but it's a same code.

The problem is with association requests, not probe requests.  Current
wireless-2.6/everything still has the problem, and if I use
disable_hw_scan=1, probe requests have incorrect rates as well, and they
are sent at 6 Mbps, so 802.11b only APs don't see them.

-- 
Regards,
Pavel Roskin

