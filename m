Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:56622 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932166Ab0D1UNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 16:13:49 -0400
Message-ID: <4BD896F7.5090703@free.fr>
Date: Wed, 28 Apr 2010 22:13:43 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Jouni Malinen <jouni.malinen@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath5k.org" <ath9k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Added get_survey callback in order to get channel
 noise
References: <1272406104-6870-1-git-send-email-benoit.papillault@free.fr> <1272438045.2772.6.camel@jm-desktop>
In-Reply-To: <1272438045.2772.6.camel@jm-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen a écrit :
> On Tue, 2010-04-27 at 15:08 -0700, Benoit Papillault wrote:
>   
>> +static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
>> +			     struct survey_info *survey)
>>     
>
>   
>> +	struct ieee80211_conf *conf = &hw->conf;
>> +
>> +	 if (idx != 0)
>> +		return -ENOENT;
>> +
>> +	survey->channel = conf->channel;
>>     
>
> Are there any plans on providing this information from all channels? I
> have assumed that the survey command was supposed to be used for
> surveying all channels (e.g., to get information for auto-channel
> selection) and returning something for the current channel is quite
> limited subset of that. In other words, I would like to be able to run a
> scan of all channels and then use NL80211_CMD_GET_SURVEY to fetch
> additional per-channel information like noise (and also channel usage
> statistics in case of ath9k) from the scanned channels.
>
> - Jouni
>   
Hi Jouni,

I dig into the source code to understand the use of "idx" and having the 
value for all scanned channels sounds a good plan. However :

- when doing a normal scan (iw dev wlan0 scan), the noise floor 
calibration is started in a special mode, so I don't know if the results 
is accurate enought.

- the first calibration takes some times .... more than the scan itself. 
So, you cannot get a valid value before switching to the next channel.

Anyway, how idx is supposed to be used? From 0 ... up to the callback 
returning -ENOENT ?
Do we need to keep a table with noise for each channel and return those 
where we have a value, in which case idx cannot be used as an index into 
this table ?

Regards,
Benoit

