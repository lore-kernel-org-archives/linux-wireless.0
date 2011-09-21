Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43143 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1IUACc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 20:02:32 -0400
Received: by gxk6 with SMTP id 6so773604gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 17:02:31 -0700 (PDT)
Message-ID: <4E792994.1080809@lwfinger.net> (sfid-20110921_020241_922701_C58B1128)
Date: Tue, 20 Sep 2011 19:02:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: linux-wireless@vger.kernel.org, george0505@realtek.com
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com>
In-Reply-To: <4E7907D3.1020606@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2011 04:38 PM, Chiefdome wrote:
> I tried at least wireless-next but the adapter isn't showing up.
> Where to get more log files and stuff?
> Isnt this adapter good supported by the rtl8192cu driver or where is the problem?

For the mainline kernel to work with 802.11n-only APs and to reconnect after an 
initial try, your kernel needs the following patches:

commit bac2555c6d86387132930af4d14cb47c4dd3f4f7
Author: George <george0505@realtek.com>
Date:   Sat Sep 3 10:58:48 2011 -0500

     rtlwifi: Fix problem when switching connections

     The driver fails to clear encryption keys making it impossible
     to switch connections.

     Signed-off-by: George <george0505@realtek.com>
     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
     Cc: Stable <stable@kernel.org>        [2.6.39+]
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 3401dc6eba788ebc7c14ce51018d775b1c263399
Author: George <george0505@realtek.com>
Date:   Sat Sep 3 10:58:47 2011 -0500

     rtlwifi: rtl8192su: Fix problem connecting to HT-enabled AP

     The driver fails to connect to 802.11n-enabled APs. The patch fixes
     Bug #42262.

     Signed-off-by: George <george0505@realtek.com>
     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
     Cc: Stable <stable@kernel.org>        [2.6.39+]
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Both of these are in wireless-testing, and were just merged into the mainline 
kernel. In addition, they were merged with the 3.0 stable tree today.

Both should be in wireless-next, but as I recall, you were not able to test with 
that tree.

With the updated mainline kernel, the link is stable and performance is 
acceptible with netperf TCP_STREAM (TX) at 20.5 +/- 4.8 Mbps and TCP_MAERTS (RX) 
of 21.7 +/- 3.8 Mbps. These numbers are not spectacular, but they will do.

Larry

