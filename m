Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gatenc.microcortex.com ([81.84.247.49]:41766 "HELO
	micro-cortex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1756553Ab3CQTDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 15:03:09 -0400
Received: from sintra.microCortex.com (localhost [127.0.0.1])
	by sintra.microCortex.com (8.14.5/8.14.5) with ESMTP id r2HIuQV1014889
	for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 18:56:26 GMT
Received: (from mar@localhost)
	by sintra.microCortex.com (8.14.5/8.14.5/Submit) id r2HIuP0Z014886
	for linux-wireless@vger.kernel.org; Sun, 17 Mar 2013 18:56:25 GMT
Date: Sun, 17 Mar 2013 18:56:25 +0000
From: Antonio Maretzek <antonio.maretzek@microcortex.com>
To: linux-wireless@vger.kernel.org
Subject: rtl8723ae losing IP connectivity (3.8.2 + 3.9-rc2)
Message-ID: <20130317185625.GA11200@itqb.unl.pt> (sfid-20130317_200315_071569_3A6AAFA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
(please CC me)
I have a "rtl8723ae" losing connectivity.
I can reproduce that. So, if somebody wants to send me patches, I think
I can test them.
(this machine is for Win7, not Linux, and I have to hand it out soon)
Hardware:
Toshiba Sat. Pro C850-1F5, PN PSCBXE-01800CEP,
lspci: 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8723]
Software:
Kernel: tested with 3.8.2 + 3.9-rc2
Don't know for sure if they behave excatly the same.
Firmware: rtl8723fw_B blob-993c7f6ecea30c5bae914c4c22152735d8eb0d61 (20130312)

Behaviour depends on power-on path. Power-on -> Win7 -> reboot -> Linux
results in a different behaviour from Power-on -> Linux.

Observations:
(Power-on -> Linux)
- DHCP gets done, some ping to the laptop make it through.
- Then, pings to the laptop get lost, may start working again, or not.
- Transferrates are about 500 kB/s, AP at about 1 m.
- If pings are comming back and ping is stopped, restarting ping
  will not show pings comming back immediatly (see below).
- ping response to the laptop is ok when a ping from the laptop is active.
  (started from a script in inittab)
(Power-on -> Win7 -> reboot -> Linux)
- pings don't fail (at least for 3.9-rc2) initially.
- Transferrates are about 250 kB/s

Hope this was useful...

Some additional info:

(Power-on -> Linux, 3.9-rc2)
ping 192.168.112.107
PING 192.168.112.107 (192.168.112.107) 56(84) bytes of data.
64 bytes from 192.168.112.107: icmp_req=1 ttl=64 time=194266 ms
64 bytes from 192.168.112.107: icmp_req=2 ttl=64 time=193266 ms
64 bytes from 192.168.112.107: icmp_req=3 ttl=64 time=192266 ms
64 bytes from 192.168.112.107: icmp_req=4 ttl=64 time=191267 ms
64 bytes from 192.168.112.107: icmp_req=5 ttl=64 time=190268 ms
64 bytes from 192.168.112.107: icmp_req=6 ttl=64 time=189269 ms
64 bytes from 192.168.112.107: icmp_req=7 ttl=64 time=188272 ms
64 bytes from 192.168.112.107: icmp_req=8 ttl=64 time=187275 ms
64 bytes from 192.168.112.107: icmp_req=193 ttl=64 time=2276 ms
64 bytes from 192.168.112.107: icmp_req=194 ttl=64 time=1277 ms
64 bytes from 192.168.112.107: icmp_req=195 ttl=64 time=279 ms
64 bytes from 192.168.112.107: icmp_req=196 ttl=64 time=2.15 ms
64 bytes from 192.168.112.107: icmp_req=197 ttl=64 time=1.67 ms
64 bytes from 192.168.112.107: icmp_req=198 ttl=64 time=3.58 ms
64 bytes from 192.168.112.107: icmp_req=199 ttl=64 time=1.59 ms
64 bytes from 192.168.112.107: icmp_req=200 ttl=64 time=1.41 ms
^C
--- 192.168.112.107 ping statistics ---
200 packets transmitted, 16 received, 92% packet loss, time 199005ms
rtt min/avg/max/mdev = 1.418/95624.968/194266.838/95159.788 ms, pipe 195

Regards, Antonio (Maretzek)
