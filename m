Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:9585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZAWSuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:50:08 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2643421fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 10:50:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090123174050.GA12042@kroah.com>
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com>
	 <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com>
	 <45e8e6c40901230929r6efbf19xbe2c32bef92db8e@mail.gmail.com>
	 <20090123174050.GA12042@kroah.com>
Date: Fri, 23 Jan 2009 10:50:06 -0800
Message-ID: <45e8e6c40901231050q714502ffk34fe16aea006b9e1@mail.gmail.com> (sfid-20090123_195015_124063_39A4DA3B)
Subject: Re: ath5k mesh in 2.6.28?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Greg KH <greg@kroah.com>
Cc: Bob Copeland <me@bobcopeland.com>, Keir <keirlawson@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

05188d21d21dc8976bff13a9ca73a230eef86d40 should apply to both .27 and
.28 and it's useful in both places as it fixes a general problem with
all Mesh Point interfaces and both kernels have Mesh Point support in
mac80211.

On Fri, Jan 23, 2009 at 9:40 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Jan 23, 2009 at 09:29:22AM -0800, Andrey Yurovsky wrote:
>> Sorry, looks like that's my mistake (I thought the patch had made it
>> in).  Greg -- thanks for queuing the patch.
>>
>> For completeness, I should note that ath5k mesh is later broken by
>> "ath5k: Update PCU code" and fixed again (hopefully both in by
>> 2.6.29!) by "ath5k: Correct usage of AR5K_CFG_ADHOC"
>>
>> Greg and Keir -- I also suggest Brian's patch, "mac80211: decrement
>> ref count to netdev after launching mesh discovery", commit
>> 05188d21d21dc8976bff13a9ca73a230eef86d40 for stable as it should apply
>> there and fixes a bug that will sometimes prevent module unload if a
>> mesh interface was active.
>
> Which stable kernel should this be for, .27 or .28 or both?
>
> thanks,
>
> greg k-h
>
