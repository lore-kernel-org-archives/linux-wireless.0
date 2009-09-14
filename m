Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43833 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbZINUu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 16:50:59 -0400
Received: by bwz19 with SMTP id 19so2375548bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 13:51:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3b0e19890909141056l4a01b8f9w9887af5d6219c3ff@mail.gmail.com>
References: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>
	 <4AAE3DF7.7060504@lwfinger.net>
	 <3b0e19890909140719y7971c9f4m5fe086a9008fd423@mail.gmail.com>
	 <4AAE53C8.1060100@lwfinger.net>
	 <3b0e19890909140905g4c6bfef3t38cd94a205d26f8@mail.gmail.com>
	 <4AAE7446.3080407@lwfinger.net>
	 <3b0e19890909141056l4a01b8f9w9887af5d6219c3ff@mail.gmail.com>
Date: Mon, 14 Sep 2009 21:51:01 +0100
Message-ID: <3ace41890909141351o261f7013u7d050a2f8a41dcb3@mail.gmail.com>
Subject: Re: RTL8187B wireless driver issue
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Vignette consultant <vignette75@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 6:56 PM, Vignette consultant
<vignette75@gmail.com> wrote:
>  Larry,
>
>  I got the same error even after adding wlan0 in
> /etc/network/interfaces file. I set the essid using "sudo iwconfig
> wlan0 essid linksys" command and restarted network. I tried other
> essids, but it gives same error.
>
>  Attached files contain log files. Please advise about solution.
>
>  How do I disable usb monitoring log, so I can see wlan0 interface log
> from dmesg?
>
>  Thanks
>  Sam
>
> On 9/14/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Vignette consultant wrote:
>>>  Hi
>>>
>>>  Attached files contain several logs of various commands. The log-1
>>> file is before running command and log-2 file is after running
>>> specific command.
>>>
>>>  Here are commands that I give as soon as I log in. It's server edition.
>>>
>>>  $ sudo ifconfig wlan0 up
>>>  $ sudo iwconfig wlan0 ESSID linksys
>>>  $ sudo dhclient wlan0 - results in no IP addr leased
>>
>> Your wireless has not associated and has no communication, which is
>> why it cannot get an IP using DHCP.
>>
>> A quick check with Google indicates that Ubuntu uses
>> /etc/network/interfaces to control the devices. Once that is correct,
>> you should be able to 'sudo /etc/init.d/networking restart' to start
>> the network. If the server is properly configured, the network should
>> start on boot.
>>
>> BTW, the dmesg buffer is circular. All that usb monitoring output has
>> completely filled the buffer, and it contains no useful information.
>>
>

scanning works, so there doesn't seem to be anything wrong with the
device or the driver itself. However, even for static configuration,
sometimes wpa_supplicant can still be involved and interfere, so you
probably want to make sure you put all the relevant config in
wpa_supplicant.conf , as well as manually; or make sure no other
network tools are running. (udev can launch wpa_supplicant/dhcp on
ifconfig up automatically - the 'not ready' messages are from udev
hooks). Lastly, I think the Ubuntu/Debian family packages
compat-wireless as 'kernel-modules-backport' or something; try that or
even compat-wireless. ( a while back there was a bug with
associattion).
