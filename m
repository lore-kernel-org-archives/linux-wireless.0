Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2CSFAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 01:00:24 -0400
Received: by pbcun15 with SMTP id un15so918898pbc.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2012 22:00:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332088355.3354.0.camel@jlt3.sipsolutions.net>
References: <1331923430-23861-1-git-send-email-yeohchunyeow@gmail.com>
	<1331901642.6753.1.camel@jlt3.sipsolutions.net>
	<CAEFj9861XC5rvBBB3DxLaPDrYFz7FECA82KpEF+L6rMsK1F6Sw@mail.gmail.com>
	<1332088355.3354.0.camel@jlt3.sipsolutions.net>
Date: Mon, 19 Mar 2012 13:00:23 +0800
Message-ID: <CAEFj985PfTAyPTmxykvOgC-ZPZkN6D_WT+5yrhD0a09iyz+pUQ@mail.gmail.com> (sfid-20120319_060027_961044_DF01005D)
Subject: Re: [PATCH] mac80211: fix the endianness problem of HWMP sequence
 number in RANN propagation
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I am able to generate the warnings. It seems that I need to
resolve the first error below, otherwise don't see the subsequent
warnings.
include/linux/skbuff.h:357:41: error: invalid bitfield specifier for
type restricted __be16.

Will submit patch with different naming since it involves the
rann->metric as well.

Chun-Yeow

On Mon, Mar 19, 2012 at 12:32 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>> > You should mark struct ieee80211_rann_ie to contain __le32, so that
>> > sparse will warn about things like this.
>> >
>>
>> I try to change u32 to __le32 for the following members in struct
>> ieee80211_rann_ie.
>>
>> struct ieee80211_rann_ie {
>>         u8 rann_flags;
>>         u8 rann_hopcount;
>>         u8 rann_ttl;
>>         u8 rann_addr[6];
>>         __le32 rann_seq;
>>         __le32 rann_interval;
>>         __le32 rann_metric;
>> } __attribute__ ((packed));
>>
>> But when I compile using "make C=2 CF=-D__CHECK_ENDIAN__", I don't see
>> any sparse warning on this.
>
> Not sure, if I make the above change I get:
>
>  CHECK   net/mac80211/mesh_hwmp.c
> net/mac80211/mesh_hwmp.c:751:17: warning: incorrect type in assignment (different base types)
> net/mac80211/mesh_hwmp.c:751:17:    expected unsigned int [unsigned] [usertype] orig_sn
> net/mac80211/mesh_hwmp.c:751:17:    got restricted __le32 [usertype] rann_seq
> net/mac80211/mesh_hwmp.c:754:16: warning: incorrect type in assignment (different base types)
> net/mac80211/mesh_hwmp.c:754:16:    expected unsigned int [unsigned] [usertype] metric
> net/mac80211/mesh_hwmp.c:754:16:    got restricted __le32 [usertype] rann_metric
>
> johannes
>
