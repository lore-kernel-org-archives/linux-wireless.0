Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:58978 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYKBUkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 15:40:35 -0500
Received: by el-out-1112.google.com with SMTP id z25so1061568ele.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 12:40:34 -0800 (PST)
Message-ID: <43e72e890811021240q1709dde4r402162bd590fa444@mail.gmail.com> (sfid-20081102_214040_876051_1DF6202C)
Date: Sun, 2 Nov 2008 12:40:34 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Bob Copeland" <me@bobcopeland.com>
In-Reply-To: <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 1:10 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/11/2 Nick Kossifidis <mickflemm@gmail.com>:
>> 2008/11/1 Luis R. Rodriguez <mcgrof@gmail.com>:
>>> On Wed, Oct 29, 2008 at 12:19 PM, Tim Gardner <tcanonical@tpi.com> wrote:
>>>> This commit 'ath5k: Update interrupt masking code' causes stalls under
>>>> load when built using compat-wireless on 2.6.27. There is no output from
>>>> dmesg, but it occasionally recovers and moves a few more packets before
>>>> stalling again. Luis suggested reverting
>>>> eb9d4e8399181357cb6f6625ba7f849987432c6c which I did. Now it appears to
>>>> work normally.
>>>>
>>>> I also think this patch should be broken into multiple pieces. There
>>>> appear to be at least 3 functional changes addressed in this single patch.
>>>
>>> Agreed, I just tested with the latest wireless-testing and the issue
>>> is still present. I reviewed the commit but its a big too large to pin
>>> point the exact issue, my AR5414 goes up but then quickly becomes
>>> unusable. Nick how about we revert this and you can then split this up
>>> into a good number of patches to make the review easier and also to be
>>> able to pin point the exact issue better?
>>>
>>> The SHA1 remains the same but just in case the title of the patch is:
>>>
>>>   ath5k: Update interrupt masking code
>>>
>>> With it reverted I'm cruising and can ditch MadWifi completely, which
>>> is the idea.
>>>
>>>  Luis
>>>
>>
>
> Can you test the attached patch ?
>
> It works for me (tested on a AR5413)...

Thanks, that fixes it.

  Luis
