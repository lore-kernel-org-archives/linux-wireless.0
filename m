Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47174 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935982Ab3DPRAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 13:00:14 -0400
Received: by mail-wg0-f42.google.com with SMTP id m15so1400463wgh.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 10:00:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366084534.24187.YahooMailNeo@web193501.mail.sg3.yahoo.com>
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
	<1365574412.20937.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmonwA=25ooSXFrNJydkERWwP7D_iY+VvDu_wz+=G7tNoBQ@mail.gmail.com>
	<1366012397.74181.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-Vmomdv1Z2_H7L_=wU+g355b0HOgMQBt6MXkJv+Aqr1EG=Rg@mail.gmail.com>
	<1366042437.8316.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-Vmon1gx_MNaDSNtbS073bR8VxCsnia2PALOXYBgo_O+P3ag@mail.gmail.com>
	<1366084534.24187.YahooMailNeo@web193501.mail.sg3.yahoo.com>
Date: Tue, 16 Apr 2013 10:00:12 -0700
Message-ID: <CAJ-Vmoki6FUETFLkThp1AvZ3R_2kCd5Ro83OuvsfW0nZ5pfJ2w@mail.gmail.com> (sfid-20130416_190019_401866_D43098EC)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 April 2013 20:55, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian,
>     Got the debugfs working. I used the regdump under
> "/sys/kernel/debug/ieee80211/phy0/ath9k". The following are the values:
> ar5416phy.h:#define    AR_BT_COEX_MODE            0x8170        Value is:
> 0x050a5b00

How's that being set? it looks like you're enabling mode 2 (slotted)
versus 2-wire or 3-wire.

Look at the code and HAL definitions. You want 2-wire / legacy
rx_clear mode for the _MODE_ field inside AR_BT_COEX_MODE.


> ar5416phy.h:#define    AR_BT_COEX_WEIGHT          0x8174       Value is:
> 0xa8a8ff55

Double-check your weight values and make sure that they're actually
-correct- for having BT stomp wifi in all instances.



Adrian
