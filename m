Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:55155 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZBCQ2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:28:48 -0500
Received: by yx-out-2324.google.com with SMTP id 8so738055yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 08:28:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090203161317.M71923@bobcopeland.com>
References: <20090131023147.GE3342@makis>
	 <20090203161317.M71923@bobcopeland.com>
Date: Tue, 3 Feb 2009 18:28:47 +0200
Message-ID: <40f31dec0902030828v453fdeafh9d47a156c07f6c9d@mail.gmail.com> (sfid-20090203_172853_170261_F6B8879C)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/3 Bob Copeland <me@bobcopeland.com>:
> On Sat, 31 Jan 2009 04:31:47 +0200, Nick Kossifidis wrote
>>  int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>>       struct ieee80211_channel *channel, bool change_channel)
>
> Here's another thing I just noticed:
>
>>  {
>> +     u32 s_seq[10], s_ant, s_led[3], staid1_flags, tsf_up, tsf_lo;
>
> s_seq is now an array (we used to initialize s_seq to 0)
>
> [...]
>> +             if (change_channel) {
>> +                     /*
>> +                      * Save frame sequence count
>> +                      * For revs. after Oahu, only save
>> +                      * seq num for DCU 0 (Global seq num)
>> +                      */
>> +                     if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
>> +
>> +                             for (i = 0; i < 10; i++)
>> +                                     s_seq[i] = ath5k_hw_reg_read(ah,
>> +                                             AR5K_QUEUE_DCU_SEQNUM(i));
>> +
>> +                     } else {
>> +                             s_seq[0] = ath5k_hw_reg_read(ah,
>> +                                             AR5K_QUEUE_DCU_SEQNUM(0));
>> +                     }
>
> We only save the DCU sequence values if changing a channel
>
> [...]
>
>>       if (ah->ah_version != AR5K_AR5210) {
>> -             ath5k_hw_reg_write(ah, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
>> +
>> +             if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
>> +                     for (i = 0; i < 10; i++)
>> +                             ath5k_hw_reg_write(ah, s_seq[i],
>> +                                     AR5K_QUEUE_DCU_SEQNUM(i));
>> +             } else {
>> +                     ath5k_hw_reg_write(ah, s_seq[0],
>> +                             AR5K_QUEUE_DCU_SEQNUM(0));
>> +             }
>
> But always write it.  The old code did this too, the only difference
> was we explicitly initialized the s_seq[0] to 0.  Since it's an array,
> gcc won't warn about it but s_seq[] probably has random crap in it.
>

Nice catch ;-)

Another difference i remembered is that we now don't set the TPC
register to 3f (until we fix the whole tx power stuff). I'll try to
reproduce this with my ar2425 as it turns it also has problems.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
