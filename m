Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:48869 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaA2Rpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 12:45:32 -0500
Received: by mail-ob0-f182.google.com with SMTP id wm4so2316931obc.13
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 09:45:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140122162522.GA10630@redhat.com>
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
	<20140117100613.GD1425@redhat.com>
	<A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
	<1390133995.6945.11.camel@X1Carbon.localdomain>
	<03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
	<52DC1761.9080608@openwrt.org>
	<CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com>
	<20140120185044.GA1682@redhat.com>
	<CABikg9y_jd6TWGGN09edqabXboO9VoBTPUtLWFyWZjfSr6dnqg@mail.gmail.com>
	<20140122162522.GA10630@redhat.com>
Date: Wed, 29 Jan 2014 18:45:31 +0100
Message-ID: <CABikg9w7JjdeD7EU1cw9A-aARddDigDZzaxoL5yk6YeFtJB4hw@mail.gmail.com> (sfid-20140129_184547_384228_45CEEDC3)
Subject: Re: USB rt2x00 driver regression
From: Sergei Antonov <saproj@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 17:25, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Jan 22, 2014 at 12:27:44PM +0100, Sergei Antonov wrote:
>> The only problem I have now is that when connected to a particular
>> access point I get a lot of warnings like this:
>> [  327.309858] ieee80211 phy0: rt2800usb_entry_txstatus_timeout:
>> Warning - TX status timeout for entry 13 in queue 2
>> and this:
>> [  327.332847] ieee80211 phy0: rt2800usb_txdone: Warning - Got TX
>> status for an empty queue 2, dropping
>> I didn't have this problem before (with older kernels and old firmware).
>
> Does it mean that after you remove new rt2800_mcu_request() and use 0.22
> firmware with 3.13 kernel you do not have those TX status timeout
> warnings with this particular AP ?

I tried it and the warnings remained.

> On older kernels "TX status timeout" messages were only enabled if
> kernel was compiled with CONFIG_RT2X00_DEBUG option , so perhaps
> that is the reason why you did not see them on older kernel with
> older firmware. But if really TX status timeouts start to happen after
> firmware update, we should fix our driver to better talk to the
> firmware, though I do not have idea how. If not, we should probably
> disable those messages in non-debug mode as it was on old kernels.

Yes, it could have been due to CONFIG_RT2X00_DEBUG=n that I didn't
have warnings.
The warnings are printed at least since 3.9. Unfortunately, I could
not go back beyond 3.9 because of some compatibility issues between
the kernel and the rest of the system.

The AP with which I have the warnings is another Linux computer with
hostapd-2.0. Can it be the cause of this "TX status" thing?
