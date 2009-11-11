Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:49272 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZKKFPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 00:15:44 -0500
Received: by iwn8 with SMTP id 8so683182iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 21:15:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911102015t3b429a61s353845c8b1d63@mail.gmail.com>
References: <43e72e890911101640r69ad67c6l2e48250596c19d44@mail.gmail.com>
	<19194.14704.375018.158963@gargle.gargle.HOWL> <43e72e890911102015t3b429a61s353845c8b1d63@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 21:15:30 -0800
Message-ID: <43e72e890911102115p5c84d5f4w5e1dee4f7c523ae9@mail.gmail.com>
Subject: Re: ath9k rate control - busted
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Aeolus Yang <Aeolus.Yang@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I tested the AP with 11n-only option setting both on 20mhz and 40
mhz channel bandwidth setting (although in reality I only see it
setting itself to 20 mhz). The rates are not so bad, I consistant
usage of MCS4 with throughput sometimes hitting 30mbps on the end
iperf server.

Here is the rcstat

very 2.0s: cat rcstat

 Tue Nov 10 21:05:37 2009

 Rate         Success  Retries  XRetries PER

  1.0:        0        0        0        0
  2.0:        0        0        0        0
  5.5:        0        0        0        0
 11.0:        0        0        0        0
  6.0:        0        0        0        0
  9.0:        0        0        0        0
 12.0:        0        0        0        0
 18.0:        0        0        0        0
 24.0:        0        0        0        0
 36.0:        0        0        0        0
 48.0:        0        0        0        0
 54.0:        0        0        0        0
  6.5:        0        0        0        0
 13.0:        1        0        0        0
 19.5:      650       77        5        0
 26.0:    31906     3022      148       10
 39.0:    49889    13260     2853       17
 52.0:     3421     2318     1199       28
 58.5:       21       81       63       87
 65.0:        0        0        0        0

So it seems the issues I saw are only caused on extremely noisy environments.

  Luis
