Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:38448 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaCYKbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 06:31:18 -0400
Received: by mail-ve0-f175.google.com with SMTP id oz11so268641veb.20
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 03:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnG4QAYrinu3LLj9PbSAdvuUzqyAZQvgrWme5Qd2Hpq6Q@mail.gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
	<CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com>
	<CA+BoTQn4ji2boTV8x-owO8PbaPm510wYEKmbKqf+VS+MS+DXnQ@mail.gmail.com>
	<CAEFj9854WN5qJ4L4V1vkLeGhj=pstjoha19iJMQ8Vy-g24a66A@mail.gmail.com>
	<CA+BoTQmNVHj-rNvVgvTx=Adq6J1kpra2qwi3Pmzh2G2Npn-jGg@mail.gmail.com>
	<CAEFj984srRCqzFmzjGuE2nFLrC-V+PEgDPC-mejsZnfGH52g_Q@mail.gmail.com>
	<CA+BoTQnG4QAYrinu3LLj9PbSAdvuUzqyAZQvgrWme5Qd2Hpq6Q@mail.gmail.com>
Date: Tue, 25 Mar 2014 18:31:17 +0800
Message-ID: <CAEFj985jyNgSR18xuitL73mqwkgYSV=v7cXSDLVqE5wJfN3fpw@mail.gmail.com> (sfid-20140325_113142_432350_57F0A5D0)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> The second stats event has pdev stats. As per my other mail, 10.1 has
> extra pdev stats. Since ath10k doesn't account that it reads peer
> stats too early from the buffer. What you see is a tail of pdev stats
> for 10.1.
>
> You can try the following to test *10.1*:
>
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -2804,6 +2804,12 @@ struct wmi_pdev_stats {
>         __le32 phy_err_count;  /* Phy error count */
>         __le32 chan_tx_pwr;    /* channel tx power */
>         struct wal_dbg_stats wal; /* WAL dbg stats */
> +       __le32 ack_rx_bad;
> +       __le32 rts_bad;
> +       __le32 rts_good;
> +       __le32 fcs_bad;
> +       __le32 no_beacons;
> +       __le32 mib_int_count;
>  } __packed;
>

Ok. Probably can come out with a patch extending the pdev stats on this.

I get the self STA stats as follow on 10.1 firmware:

AP:
[  754.280000] ath10k: pdev 1 vdev 0 peer 1
[  754.280000] ath10k: MAC 04:f0:21:0c:a5:43
[  754.280000] ath10k: RSSI 0
[  754.290000] ath10k: Tx 6000
[  754.290000] ath10k: Rx 0

STA:
[  880.060000] ath10k: pdev 1 vdev 0 peer 1
[  880.060000] ath10k: MAC 00:00:00:00:00:01
[  880.070000] ath10k: RSSI 0
[  880.070000] ath10k: Tx 6000
[  880.070000] ath10k: Rx 0

Similar to 636. But on 636, I don't find any tx rate, only rssi.

---
Chun-Yeow
