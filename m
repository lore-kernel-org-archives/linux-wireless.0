Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62157 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbaGYI4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 04:56:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: handle attention flags correctly when using A-MSDU
References: <1406193931-5478-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Fri, 25 Jul 2014 11:56:04 +0300
In-Reply-To: <1406193931-5478-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Thu, 24 Jul 2014 11:25:31 +0200")
Message-ID: <871tt9rf4r.fsf@kamboji.qca.qualcomm.com> (sfid-20140725_105615_784750_48B8C866)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> In case of A-MSDU RX we should check attention flags
> correctly to be sure we report correct FCS status for
> A-MSDU subframes. Without a patch we could report A-MSDU
> subframes with wrong FCS as a correct to the stack, next
> get a lot of DUP ACK TCP packets. Finally TP drop is seen
> and this drop depends on FCS errors ratio for A-MSDU frame.
>
> Example test case when TP drop is seen:
> - ath10k configured as an AP
> - used ath10k station
> - forced A-MSDU (7 frames) on STA
> - other traffic on channel (often FCS errors)
> - monitor iface added on AP
> - TCP STA -> AP traffic (iperf)
>
> a) Iperf logs for case without the patch:
>
> echo "1 64" > htt_max_amsdu_ampdu // disable A-MSDU
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0- 5.0 sec  56.6 MBytes  95.0 Mbits/sec
> [  3]  5.0-10.0 sec  60.4 MBytes   101 Mbits/sec
> [  3] 10.0-15.0 sec  60.2 MBytes   101 Mbits/sec
> [  3] 15.0-20.0 sec  60.2 MBytes   101 Mbits/sec
> [  3] 20.0-25.0 sec  63.8 MBytes   107 Mbits/sec
> [  3] 25.0-30.0 sec  64.9 MBytes   109 Mbits/sec
>
> echo "7 64" > htt_max_amsdu_ampdu  // set 7 A-MSDU subframes
> [  3] 30.0-35.0 sec  40.0 MBytes  67.1 Mbits/sec
> [  3] 35.0-40.0 sec  35.9 MBytes  60.2 Mbits/sec
> [  3] 40.0-45.0 sec  36.9 MBytes  61.9 Mbits/sec
> [  3] 45.0-50.0 sec  37.9 MBytes  63.5 Mbits/sec
> [  3] 50.0-55.0 sec  34.5 MBytes  57.9 Mbits/sec
> [  3] 55.0-60.0 sec  25.4 MBytes  42.6 Mbits/sec
> [  3] 60.0-65.0 sec  48.2 MBytes  81.0 Mbits/sec
> [  3] 65.0-70.0 sec  28.8 MBytes  48.2 Mbits/sec
> [  3] 70.0-75.0 sec  29.2 MBytes  49.1 Mbits/sec
> [  3] 75.0-80.0 sec  22.9 MBytes  38.4 Mbits/sec
> [  3] 80.0-85.0 sec  26.4 MBytes  44.2 Mbits/sec
> [  3] 85.0-90.0 sec  31.5 MBytes  52.8 Mbits/sec
>
> b) Iperf logs for case with patch:
>
> echo "1 64" > htt_max_amsdu_ampdu // disable A-MSDU
> [  3] local 192.168.12.2 port 57512 connected with 192.168.12.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0- 5.0 sec  60.8 MBytes   102 Mbits/sec
> [  3]  5.0-10.0 sec  62.2 MBytes   104 Mbits/sec
> [  3] 10.0-15.0 sec  60.9 MBytes   102 Mbits/sec
>
> echo "7 64" > htt_max_amsdu_ampdu  // set 7 A-MSDU subframes
> [  3] 15.0-20.0 sec  68.1 MBytes   114 Mbits/sec
> [  3] 20.0-25.0 sec  80.5 MBytes   135 Mbits/sec
> [  3] 25.0-30.0 sec  83.0 MBytes   139 Mbits/sec
> [  3] 30.0-35.0 sec  79.1 MBytes   133 Mbits/sec
> [  3] 35.0-40.0 sec  77.1 MBytes   129 Mbits/sec
> [  3] 40.0-45.0 sec  77.4 MBytes   130 Mbits/sec
>
> Reported-by: Denton Gentry <denton.gentry@gmail.com>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

> *v2 - changed commit message

And extra thanks to the good commit log. This is exactly what I want to
see in a commit log and I'm sure I'm not alone on this :)

-- 
Kalle Valo
