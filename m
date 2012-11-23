Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:40885 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919Ab2KWGjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 01:39:31 -0500
Message-ID: <50AF1A1E.8090704@posedge.com> (sfid-20121123_073937_910352_1A596F7A)
Date: Fri, 23 Nov 2012 12:09:26 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: RFC[1/2]mac80211: Add Statistic to debugfs
References: <50AF0E91.30709@posedge.com> <CAGRGNgW1x0O26SxytoDQLYXFqWcmfaCGE=Q_pxGg31mW0HyRtw@mail.gmail.com>
In-Reply-To: <CAGRGNgW1x0O26SxytoDQLYXFqWcmfaCGE=Q_pxGg31mW0HyRtw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thanks for the comments. I will post individual statistics as individual 
patch.
Please find my comments inline.

On 11/23/2012 11:28 AM, Julian Calaby wrote:
> Hi Saravana,
>
> On Fri, Nov 23, 2012 at 4:50 PM, Saravana <saravanad@posedge.com> wrote:
>> Provide additional statistic support to the debugfs.
>>
> Also, as you're adding new statistics which are only used when debugfs
> is enabled, you might want to wrap them in #ifdefs so that they're
> only compiled when debugfs support is compiled.
>

The function ieee80211_sta_debugfs_add(struct sta_info *sta) which adds 
the debugfs will try to create the directory first.This 
debugfs_create_dir(mac, stations_dir) will be return a valid dentry only 
when CONFIG_DEBUG_FS is defined.if CONFIG_DEBUG_FS is not defined then 
dentry will be invalid and hence the ieee80211_sta_debugfs_add() will 
return without adding the files.
Hence we don't need to wrap this up in #ifdef as it is already taken 
care during the directory creation.
>>   ---
>> The diff file is generated from wireless-testing git tree.
>>
>> net/mac80211/debugfs_sta.c |    3 +++
>>   net/mac80211/sta_info.h    |    4 ++++
>>   net/mac80211/status.c      |    2 ++
>>   net/mac80211/wpa.c         |    1 +
>>   4 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index ab63237..19baafc 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -539,6 +539,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
>> struct sk_buff *skb)
>>                                  sta->lost_packets = 0;
>>                          }
>>                  }
>> +               if(acked)
>> +               sta->last_ack_signal=info->status.ack_signal;
>
> Either the indentation here is wrong or your mailer mangled the patch.
> Either way it should get fixed up when you resubmit.
>
+		if (acked)
+			sta->last_ack_signal=info->status.ack_signal;	
Please find the corrected indentation.
>>          }
>>
>>          rcu_read_unlock();
>
> Thanks,
>

