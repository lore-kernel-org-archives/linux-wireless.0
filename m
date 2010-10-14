Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58250 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0JNW3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:29:23 -0400
Received: by iwn35 with SMTP id 35so110555iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
References: <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net>
 <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
 <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
 <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
 <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
 <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
 <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop>
 <4CB5E0A8.5020502@candelatech.com> <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Oct 2010 15:29:02 -0700
Message-ID: <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 3:16 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> 2010/10/14 Ben Greear <greearb@candelatech.com>:
>> On 10/14/2010 02:52 PM, Björn Smedman wrote:
>>>
>>> 2010/10/13 Björn Smedman<bjorn.smedman@venatech.se>:
>>>>
>>>> Hi Ben,
>>>>
>>>> First of all keep up the good work. :)
>>>>
>>>> On Wed, Oct 13, 2010 at 6:39 PM, Ben Greear<greearb@candelatech.com>
>>>>  wrote:
>>>> [snip]
>>>>>
>>>>> Either way, it seems safer to null out the bf_ampdu field after
>>>>> the memory is consumed..it could prevent some tricky bugs later.
>>>>
>>>> I think this is a good idea. But it probably wont be enough to null
>>>> out bf_mpdu. You also need to look at bf_buf_addr (which if I
>>>> understand correctly is the physical address the DMA engine will
>>>> actually write RXed frames to) and bf_dmacontext (which seems in most
>>>> cases to hold an identical address and may in fact be where the DMA
>>>> engine will really write the frame).
>>>
>>> I took another look at the code. It turns out both bf_buf_addr and
>>> bf_dmacontext are in fact meaningless to the DMA. Instead each bf
>>> holds a pointer (bf_desc) to the real DMA descriptor which in turn
>>> holds the address (ds_data) where the DMA will really (really this
>>> time) write the frame. There is also a field to hold the virtual
>>> address of the same place (ds_vdata).
>>>
>>> It's a little too much work for me to set up the testbed you have Ben
>>> but would be interesting to see what happens if you set
>>> bf->bf_desc->ds_{data,vdata} = 0 as well. No?
>>
>> I'll investigate those suggestions.
>>
>> But setting up a test-bed is as easy
>> as getting an ath9k NIC in a system, with a few APs around, and run the
>> script below.
>>
>> You do not need any traffic generation, dhcp, etc...seems just beacons and
>> whatever
>> wpa_supplicant is doing is enough to hit the problem fast.  (Make sure
>> you are compiled to detect memory poisoning, of course).
>>
>> You'll need to fix the paths to the executables most likely.
>>
>
> You don't need such complicated scripts, I've managed to reproduce now
> by creating a lot of monitor interfaces and then looping with a
> regular interface issuing a scan command over and over.  I suspect
> I'll be able to do this as well by changing channels instead of doing
> a scan. I believe the issue may be due to races in hardware on resets
> and enabling RX on an already freed buffer.

Fun enough if I just create one monitor interface and loop quickly
over some 2 GHz channels where I know I have traffic nearby I don't
see the poison. So channel changes don't seem to do much because this
is changing channels as fast as possible from userspace. I also can
confirm that I see frames from the different channels as I move along.

  Luis
