Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53153 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2AJHAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 02:00:49 -0500
Received: by wgbdr10 with SMTP id dr10so2680081wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 23:00:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120109222544.11008.qmail@stuge.se>
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
	<CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com>
	<20120109222544.11008.qmail@stuge.se>
Date: Tue, 10 Jan 2012 08:00:48 +0100
Message-ID: <CACna6ryJT1Nw8Yxrj8CftERjO=y7kYc-9cTP5Bj-N-=NniAhdg@mail.gmail.com> (sfid-20120110_080053_389855_6FB618D3)
Subject: Re: BCM43231
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Abimanyu Gottumukkala <me@abimanyu.in>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 stycznia 2012 23:25 użytkownik Peter Stuge <peter@stuge.se> napisał:
> Rafał Miłecki wrote:
>> I've been using "usbmon" to dump traffic.
>
> The tool at http://people.redhat.com/zaitcev/linux/usbmon-6.tar.gz
> and not simply cat on the usbmon files in debugfs I hope.
>
> debugfs only shows the first bytes of long transfers, but the API
> used by the usbmon-6 tool shows complete traffic.

I think I start to understand. The number before "<" or "=" or ">" is
amount of bytes. For example:

ea700b40 493839847 S Bi:2:003:6 -115 8 <
We just asked for 8 bytes

ea700b40 493840818 C Bi:2:003:6 0 8 = 00060456 00000000
Here we received the 8 bytes.

f3dad540 493840838 S Bi:2:003:6 -115 13 <
We asked for 13 bytes.

f3dad540 493840923 C Bi:2:003:6 0 13 = 55534253 0a1a0000 00000000 00
The requested 13 bytes.

Now some bigger amount:

eb48d640 504977573 S Ci:2:010:0 s 80 06 0200 0000 0027 39 <
Asking for 39bytes?

eb48d640 504977936 C Ci:2:010:0 0 39 = 09022700 010100a0 64090400
0003ff02 ff000705 81031000 04070582 02000200
Only 32bytes received?

Is this the issue you meant? Am I correctly parsing that dumps?



I've quickly tried usbmon userspace tool, but not much more luck with
it. Example from this tool:

f2c19e40 6.317817 S Ci:2:013:0 s 80 06 0200 0000 0027 39 <
f2c19e40 6.318305 C Ci:2:013:0 0 39 =
    09022700 010100a0 64090400 0003ff02 ff000705 81031000 04070582 02000200
     . . ' .  . . . .  d . . .  . . . .  . . . .  . . . .  . . . .  . . . .

Maybe it requires some switch or sth... unfortunately it's not
documented at all ;/

-- 
Rafał
