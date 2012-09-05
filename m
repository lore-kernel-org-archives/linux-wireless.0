Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39911 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab2IETq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 15:46:28 -0400
Message-ID: <5047AC15.8060207@canonical.com> (sfid-20120905_214637_691035_AF7D277E)
Date: Wed, 05 Sep 2012 12:46:29 -0700
From: Brad Figg <brad.figg@canonical.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback operation
References: <1346838562-4818-1-git-send-email-arend@broadcom.com> <1346838562-4818-3-git-send-email-arend@broadcom.com> <20120905165735.GD302@thinkpad-t410> <50478CE9.6040103@canonical.com> <5047A624.7090105@broadcom.com>
In-Reply-To: <5047A624.7090105@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 12:21 PM, Arend van Spriel wrote:
> On 09/05/2012 07:33 PM, Brad Figg wrote:
>> On 09/05/2012 09:57 AM, Seth Forshee wrote:
>>> On Wed, Sep 05, 2012 at 11:49:22AM +0200, Arend van Spriel wrote:
>>>> This patch addresses a long standing issue of the driver with the
>>>> mac80211 .flush() callback. Since implementing the .flush() callback
>>>> a number of issues have been fixed, but a WARN_ON_ONCE() was still
>>>> triggered because the flush takes too much time. The flush now
>>>> makes use of a waitqueue and still has a timeout on which a warning
>>>> is given.
>>>
>>> Brad Figg and I have been testing this patch with a 3.5 kernel. With the
>>> patch we're both still seeing the warning from brcms_ops_flush(), and
>>> Brad has also seen the "No where to go" message in
>>> brcms_c_prec_enq_head(). But the connection continues to work when this
>>> happens, whereas previously we had to reconnect, so this is definitely
>>> an improvement.
>>>
>>> Seth
>>>
>>
>> Arend,
>>
>> Though the driver is definitely better, it is still struggling quite a
>> bit as can be seen in the iperf output found at:
>>      http://pastebin.ubuntu.com/1187578/
>>
> 
> Thanks, Brad
> 
> I was focusing on the warning in the flush callback. I actually could not reproduce the "nowhere to go" message under my ubuntu test laptop.
> 
> The root cause of your problem seems the "nowhere to go". Basically, all packet queues in the driver have reached their limit. In that case packets are simply dropped.
> 
> Could you provide following info:
> * cpu info
> * wireless device id
> * scan data of your AP
> * kernel configuration
> 
> If I can download the kernel debian package of your 3.5 kernel from somewhere that would be great.
> 
> Gr. AvS
> 

Arend,

I just filed https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1046507
which should contain all this information.

If there is _anything_ more I can provide to you or test for you do not
hesitate to ask.

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
