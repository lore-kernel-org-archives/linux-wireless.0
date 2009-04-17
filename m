Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:56101 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZDQKWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 06:22:24 -0400
Received: by yx-out-2324.google.com with SMTP id 3so34965yxj.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 03:22:23 -0700 (PDT)
Message-ID: <49E85859.5060603@tuffmail.co.uk> (sfid-20090417_122228_345029_109C6839)
Date: Fri, 17 Apr 2009 11:22:17 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [ath5k-devel] BUG in freq_reg_info_regd
References: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com>	 <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com>	 <20090415130232.GA21411@tuxdriver.com> <49E5EC66.80408@tuffmail.co.uk>	 <b6c5339f0904150809p308d8eedt83198f12a7887f7e@mail.gmail.com>	 <49E5F99E.1090809@tuffmail.co.uk> <b6c5339f0904150908nb23cf89n9f36bba5a29f955e@mail.gmail.com>
In-Reply-To: <b6c5339f0904150908nb23cf89n9f36bba5a29f955e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
>>> Hmm, null pointer is probably custom_regd since reg_rule comes from
>>> the stack and wiphy should've been validated a lot earlier.
>>>
>>> Mind posting the objdump -S net/wireless/reg.o ?
>>>
>>>       
>> Sure.  It's 120k so I trimmed the CC list.
>>     
>
> Darn, no debug info..  In hindsight I should've just asked for
> the scripts/markup_oops.pl treatment :)
>
> Ok, I was wrong: it's last_request.  This looks very similar to the bug you
> had a few days ago to which Pavel Roskin responded.  I don't think anything
> changed wrt last_request initialization, so maybe some kind of module
> loading race again?
>   

Could be.  It goes away if I just make cfg80211 built-in (and leave
mac80211 and ath/ath5k as modules).

Note that unlike the previous bug, this only happens with
wireless-testing.  It's still present in today's wireless-testing,
v2.6.30-rc2-21665-gca0be26.  I haven't seen it while testing mainline.

Thanks
Alan

