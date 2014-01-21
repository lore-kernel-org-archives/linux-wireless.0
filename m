Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58992 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaAUTLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 14:11:33 -0500
Received: by mail-wi0-f170.google.com with SMTP id ex4so5942619wid.5
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 11:11:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390215015.4335.6.camel@jlt4.sipsolutions.net>
References: <1390009167-4766-1-git-send-email-chaitanya.mgit@gmail.com> <1390215015.4335.6.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 22 Jan 2014 00:41:12 +0530
Message-ID: <CABPxzYKBP7Oby9yCrahS_8918cDqkApGyvz3F80eCGcmqeKSHw@mail.gmail.com> (sfid-20140121_201137_408746_69295727)
Subject: Re: [PATCH V2] cfg80211: Do not call CRDA when using internal
 regulatory database
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 20, 2014 at 4:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2014-01-18 at 07:09 +0530, Chaitanya T K wrote:
>> When using internal regulatory data base kconfig option,
>> do not try to call crda. This completely defeats the
>> purpose of enabling internal regulatory db.
>
> I still think that this is a significant userspace API change, so I'm
> not going to apply it. Find another solution.
>
Well, only way i can think of is ignore the update from the CRDA
and go on with internal db.txt, but even this will have impact on
user. As internal regdb is rarely used,this is not really needed.

But the second fix which returns REG_IGNORE when call_crda
returns an error should be still taken. Probably !=0 check is still better .
