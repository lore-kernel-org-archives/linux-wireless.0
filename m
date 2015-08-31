Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37607 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbHaRKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:10:00 -0400
Received: by wicmx12 with SMTP id mx12so5636533wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 10:09:59 -0700 (PDT)
Message-ID: <55E48A6A.8050109@gmail.com> (sfid-20150831_191005_801648_FA0F6E7D)
Date: Mon, 31 Aug 2015 19:10:02 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: NetworkManager crashing
References: <55DF3E75.1080305@gmail.com> <1441035810.2718.6.camel@redhat.com> <55E489EC.3000209@gmail.com>
In-Reply-To: <55E489EC.3000209@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31-08-15 19:07, Arend van Spriel wrote:
> 
> 
> On 31-08-15 17:43, Dan Williams wrote:
>> On Thu, 2015-08-27 at 18:44 +0200, Arend van Spriel wrote:
>>> Hi Dan,
>>>
>>> I ran into issue when NetworkManager keeps crashing/respawning. I have
>>> no idea what happened. My laptop was rebooted (might been my sons work)
>>> and this was the situation I stumbled upon. Running 4.1 kernel on Linux
>>> Mint. NetworkManager version is 0.9.8.8.
>>
>> Odd, can you get any more log messages out of the machine?  Or perhaps a
>> backtrace?  Looks like it's happening quite early in boot, before
>> anything would really get configured...
> 
> Ran NetworkManager manually on the machine. On every run the following
> shows up in dmesg
> 
> [19456.972855] traps: NetworkManager[5497] general protection ip:469f8e
> sp:7ffeab94c1f0 error:0 in NetworkManager[400000+10c000]
> 
> and in the terminal:
> 
> (NetworkManager:5508): GLib-WARNING **: GError set over the top of a
> previous GError or uninitialized memory.
> This indicates a bug in someone's code. You must ensure an error is NULL
> before it's set.
> The overwriting error message was: Key file does not have group
> 'connectivity'
> 
> Not sure which key file it is talking about so no idea where to look.

Is this about the keyfile plugin that is mentioned in my
NetworkManager.conf:

[main]
plugins=ifupdown,keyfile,ofono
dns=dnsmasq

[ifupdown]
managed=false

Regards,
Arend

