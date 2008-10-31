Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33994 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbYJaXcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 19:32:18 -0400
Message-ID: <490B957E.8020406@lwfinger.net> (sfid-20081101_003225_034282_B0005F16)
Date: Fri, 31 Oct 2008 16:32:14 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx callback/correctly
 ack tx pkts
References: <1225467722-31684-1-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1225467722-31684-1-git-send-email-herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Two patches for two current issues in rtl8187:
> - First it should implement conf_tx callback, instead of hardcoding some tx
>   queue values.
> - The second one should make rate control work for 8187B sending correct
>   feedback about transmitted packet status, using one of the Bulk In endpoints
>   that provides this info. Unfortunately after recently rate control api rewrite
>   in my testing here I don't get anymore greater than 1M rate with pid, before I
>   would still get until 9M (and after some time falling to 1M, then going back
>   up in steps, and so on) on same environment, don't know if it's expected to
>   the new rate control api be more strict/have different behaviour, or if
>   something additional must be done in rtl8187 (the link/signal quality may be
>   too low and may be new rate control changes are more sensitive).
> 
> Please test and check if there are any additional issues.

With these patches installed, my RTL8187B device was stuck at 1 Mbs using the
'pid' algorithm. Without them, the rate rapidly increases to 54 Mbs. I'm roughly
2 m from my AP, and get an indicated signal of -22 dBm and a link quality of
98/100. My kernel is from wireless-testing (v2.6.28-rc2-4159-g6c11cd2) with the
rtl8187 power control and timing patches submitted earlier. There are no changes
to any of the mac80211 components.

Larry
