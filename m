Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-07.prod.phx3.secureserver.net ([72.167.82.87]:53583
	"HELO p3plsmtpa01-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760320Ab0I0Wkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 18:40:41 -0400
Message-ID: <F2D55DC7DDE6443EA6E69CBBE698A335@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: <linux-wireless@vger.kernel.org>
References: <58E3CFACA7054DC48245C67E9D4AE07B@ChuckPC> <AANLkTim=hHPMS9kUn11BnWDED1DeUVdJmu3u0Ajr3MPa@mail.gmail.com>
In-Reply-To: <AANLkTim=hHPMS9kUn11BnWDED1DeUVdJmu3u0Ajr3MPa@mail.gmail.com>
Subject: Re: memory leak in scan with 9170?
Date: Mon, 27 Sep 2010 18:40:28 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, (as usual) I was wrong. It isn't a memory problem. It seems that after 
some indeterminant time, the USB interface locks up. When we try to take it 
down (ifconfig wlan0 down) we get a message about outstanding urbs. By 
powering down the 9170 we can re-set the device and get it to re-associate 
and resume work. So, the problem is a USB problem. The question is if it is 
a module problem or a system problem. We are typically seeing this after 
50-200 reassociations. If we don't reassociate, it doesn't seem to occur. 
Does anyone else have experience or insight into this?

Chuck
----- Original Message ----- 
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Chuck Crisler" <ccrisler@vgocom.com>
Cc: <linux-wireless@vger.kernel.org>
Sent: Monday, September 27, 2010 1:31 PM
Subject: Re: memory leak in scan with 9170?


> On Mon, Sep 27, 2010 at 10:16 AM, Chuck Crisler <ccrisler@vgocom.com> 
> wrote:
>> I have modified my code that is using a 9170. I am really concerned about
>> roaming and so am testing that pretty hard. Yesterday I had a loop that
>> forced a DISCONNECT followed by a REASSOCIATE every 30 seconds. After
>> between 1:30 and 1:40 it failed by no longer receiving scan results. When 
>> I
>> looked into a log, the very last scan results that I received had a 
>> reduced
>> number of BSSs, down from 10-12 per scan to 4, then the next scan was 
>> zero.
>> It never recovered. All scans always failed to return any results from 
>> then
>> on and, of course, the re-associate failed. This 'feels' to me like a 
>> memory
>> leak somewhere, either in the firmware or the driver. I am running the
>> 2.6.31 kernel/driver and the dual file firmware and version 0.6.10 of the
>> supplicant.
>
> Both are ancient. Please try compat-wireless-2.6.36-rc3-1, I will soon
> make a new release with some stable fixes applied which are not yet in
> Linus' tree which I think will help a lot with your roaming testing. I
> should also note roaming was not possible until circa 2.6.33 when
> Jouni allowed for cfg80211 to authenticate to two APs at the same time
> and then move off to it to associate. Also although technically older
> userspace should work with newer kernels I have noted some issues with
> some really old supplicant on current kernels. I don't think there has
> been enough motivation to track down the exact issues though, but your
> best bet is to just upgrade the supplicant.
>
>> At the moment I am running another test where it roams every 60
>> seconds rather than 30 seconds to see what kind of difference that makes. 
>> I
>> know that my kernel is old, but for now I don't have a choice. Does 
>> anyone
>> have any experience like this or insight into this new problem? This is 
>> an
>> embedded device that doesn't have the memory of a PC. Is there some way 
>> that
>> I could instrument something to check this?
>
> I'm testing roaming by using wpa_cli roam <bss> in an ESS every 5
> seconds. To really stress test the hell out of this I force a roam
> every second too, its quite fun, it created a crash but I think we now
> know one of the main issues behind some warnings and Johannes has been
> brainstorming some solution. I don't suspect you'll hit these corner
> cases unless you roam every 2 seconds or so. The warnings are related
> to the fact that we assume the STA peer channel is the currently
> operating one when we TX a frame, and if we already associated to
> another station when moving from 2.4 GHz to 5 GHz we can potentially
> be trying to send a frame to a peer with no valid bitrate.
>
> You can use my script to test stuff as well:
>
> http://bombadil.infradead.org/~mcgrof/test-roam
>
> For example if you already know your ESS just replace the ESS variable
> with the set of BSSes for your ESS, they all most be on the same SSID
> though.
>
>  Luis
> 

