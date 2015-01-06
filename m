Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39863 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbAFAxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 19:53:01 -0500
Received: by mail-ob0-f172.google.com with SMTP id va8so63549311obc.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 16:53:01 -0800 (PST)
Message-ID: <54AB31EB.6020801@lwfinger.net> (sfid-20150106_015306_425223_200E98E0)
Date: Mon, 05 Jan 2015 18:52:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Erich Titl <erich.titl@think.ch>, linux-wireless@vger.kernel.org
Subject: Re: b43 driver and WEP (solved)
References: <54AA5438.9070902@think.ch> <54AAFFB1.8030109@lwfinger.net> <54AB2405.3050602@think.ch>
In-Reply-To: <54AB2405.3050602@think.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 05:53 PM, Erich Titl wrote:
> Hi Larry
>
> Am 05.01.2015 um 22:18 schrieb Larry Finger:
>> On 01/05/2015 03:07 AM, Erich Titl wrote:
> ...
>>
>> I then generated a 3.10.63 kernel, rebooted and retested. It also works.
>>
>> One thing would be to try disabling hardware encryption using option
>> "nohwcrypt=1". You might also check to determine what key slot your AP
>> is expecting to use. My AP has only a single key setup. It calls it #1
>> while Linux is using #0, but that is expected.
>
> Thanks a lot for coming back on this issue. I have been digging into the
> code and found the culprit tonight. The arc4 module was not loaded and
> WEP could not be initialized. The puzzling thing is, the outgoing dhcp
> packet passed.... weird.

Glad you found it. Strange that loading mac80211 did not force loading. Have you 
run 'depmod -a' on the modules?

Larry


