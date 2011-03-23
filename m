Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab1CWXAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 19:00:17 -0400
Received: by fxm17 with SMTP id 17so7788686fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 16:00:16 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: users@rt2x00.serialmonkey.com
Subject: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Wed, 23 Mar 2011 23:58:29 +0100
Cc: Jay Hung <Jay_Hung@ralinktech.com>,
	Eddy Tsai <Eddy_Tsai@ralinktech.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201103232358.29966.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[CC'ing Jay and Eddy as they might be able to answer some questions
 regarding 11n aggregation on rt2800 devices]

I'm using rt2800pci as AP. 11n aggregation works just fine when using a
Intel 5100 client and transferring data in both directions on Linux. Also
my Intel 4965 works just fine.

However, using Windows Vita on the same machine (Intel 5100) the Intel
RX reorder buffer seems to get confused. At least I can see (I can also
provide a pcap if anyone is interested) that the Intel STA still BlockAcks
received AMPDUs but the frames never make it out of the driver. It seems
as if they are stuck in the Intel driver/firmware (Windows).

I first thought this might be due to an old windows driver but even after
updating it to the newest version I can still reproduce this issue.

After debugging some more I noticed that this issue seems to appear as
soon as some parts (or maybe all parts) of an AMPDU (rt2800pci -> Intel 5100
Windows STA) are not BlockAcked and need to be retried. However, as far as I
can see the whole aggregation stuff including retransmissions on failures
should be handled entirely in hardware (only the BA session setup/teardown is
done by the driver/mac80211).

According to 802.11n-2009 the BA originator could send a BlockAckReq if 
an AMPDU is not BlockAcked in time. However, I never see the hw sending a
BlockAckReq.

Jay, Eddy, does the hw ever send a BlockAckReq if it doesn't receive a
BlockAck for an AMPDU?

At least, I hacked rt2x00 to set IEEE80211_TX_STAT_AMPDU_NO_BACK for failed
aggregated frames such that mac80211 sends a BlockAckReq for this failed MPDU
and this indeed seems to improve the situation but doesn't fix it completely.

Anything else I could try? Any ideas?

Thanks,
Helmut
