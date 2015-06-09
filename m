Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34838 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbbFIU3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:29:21 -0400
Received: by igdj8 with SMTP id j8so3666308igd.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 13:29:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433880520.1892.23.camel@sipsolutions.net>
References: <1433355732-7604-1-git-send-email-chaitanya.mgit@gmail.com> <1433880520.1892.23.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 10 Jun 2015 01:58:59 +0530
Message-ID: <CABPxzYJ4zuFL62CPMASqpjCeT2dZMBDQNW5_QNMEP7fPzWoxzg@mail.gmail.com> (sfid-20150609_222937_303554_9A2A85C9)
Subject: Re: [PATCH V3] mac80211: minstrel_ht: Handle Dynamic SMPS state of
 the peer.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 1:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-06-03 at 23:52 +0530, Chaitanya T K wrote:
>> In case of Dynamic SMPS enable RTS/CTS for all rates.
>
>> +     /* Enable RTS/CTS for below cases.
>> +      * 1) Handle STA's SMPS State, if Nss > 1.
>> +      *    a. Use RTS_CTS, if STA is in Dynamic SMPS Mode
>> +      *    b. Mark Nss > 1 as unsupported, if STA is in static SMPS mode
>> +      * 2) 2nd and 3rd Rates, as 1st Rate Failed.
>> +      */
>> +     if ((mi->sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
>> +          group->streams > 1) ||
>> +          offset > 0) {
>
> Indent still isn't right - the line starting with "offset" should be
> indented one less. Might also be worthwhile to just reorder the
> condition to first check for offset > 0?
Ok, i will fix the indent and also re-order the check.

> I was about to do that and apply this, but it seems the comment doesn't
> make sense since you're not doing 1b. afaict?
Yes, the comment is not applicable for this version, will remove.
Will submit V4, Thanks.
