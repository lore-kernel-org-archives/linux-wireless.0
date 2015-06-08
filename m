Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:43607 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbFHIPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:15:50 -0400
Received: by vnbg7 with SMTP id g7so10323722vnb.10
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 01:15:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101266353E4@DFRE01.ent.ti.com>
References: <CAGm1_kt1FfO=juFvwRP6CQU7_YTf2WQcQEgHfNAVkW=PSKMAzQ@mail.gmail.com>
 <87bngtnf00.fsf@kamboji.qca.qualcomm.com> <CAGm1_ku=YSQw5W11=NJA79pgPN8ptfE4iv8CCuXR1DTz=9JLAQ@mail.gmail.com>
 <AE1C82FB3D0EC64DB1F752C81CBD1101266353E4@DFRE01.ent.ti.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Mon, 8 Jun 2015 10:15:29 +0200
Message-ID: <CAGm1_kt554dOWMtQ1dzD+j6wHiLc2w2YbNfgGcfctGfaNE566A@mail.gmail.com> (sfid-20150608_101555_658241_4E344CFA)
Subject: Re: wl18xx: wlconf kernel compatibility
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yaniv,

On Sun, Jun 7, 2015 at 9:30 AM, Machani, Yaniv <yanivma@ti.com> wrote:
> Hi,
> As the configuration file is HW depended it should be created per platform,
> we have set this wiki page and script to help with initial setup :
> http://processors.wiki.ti.com/index.php/Open_Source_Wireless_Connectivity_wlconf
>
> We have also pushed a patch that makes sure the driver will not crash if there is a file size mismatch,
> and will fall back to default.

What about following proposal. I'm learning libxmlrpc now. It has
following struct *xmlrpc_server_abyss_parms*
(http://xmlrpc-c.sourceforge.net/doc/libxmlrpc_server_abyss.html#server_abyss_parameters).
If new parameter will be added, it is done via appending this to the
bottom of the structure. This way old structure is still preserved.

The user of this library must specify till what parameter this
structure should be used (parmSize parameter):

oid
xmlrpc_server_abyss(xmlrpc_env *                const envP,
                    xmlrpc_server_abyss_parms * const parmP,
                    unsigned int const parmSize);

This will be achieved via XMLRPC_APSIZE(log_file_name), i.e. macro
with structure field name. This way old programs still can work with
newer library.

This approach could be taken for wl18xx-conf.bin. Driver calculates
the size of known parameters and conf file size and as long as the
size of wl18xx-conf.bin is not smaller than known size, the driver can
use it.

What do you think about it?

Yegor

>> -----Original Message-----
>> From: Yegor Yefremov [mailto:yegorslists@googlemail.com]
>> Sent: Saturday, June 06, 2015 6:19 PM
>> To: Kalle Valo
>> Cc: linux-wireless@vger.kernel.org; Machani, Yaniv; Eliad Peller; Marc Kleine-
>> Budde
>> Subject: Re: wl18xx: wlconf kernel compatibility
>>
>> Hi Kalle,
>>
>> On Sat, Jun 6, 2015 at 3:27 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> > Yegor Yefremov <yegorslists@googlemail.com> writes:
>> >
>> >> How do I know, which wlconf version is compatible with which kernel
>> >> version? I have following problem:
>> >>
>> >> I have *.INI file for my particular WLAN chip. This file will be used
>> >> to produce wl18xx-conf.bin. The size of this file will be check
>> >> during device initialization. Depending on which kernel version is
>> >> used the size of the required file differs. For example kernel 3.18
>> >> requires wl18xx-conf.bin to have 1221 bytes, 4.1 expects 1226 bytes.
>> >> Recent wlconf (git://git.ti.com/wilink8-wlan/18xx-ti-utils.git)
>> >> produces 1229 bytes files.
>> >>
>> >> How should I determine correct wlconf version?
>> >
>> > I also complained about something along these lines earlier, this is
>> > not how upstream drivers are supposed to work. Users should not be
>> > forced to find correct files from somewhere, instead everything should
>> > just work out of box.
>> >
>> > Can anyone help Yegor to solve his problem? But in the long run wl18xx
>> > really should manage this better.
>>
>> I could solve the problem, though for the future it should be clear, what wlconf
>> version to use.
>>
>> See my post here:
>> http://e2e.ti.com/support/wireless_connectivity/f/307/p/426229/1523235#152
>> 3235
>>
>> Yegor
