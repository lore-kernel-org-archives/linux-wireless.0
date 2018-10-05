Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46608C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0349920875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0349920875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbeJERBY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:01:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12981 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbeJERBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:01:24 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A258307D90F;
        Fri,  5 Oct 2018 10:03:21 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90F5769FDB;
        Fri,  5 Oct 2018 10:03:20 +0000 (UTC)
Date:   Fri, 5 Oct 2018 12:03:18 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
Message-ID: <20181005100318.GA22691@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
 <1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com>
 <20181005074422.GA1931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005074422.GA1931@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 05 Oct 2018 10:03:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 05, 2018 at 09:44:23AM +0200, Stanislaw Gruszka wrote:
> > Below screenshots show iperf test from MS150N (RF5370) device connected to RT3070 adapter running AP mode:
> > 
> > This is with standard openwrt build without any rt2x00 changes:
> > 
> > [url=https://postimg.cc/BtYQLf6r][img]https://i.postimg.cc/BtYQLf6r/shot-2018-10-04_17-23-56.jpg[/img][/url]
> > 
> > And this printscreen show iperf test with your changes:
> > 
> > [url=https://postimg.cc/D8Sf1p48][img]https://i.postimg.cc/D8Sf1p48/shot-2018-10-04_17-42-09.jpg[/img][/url]
> 
> My experience is that performance between two rt2800 devices vary with
> no apparent reason. There are two problems I know that maigh affect
> performance at random (and I think there are also some other low level
> problems that I'm not aware of that cause performance fluctuations).
> 
> First problem is that HW aggregate RATE_PROBE frames with other frames
> at different rate, so we can not do rate probing properly for rate
> control algorithm.
> 
> Second problem: we send BAR when we fail to send a frame and this might
> have positive and negative effect, depend what remote hardware do when it
> gets BAR. This seems to be problem when two rt2800 devices are connected
> and not a problem if rt2800 is connected with ath or iwl devices.

I have such results without patches:

[root@dhcp-27-155 ~]# iperf3 -c 192.168.9.1
Connecting to host 192.168.9.1, port 5201
[  4] local 192.168.9.11 port 60040 connected to 192.168.9.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  1.67 MBytes  14.0 Mbits/sec    0   72.1 KBytes       
[  4]   1.00-2.00   sec  1.43 MBytes  12.0 Mbits/sec    0    123 KBytes       
[  4]   2.00-3.00   sec  1.93 MBytes  16.2 Mbits/sec    0    194 KBytes       
[  4]   3.00-4.00   sec  4.47 MBytes  37.5 Mbits/sec    0    328 KBytes       
[  4]   4.00-5.00   sec  3.23 MBytes  27.1 Mbits/sec    0    402 KBytes       
[  4]   5.00-6.00   sec  3.73 MBytes  31.3 Mbits/sec    0    464 KBytes       
[  4]   6.00-7.00   sec  4.72 MBytes  39.6 Mbits/sec    0    489 KBytes       
[  4]   7.00-8.00   sec  4.16 MBytes  34.9 Mbits/sec    0    516 KBytes       
[  4]   8.00-9.00   sec  3.91 MBytes  32.8 Mbits/sec    0    570 KBytes       
[  4]   9.00-10.00  sec  3.85 MBytes  32.3 Mbits/sec    0    570 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  33.1 MBytes  27.8 Mbits/sec    0
sender
[  4]   0.00-10.00  sec  31.8 MBytes  26.7 Mbits/sec
receiver

iperf Done.
[root@dhcp-27-155 ~]# iperf3 -c 192.168.9.1
Connecting to host 192.168.9.1, port 5201
[  4] local 192.168.9.11 port 60044 connected to 192.168.9.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  1.63 MBytes  13.7 Mbits/sec    0   69.3 KBytes       
[  4]   1.00-2.00   sec  1.49 MBytes  12.5 Mbits/sec    0    129 KBytes       
[  4]   2.00-3.00   sec  2.11 MBytes  17.7 Mbits/sec    0    208 KBytes       
[  4]   3.00-4.00   sec  4.41 MBytes  37.0 Mbits/sec    0    361 KBytes       
[  4]   4.00-5.00   sec  3.85 MBytes  32.3 Mbits/sec    0    478 KBytes       
[  4]   5.00-6.00   sec  4.41 MBytes  37.0 Mbits/sec    0    478 KBytes       
[  4]   6.00-7.00   sec  3.17 MBytes  26.6 Mbits/sec    0    502 KBytes       
[  4]   7.00-8.00   sec  3.73 MBytes  31.3 Mbits/sec    0    527 KBytes       
[  4]   8.00-9.00   sec  3.04 MBytes  25.5 Mbits/sec    0    551 KBytes       
[  4]   9.00-10.00  sec  4.10 MBytes  34.4 Mbits/sec    0    551 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  32.0 MBytes  26.8 Mbits/sec    0
sender
[  4]   0.00-10.00  sec  31.0 MBytes  26.0 Mbits/sec
receiver

iperf Done.
[root@dhcp-27-155 ~]# iperf3 -c 192.168.9.1
Connecting to host 192.168.9.1, port 5201
[  4] local 192.168.9.11 port 60048 connected to 192.168.9.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  1.44 MBytes  12.0 Mbits/sec    0   60.8 KBytes       
[  4]   1.00-2.00   sec  1.43 MBytes  12.0 Mbits/sec    0    113 KBytes       
[  4]   2.00-3.00   sec  2.61 MBytes  21.9 Mbits/sec    0    212 KBytes       
[  4]   3.00-4.00   sec  3.91 MBytes  32.8 Mbits/sec    0    349 KBytes       
[  4]   4.00-5.00   sec  4.04 MBytes  33.9 Mbits/sec    0    436 KBytes       
[  4]   5.00-6.00   sec  3.73 MBytes  31.3 Mbits/sec    0    494 KBytes       
[  4]   6.00-7.00   sec  3.73 MBytes  31.3 Mbits/sec    0    519 KBytes       
[  4]   7.00-8.00   sec  3.85 MBytes  32.3 Mbits/sec    0    560 KBytes       
[  4]   8.00-9.00   sec  4.16 MBytes  34.9 Mbits/sec    0    594 KBytes       
[  4]   9.00-10.00  sec  4.04 MBytes  33.9 Mbits/sec    0    600 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  32.9 MBytes  27.6 Mbits/sec    0
sender
[  4]   0.00-10.00  sec  31.7 MBytes  26.6 Mbits/sec
receiver

iperf Done.



And with patches:

[stasiu@dhcp-27-155 ~]$ iperf3 -c 192.168.9.1
Connecting to host 192.168.9.1, port 5201
[  4] local 192.168.9.11 port 59810 connected to 192.168.9.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  1.58 MBytes  13.3 Mbits/sec    0   72.1 KBytes       
[  4]   1.00-2.00   sec  1.68 MBytes  14.1 Mbits/sec    0    130 KBytes       
[  4]   2.00-3.00   sec  3.67 MBytes  30.8 Mbits/sec    0    279 KBytes       
[  4]   3.00-4.00   sec  6.21 MBytes  52.1 Mbits/sec    0    423 KBytes       
[  4]   4.00-5.00   sec  6.28 MBytes  52.6 Mbits/sec    0    495 KBytes       
[  4]   5.00-6.00   sec  6.28 MBytes  52.6 Mbits/sec    0    547 KBytes       
[  4]   6.00-7.00   sec  6.34 MBytes  53.2 Mbits/sec    0    547 KBytes       
[  4]   7.00-8.00   sec  6.34 MBytes  53.2 Mbits/sec    0    573 KBytes       
[  4]   8.00-9.00   sec  5.97 MBytes  50.0 Mbits/sec    0    604 KBytes       
[  4]   9.00-10.00  sec  5.90 MBytes  49.5 Mbits/sec    0    604 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  50.2 MBytes  42.1 Mbits/sec    0
sender
[  4]   0.00-10.00  sec  49.1 MBytes  41.2 Mbits/sec
receiver

iperf Done.
[stasiu@dhcp-27-155 ~]$ iperf3 -c 192.168.9.1
Connecting to host 192.168.9.1, port 5201
[  4] local 192.168.9.11 port 59814 connected to 192.168.9.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  3.73 MBytes  31.3 Mbits/sec    0    192 KBytes       
[  4]   1.00-2.00   sec  6.34 MBytes  53.2 Mbits/sec    0    379 KBytes       
[  4]   2.00-3.00   sec  7.02 MBytes  58.9 Mbits/sec    0    458 KBytes       
[  4]   3.00-4.00   sec  5.97 MBytes  50.0 Mbits/sec    0    501 KBytes       
[  4]   4.00-5.00   sec  5.90 MBytes  49.5 Mbits/sec    0    523 KBytes       
[  4]   5.00-6.00   sec  6.09 MBytes  51.1 Mbits/sec    0    550 KBytes       
[  4]   6.00-7.00   sec  6.28 MBytes  52.6 Mbits/sec    0    588 KBytes       
[  4]   7.00-8.00   sec  5.90 MBytes  49.5 Mbits/sec    0    588 KBytes       
[  4]   8.00-9.00   sec  6.28 MBytes  52.7 Mbits/sec    0    588 KBytes       
[  4]   9.00-10.00  sec  6.46 MBytes  54.2 Mbits/sec    0    617 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  60.0 MBytes  50.3 Mbits/sec    0
sender
[  4]   0.00-10.00  sec  58.6 MBytes  49.2 Mbits/sec
receiver

iperf Done.
[stasiu@dhcp-27-155 ~]$ iperf3 -c 192.168.9.1
Connecting to host 192.168.9.1, port 5201
[  4] local 192.168.9.11 port 59818 connected to 192.168.9.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  2.29 MBytes  19.2 Mbits/sec    0    107 KBytes       
[  4]   1.00-2.00   sec  3.11 MBytes  26.1 Mbits/sec    0    238 KBytes       
[  4]   2.00-3.00   sec  6.71 MBytes  56.3 Mbits/sec    0    447 KBytes       
[  4]   3.00-4.00   sec  6.59 MBytes  55.3 Mbits/sec    0    484 KBytes       
[  4]   4.00-5.00   sec  6.28 MBytes  52.6 Mbits/sec    0    533 KBytes       
[  4]   5.00-6.00   sec  6.46 MBytes  54.2 Mbits/sec    0    559 KBytes       
[  4]   6.00-7.00   sec  4.72 MBytes  39.6 Mbits/sec    0    559 KBytes       
[  4]   7.00-8.00   sec  3.98 MBytes  33.4 Mbits/sec    0    587 KBytes       
[  4]   8.00-9.00   sec  3.36 MBytes  28.1 Mbits/sec    0    587 KBytes       
[  4]   9.00-10.00  sec  4.04 MBytes  33.9 Mbits/sec    0    587 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  47.5 MBytes  39.9 Mbits/sec    0
sender
[  4]   0.00-10.00  sec  46.1 MBytes  38.7 Mbits/sec
receiver

iperf Done.

when connecting two rt2800usb devices one in AP mode second in STA mode.
Results with patches are somewhat better, but this is by accident.
Basically performance randomly vary on those testing.

Only 'flush' was chagned for USB, otherwise the code was just moved to
rt2800lib. So probability of regression there is low. Much more changes
were done for MMIO by those patches, so I would be more worry about
that. But this was tested by me and various other users. 

Thanks
Stanislaw
