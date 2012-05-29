Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.uniroma2.it ([160.80.6.23]:60747 "EHLO smtp.uniroma2.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab2E2PFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 11:05:38 -0400
Message-ID: <4FC4E5A1.3010508@uniroma2.it> (sfid-20120529_170547_135275_9E463580)
Date: Tue, 29 May 2012 16:05:05 +0100
From: Claudio Pisa <claudio.pisa@uniroma2.it>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix flag check for QoS NOACK frames
References: <1338206785-3222-1-git-send-email-claudio.pisa@uniroma2.it> <1338275092.4342.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338275092.4342.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 08:04 AM, Johannes Berg wrote:
> On Mon, 2012-05-28 at 13:06 +0100, Claudio Pisa wrote:
>> Signed-off-by: Claudio Pisa <claudio.pisa@uniroma2.it>
>> ---
>>  net/mac80211/tx.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index d67d36f..cb17497 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -153,7 +153,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
>>  
>>  	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
>>  	if (ieee80211_is_data_qos(hdr->frame_control) &&
>> -	    *(ieee80211_get_qos_ctl(hdr)) | IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
>> +	    *(ieee80211_get_qos_ctl(hdr)) & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
> 
> Looks right to me, I guess nobody cares about duration calculations
> after all. How did you find this?!

Working on a project involving EDCA TXOPs and trying to find out how the
duration field is set...

cheers,
Claudio

