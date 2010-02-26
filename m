Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:57904 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965976Ab0BZUKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:10:09 -0500
Received: by fg-out-1718.google.com with SMTP id d23so126855fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 12:10:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002261205160.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>
	<4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002261205160.4513@localhost.localdomain>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 26 Feb 2010 21:09:46 +0100
Message-ID: <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA
	errors
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2010 at 9:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 26 Feb 2010, Linus Torvalds wrote:
>> On Fri, 26 Feb 2010, Larry Finger wrote:
>> >
>> > Incidentally, we have learned today that the fault does not occur when running
>> > MMIO traces, and that it is not SMP related.
>>
>> Timing? I guess MMIO tracing will slow down the actual command setup part
>> a lot.
>
> Adding a "udelay(10)" to the "b43_write[16|32]()" functions doesn't make
> any difference on the machine I have access to, though.
>
> Ill happily test other ideas or patches. Automatically falling back to PIO
> makes things work, but I'd obviously _much_ rather have working DMA.
>
>                        Linus

Does actually enabling mmiotrace fix it for you too?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
