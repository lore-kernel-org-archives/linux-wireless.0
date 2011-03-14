Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59599 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1CNSQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:16:51 -0400
Received: by pwi15 with SMTP id 15so904040pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:16:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300063647.24333.7.camel@wwguy-ubuntu>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
 <1299831238.5082.185.camel@wwguy-huron> <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
 <1300063647.24333.7.camel@wwguy-ubuntu>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 14 Mar 2011 11:16:30 -0700
Message-ID: <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 13, 2011 at 5:47 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> On Sun, 2011-03-13 at 12:59 -0700, Daniel Halperin wrote:
>> On Fri, Mar 11, 2011 at 12:13 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>> >> (1) Why does iwlwifi default to an aggregation frame limit of 31? I
>> >> didn't see any negative effects from 63 frame limit and performance
>> >> improved dramatically
>> > if I remember correctly, we change from 63 to 31 while we have some 11n
>> > performance issue. even later we found out frame limit is not the main
>> > reason of low tpt, but we did not change it back since at the time we
>> > did not see any performance different, I believe we can use different
>> > frame limit, but I will prefer make it more flexible, maybe something
>> > could be change by either module parameter or debugfs. Also I am not
>> > sure are there any behavior differences between different devices and
>> > different versions of ucode.
>>
>> 63 hasn't hurt me yet, though the scheduler still does occasionally
>> send a 64th frame that shifts the reorder buffer's window.  Is there a
>> chance that 64 will work as a max?  63 seems an odd choice.
>
> it is limited by uCode, did not have chance to look at what the reason
> is yet. my initial guess without look at the code, 63 = 0x3F which use 6
> bits and 64=0x40 is 7 bits, but I am not sure, I will check

A few followups: in iwl-prph.h, we see that the default SCD window
size and AGG FRAME LIMIT are both 64 [1]. Indeed, the various masks on
these fields are 7 bits long. I bet an agg frame limit of 64 would
work just fine.

BUT, it looks like when we set up aggregation, we set the scheduler to
ALWAYS use the default maximum of 64 frames for both these parameters
[2] when configuring the agg queue. This is probably why the scheduler
is willing to send long batches and have many outstanding frames.  I
bet that the fix is to make these parameters match the ones that come
down from mac80211.  If I get time later, I will see if I can fix
this.

Dan

[1] https://github.com/mirrors/linux-2.6/blob/master/drivers/net/wireless/iwlwifi/iwl-prph.h#L336
[2] https://github.com/mirrors/linux-2.6/blob/master/drivers/net/wireless/iwlwifi/iwl-agn-tx.c#L270
