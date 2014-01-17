Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41012 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaAQNL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:11:26 -0500
Received: by mail-bk0-f53.google.com with SMTP id na10so1628776bkb.26
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 05:11:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87txd2re1z.fsf@kamboji.qca.qualcomm.com>
References: <1389345564-21042-1-git-send-email-yeohchunyeow@gmail.com>
	<87txd2re1z.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 17 Jan 2014 21:11:24 +0800
Message-ID: <CAEFj987bofbcHJh2=pvxujxZgLwFjgV+1UeLC5kfKZYqiQHyyg@mail.gmail.com> (sfid-20140117_141129_891381_D1A08CBB)
Subject: Re: [PATCH v2] ath10k: fix the MAC address of peer statistic
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Any ideas what's happening here?

My one is MIPS32 (Compex WPJ344) and the following PEER stats are
printed correctly:

# cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_stats

   MPDU errors (FCS, MIC, ENC)          0

             ath10k PEER stats
             =================

              Peer MAC address 04:f0:21:0c:a5:44
                     Peer RSSI 68
                  Peer TX rate 0

Could this be the Endianness problem? How about if you remain the
struct wmi_peer_stats? Also, just to point out the TxRate is not
working (always 0).


>> +     /* The first peer is self MAC address, ignore this */
>> +     num_peer_stats--;
>> +     tmp += sizeof(struct wmi_peer_stats);
>
> Should we show "self peer" separately? Does it provide any useful
> information?

So far, we only have RSSI and Tx Rate. Both are not really useful for
"self peer".

----
Chun-Yeow
