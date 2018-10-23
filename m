Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4312DC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 10:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C2820665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 10:58:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00C2820665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbeJWTVV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 15:21:21 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.212]:40379 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727250AbeJWTVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 15:21:20 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 309E84031ECFC
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2018 05:58:24 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id EuOGgVZEQFxNhEuOGgngBc; Tue, 23 Oct 2018 05:58:24 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:55368 helo=[192.168.1.41])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEuOF-00241d-MG; Tue, 23 Oct 2018 05:58:23 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20181023001308.GA4150@embeddedor.com>
 <0b3197a734f71bdfffaf717e63b17e2fe31720a2.camel@sipsolutions.net>
 <f0a240e2-cae7-07f4-757f-a8606199d29e@embeddedor.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 VtSixD1uOgytAP7RWS474w==
Subject: Re: [PATCH v2] wireless: mark expected switch fall-throughs
Message-ID: <c2fad584-1705-a5f2-d63c-824e9b96cf50@embeddedor.com>
Date:   Tue, 23 Oct 2018 12:58:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <f0a240e2-cae7-07f4-757f-a8606199d29e@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 86.245.173.13
X-Source-L: No
X-Exim-ID: 1gEuOF-00241d-MG
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr ([192.168.1.41]) [86.245.173.13]:55368
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/23/18 10:59 AM, Gustavo A. R. Silva wrote:
> 
> On 10/23/18 9:01 AM, Johannes Berg wrote:
>> On Tue, 2018-10-23 at 02:13 +0200, Gustavo A. R. Silva wrote:
>>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>>> where we are expecting to fall through.
>>>
>>> Warning level 3 was used: -Wimplicit-fallthrough=3
>>>
>>> This code was not tested and GCC 7.2.0 was used to compile it.
>>
>> Look, I'm not going to make this any clearer: I'm not applying patches
>> like that where you've invested no effort whatsoever on verifying that
>> they're correct.
>>
> 
> How do you suggest me to verify that every part is correct in this type
> of patches?
> 

BTW... I'm under the impression you think that I don't even look at
the code. Is that correct?

I've been working on this for quite a while, and in every case I try to
understand the code in terms of the context in which every warning is
reported.

I look for dependencies between variables in adjacent switch cases, that could
make think it might be OK for some of those cases to fall through to the one
below. I check the names of the case labels to see if there might be any relation
between them, or if they are totally diferent as it might be the case for labels
that indicate the transmision(FOO_TX) or reception of data(FOO_RX). Something
similar to the latter is the case with on/off logic (FOO_ON/FOO_OFF). These are
some of the things I review in the code, so I can have an idea if the warning is
a false positive or an actual bug.

Here is a bug I found yesterday at drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c

5690         case WLAN_CIPHER_SUITE_CCMP:
5691                 key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
5692                 break;
5693         case WLAN_CIPHER_SUITE_TKIP:
5694                 key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
5695         default:
5696                 return -EOPNOTSUPP;
5697         }

Notice how the absence of a break statement is very suspicious in case
WLAN_CIPHER_SUITE_TKIP, because the code for case WLAN_CIPHER_SUITE_CCMP
is pretty similar and in that case there is a break at the bottom. Now,
that's not the only thing that looks supicious: in the absence of a break,
the code falls through to the default case, which returns the error value
-EOPNOTSUPP. So, even when key->flags is updated, the code always returns
an error for case WLAN_CIPHER_SUITE_TKIP. This analysis led me to think
that this is an actual bug, so I sent a patch to fix it:

https://lore.kernel.org/patchwork/patch/1002440/

Notice that this bug has been there since 2015:
commit 26f1fad29ad973b0fb26a9ca3dcb2a73dde781aa


Now, let's take a look at the following warning in net/wireless/chan.c:

net/wireless/chan.c: In function ‘cfg80211_chandef_usable’:
net/wireless/chan.c:748:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (!ht_cap->ht_supported)
      ^
net/wireless/chan.c:750:2: note: here
  case NL80211_CHAN_WIDTH_20_NOHT:
  ^~~~

This is the piece of code at net/wireless/chan.c:740:

 740         case NL80211_CHAN_WIDTH_5:
 741                 width = 5;
 742                 break;
 743         case NL80211_CHAN_WIDTH_10:
 744                 prohibited_flags |= IEEE80211_CHAN_NO_10MHZ;
 745                 width = 10;
 746                 break;
 747         case NL80211_CHAN_WIDTH_20:
 748                 if (!ht_cap->ht_supported)
 749                         return false;
 750         case NL80211_CHAN_WIDTH_20_NOHT:
 751                 prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 752                 width = 20;
 753                 break;
 754         case NL80211_CHAN_WIDTH_40:
 755                 width = 40;
 756                 if (!ht_cap->ht_supported)
 757                         return false;
 758                 if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
 759                     ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
 760                         return false;
 761                 if (chandef->center_freq1 < control_freq &&
 762                     chandef->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
 763                         return false;
 764                 if (chandef->center_freq1 > control_freq &&
 765                     chandef->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
 766                         return false;
 767                 break;

Notice that the warning was reported at line 748, but I'm including more code
here to make it explicitly clear that I not only focus my atention in a very
narrowed piece of code around the warning.

Now, I don't see anything supicious. The labels NL80211_CHAN_WIDTH_20 and
NL80211_CHAN_WIDTH_20_NOHT seem to be related, and it's even less supicious
when there is an explicit line of code that breaks the switch under certain
conditions, just at the bottom of the "case", as is the case with lines 748
and 749:

 748                 if (!ht_cap->ht_supported)
 749                         return false;

Also, no default case returning an error every time if the code falls through
to the next case. Lastly, I also check the age of the code, but this only after
I have analyzed it as explained above.


I do this analysis for every warning.  Now, when I say I haven't tested the code
is because I don't have any log as evidence for anything. Not that I haven't put
any effort on trying to understand it and its context.  When I started working on
this task there were more than 2000 of these issues, now there are around 600 left.

I have fixed many bugs on the way, so a good amount of work is being invested on
this, and it's paying off. :)


Now, let me ask you this question:

It would be easier for you to review this patch if I turn it into a series?

I can do that without a problem.

Thanks!
--
Gustavo

