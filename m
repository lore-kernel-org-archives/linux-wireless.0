Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49603 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3EUOdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 10:33:36 -0400
Received: by mail-we0-f177.google.com with SMTP id n57so416038wev.22
        for <linux-wireless@vger.kernel.org>; Tue, 21 May 2013 07:33:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369118418.41680.YahooMailNeo@web193504.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<20830.46610.23754.783231@gargle.gargle.HOWL>
	<1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
	<CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
	<CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com>
	<1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<1366084534.24187.YahooMailNeo@web193501.mail.sg3.yahoo.com>
	<CAJ-Vmoki6FUETFLkThp1AvZ3R_2kCd5Ro83OuvsfW0nZ5pfJ2w@mail.gmail.com>
	<1366194814.88121.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-Vmokx0MbTC47+0fcRt9yQshfTaPEDte2A=7Ycn2bzwLSPxg@mail.gmail.com>
	<1366248389.18545.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmomXz93U7HCmscd=NVZKQ+RFbty+Xh_wcOPYEDhX57ptbw@mail.gmail.com>
	<1366281249.7026.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmokO+Tc+5k+=d2qiZSFQtrLFaHuYgpPK7r_OO5PKBue_TQ@mail.gmail.com>
	<1369118418.41680.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Date: Tue, 21 May 2013 07:33:35 -0700
Message-ID: <CAJ-Vmo=533O+3tDhjbzyOd1PRMX0kJB8guCc_9xyiHioifteJg@mail.gmail.com> (sfid-20130521_163340_077000_C87E11F5)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 20 May 2013 23:40, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian,
>     Greetings! I resumed my experiments with 2-wire co-existence with AR9287
> in WiFi AP mode.
> I was able to see that WLAN_STATUS signal being suppressed when BT_ACTIVE is
> enabled. I used a 100ms On and 100ms Off (Period = 200ms; 50% dc) for
> BT_ACTIVE. Just want to confirm the following before ensuring that I am
> seeing the expected behavior:
>
Cool! Can you share some code and register settings to enable this?

> 1. As I am running the WiFi AP with co-existence, other WiFi clients are
> connected to my AP. by means of diagnsosis (I have enabled diagnosis with
> modprobe ath9k btcoex_enabled=1 diag=0xffffffff), how can I find out if any
> WiFi clients are loosing connection and re-connecting back to AP.

I think you should enable hostapd logging. That will log the MLME events.

> 2. How can I come to know if any of the beacons in WiFi AP mode are getting
> missed? Diagnosis messages that I can look at.

You can look for missed beacon transmit events. That should tell you
if you're missing beacon transmission at all.

> 3. As diagnosis is enabled I see the following....is this a concern as there
> is disable and enable of IER?
> <7>ath: disable IER
> <7>ath: AR_IMR 0x918104b0 IER 0x1
> <7>ath: tx queue 2 (4bfc09c4), link ffde09c4
> <7>ath: enable IER
> <7>ath: Enable TXE on queue: 2
> <7>ath: disable IER
> <7>ath: AR_IMR 0x918104b0 IER 0x1

That's fine. That's what ath9k does with interrupts. :-)

> 4. How can I come to know if the ath9k drivers are getting reset and
> reinitializing?

There's a hw reset routine that gets called. You can just look for the
logging from that, or add a printk() yourself.



Adrian
