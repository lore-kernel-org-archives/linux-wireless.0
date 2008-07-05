Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:39460 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYGESoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 14:44:55 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1045213waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 11:44:54 -0700 (PDT)
Message-ID: <1ba2fa240807051144g65821ba1neabcd56ff56d273c@mail.gmail.com> (sfid-20080705_204505_915789_B450D197)
Date: Sat, 5 Jul 2008 21:44:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH] iwlwifi: Memory allocation optimization.
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Gregory Greenman" <gregory.greenman@intel.com>
In-Reply-To: <1215275435.6848.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215103274-8516-1-git-send-email-tomas.winkler@intel.com>
	 <1215275435.6848.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 5, 2008 at 7:30 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-03 at 19:41 +0300, Tomas Winkler wrote:
>> From: Gregory Greenman <gregory.greenman@intel.com>
>>
>> This patch optimizes memory allocation. The cmd member of
>> iwl_tx_queue was allocated previously as a continuous block
>> of memory. This patch allocates separate memory chunks for each command
>> and maps/unmaps these chunks in the run time.
>
> You still allocate a lot of unused memory. Why don't you, at least
> temporarily until you've figured out how to do gather-IO [1], reduce the
> maximum number of DMA fragments to 2 so you need 1/10th the memory? You
> can always bump it back up after you do the necessary mac80211 changes.

We have to improve more places in allocation and we hopefully had
mapped all of them.
This patch fixes allocation that was in order 5 in( (ATOMCI | DMA) and
was most urgent.
The section you've suggested is I think on 3rd or 4th place. Don't
worry we get there.
What is more important now that we get some feedback on this fix.
Thanks
Tomas


> johannes
>
> [1] and I still maintain that you will not be able to, but that's
> irrelevant.
>
