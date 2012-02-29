Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.thefabfarrows.com ([70.88.29.81]:37296 "EHLO
	mail.thefabfarrows.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031018Ab2B2O5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 09:57:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 29 Feb 2012 09:57:13 -0500
From: Paul Farrow <linuxwireless@thefabfarrows.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Can't compile latest compat-wireless on Fedora 16 -
 =?UTF-8?Q?=33=2E=32=2E=37-=31=2Efc=31=36=2Ex=38=36=5F=36=34=2Edebug?=
In-Reply-To: <20120229143847.GA20516@redhat.com>
References: <fb86ee45cba7d303c361b65c072504ca@www.thefabfarrows.com>
 <20120229143847.GA20516@redhat.com>
Message-ID: <f2b62fb34829096ffd782328db881d52@www.thefabfarrows.com> (sfid-20120229_155719_722455_1526E3CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 29 Feb 2012 15:38:52 +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 28, 2012 at 02:05:24PM -0500, Paul Farrow wrote:
>> I have in recent times compiled the latest compat-wireless with no
>> problem but I seem to be having trouble compiling it on this kernel
>> - lots of undefined warnings in the mac80211 area.
>>
>> Output from make is attached.
>>
>> Can any one tell me what I have done wrong?
>
>
>> WARNING: "__tracepoint_api_stop_tx_ba_session" 
>> [/usr/local/src/compat-wireless-2012-02-27/net/mac80211/mac80211.ko] 
>> undefined!
>
> In compat-wireless tree do:
>
> patch -p1 -R < patches/44-deactivate-mac80211-tracing.patch
>
> I'm not sure how proper fix should looks like. I guess removing that
> patch will broke compiation on older kernels without tracing support.
>
> BTW: this could be usefull for you
> http://people.redhat.com/sgruszka/compat_wireless.html
>
> Stanislaw


Bravo, that works for me.  Now to test the latest code for DMA TX 
errors problem that I have, to see if its been fixed (bug already lodged 
with kernel.org).

Thanks for your help Stanislaw much appreciated.

Paul
