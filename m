Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53276 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1EQQex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 12:34:53 -0400
Received: by iyb14 with SMTP id 14so557984iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 09:34:53 -0700 (PDT)
Message-ID: <4DD2A3A9.90003@lwfinger.net> (sfid-20110517_183456_836520_99E95F3C)
Date: Tue, 17 May 2011 11:34:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rob Browning <rlb@defaultvalue.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>	<4DD074E3.3090502@lwfinger.net>	<87vcxbe5xz.fsf@trouble.defaultvalue.org>	<4DD09C78.2010304@lwfinger.net>	<8762pbkytq.fsf@trouble.defaultvalue.org>	<4DD13EF0.2070803@lwfinger.net>	<87iptaj8nf.fsf@trouble.defaultvalue.org> <87fwoehtd7.fsf@trouble.defaultvalue.org>
In-Reply-To: <87fwoehtd7.fsf@trouble.defaultvalue.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2011 10:57 PM, Rob Browning wrote:
> Rob Browning<rlb@defaultvalue.org>  writes:
>
>> So that command ran at essentially the rates you report for 10-20
>> seconds.  Then I killed it and tried another test I'd been using, which
>> was to lftp to ftp.kernel.org and get -c linux-2.6.39-rc7.tar.bz2.  That
>> transfer started at a high rate, but settled fairly quickly at about
>> 60KB/s.  So I killed that transfer and restarted the wget, and it ran
>> steadily at ~60KB/s.
>
> In case it helps, it also looks like the 60KB/s is an aggregate limit.
> Once it gets into the "lower bandwidth" state, if I run multiple
> transfers, the total won't go above that.

I can duplicate your result. To me, it appears to be a problem with bufferbloat. 
If that is correct, then there is little I can do with rtl8192cu to fix the 
problem. I see exactly the same slow rate with rt2800usb using an Ralink RT3070 
device. In addition, I see that rate when connected to my router with a wired 
100 Mbps connection.

What up/down rates do you see if you test with www.speedtest.net? I get 0.48 
Mbps up and 12.03 Mbps down. The up rate is a little slower than the 512 Kbps 
that my ISP provides. My nominal down rate is 7 Mbps with burst rates above 10 
if the bandwidth is available. Apparently it was this morning.

Larry
