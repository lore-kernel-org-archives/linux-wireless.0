Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:64517 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZKDPyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 10:54:38 -0500
Received: by gv-out-0910.google.com with SMTP id r4so910447gve.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 07:54:42 -0800 (PST)
Message-ID: <4AF1A3BD.1020009@lwfinger.net>
Date: Wed, 04 Nov 2009 09:54:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com>
In-Reply-To: <20091104151132.GD12965@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 09:11 AM, John W. Linville wrote:
> On Wed, Nov 04, 2009 at 12:00:25AM -0600, Larry Finger wrote:
>> As reported by Rick Farina (sidhayn@gmail.com), removing the RTL8187 USB
>> stick, or unloading the driver rtl8187 using rmmod will cause a kernel oops.
>> There are at least two forms of the failure, (1) BUG: Scheduling while atomic,
>> and (2) a fatal kernel page fault. This problem is reported in Bugzilla #14539.
>>
>> This problem does not occur for kernel 2.6.31, but does for 2.6.32-rc2, thus
>> it is technically a regression; however, bisection did not locate any faulty
>> patch. The fix was found by comparing the faulty code in rtl8187 with p54usb.
>> My interpretation is that the handling of work queues in mac80211 changed
>> enough to the LEDs to be unregistered before tasks on the work queues are
>> cancelled. Previously, these actions could be done in either order.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Reported-and-tested by: Rick Farina <sidhayn@gmail.com>
>> ---
>>
>> John,
>>
>> This is 2.6.32 material. Sorry to take so long to get a patch, but it was
>> difficult for me to locate the problem. Fortunately, I had the postings of the
>> two flame wars to amuse me while all the kernel compilations were happening.
>>
>> Larry
>> ---
>>
>> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
>> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
>> @@ -210,10 +210,10 @@ void rtl8187_leds_exit(struct ieee80211_
>>  
>>  	/* turn the LED off before exiting */
>>  	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
>> -	cancel_delayed_work_sync(&priv->led_off);
>> -	cancel_delayed_work_sync(&priv->led_on);
>>  	rtl8187_unregister_led(&priv->led_rx);
>>  	rtl8187_unregister_led(&priv->led_tx);
>> +	cancel_delayed_work_sync(&priv->led_off);
>> +	cancel_delayed_work_sync(&priv->led_on);
>>  }
>>  #endif /* def CONFIG_RTL8187_LED */
>>  
> 
> This seems like a band-aid.  If anything, the original order would
> seem to make more sense.
> 
> Do you have a link to the original backtrace?  I don't see one in
> the bugzilla entry.

I agree that the original order makes more sense, which is why I coded
it that way in the first place; however, something changed during the
post-2.6.31 merge period. I tried to bisect the regression, but gave
up after 4 days of trying. I kept ending up where all the remaining
commits referred to drivers I'm not even using.

I don't have a full backtrace as I have had no success with
netconsole. My hand notes have only limited trace info, but I did note
that none of the rtl8187 or mac80211 routines are mentioned in any
trace I've seen. In the one in my notes, the process that crashed was
ifdown with a "scheduling while atomic" BUG.

I will try once more to get netconsole working to capture the backtrace.

Larry
