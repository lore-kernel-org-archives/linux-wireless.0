Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:35936 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbaDXJrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 05:47:02 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlmvm: High latencies and low RX rate with firmware version 22.24.8.0 but not with 22.1.7.0
References: <87sip3b20f.fsf@nemi.mork.no>
	<1398326539.4154.0.camel@jlt4.sipsolutions.net>
Date: Thu, 24 Apr 2014 11:46:55 +0200
In-Reply-To: <1398326539.4154.0.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 24 Apr 2014 10:02:19 +0200")
Message-ID: <87oazrawkw.fsf@nemi.mork.no> (sfid-20140424_114713_739352_11F169DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2014-04-24 at 09:49 +0200, Bjørn Mork wrote:
>
>> I realize that icmp echos don't necessarily tell the whole truth, but
>> the same latency difference is noticable on e.g interactive ssh sessions
>> as well.  So I believe pinging illustrates the difference pretty well.
>> The *only* thing changed between these sessions is the iwl
>> firmware. Position, channel, driver, hardware is the same. This was
>> captured on 2.4GHz.
>
> There might be differences in how the driver treats the firmware - I
> think it probably turns off powersave for the older one. Have you tried
> turning it off manually?

Thanks for the tip.  Yes, it seems to be related to that.  Using

 modprobe iwlmvm power_scheme=1

avoids the problem. I also tried using

 modprobe iwlwifi power_save=N

with iwlmvm.power_scheme=2 (default), but that made no difference.  The
problem was still present with this setting.


Bjørn
