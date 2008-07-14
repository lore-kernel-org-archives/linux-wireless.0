Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:62664 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYGNMjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:39:01 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2384887ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 05:38:54 -0700 (PDT)
Message-ID: <1ba2fa240807140538n671ac95cm3e4b1a9d25af411a@mail.gmail.com> (sfid-20080714_143906_742001_502D8EB0)
Date: Mon, 14 Jul 2008 15:38:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: pass dtim_period to low level driver
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1216038966.11189.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038966.11189.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 3:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -191,6 +191,7 @@ struct ieee80211_bss_conf {
>>       /* erp related data */
>>       bool use_cts_prot;
>>       bool use_short_preamble;
>> +     u8 dtim_period;
>>       u16 beacon_int;
>>       u16 assoc_capability;
>>       u64 timestamp;
>
> Can you add documentation please, especially about the fact that it can
> be zero if the network is buggy / IBSS.

Right, I will also add fallback to 1 if it's 0
Thanks
Tomas
