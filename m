Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:22970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYIFWcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:32:48 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1029715fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 15:32:47 -0700 (PDT)
Message-ID: <1ba2fa240809061532s4f8e08c1xe59f99768ce440c0@mail.gmail.com> (sfid-20080907_003251_159000_109CBECA)
Date: Sun, 7 Sep 2008 01:32:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739930.21016.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739930.21016.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 1:25 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>>
>> +static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>> +                                  struct ieee80211_if_sta *ifsta, int deauth,
>> +                                  int self_disconnected, u16 reason)
>
> I think you should use bool for those two (deauth, self)

I'm thinking rather using some enum values just for readability
foo(DEAUTH, ORIGIN_SELF) vs foo(tree,true)
foo(DISASSOC, ORIGIN_PEER)  vs foo(false, false)


>> +     rcu_read_unlock();
>> +
>> +     sta_info_unlink(&sta);
>
> Those need to be the other way around.

Will do,
Thanks
Tomas
