Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:47338 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbaBYNbf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:31:35 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v1 1/6] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ into info->control.flags
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1393244624.4190.8.camel@jlt4.sipsolutions.net>
Date: Tue, 25 Feb 2014 14:31:32 +0100
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Message-Id: <23FA0097-F436-4FD7-B076-44EB35CDE9FF@net.t-labs.tu-berlin.de> (sfid-20140225_143140_186605_2071414A)
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1393164527-13800-2-git-send-email-thomas@net.t-labs.tu-berlin.de> <1393244624.4190.8.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> On Sun, 2014-02-23 at 15:08 +0100, Thomas Huehn wrote:
>> Flag IEEE80211_TX_CTL_ASSIGN_SEQ is only used within the tx path while
>> ieee80211_tx_info->control is valid. Therefore this patch moves this flag
>> from info->flags structure into the info->control.flags and renames it to
>> IEEE80211_TX_CTRL_ASSIGN_SEQ.
> 
> I'm not convinced this patch is correct, so you need to convince me.
> What happens to software-retry frames? They probably *shouldn't* get a
> new seqno, but if the driver doesn't modify the SKB (say because
> hardware/firmware assigns it) then this is certainly not right.
> 

As far as I can see, software-retry frames get in status.c the flag IEEE80211_TX_INTFL_RETRANSMISSION
assigned (in function ieee80211_handle_filtered_frame). And this flag prevents in function
invoke_tx_handlers() the call of ieee80211_tx_h_sequence(), so there is not new seqno assigned in case of a software-retry within tx.c.

But in case of a software retry there is info->control set to zero. After I would move IEEE80211_TX_CTL_ASSIGN_SEQ into info->control.flags this flag is zero.
Hence also drivers do not assign a new sequence number.

Do I miss something here ?


Greetings Thomas