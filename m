Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33017 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbFCHQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:16:22 -0400
Received: by iebgx4 with SMTP id gx4so7002344ieb.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 00:16:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433314971.2274.1.camel@sipsolutions.net>
References: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
 <CAGRGNgV_4axC8Cq5AYkd7RQdJOnrT_9L85qisrrZnKYHyUEczQ@mail.gmail.com> <1433314971.2274.1.camel@sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 3 Jun 2015 17:16:01 +1000
Message-ID: <CAGRGNgV7=D7d+QKSjWZrKiUxNKtSGDc8_LuZSRcgvPj-prUHsw@mail.gmail.com> (sfid-20150603_091626_000137_1A27FF25)
Subject: Re: [RFC] mac80211: convert HW flags to unsigned long bitmap
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	gregory.greenman@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Jun 3, 2015 at 5:02 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-06-03 at 10:57 +1000, Julian Calaby wrote:
>
>> Why not add a ieee80211_hw_clear() function? Yes, it'd only be used in
>> 3 places, but it'd look neater.
>
> Well, this was actually intentional.
>
> Drivers are not *supposed* to be doing this, the hardware flags are
> supposed to be constant hardware description flags. The three drivers
> clearing this specific but currently work OK due to the way this
> particular flag is treated, but that wouldn't necessarily the case for
> all of the flags; adding a _clear() function would seem to imply that
> it's OK to do this, when it's really not.

Ok, fair enough then. It just looked really odd to be setting it with
a function in one branch of an if statement and clearing it open coded
in the other.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
