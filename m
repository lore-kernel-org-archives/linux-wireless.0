Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57663 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab0DBG5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 02:57:48 -0400
Received: by bwz1 with SMTP id 1so1326033bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 23:57:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB513AA.8020209@gmail.com>
References: <k2g880c1631004011414z59ce4547j1bcea7ad5aff7229@mail.gmail.com>
	 <4BB513AA.8020209@gmail.com>
Date: Fri, 2 Apr 2010 08:57:45 +0200
Message-ID: <p2wa32f33a41004012357wdbb76431m48945b3778ebdb4a@mail.gmail.com>
Subject: Re: [PATCH V3] rt2x00: remove MCU requests for SoC platforms
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Apr 1, 2010 at 11:44 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Luis,
>
> On 04/01/10 23:14, Luis Correia wrote:
>> The ralink SoC platforms do not have an MCU.
>>
>> Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
>
> I know Ivo already acked the v2 version of the patch, but isn't the
> addition of a driver flag a bit overkill?
>
> We have the test on whether the platform is SOC w.r.t. MCU requests
> in 2 places, and both of them are in rt2800 code. I do not really see
> a need to clutter the global rt2x00 space with a rt2800 specific flag,
> which is only used in rt2800 code.

I suggested the new flag to Luis. I wonder if a case exists where the driver
has no firmware but does need MCU access. I already considered it strange
when Ralink released a chip without firmware while other revisions did need it.
If this combination would be extremely unlikely, then we can indeed remove
the flag.

Ivo
