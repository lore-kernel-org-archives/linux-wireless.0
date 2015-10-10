Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37663 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbJJERV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 00:17:21 -0400
Received: by wicfx3 with SMTP id fx3so89041666wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2015 21:17:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfjio6h18jq.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<87d1wp49ds.fsf@frog.home>
	<wrfjio6h18jq.fsf@redhat.com>
Date: Sat, 10 Oct 2015 13:17:19 +0900
Message-ID: <CAMArcTUNtE=Tb_hpyQ4c_w_nbJXcX-SkHyk1N5OWSvdNdYpkrw@mail.gmail.com> (sfid-20151010_061748_624696_CD2FB105)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Taehee Yoo <ap420073@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jakub Sitnicki <jsitnicki@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-10-09 4:09 GMT+09:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> Hi Jes,
>>
>> On Sat, Aug 29, 2015 at 11:18 PM CEST, Jes.Sorensen@redhat.com wrote:
>>> This is an alternate driver for a number of Realtek WiFi USB devices,
>>> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
>>> It was written from scratch utilizing the Linux mac80211 stack.
>>>
>>> After spending months cleaning up the vendor provided rtl8723au
>>> driver, which comes with it's own 802.11 stack included, I decided to
>>> rewrite this driver from the bottom up.
>>
>> In the long term, do you plan for this driver to support the
>> RTL8188EU-based devices as well?
>
> I have an 8188EU dongle in my wifi dongle pouch, together with several
> other yet to be supported ones :) I am currently trying to get the
> 8723BU and 8192EU working, but I haven't had time to work much on the
> 8188EU yet.
>
>> I've been checking how far I can get through the rtl8xxxu initialization
>> using a TP-Link TL-WN725N dongle without changing too much.
>>
>> Getting it up to read the EFUSE contents wasn't difficult but then you
>> need to parse it and first differences come to light.  Namely, TX power
>> levels are defined per each of 6 (not 3) channel groups, and power
>> differences are defined per TX path (as opposed to per channel group).
>> This is perhaps better described by the relevant structure from
>> rtl8188eu driver:
>>
>> struct txpowerinfo24g {
>>       u8 IndexCCK_Base[MAX_RF_PATH][MAX_CHNL_GROUP_24G];
>>       u8 IndexBW40_Base[MAX_RF_PATH][MAX_CHNL_GROUP_24G];
>>       /* If only one tx, only BW20 and OFDM are used. */
>>       s8 CCK_Diff[MAX_RF_PATH][MAX_TX_COUNT];
>>       s8 OFDM_Diff[MAX_RF_PATH][MAX_TX_COUNT];
>>       s8 BW20_Diff[MAX_RF_PATH][MAX_TX_COUNT];
>>       s8 BW40_Diff[MAX_RF_PATH][MAX_TX_COUNT];
>> };
>>
>> AFAICT, in this regard, rtl8188eu driver has more in common with the
>> rtlwifi/rtl8188ee driver.
>>
>> I'm curious what is your opinion on this.  In particular, do you see any
>> reason not to make an attempt to extend rtl8xxxu to support 8188EU
>> chips?
>
> Parsing the efuse is normally fairly easy, if you have a reference to
> the layout. It can be deducted from the vendor driver code. The layout
> pretty much differ for each chip, but I have seen enough of them by now
> that I can parse most of it by looking at the hex dump.
>
> I think the 8188EU uses IOL, which is an enhanced firmware assist API.
> That will change the programming a bit, but I think it's well within
> scope for this driver to support this as well.
>
> In other words, it is my plan to look at the 8188EU. If you get it going
> before me, I am very happy to work with you on integrating the patches.
>
> Cheers,
> Jes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi

I am currently writing a rtl8188eu driver that is using rtlwifi.
I think this driver can help you to support the RTL8188EU chip.

https://github.com/TaeheeYoo/rtl8188eu

Thanks,
Taehee
