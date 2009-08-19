Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:65003 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZHSOEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 10:04:14 -0400
Received: by fg-out-1718.google.com with SMTP id e12so801445fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 07:04:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8C056A.4050005@huijgen.tk>
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
	<4A8BBB02.4020203@huijgen.tk> <69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com>
	<4A8BF35E.1090507@huijgen.tk> <1250687066.1067.25.camel@johannes.local>
	<69e28c910908190626s46fd0bfer5cc9dec9c5bb1c24@mail.gmail.com>
	<4A8C02D8.7080309@huijgen.tk> <69e28c910908190654v231d66c7k6a223f481f702c7c@mail.gmail.com>
	<4A8C056A.4050005@huijgen.tk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 19 Aug 2009 16:03:55 +0200
Message-ID: <69e28c910908190703h1ad7e98bqa4fe55a5fe7800e2@mail.gmail.com>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) working (partially)!
To: Mark Huijgen <mark.sf.net@huijgen.tk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/19 Mark Huijgen <mark.sf.net@huijgen.tk>:
> Gábor Stefanik wrote:
>> 2009/8/19 Mark Huijgen <mark.sf.net@huijgen.tk>:
>>
>>> Gábor Stefanik wrote:
>>>
>>>> Mark, could you produce a dmesg output with the new firmware, patches
>>>> applied, and channel set to 1? Post the output of dmesg after scanning
>>>> & probably associating, if possible. (Scan/assoc may produce messages
>>>> in dmesg.)
>>>>
>>>>
>>> I tested this already, but with default chan set to 1, I cannot get the
>>> interface up.
>>> This is somewhere in my mail, but it got a bit messy after I noticed
>>> that after
>>> changing some of the code my modules got installed in another directory
>>> (-dirty).
>>>
>>> I just restarted the notebook, but now the results are different again...
>>>
>>> New firmware, with patches applied and default channel 7:
>>> [   72.160057] b43-phy1: Loading firmware version 478.104 (2008-07-01
>>> 00:50:23)
>>> [   72.163484] b43-phy1 debug: RC calib: Failed to switch to channel 7,
>>> error = -5
>>> [   72.168100] b43-phy1 debug: Switch to init channel failed, error = -5.
>>>
>>> Recompile module with default chan 1, patches still applied and new
>>> firmware,
>>> # modprobe -r b43 && modprobe b43 verbose=3 && ifconfig wlan0 up
>>>
>>> [  430.259877] b43-phy2 debug: Switch to init channel failed, error = -5.
>>>
>>> Recompile again, but with default chan back to 7, still patched and
>>> still new firmware.
>>> So same as in first situation:
>>> # modprobe -r b43 && modprobe b43 verbose=3 && ifconfig wlan0 up
>>>
>>> [  524.748062] b43-phy3 debug: Chip initialized
>>>
>>> And I can get my interface up and working!
>>>
>>> Without this procedure I have not been able to get a working chip. Seems
>>> the partially
>>> initialized state after each try, allows the next try to get a bit
>>> further. And together with
>>> the default channel switching between 1 and 7, I get a working chip, but
>>> a chip that does
>>> not seem to be able to find my AP thats on channel 1.
>>>
>>> If I now change default chan to 1 again, I am getting the same error as
>>> in step 2 above.
>>> I have not been able to get the interface up with default chan set to 1.
>>>
>>> Mark
>>>
>>>
>>>
>>
>> What do you see in dmesg after running a scan?
>>
> After step 2, interface cannot be brought up:
> # iw dev wlan0 scan
> command failed: Network is down (-100)
>
> No extra output in dmesg
>
> After step 3 (so with default chan 7 again), interface comes up and I
> can scan:
> # iw dev wlan0 scan
> <<list of scan results>>
>
> No extra output generated in dmesg.
>
> I must add that I do not have debugging messages enabled for any
> mac80211 related options, only for b43 module.

That's not needed.

However, try "iw dev wlan0 scan trigger".

Also, try switching to all B/G channels manually.

One more thing to try is create a monitor interface and run kismet on
it. In addition, you can use aireplay-ng on the monitor interface to
test TX.

>
> Mark
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
