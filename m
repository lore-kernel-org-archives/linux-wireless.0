Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27207 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762AbZCPMgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 08:36:25 -0400
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: don't drop null frames during software	scan
References: <20090315200738.17370.29374.stgit@tikku>
	<20090316085741.GA29986@jm.kir.nu>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 16 Mar 2009 14:35:30 +0200
In-Reply-To: <20090316085741.GA29986@jm.kir.nu> (ext Jouni Malinen's message of "Mon\, 16 Mar 2009 09\:57\:41 +0100")
Message-ID: <871vsxve5p.fsf@nokia.com> (sfid-20090316_133629_128179_580995A6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Sun, Mar 15, 2009 at 10:07:39PM +0200, Kalle Valo wrote:
>> ieee80211_tx_h_check_assoc() was dropping everything else than probe
>> requests during software scan. So the null frame with the power save
>> bit was dropped and AP never received it. This meant that AP never
>> buffered any frames for the station during software scan.
>> 
>> Fix this by allowing to transmit both probe request and null frames
>> during software scan. Tested with stlc45xx.
>
> I would assume the nullfunc frames are sent only just before the scan
> and just after the scan, not really "during" the scan. Or am I missing
> something here?

No, you are not missing anything. I just considered the start of scan
happening in the beginning of function ieee80211_start_scan() (which
sends the nullfunc frame) and that's why I chose the word "during".

>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -193,7 +193,14 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
>>  		return TX_CONTINUE;
>>  
>>  	if (unlikely(tx->local->sw_scanning) &&
>> -	    !ieee80211_is_probe_req(hdr->frame_control))
>> +	    !ieee80211_is_probe_req(hdr->frame_control) &&
>> +	    !ieee80211_is_nullfunc(hdr->frame_control))
>> +		/*
>> +		 * When software scanning only null frames (to notify the
>> +		 * sleep state to the AP) and probe requests (for the
>> +		 * active scan) are allowed, everything else should be
>> +		 * dropped.
>> +		 */
>>  		return TX_DROP;
>
> While this is probably the easiest way of fixing the issue you are
> seeing, the more correct operation would be to allow nullfunc frames
> only at the beginning and end of the scan operation, not during it,
> i.e., there is no point allowing those frames to go out when we are not
> on our operational channel. I would hope we do not currently send those
> frames at such time,

Actually I was thinking of adding a WARN_ONCE just to catch that but I
decided to abandon the idea because all the blame I would get from the
warnings :)

> so this should not matter much, but the comment could be made more
> clear about the different needs for nullfunc frames (please also
> s/null frames/nullfunc frames/) and probe request frames. The former
> are sent only on the operational channel in the beginning and end of
> scan while the latter are sent on the channels to be scanned during
> an active scan.

Should the description be in ieee80211_start_scan() in scan.c? I think
it would make more sense to have it there instead of tx.c. I can then
add a reference to the comment above.

-- 
Kalle Valo
