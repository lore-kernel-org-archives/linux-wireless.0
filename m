Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:10814 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYHEXTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 19:19:20 -0400
Received: by an-out-0708.google.com with SMTP id d40so459695and.103
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 16:19:19 -0700 (PDT)
Message-ID: <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com> (sfid-20080806_011925_636654_B6119E7A)
Date: Tue, 5 Aug 2008 16:19:19 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomasz Chmielewski" <mangoo@wpkg.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"OpenWrt Development List" <openwrt-devel@lists.openwrt.org>
In-Reply-To: <4898CBF9.6030606@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4898B018.5050202@wpkg.org>
	 <1217967177.3603.60.camel@johannes.berg> <4898CBF9.6030606@wpkg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 5, 2008 at 2:54 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Johannes Berg schrieb:
>>>
>>> Call Trace:[<c0060000>][<c0057150>]
>>
>> My magic crystal ball says that this is not inside p54 at all, and
>> indeed a problem in your kernel patches. :P
>
> An amazingly advanced crystal ball you have ;)
>
> So, a final update: ASUS WL-500gP (v1) running with OpenWRT patches and a
> prism54 mini-pci card:
>
> - panics / oopses with p54pci.ko

Can't help you there, and what Johannes was trying to say is the call
trace doesn't help us as its just hex values to us. We would need the
mapped culprit routines.

> - doesn't work with prism54.ko module (similar messages to
> http://marc.info/?l=linux-wireless&m=120250829717134&w=2)

We need more details, or do you get *exactly* the same error messages?

"Out of memory, cannot handle oid" comes up after a failed kmalloc()
while trying to handle an interrupt and management frame (not 802.11
frame) from the firmware. From that archived mailing list though the
oid 0x080002ff is mentioned and... well prism54 doesn't know what that
is. I wonder if the firmware is triggering random interrupts with
bogus oids.

If you can provide a complete log it can help. Also in your previous
posts I see you mentioned you were working with different firmwares.
1.0.4.3.arm should *only* be used with prism54. You may also want to
try an older firmware version than 1.0.4.3.arm, this one came from
3com cards.

  Luis
