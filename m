Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:4189 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYEHAVC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 20:21:02 -0400
Received: by wa-out-1112.google.com with SMTP id j37so771778waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2008 17:21:02 -0700 (PDT)
Message-ID: <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com> (sfid-20080508_022012_233566_938B8A3C)
Date: Thu, 8 May 2008 03:21:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi and tx info in skb->cb
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210203054.3547.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 2:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  > >  What is a TFD, and why can it have multiple SKBs with a single tx
>  > >  status? I'm referring to:
>  >
>  > TFD stands for TX File Descriptor
>
>  Huh, "file"?
Sorry,. it's field.
>
>  Anyway,
>
>
>  > This is for scatter gather. Nothing to do with aggregation. If you get
>  > fragmented frame you can send it out without linearizing in CPU. in
>  > numer of TB - TX buffers (which is limitted bu MAX_NUM_OF_TBS)  But
>  > I'm just over ever explaining :)
>
>  We don't support that in mac80211 right now, why do you have that there?

Currently we actively use 2 of them. First for TX command second for
actual frame.  It would be even worth if we need to expand
each packet also for TX command.
Any how hope to make it work one day. There is significant performance
gain in using this at least in the other operating system.


Thanks
Tomas

Tomas

>  johannes
>
