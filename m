Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:60607 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYFLW06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 18:26:58 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2245591rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 15:26:58 -0700 (PDT)
Message-ID: <1ba2fa240806121526g2ed0c7u733d5620cb790eb6@mail.gmail.com> (sfid-20080613_002702_532019_30A61E96)
Date: Fri, 13 Jun 2008 01:26:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Rik van Riel" <riel@redhat.com>,
	"Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <48519577.8000402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <48519577.8000402@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 12:30 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 06/12/2008 05:43 PM, Tomas Winkler wrote:
>>
>> On Thu, Jun 12, 2008 at 4:54 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>>
>>> This cuts the allocation to 10%, or (under) a page in all cases.
>>
>> Probably. it would be safe to use vmalloc for allocating txb anyway.
>> I'll give it a try.
>
> Why it wouldn't be "safe". I suggested it to you already, since allocating
> 64k by kmalloc for descriptors accessed only in kernel is crud. Moreover
> you're mixing the buffer with its descriptors here? Or what you're
> considering to vmalloc?
>
Not that. I just wasn't sure when I dropped the line  I'm not doing it
under some spinlock or something like that.
Tomas
