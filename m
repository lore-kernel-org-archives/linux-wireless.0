Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbcBKPIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 10:08:23 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] codel: add forgotten inline to functions in header file
Date: Thu, 11 Feb 2016 15:05:44 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA0E6FD@hasmsx107.ger.corp.intel.com> (sfid-20160211_160831_813541_251CAEA4)
References: <1455199701-25767-1-git-send-email-emmanuel.grumbach@intel.com>
 <1455201038.19473.12.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fixing linux-wireless address ...

On 02/11/2016 04:30 PM, Eric Dumazet wrote:
> On Thu, 2016-02-11 at 16:08 +0200, Emmanuel Grumbach wrote:
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>> -static bool codel_should_drop(const struct sk_buff *skb,
>> -			      struct Qdisc *sch,
>> -			      struct codel_vars *vars,
>> -			      struct codel_params *params,
>> -			      struct codel_stats *stats,
>> -			      codel_time_t now)
>> +static inline bool codel_should_drop(const struct sk_buff *skb,
>> +				     struct Qdisc *sch,
>> +				     struct codel_vars *vars,
>> +				     struct codel_params *params,
>> +				     struct codel_stats *stats,
>> +				     codel_time_t now)
>
> The lack of inline was done on purpose.
>
> This include file is kind of special, being included by codel and
> fq_codel.
>
> Hint : we do not want to force the compiler to inline
> codel_should_drop() (or any other function).
>
>
> See this file as if it was a .c really.
>
>

Yeah :) codel_should_drop seemed very long indeed... I wanted to use the
codel_get_time and associated utils (_before, _after) in iwlwifi.
They're better than jiffies... So maybe I can just copy that code to
iwlwifi.
