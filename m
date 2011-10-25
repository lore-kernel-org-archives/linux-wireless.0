Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41709 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab1JYOGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:00 -0400
Received: by mail-gy0-f174.google.com with SMTP id 13so511124gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 07:06:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111025135647.GB2231@redhat.com>
References: <1319531194-26839-1-git-send-email-eliad@wizery.com>
	<20111025135647.GB2231@redhat.com>
Date: Tue, 25 Oct 2011 16:06:00 +0200
Message-ID: <CAB3XZEf8ZWhO+7y6Ap8YNWzYd1jjd4Souy_4o9nqxEefT3CJhQ@mail.gmail.com> (sfid-20111025_160609_546608_F57B8657)
Subject: Re: [PATCH] mac80211: use min rate as basic rate for buggy APs
From: Eliad Peller <eliad@wizery.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 25, 2011 at 3:56 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Oct 25, 2011 at 10:26:34AM +0200, Eliad Peller wrote:
>> Some buggy APs (and even P2P_GO) don't advertise their
>> basic rates in the association response.
>>
>> In such case, use the min supported rate as the
>> basic rate.
>
> Can we do this in simpler way?
>
>   if (unlikely(!basic_rates))
>        basic_rates = BIT(ffs(rates) - 1);
>
the bitrates array is not sorted, so i guess not (unless we want to
choose an arbitrary rate).

Eliad.
