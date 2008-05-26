Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:41083 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbYEZOsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:48:32 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2151062waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2008 07:48:31 -0700 (PDT)
Message-ID: <1ba2fa240805260748w6766e5efkb236bc7e0f776bc4@mail.gmail.com> (sfid-20080526_164835_917403_977C70EF)
Date: Mon, 26 May 2008 17:48:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix deadlock in sta->lock
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1211812853.4843.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
	 <1211811554.4843.4.camel@johannes.berg>
	 <1ba2fa240805260732g4c5942b2qec443dfc6d6339a7@mail.gmail.com>
	 <1211812853.4843.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2008 at 5:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-05-26 at 17:32 +0300, Tomas Winkler wrote:
>> On Mon, May 26, 2008 at 5:19 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2008-05-26 at 17:09 +0300, Tomas Winkler wrote:
>> >> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>> >>
>> >> This patch fixes a deadlock of sta->lock use, occuring while changing
>> >> tx aggregation states, as dev_queue_xmit end up in new function
>> >> test_and_clear_sta_flags that uses that lock thus leading to deadlock
>> >
>> > Oh, good catch, thanks. Reminds me to debug the other deadlock I saw
>> > (not mac80211 related though)
>> >
>> very encouraging :) . Can you send me details I also experience some
>> lockups on rc2
>
> Well when I resume my machine it locks up right after printing "eth0:
> resuming" or something like that, *iff* eth0 was down when suspending. I
> fixed a bug like that (NAPI related) a while ago, but w/o sungem changes
> it has re-appeared, or so it seems.
>
Thanks, doesn't look like what I see.
Tomas
