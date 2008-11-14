Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36255 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbYKNFJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 00:09:36 -0500
Message-ID: <491D080E.7040505@lwfinger.net> (sfid-20081114_060943_268492_4F325FD0)
Date: Thu, 13 Nov 2008 23:09:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] rtl8187: throughput fix/conf_tx callback/ack tx pkts
References: <1226590756-10743-1-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1226590756-10743-1-git-send-email-herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Three patches that fixes/introduces the following in rtl8187:
> - Fixes 8187B reported throughput issues after short slot handling addition.
> - Implement conf_tx callback, instead of hardcoding some tx queue values.
> - Make rate control work for 8187B sending correct feedback about transmitted
>   packet status, using one of the Bulk In endpoints that provides this info.

With these 3 patches applied, my throughput improved again. Using sftp with an
128 MB file, my transmit rate increased to to 1.5 MB/s. With tcpperf, I get 9.9
Mb/s - roughly the same.

I'm using the 'pid' rate-control method, which now stabilizes at a lower stated
rate than previously seen, but the throughput is higher. Curious.

Larry
