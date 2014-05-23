Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:26202 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaEWIPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:15:16 -0400
Message-ID: <537F038C.7050305@neratec.com> (sfid-20140523_101523_286617_2362063D)
Date: Fri, 23 May 2014 10:15:08 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jim.epost@gmail.com
Subject: Re: [PATCH] ath9k: fix build error with disabled debug
References: <1400668835-22335-1-git-send-email-zefir.kurtisi@neratec.com> <877g5e3qfg.fsf@purkki.adurom.net>
In-Reply-To: <877g5e3qfg.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2014 03:15 PM, Kalle Valo wrote:
> Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:
> 
>> DFS pulse interval printing is only available
>> when CONFIG_ATH9K_DEBUGFS is set.
>>
>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> 
> [...]
> 
>> --- a/drivers/net/wireless/ath/ath9k/dfs.c
>> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
>> @@ -178,12 +178,14 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
>>  	pe.ts = mactime;
>>  	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
>>  		struct dfs_pattern_detector *pd = sc->dfs_detector;
>> +#ifdef CONFIG_ATH9K_DEBUGFS
> 
> IMHO config_enabled() is much nicer than ifdef.
> 

Actually, I dislike both of them.

While this is for debug printing only, it is still a bad idea to use variables in
debugfs dependent space and splatter source code with required checks. I'll move
that into a different context and post a follow-up patch.


John, please drop this one.
