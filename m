Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44139 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2GLQXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:23:24 -0400
Received: by yhmm54 with SMTP id m54so2890027yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 09:23:23 -0700 (PDT)
Message-ID: <4FFEF9F8.5060106@lwfinger.net> (sfid-20120712_182328_628958_B8618D93)
Date: Thu, 12 Jul 2012 11:23:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Anyone using rtl8192de with 2.4GHz 802.11g?
References: <20120712002149.GA14850@alittletooquiet.net> <4FFE211C.3020506@lwfinger.net> <20120712013216.GB14850@alittletooquiet.net> <4FFE2F38.7030604@lwfinger.net> <20120712152545.GA9489@alittletooquiet.net>
In-Reply-To: <20120712152545.GA9489@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2012 10:25 AM, Forest Bond wrote:
> Hi Larry,
>
> On Wed, Jul 11, 2012 at 08:58:16PM -0500, Larry Finger wrote:
>> On 07/11/2012 08:32 PM, Forest Bond wrote:
>>> On Wed, Jul 11, 2012 at 07:58:04PM -0500, Larry Finger wrote:
>>>> On 07/11/2012 07:21 PM, Forest Bond wrote:
>>>>> The rtl8192de driver is working fine for me at 5GHz, but I am having trouble
>>>>> getting scan results for 2.4GHz 802.11g networks.  I have been doing a lot of
>>>>> debugging but am not making much progress.  I suspect the 802.11 b/g/n phy is
>>>>> not being initialized correctly, but I'm pretty far outside my domain on this
>>>>> one.
>>>>>
>>>>> Is anyone successfully using this driver with a 2.4GHz 802.11g network?
>>>>
>>>> I have several different models - some work better than others. What
>>>> is the PCI ID for yours?
>>>
>>> This is the one I have:
>>>
>>> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8193]
>>> 02:00.1 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8193] (rev 01)
>>
>> It turns out that both kinds have the same ID. I think one of them
>> is a prototype, while the other is probably a production unit.
>> Obviously, bitrot has set in while I wasn't testing. With the kernel
>> driver, neither unit can even scan in the 2.4 GHz band. Using the
>> latest version of the vendor driver, the production version connects
>> with APs running WEP, WPA, or WPA2. The prototype can only handle
>> WEP.
>>
>> Obviously, I have some work to do. In the meantime, I will send you
>> a tarball containing the vendor driver - privately so as not to spam
>> the list.
>
> Thank you, I appreciate that.
>
> Of course, my preference would be to fix up the kernel driver.  I don't mind
> doing some manual bisection with compat-wireless releases unless you think that
> would be a total waste of time.  Do you have any sense for what the last working
> kernel version would have been?
>
> As you suggest, we may need to use the vendor driver in the meantime.  Thanks
> again for sending it over (although I suspect it is the same version I
> downloaded from Realtek's web site).

It started with the Realtek version, but has some important bug fixes that I 
wanted you to have.

Of course, we want to fix the kernel version, but if you want to bisect 
compat-wireless, that would be a big help. In the meantime, I will try bisecting 
wireless-testing when I get a chance.

Larry


