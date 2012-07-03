Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38849 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2GCSCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 14:02:12 -0400
Received: by gglu4 with SMTP id u4so5586311ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 11:02:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341316520.20124.0.camel@jlt3.sipsolutions.net>
References: <1341304650-2593-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341316520.20124.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 3 Jul 2012 11:01:47 -0700
Message-ID: <CAB=NE6VMRKVpeKjNO1N3sR=bgb4LToNS_PiecxdsngWO6av_Qg@mail.gmail.com> (sfid-20120703_200215_539556_F3699882)
Subject: Re: [PATCH 0/2] High bitrate support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 4:55 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2012-07-03 at 11:37 +0300, Vladimir Kondratiev wrote:
>> Proposed patches solve issue with high bitrates not fitting into u16.
>>
>> I split it into 2 patches: one introduces new u32 bitrate,
>> and 2-nd adds 60g specific calculations.
>>
>> Idea is to report (in nl80211) both old and new values,
>> or only new if it not fits into u16.
>> User space tools will migrate to the new bitrate, then old one
>> may be removed from kernel.
>>
>> There are few places where cfg80211_calculate_bitrate() used
>> besides nl80211.c; but these places are OK with bitrate changing
>> from u16 to u32.
>>
>> Vladimir Kondratiev (2):
>>   {nl,cfg}80211: support high bitrates
>>   cfg80211: bitrate calculation for 60g
>
> I've applied this (but not yet pushed out in case somebody objects
> still).

In case it is missed, I did point out a few things with the first patch.

  Luis
