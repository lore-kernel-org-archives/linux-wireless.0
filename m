Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42869 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2CGKRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 05:17:44 -0500
Received: by vbbff1 with SMTP id ff1so5330376vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 02:17:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0T2ftbpaP6e1SZrDk7aMf-+C6E9Tocwn-Oj1WoNhjEcw@mail.gmail.com>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<CAD2nsn2GLAo=8xhe+-Xm0igSmQ+tr1F+Q6scuFaeaQWMYrQbwg@mail.gmail.com>
	<CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
	<CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com>
	<CALx5=V98n26O88C2XkGnH8z69EKpRY6rejXxasTwZC=iZFTumA@mail.gmail.com>
	<CAD2nsn0T2ftbpaP6e1SZrDk7aMf-+C6E9Tocwn-Oj1WoNhjEcw@mail.gmail.com>
Date: Wed, 7 Mar 2012 15:47:42 +0530
Message-ID: <CAD2nsn3pwY8ot632Mt4rjUczRyagyjA67YJqfOsi2aKrSNCM=Q@mail.gmail.com> (sfid-20120307_111804_422671_395468AB)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 7, 2012 at 3:11 PM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> Hi Matt,
>
>> yes, those are working to me now, but see the file "regval", it is
>> allowed to be written. I tried to echo a value to it, and cat it, it
>> seems not work right to me. :(
>>
>> You may try to echo "0x00000c45" > regval when the regval is
>> "0x00000c55". Then cat regval again, see if it changed to
>> "0x00000c45".
>
> yes, i will quickly take a look at this. thanks for reporting.

 i think even though we change the regvalue, hardware will immediately
updates with GPIO pins status in the register.

you can just play with the rx filter register, putting 0 in that
register should filter all frames.

at regidx
0x0000803c
echo 0 to it

hope it should completely filter all frames coming to your chip

after some time it will be properly updated (pls see
ath9k_hw_setrxfilter) via driver
ath_prepare_reset -> ath_stoprecv  -> ath9k_hw_setrxfilter

that can be called by chip reset path, or mac80211 call back

we can play with some register that completely has our control

>
> --
> thanks,
> shafi



-- 
thanks,
shafi
