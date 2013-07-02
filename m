Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39389 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab3GBSFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 14:05:50 -0400
Message-ID: <51D3167D.3070000@openwrt.org> (sfid-20130702_200553_552881_CD849E9C)
Date: Tue, 02 Jul 2013 20:05:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: Use libnl-configurable values for retry counts
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> <51CF3EC9.3000707@openwrt.org> <000001ce7728$18b07de0$4a1179a0$@acksys.fr> <51D2DAB9.4050002@openwrt.org> <000101ce774b$3925e380$ab71aa80$@acksys.fr>
In-Reply-To: <000101ce774b$3925e380$ab71aa80$@acksys.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-02 7:40 PM, Jean-Pierre Tosoni wrote:
> Hi Felix,
> 
> Sorry to use your time again...
> 
>> But much more important than that is to not cause regressions for other
>> people via aggressive packet dropping.
> 
> Agreed, but see below.
> 
>> If you put the code in minstrel (and minstrel_ht), it not only allows
>> making a better tradeoff for retry handling, the code also doesn't have
>> to be run for every single packet. You can run it during the rate
>> control stats update.
> 
> OK, I'll have a look at that part now.
> 
>> 
>> The reduction of retry attempts definitely needs to be balanced
>> properly. Retries with max_prob_rate can be more important than retries
>> with max_tp_rate, but there needs to be a minimum for each of those.
> 
> This leads to a question about regressions and backward compatibility:
> 
> Since minstrel can compute as much as 28 retries for a frame,
> And since the (standard) default value for "short_frame_max_tx_count" is 7,
> 
> ... there is no way I can enforce the configured value while keeping
> minstrel counts by default !
> The standard itself gives a very aggressive limit! Or am I mistaken about
> the significance of this configuration parameter ?
I think you're right about this. Specifically because the standard limit
is much lower than what is being used now, we need to really make sure
that it's applied in a way that it does not harm the normal use case in
any visible way.

- Felix
