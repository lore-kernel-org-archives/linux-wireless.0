Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:36649 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZBDFOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 00:14:20 -0500
Received: by yw-out-2324.google.com with SMTP id 9so864230ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 21:14:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090204045208.GA8086@hash.localnet>
References: <20090131023147.GE3342@makis>
	 <20090203161317.M71923@bobcopeland.com>
	 <40f31dec0902030828v453fdeafh9d47a156c07f6c9d@mail.gmail.com>
	 <20090204045208.GA8086@hash.localnet>
Date: Wed, 4 Feb 2009 07:14:19 +0200
Message-ID: <40f31dec0902032114k9df1715h6dd60746dcb1f6a4@mail.gmail.com> (sfid-20090204_061426_728907_4D0DA511)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/4 Bob Copeland <me@bobcopeland.com>:
> On Tue, Feb 03, 2009 at 06:28:47PM +0200, Nick Kossifidis wrote:
>> Nice catch ;-)
>>
>> Another difference i remembered is that we now don't set the TPC
>> register to 3f (until we fix the whole tx power stuff). I'll try to
>> reproduce this with my ar2425 as it turns it also has problems.
>
> And the winning hunk is:
>
>        if (ah->ah_version != AR5K_AR5210) {
>                ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
> -               /* If we later allow tuning for this, store into sc structure */
> -               data = AR5K_TUNE_RSSI_THRES |
> -                       AR5K_TUNE_BMISS_THRES << AR5K_RSSI_THR_BMISS_S;
> -               ath5k_hw_reg_write(ah, data, AR5K_RSSI_THR);
>        }
>
> (hmm, bmiss threshold, should've seen that before...)
>
> With that reverted from the rest of the patchset, I no longer get the
> interrupt storm.  I do seem to get an occasional lockup at association
> time, but I haven't caught an oops for that yet.  It could be unrelated.
>

O.K. i got that from legacy HAL. It first reads the register and if
it's zeroed it sets to the default value of 0x781 (which is the same
really, it's  AR5K_TUNE_RSSI_THRES | AR5K_TUNE_BMISS_THRES <<
AR5K_RSSI_THR_BMISS_S), if not it saves it and restores it after reset
is done.

So can you see why this

	/* Save RSSI thresholds (they 'll get zeroed from initvals) */
	rssi_thr = ath5k_hw_reg_read(ah, AR5K_RSSI_THR);
	/* If they are not set, set the default value */
	if (!rssi_thr)
		rssi_thr = AR5K_INIT_RSSI_THR;

doesn't work ? What is the value of rssi_trh if not zero ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
