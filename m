Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:62181 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYFWLRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 07:17:24 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7013690rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 04:17:23 -0700 (PDT)
Message-ID: <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com> (sfid-20080623_131732_516748_417041EC)
Date: Mon, 23 Jun 2008 13:17:23 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: mac80211: workqueue & RTNL lock
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200806231120.41519.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806230042.41219.IvDoorn@gmail.com>
	 <200806230030.42776.mb@bu3sch.de>
	 <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
	 <200806231120.41519.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/23/08, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 23 June 2008 10:30:47 Ivo Van Doorn wrote:
>> On 6/23/08, Michael Buesch <mb@bu3sch.de> wrote:
>> > On Monday 23 June 2008 00:42:41 Ivo van Doorn wrote:
>> >> That function calls flush_workqueue()
>> >
>> > Uh wait. It shouldn't call that. Where exactly is this function called?
>>
>> It is called right before local->ops->remove_interface() which means the
>> workqueue is flushed when it isn't even guaranteed that all interfaces are
>> gone.
>>
>> net/mac80211/main.c:553
>>
>> static int ieee80211_stop(struct net_device *dev)
>> {
>> <snip>
>>   switch (sdata->vif.type) {
>> 	case IEEE80211_IF_TYPE_MESH_POINT:
>> 	case IEEE80211_IF_TYPE_STA:
>> 	case IEEE80211_IF_TYPE_IBSS:
>>         <snip>
>>         flush_workqueue(local->hw.workqueue);
>>        <snip>
>>   }
>> <snip>
>> }
>
> Oh right. I see. This is actually OK. I thought it would flush the global
> wq.
> The local mac80211 wq was introduced to workaround this rtnl deadlock,
> so I'm surprised it happens again.

Well it was caused by the recent introduction of the interface iterator.
Question now is if we need to restrict the usage, remove the flush_workqueue,
or change the locking in the interface iterator. :S

Ivo
