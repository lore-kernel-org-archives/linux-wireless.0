Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:47874 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaAEHd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jan 2014 02:33:57 -0500
Received: by mail-la0-f47.google.com with SMTP id e16so1143077lan.6
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jan 2014 23:33:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJ_iEdFVmyqMtpvzfVnyiMFR+ek8dfTjwRU0zoEBk5Dbw@mail.gmail.com>
References: <1388870653-3507-1-git-send-email-chaitanya.mgit@gmail.com>
	<CANUX_P1VCsciMzFzF6PmYakdTnnbMQysAQHv+Dj3JC-XzHbUvw@mail.gmail.com>
	<CABPxzYJ_iEdFVmyqMtpvzfVnyiMFR+ek8dfTjwRU0zoEBk5Dbw@mail.gmail.com>
Date: Sun, 5 Jan 2014 09:33:55 +0200
Message-ID: <CANUX_P3PK60sfTK2HHsjssrVjHX-pCpv5oVepB2aXP9Qzh6AMQ@mail.gmail.com> (sfid-20140105_083419_111986_377D78CA)
Subject: Re: [PATCH] mac80211: SMPS: Fix the overwrite of rx_chains in the
 interface loop.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Sun, Jan 5, 2014 at 9:21 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Sun, Jan 5, 2014 at 12:12 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>> On Sat, Jan 4, 2014 at 11:24 PM, Chaitanya T K <chaitanya.mgit@gmail.com> wrote:
>> > The interface loop identifies the no of static and dynamic
>> > smps chains, but overwrites their values across the VIF's
>> > (assuming there are more than one, in my case its AP and STA
>> > loopback), so the driver might not intimated about this update
>> > of SMPS mode, is the value is same.
>> >
>> > So inform driver for every VIF.
>> >
>> > For Ex: STA's SMPS state is changed, but in the loop AP appears
>> > at the last, SMPS state of AP is unchanged hence not intimated
>> > to the driver.
>> >
>> > Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
>> > ---
>>
>> But the dynamic / static chains number is a property of the channel
>> context. If you have several vifs on the same channel context, the
>> maximum number of dynamic / static chains will be assigned to the
>> channel context. In short, I think that mac80211 already does the job
>> of taking all the parameters into account and putting the right value
>> into the channel context?
>> I don't really see what bug you are trying to solve - could you please
>> tell us exactly what is your configuration?
>> What SMPS do you have for each interface and what dynamic / static
>> chains settings does mac80211 end up with?
>
> Agree this looks good in channel context angle.
>
> Lets say we have two VIF's one AP and one STA and the driver doesn't
> support channel context's so in that case the config will happen
> through hw_config but the problem is hw_config is out side the loop
> so the config will happen with the parameters of the last VIF, which
> is incorrect.

Same applies if the driver doesn't support channel contexts. hw_config
will be called with the correct local->smps_mode based on the number
of channels required by each one of the vifs?
I don't see why only the last vif will be taken into account: the loop
computes the maximum number of antenna requires by *all* the vifs.
What am I missing here?
