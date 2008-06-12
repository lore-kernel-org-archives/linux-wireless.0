Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:45958 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYFLVbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 17:31:46 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2612462fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 14:31:43 -0700 (PDT)
Message-ID: <48519577.8000402@gmail.com> (sfid-20080612_233151_396947_6DD827EC)
Date: Thu, 12 Jun 2008 23:30:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Rik van Riel <riel@redhat.com>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>	 <20080612093833.0fb9cdd6@bree.surriel.com>	 <1213278884.3936.15.camel@johannes.berg> <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
In-Reply-To: <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2008 05:43 PM, Tomas Winkler wrote:
> On Thu, Jun 12, 2008 at 4:54 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> This cuts the allocation to 10%, or (under) a page in all cases.
> 
> Probably. it would be safe to use vmalloc for allocating txb anyway.
> I'll give it a try.

Why it wouldn't be "safe". I suggested it to you already, since allocating 64k 
by kmalloc for descriptors accessed only in kernel is crud. Moreover you're 
mixing the buffer with its descriptors here? Or what you're considering to vmalloc?
