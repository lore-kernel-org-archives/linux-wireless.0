Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54649 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2CTM3s convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 20 Mar 2012 08:29:48 -0400
Received: by bkcik5 with SMTP id ik5so5069937bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 05:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332224377.3329.1.camel@jlt3.sipsolutions.net>
References: <CALx5=V_czM-3sqhutbYx27wHnLtQL_PvcSjKHd4RGtopkKqf3A@mail.gmail.com>
	<1332224377.3329.1.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Mar 2012 20:29:39 +0800
Message-ID: <CALx5=V-CLY2QE=BuYoYOdBSELmFUxNXQ+Ws5Gh=rCND0SbJL1g@mail.gmail.com> (sfid-20120320_132953_451159_95C90941)
Subject: Re: About the .start function in ieee80211_ops.
From: Matt Chen <machen@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

2012/3/20 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2012-03-20 at 14:02 +0800, Matt Chen wrote:
>> Hi all,
>> I have a issue recently for rt2800pci, the way to duplicate this is
>> 1. Press function key to set rfkill hard blocked, it would cause
>> driver to power off.
>> 2. reboot
>> 3. find when load the driver (rt2800pci), it would stop in "Registered
>> led device: rt2800pci-phy0::quality".
>>
>> Here you would find the rfkill_poll function is not started to work,
>> also the rt2x00mac_start() registered in rt2800pci_mac80211_ops
>> structure is not yet be executed.
>> My question is when or what condition the rt2x00mac_start()  would be
>> running, because if it is not yet executed, then it would not be able
>> to load the firmware in rt2x00lib_start().
>
> That's a bug in the driver then -- it should probably start the rfkill
> stuff without mac80211's start() command. start() is only called when
> the first interface comes up, but that will never happen if it's in
> rfkill block.
Do you have any idea which part of code would make the first interface
comes up ?  :)
Would that be in cfg80211 ?

Thanks.
> johannes
>
> .

-- 
Thank you.
