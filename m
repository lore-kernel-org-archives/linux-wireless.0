Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38624 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab1FVDJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 23:09:32 -0400
Received: by iyb12 with SMTP id 12so336668iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 20:09:32 -0700 (PDT)
Message-ID: <4E015CE8.3000304@lwfinger.net> (sfid-20110622_050936_485481_7C7B11E6)
Date: Tue, 21 Jun 2011 22:09:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ali@internetdog.org
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net> <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net> <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net> <20110621124954.GA8462@internetdog.org> <4E011644.3070906@lwfinger.net> <20110622010057.GA12123@internetdog.org> <4E0154B7.2000204@lwfinger.net> <20110622025623.GC12547@internetdog.org>
In-Reply-To: <20110622025623.GC12547@internetdog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2011 09:56 PM, Ali Bahar wrote:
>
>>>>> this is more of a quick FYI, regarding Staging's r8712u driver.
>>>
>>>>> root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
>>>>> Error for wireless request "Set ESSID" (8B1A) :
>>>>>      SET failed on device wlan2 ; Operation not permitted.
>
>> I have no idea what you are doing wrong, but I get the following:
>
> Again, the test procedure was identical, and deliberately so.
>
> This was all just FYI; I was just providing some data. Thank you for
> your reply, and for your ongoing work.
>
>
>> finger@larrylap:~/wireless-testing-new>  sudo iwconfig wlan9 essid junk
>> finger@larrylap:~/wireless-testing-new>
>>
>> The above is with r8712u running on wireless-testing 3.0-rc4.
>
> I'd tried 3.0.0-rc3-wl_m_Sun19jun2011 (ie wireless rc3, built on
> Sunday) as well. Same wext and OS, on a different box.
>
> Since you are rewriting this driver, I won't try to dig into this on
> my end.

I am not rewriting this driver in the immediate future, thus you need to find 
out what is wrong.

As I said earlier, your error certainly looks like a privilege problem. Adding 
to what I posted earlier, I get

finger@larrylap:~> iwconfig wlan9 essid test
Error for wireless request "Set ESSID" (8B1A) :
     SET failed on device wlan9 ; Operation not permitted.
finger@larrylap:~> sudo iwconfig wlan9 essid test
finger@larrylap:~>

As you can see, my unprivileged version gets exactly the error message that you 
reported and the one as root works.

Larry

