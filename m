Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:35246 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbcHKMeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:34:50 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH] mac80211: Keep CoDel stats per txq,
	export them in debugfs.
References: <20160720145442.1098-1-toke@toke.dk>
	<1470918167.12075.2.camel@sipsolutions.net>
Date: Thu, 11 Aug 2016 14:34:44 +0200
In-Reply-To: <1470918167.12075.2.camel@sipsolutions.net> (Johannes Berg's
	message of "Thu, 11 Aug 2016 14:22:47 +0200")
Message-ID: <87popf8owr.fsf@toke.dk> (sfid-20160811_143453_969636_1705B51E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> @@ -137,18 +137,20 @@ static int aqm_open(struct inode *inode, struct
>> file *file)
>>  	len += scnprintf(info->buf + len,
>>  			 info->size - len,
>>  			 "* vif\n"
>> -			 "ifname addr ac backlog-bytes backlog-
>> packets flows overlimit collisions tx-bytes tx-packets\n");
>> +			 "ifname addr ac backlog-bytes backlog-
>> packets flows drops marks overlimit collisions tx-bytes tx-
>> packets\n");
>
> It seems to me that you have to change the buffer length to take this
> into account?

Haven't run into issues with running out of buffer space in my testing.
But yeah, guess that could become an issue.

>>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>>  		txqi = to_txq_info(sdata->vif.txq);
>>  		len += scnprintf(info->buf + len, info->size - len,
>> -				 "%s %pM %u %u %u %u %u %u %u %u\n",
>> +				 "%s %pM %u %u %u %u %u %u %u %u %u
>> %u\n",
>>  				 sdata->name,
>
> Why is it this way anyway? It'd seem nicer to move the content of this
> into the per-netdev subdirectories, and then it becomes a lot simpler
> code too (yes, at the expense of some userspace, but still)

Yeah, makes sense. Can do a larger reorg moving things into the
per-netdev and per-station directories instead.

>>  				 txqi->txq.ac,
>>  				 txqi->tin.backlog_bytes,
>>  				 txqi->tin.backlog_packets,
>>  				 txqi->tin.flows,
>> +				 txqi->cstats.drop_count,
>> +				 txqi->cstats.ecn_mark,
>>  				 txqi->tin.overlimit,
>>  				 txqi->tin.collisions,
>>  				 txqi->tin.tx_bytes,
>
> Do you really want to add these in the middle? Seems that if you add
> them at the end, you at least have *some* way of keeping this working
> with older versions?

Well I though they should be logically grouped with overlimits, and was
counting on no one actually parsing these yet. Guess if the information
is moved that becomes moot.


Will re-send; thanks for the feedback :)

-Toke
