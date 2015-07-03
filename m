Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:21142 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbbGCLIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 07:08:16 -0400
Message-ID: <55966D1B.1040603@neratec.com> (sfid-20150703_130821_535048_F32F7BF3)
Date: Fri, 03 Jul 2015 13:08:11 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Wei Zhong <wzhong@google.com>, seth.forshee@canonical.com
CC: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: update CA rules for 5600 - 5650 mHz
References: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
In-Reply-To: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/02/2015 07:44 AM, Wei Zhong wrote:
> commit 2fef4cad8a1bd9cbbf178e59a1b3ca672b057095
> Author: Wei Zhong <wzhong@google.com>
> Date:   Wed Jul 1 22:39:09 2015 -0700
> 
>     wireless-regdb: update CA rules for 5600 - 5650 mHz
> 
>     Related regulation:
>     http://www.ic.gc.ca/eic/site/smt-gst.nsf/eng/sf10971.html#s6.2.3
> 
>     Frequency Bands 5470-5600 MHz and 5650-5725 MHz
>     Until further notice, devices subject to this section [i.e. Wifi device
>     supporting 5 GHz bands] shall not be capable of transmitting in the band
>     5600-5650 MHz. This restriction is for the protection of Environment
>     Canada’s weather radars operating in this band.
> 
> diff --git a/db.txt b/db.txt
> index 809cd3c..da0cfad 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -216,7 +216,8 @@ country CA: DFS-FCC
>         (2402 - 2472 @ 40), (30)
>         (5170 - 5250 @ 80), (17), AUTO-BW
>         (5250 - 5330 @ 80), (24), DFS, AUTO-BW
> -       (5490 - 5730 @ 160), (24), DFS
> +       (5490 - 5600 @ 80), (24), DFS
> +       (5650 - 5730 @ 40), (24), DFS
>         (5735 - 5835 @ 80), (30)
> 
>  # Source:
> --

I believe this could also be interpreted differently. If the change is only about
removing the weather radar band (5600-5650), the change should be

 -       (5490 - 5730 @ 160), (24), DFS
 +       (5490 - 5570 @ 80), (24), DFS
 +       (5570 - 5590 @ 20), (24), DFS
 +       (5650 - 5730 @ 80), (24), DFS

The second rule explicitly states that channel 116 remains available for HT20. If
this level of strict correctness is not needed, rule 1 and 2 combined would be

 -       (5490 - 5730 @ 160), (24), DFS
 +       (5490 - 5590 @ 80), (24), DFS
 +       (5650 - 5730 @ 80), (24), DFS


Cheers
Zefir
