Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3.mo177.mail-out.ovh.net ([46.105.36.172]:49454 "EHLO
        3.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbeH1U7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 16:59:22 -0400
Received: from player778.ha.ovh.net (unknown [10.109.146.173])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id D2609C10AA
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 18:27:16 +0200 (CEST)
Subject: Re: [PATCH v6 3/3] mac80211: Fix PTK rekey freezes and cleartext
 leaks
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-4-alexander@wetzel-home.de>
 <1535446120.5895.6.camel@sipsolutions.net>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <0ed63254-cdb3-cefb-6074-d6a501809e8f@wetzel-home.de> (sfid-20180828_190657_051826_DC447034)
Date: Tue, 28 Aug 2018 18:27:08 +0200
MIME-Version: 1.0
In-Reply-To: <1535446120.5895.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.08.18 um 10:48 schrieb Johannes Berg:
> On Tue, 2018-08-14 at 12:42 +0200, Alexander Wetzel wrote:
>>
>> +	/* PTK only using key ID 0 needs special handling on rekey */
>> +	if (new_key && sta && ptk0rekey) {
>> +		local = old_key->local;
>> +		sdata = old_key->sdata;
>> +
>> +		/* Stop TX till we are on the new key */
>> +		old_key->flags |= KEY_FLAG_TAINTED;
>> +		ieee80211_clear_fast_xmit(sta);
>> +
>> +		/* Aggregation sessions during rekey are complicated due to
>> +		 * the reorder buffer. Side step that by blocking aggregation
>> +		 * and tear down running connections.
>> +		 */
>> +		if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
>> +			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
>> +			ieee80211_sta_tear_down_BA_sessions(sta,
>> +							    AGG_STOP_LOCAL_REQUEST);
>> +		}
>> +
>> +		if (new_key->local->ops->replace_key) {
>> +			ret = drv_replace_key(old_key->local, sdata,
>> +					      &sta->sta, &old_key->conf,
>> +					      &new_key->conf);
>> +			if (!ret)
>> +				new_key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
>> +			else
>> +				sdata_err(sdata,
>> +					  "failed to replace key (%d) for " \
>> +					  "STA (%pM) in hardware: ret=(%d)\n",
>> +					  old_key->conf.keyidx,
>> +					  sta->sta.addr,
>> +					  ret);
>> +
>> +			old_key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
>> +		} else {
>> +			sdata_info(sdata,
>> +				   "Userspace requested a PTK rekey for STA " \
>> +				   "%pM while feature not supported! " \
>> +				   "This may leak clear text packets or " \
>> +				   "freeze the connection.",
>> +				   sta->sta.addr);
> 
> This seems a bit weird - we know a likely dangerous thing is happening
> and only print an info message? Why not just prevent this in the first
> place?

The next version will upgrade that to a warning.

Rejecting it outright will break things for users with card/drivers
where rekey currently is working. There is no error error message for
"please re-associate as quick as you can" and tricking userspace to do
that across versions and implementations would need code at I do not see
belonging into the kernel. Here what I wrote in the cover letter of the
v4 version of the patch about this decision:

> I do not see an acceptable way from the kernel to trigger a fast
> reconnect. wpa_supplicant e.g. has some special code handling errors
> during a 4-way-handshake differently. I assume we would have to add
> code detecting if we are running as AP, Station Infrastructure, Ad-Hoc
> or Mesh and then find and spoof an error which allows the userspace to
> reconnect fast. For multiple different userspace implementations and
> the different versions of them.
> And we'll have that mess in the kernel for basically forever...
> Seems to be a clear no go, correct?
>
> So this patch (series) is giving up on a quick fix and will allow
> broken rekeys to continue. It is instead providing an updated API for
> both the userspace and the drivers to also do it correctly. Users
> running a userspace not aware of the new API will get some
> improvements but may
> still leak cleartext packets and have connection freezes till we get
> an updated userspace rolled out. On the plus side users running
> updated userspace won't be able to rekey connections any longer,
> avoiding the issues even with unpatched kernels.

Of course I may miss something and there may be a good way to get that
working anyhow. But for me it looks like we either have to accept
something which looks like a regression to users or accept that some
drivers may not be fixed with this patch alone and will need either an
updated userspace or drivers.

Alexander
