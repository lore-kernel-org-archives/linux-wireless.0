Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36484 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3BVF0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 00:26:36 -0500
Message-ID: <51270186.6070003@candelatech.com> (sfid-20130222_062641_830802_1CB6196B)
Date: Thu, 21 Feb 2013 21:26:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [RFC] ath9k:  Detect and work-around tx-queue hang.
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com> <20774.62475.588131.344540@gargle.gargle.HOWL> <5126F732.6040007@candelatech.com> <20774.63702.208829.602903@gargle.gargle.HOWL>
In-Reply-To: <20774.63702.208829.602903@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2013 08:49 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> I'll be happy to test patches, but I'm not sure how to go about
>> debugging the real problem on my own.  Maybe some stats could
>> be added to the xmit debugfs file to help diagnose the problem,
>> or maybe some other debugfs info will help?
>>
>> I can't reproduce the problem with ath9k debugging set at the
>> previous suggested level, so it would have to be something
>> less invasive.
>>
>> As for just stations going out of range, it remains locked up
>> even with signal level goes back to -20, so it's not just a simple
>> station-out-of range issues..
>
> Sure, but I think that filtered frames are not handled properly,
> especially with aggregation, since the debugfs stats from your earlier email
> showed a large counter (from a private patch ?):
>
> TXERR Filtered:            224          0         0         0

Yeah, guess that patch never made it upstream.  The pertinent bit is:

+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -579,6 +579,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
         PR("AMPDUs Completed:", a_completed);
         PR("AMPDUs Retried:  ", a_retries);
         PR("AMPDUs XRetried: ", a_xretries);
+       PR("TXERR Filtered:  ", txerr_filtered);
         PR("FIFO Underrun:   ", fifo_underrun);
         PR("TXOP Exceeded:   ", xtxop);
         PR("TXTIMER Expiry:  ", timer_exp);
@@ -867,6 +868,8 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
                         TX_STAT_INC(qnum, completed);
         }

+       if (ts->ts_status & ATH9K_TXERR_FILT)
+               TX_STAT_INC(qnum, txerr_filtered);
         if (ts->ts_status & ATH9K_TXERR_FIFO)
                 TX_STAT_INC(qnum, fifo_underrun);
         if (ts->ts_status & ATH9K_TXERR_XTXOP)

I'll post this and a few other small patches when I get a chance.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

