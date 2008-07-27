Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53737 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757727AbYG0VcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 17:32:13 -0400
Message-ID: <488CE95B.2090606@lwfinger.net> (sfid-20080727_233219_425978_3209D0EB)
Date: Sun, 27 Jul 2008 16:32:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mohammed Gamal <m.gamal005@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Fw: [Oops] b43 driver on 2.6.26
References: <20080727135840.a040e368.akpm@linux-foundation.org> <52d4a3890807271402n792dbaces52555f545a7bfa46@mail.gmail.com>
In-Reply-To: <52d4a3890807271402n792dbaces52555f545a7bfa46@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Gamal wrote:
> On Sun, Jul 27, 2008 at 11:58 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> Begin forwarded message:
>>
>> Date: Wed, 23 Jul 2008 01:03:24 +0300
>> From: "Mohammed Gamal" <m.gamal005@gmail.com>
>> To: linux-net@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Subject: [Oops] b43 driver on 2.6.26
>>
>>
>> I get the following oops with b43 driver on scanning for wireless networks.
>> ----
>> [...]
> 
> Ignore this, I'm no longer getting this oops on the latest git tree.

This message came from a BUG_ON statement in __netif_schedule(). A subsequent
commit changed it to a WARN_ON, and finally commit 5b3ab1d removed it completely
as the tested condition was essentially harmless.

You should be aware that wireless has not worked since commit 
175f9c1bba9b825d22b142. See the thread at
http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/0936.html for details. This 
problem is not yet formally entered at bugzilla as a regression.

Larry


