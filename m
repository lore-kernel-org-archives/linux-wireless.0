Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63573 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaAQNkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:40:46 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix the MAC address of peer statistic
References: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmexjQy-+Bv-uofBa2Ndcu56yYOAEeNzdBSE3yMCQdZKw@mail.gmail.com>
Date: Fri, 17 Jan 2014 15:40:41 +0200
In-Reply-To: <CA+BoTQmexjQy-+Bv-uofBa2Ndcu56yYOAEeNzdBSE3yMCQdZKw@mail.gmail.com>
	(Michal Kazior's message of "Fri, 17 Jan 2014 14:38:00 +0100")
Message-ID: <87d2jqrajq.fsf@kamboji.qca.qualcomm.com> (sfid-20140117_144049_862413_3AB08366)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 10 January 2014 10:19, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>
>>  struct wmi_peer_stats {
>> +       __le32 peer_tx_rate;    /* TBA */
>>         struct wmi_mac_addr peer_macaddr;
>>         __le32 peer_rssi;
>> -       __le32 peer_tx_rate;
>>  } __packed;
>
> This looks wrong too. I've just checked it and it seems the
> `wal_dbg_tx_stats` is out of date. It's missing a `__le32
> stateless_tid_alloc_failure` that has been inserted at some point in
> time in the firmware between `pdev_resets` and `phy_underrun`. You
> should add this missing field instead of moving `peer_tx_rate`.
>
> Unfortunately AP firmware has even more fields inserted in
> `wmi_pdev_stats`. Making this work with both firmwares is a mess.

This reminds me that Bartosz sent something related to this few months back:

http://lists.infradead.org/pipermail/ath10k/2013-September/000317.html

I promised to finish it, but it's still in my todo folder :/

-- 
Kalle Valo
