Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:16832 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYI2MBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 08:01:13 -0400
Received: by ey-out-2122.google.com with SMTP id 6so546994eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 05:01:11 -0700 (PDT)
Message-ID: <48E0C384.3000903@gmail.com> (sfid-20080929_140116_421937_DA5031A7)
Date: Mon, 29 Sep 2008 14:01:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
References: <48E0A65A.2060102@gmail.com>	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>	 <1222683923.7064.18.camel@johannes.berg> <48E0C185.6070705@gmail.com>	 (sfid-20080929_135242_032949_BF501638) <1222689340.7064.26.camel@johannes.berg>
In-Reply-To: <1222689340.7064.26.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2008 01:55 PM, Johannes Berg wrote:
> On Mon, 2008-09-29 at 13:52 +0200, Jiri Slaby wrote:
> 
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -246,16 +246,26 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct
>> genl_info *info)
>>  {
>>         struct sk_buff *msg;
>>         struct cfg80211_registered_device *dev;
>> +       size_t bufsize = NLMSG_GOODSIZE;
>> +       unsigned int tries = 0;
>> +       int ret;
>>
>>         dev = cfg80211_get_dev_from_info(info);
>>         if (IS_ERR(dev))
>>                 return PTR_ERR(dev);
>>
>> -       msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>> +retry:
>> +       msg = nlmsg_new(bufsize, GFP_KERNEL);
>>         if (!msg)
>>                 goto out_err;
>>
>> -       if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev) < 0)
>> +       ret = nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev);
>> +       if (ret == -EMSGSIZE && ++tries < 2) {
>> +               bufsize *= 2;
>> +               nlmsg_free(msg);
>> +               goto retry;
>> +       }
>> +       if (ret < 0)
>>                 goto out_free;
>>
>>         cfg80211_put_dev(dev);
>>
> 
> Works for me. Not the greatest way to do this I guess, but hey, it
> works.

Anyway it is wrong. NLMSG_GOODSIZE * x for x > 1 doesn't give skb aligned to a
page boundary. bufsize should start with PAGE_SIZE or 8192 and be multiplied
then and the parameter used for nlmsg_new SKB_WITH_OVERHEAD(bufsize).

But it's ugly as hell, I agree -- and quite a temporary solution until somebody
decides to add channels, another channel info or whatever.
