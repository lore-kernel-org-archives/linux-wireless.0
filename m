Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3583 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3BQOlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 09:41:23 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression caused by commit df88129
Date: Sun, 17 Feb 2013 14:41:21 +0000
Message-ID: <8887AA04B7EC49479420AE48C5F94A93017ACD48@NASANEXD02D.na.qualcomm.com> (sfid-20130217_154130_093447_2052D481)
In-Reply-To: <51207925.5040702@lwfinger.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2/17/13 8:31 AM, "Larry Finger" <Larry.Finger@lwfinger.net> wrote:

>IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)

I do see one of these (which, I'd assume, is actually expected if you
have something on the system that runs to transmit before 4-way
handshake is completed).

>wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
>wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)

But this does not show up in my tests with mac80211_hwsim and the
current wireless-testing.git and hostap.git snapshots.

>The regression was bisected to commit
>df881293c6ba9a12868491a717b25cb14ec1fa4a.

Did you confirm that the latest snapshot works with this reverted?

>If you need any more debugging output for this problem, please let me
>know.

Since I was unable to reproduce, some more debug output could be
useful. Please at least verify that the STA entry for the AP is not
marked authorized. The next step would be to check whether sta_set_flags
in wpa_supplicant driver_nl80211.c is failing. Unfortunately, it looks
like the current implementation does not make this very clear in the
debug log, so some additional prints may be needed there.

Please also describe the security configuration (WPA2-Personal/CCMP?)
that you are using.

- Jouni

