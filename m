Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C213C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEA732098A
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:05:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEA732098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbeJKRcC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 13:32:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbeJKRcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 13:32:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22A95307C941;
        Thu, 11 Oct 2018 10:05:27 +0000 (UTC)
Received: from localhost (ovpn-204-112.brq.redhat.com [10.40.204.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 754128C06B;
        Thu, 11 Oct 2018 10:05:26 +0000 (UTC)
Date:   Thu, 11 Oct 2018 12:05:25 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
Message-ID: <20181011100524.GA20794@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
 <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com>
 <20181010120657.GA1185@makrotopia.org>
 <20181010124508.GA22330@redhat.com>
 <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
 <20181010154054.GA27779@redhat.com>
 <CAKR_QVLjFyGtzikLTiQKhrVBSyUoPmDn2tMJqto8dyBDjoFJOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVLjFyGtzikLTiQKhrVBSyUoPmDn2tMJqto8dyBDjoFJOQ@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 11 Oct 2018 10:05:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 10:03:12PM +0200, Tom Psyborg wrote:
> ok, that is strange. do you see any performance differences without
> TX_SW_CFG regs? iperf test is a good pointer.
> 
> this was a problem on xiaomi mini with old DD trunk builds on 4.4
> kernel and LEDE builds from last year. i ain't got no chance to try
> this on 18.06. which device you tried this on? if ipa/ilna it might
> make no difference

No diffrence for me. I have nexx wt3020 8M.

However I notice this set couse performance regression for me. 
When connecting to iwl 7265 . Without the set I have:

root@LEDE:~# iperf3 -c 192.168.10.243
Connecting to host 192.168.10.243, port 5201
[  5] local 192.168.10.1 port 59304 connected to 192.168.10.243 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  5.37 MBytes  44.9 Mbits/sec    0    279 KBytes       
[  5]   1.00-2.00   sec  5.80 MBytes  48.8 Mbits/sec    0    494 KBytes       
[  5]   2.00-3.00   sec  6.03 MBytes  50.5 Mbits/sec    0    513 KBytes       
[  5]   3.00-4.01   sec  5.90 MBytes  49.2 Mbits/sec    0    513 KBytes       
[  5]   4.01-5.01   sec  5.90 MBytes  49.5 Mbits/sec    0    515 KBytes       
[  5]   5.01-6.00   sec  5.78 MBytes  48.9 Mbits/sec    0    515 KBytes       
[  5]   6.00-7.00   sec  5.66 MBytes  47.4 Mbits/sec    0    515 KBytes       
[  5]   7.00-8.00   sec  6.03 MBytes  50.6 Mbits/sec    0    515 KBytes       
[  5]   8.00-9.00   sec  6.09 MBytes  50.9 Mbits/sec    0    515 KBytes       
[  5]   9.00-10.00  sec  5.72 MBytes  48.2 Mbits/sec    0    515 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  58.3 MBytes  48.9 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  58.3 MBytes  48.9 Mbits/sec                  receiver

With the set I have:

root@LEDE:~# iperf3  -c 192.168.10.243
Connecting to host 192.168.10.243, port 5201
[  5] local 192.168.10.1 port 45824 connected to 192.168.10.243 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  3.78 MBytes  31.7 Mbits/sec    0    197 KBytes
[  5]   1.00-2.00   sec  3.71 MBytes  31.0 Mbits/sec    0    369 KBytes
[  5]   2.00-3.00   sec  3.51 MBytes  29.5 Mbits/sec    0    484 KBytes
[  5]   3.00-4.00   sec  3.36 MBytes  28.1 Mbits/sec    0    519 KBytes
[  5]   4.00-5.00   sec  4.10 MBytes  34.4 Mbits/sec    0    519 KBytes
[  5]   5.00-6.00   sec  3.73 MBytes  31.2 Mbits/sec    0    519 KBytes
[  5]   6.00-7.00   sec  4.29 MBytes  36.0 Mbits/sec    0    519 KBytes
[  5]   7.00-8.00   sec  4.16 MBytes  34.9 Mbits/sec    0    519 KBytes
[  5]   8.00-9.00   sec  4.35 MBytes  36.5 Mbits/sec    0    519 KBytes
[  5]   9.00-10.00  sec  4.41 MBytes  37.0 Mbits/sec    0    519 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  39.4 MBytes  33.0 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  39.4 MBytes  33.0 Mbits/sec                  receiver


Stanislaw

