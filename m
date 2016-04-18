Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38089 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbcDRFbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 01:31:39 -0400
Received: by mail-wm0-f44.google.com with SMTP id u206so106528422wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2016 22:31:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460845772.2075.31.camel@sipsolutions.net>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-5-git-send-email-michal.kazior@tieto.com>
	<1460845772.2075.31.camel@sipsolutions.net>
Date: Mon, 18 Apr 2016 07:31:37 +0200
Message-ID: <CA+BoTQkHAOhwFh5grveGCH5tfsxOT=BXAx2qgF1c=GcT7SrSQw@mail.gmail.com> (sfid-20160418_073143_116705_BEF09178)
Subject: Re: [PATCHv3 4/5] mac80211: implement codel on fair queuing flows
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2016 at 00:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-04-14 at 14:18 +0200, Michal Kazior wrote:
>>
>> +                             struct ieee80211_vif *vif;
>> +
>> +                             /* When packets are enqueued on txq
>> it's easy
>> +                              * to re-construct the vif pointer.
>> There's no
>> +                              * more space in tx_info so it can
>> be used to
>> +                              * store the necessary enqueue time
>> for packet
>> +                              * sojourn time computation.
>> +                              */
>> +                             u64 enqueue_time;
>> +                     };
>
> I wonder if we could move something like the hw_key into tx_control
> instead?

Hmm.. It's probably doable. From a quick look it'll require quite some
change here and there (e.g. tdls_channel_switch op will need to be
extended to pass tx_control). I'll play with the idea..


Michał
