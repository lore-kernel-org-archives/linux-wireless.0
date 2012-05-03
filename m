Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46302 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab2ECUU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:20:29 -0400
Received: by obbtb18 with SMTP id tb18so2920568obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 13:20:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336073794.5167.15.camel@jlt3.sipsolutions.net>
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com> <1336073794.5167.15.camel@jlt3.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 3 May 2012 13:20:08 -0700
Message-ID: <CACcxo+pim4A398uzj0cjdmfdkGJ0o6f9QB=tdCsicmiT0AyKsw@mail.gmail.com> (sfid-20120503_222032_593820_3EE1A094)
Subject: Re: [PATCH v2 1/4] mac80211: Advertise HT protection mode in IEs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 3, 2012 at 12:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:
>
>>               pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
>> -                                              chan, channel_type);
>> +                                              chan, channel_type, 0);
>
>> -     /*
>> -      * Note: According to 802.11n-2009 9.13.3.1, HT Protection field and
>> -      * RIFS Mode are reserved in IBSS mode, therefore keep them at 0
>> -      */
>> -     ht_oper->operation_mode = 0x0000;
>> +     ht_oper->operation_mode = cpu_to_le16(prot_mode);
>
> Please move the comment to the now correct place instead of deleting it.
>
Sure.
> johannes
>
