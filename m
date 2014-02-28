Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:48942 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbaB1O1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 09:27:12 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v1 1/6] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ into info->control.flags
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1393340740.4170.5.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Feb 2014 15:27:09 +0100
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Message-Id: <214A2CB4-EC3E-4434-AEA4-92956A149C73@net.t-labs.tu-berlin.de> (sfid-20140228_152716_304336_FE75E02A)
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1393164527-13800-2-git-send-email-thomas@net.t-labs.tu-berlin.de> <1393244624.4190.8.camel@jlt4.sipsolutions.net> <23FA0097-F436-4FD7-B076-44EB35CDE9FF@net.t-labs.tu-berlin.de> <1393340740.4170.5.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> As far as I can see, software-retry frames get in status.c the flag
>> IEEE80211_TX_INTFL_RETRANSMISSION
>> assigned (in function ieee80211_handle_filtered_frame). And this flag
>> prevents in function
>> invoke_tx_handlers() the call of ieee80211_tx_h_sequence(), so there
>> is not new seqno assigned in case of a software-retry within tx.c.
> 
> Right, but if IEEE80211_TX_CTL_ASSIGN was set then it also isn't
> cleared.

So the standard conform behavior should be to re-use the same sequno in case of a software retry ?
I could re-assign the flag IEEE80211_TX_CTL_ASSIGN_SEQ when a software retry happens by add
a test to function ieee80211_handle_filtered_frame. Something like:
	 if (!ieee80211_is_data_qos(hdr->frame_control) || is_multicast_ether_addr(hdr->addr1)) {
		/* driver should assign sequence number */
		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
	}

Would this be right ?

>> But in case of a software retry there is info->control set to zero.
>> After I would move IEEE80211_TX_CTL_ASSIGN_SEQ into
>> info->control.flags this flag is zero.
>> Hence also drivers do not assign a new sequence number.
> 
> But now the frame might not have *any* sequence number assigned at all,
> if e.g. the firmware assigns sequence numbers and they're not written
> back to the frame. Thus I think you're losing the entire sequence number
> assignment in this case.
> 

If I re-assign the IEEE80211_TX_CTL_ASSIGN_SEQ flag for software retries, than drivers
that assigned a sequence number in the first try, could probably assign a new one. Would that
be ok ?

Greetings Thomas


> johannes
> 

