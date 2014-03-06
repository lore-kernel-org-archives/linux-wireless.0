Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55245 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCFP5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 10:57:49 -0500
Received: by mail-ob0-f172.google.com with SMTP id wm4so2727151obc.17
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 07:57:49 -0800 (PST)
Message-ID: <53189AF9.9030707@lwfinger.net> (sfid-20140306_165754_630176_1E54BC72)
Date: Thu, 06 Mar 2014 09:57:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thierry Moreau <thierry.moreau@connotech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning
 works
References: <5316C602.8020504@connotech.com> <5316CE44.5060905@lwfinger.net> <5317506B.1080305@connotech.com> <53175368.50009@lwfinger.net> <531777F8.5060506@connotech.com>
In-Reply-To: <531777F8.5060506@connotech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2014 01:16 PM, Thierry Moreau wrote:
> On 03/05/14 16:40, Larry Finger wrote:
>>
>> Please give me the exact set of commands you use to get this problem. If
>> possible, capture the console output. As I am currently running
>> long-term tests of the latest version of rtl8192ce using an RTL8188CE
>> (10ec:8176), it will be a perfect time to test.
>>
>
> Here is the command script, and the console log
> (....sh 2>&1 | tee ....log)
>
> Is it possible that the Shuttle system be arranged with a digital output
> enabling/inhibiting the Realtek wifi interface active participation in wifi
> protocol?
>
> I did ask Shuttle tech support, but in any event I don't want to induce you to
> troubleshoot a specific system.

The problem is not specific to the Shuttle - I can reproduce it on my HP laptop. 
Furthermore, it affects other mac80211-based drivers. The EBUSY return comes out 
of mac80211/cfg80211/nl80211 code.

I have no idea why that particular set of commands fails to be able to set the 
channel. Both NetworkManager and the openSUSE ifup sequence work OK. Your system 
can set channels using the scan mechanism.

If you want to track it down, you will need to put printk statements at every 
place that the net/wireless code sets EBUSY to see which one triggers. Perhaps 
that will expose any bug there, or in your script.

Larry


