Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11.bullet.mail.ird.yahoo.com ([77.238.189.64]:24135 "HELO
	nm11.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756764Ab3LEP53 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:57:29 -0500
Message-ID: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com> (sfid-20131205_165733_059424_F6F2D350)
Date: Thu, 5 Dec 2013 15:57:27 +0000 (GMT)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Using wmediumd in kernel 3.10
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Dear all,

I would like to use wmediumd with linuxwireless backports 3.10.

The problem is that as indicated in this post: http://www.spinics.net/lists/linux-wireless/msg96575.html, wmediumd is not supported in this kernel. Quoting from the post:

"To use mac80211_hwsim for testing channel contexts it has to support them, and for that it has to support hw scan and hw-remain-on-channel.
Since it's pure software, the off-channel activities are really not off-channel but listening and sending on a second channel. Also, the multi-channel isn't really doing TDM, it's just on both channels at the same time. 
Note that this breaks wmediumd right now as it doesn't propagate the channel."


In particular, wmediumd crashes whenever the first packet between the two mac80211_hwsim radios is sent. Specifically the place in mac80211_hwsim.c where the error occurs is in this call inside the function hwsim_tx_info_frame_received_nl():

mac80211_hwsim_monitor_ack(txi->rate_driver_data[0], hdr->addr2);

In mac80211_hwsim_monitor_ack() a crash occurs whenever accessing a field of txi->rate_driver_data[0], which is of type struct ieee80211_channel.

So, I would like to ask for support in any of the following:

1- Guidance on how to fix wmediumd for kernel 3.10.
2- Advise on another tool with functionality equivalent to that of wmediumd, i.e. introducing delay and drop probability to packets exchanged between mac80211_hwsim radios, and that works with kernel 3.10.

Best Regards

Daniel
